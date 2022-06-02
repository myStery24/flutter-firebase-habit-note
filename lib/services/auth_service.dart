import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../configs/constants.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../screens/onboard/onboard_screen.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();

  /// Google Sign In
  Future<UserModel> signInWithGoogle() async {
    try {
      AuthCredential credential = await getGoogleAuthCredential();
      UserCredential authResult = await _auth.signInWithCredential(credential);

      final User? user = authResult.user;

      await googleSignIn.signOut();

      return await loginFromFirebaseUser(user!, LoginTypeGoogle);
    } catch (e) {
      log(e);
      throw 'Something went wrong, please try again later!';
    }
  }

  /// Google Sign In Authentication
  Future<AuthCredential> getGoogleAuthCredential() async {
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication =
        await googleAccount!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken,
    );
    return credential;
  }

  /// Delete user account that was created using Google but the associated user collection document remains
  /// Can only delete Google-created user account
  /// User collection documents not deleted
  /// User still can access old documents even with different UID
  Future deleteUser(BuildContext context) async {
    try {
      AuthCredential credential = await getGoogleAuthCredential();
      UserCredential authResult = await _auth.signInWithCredential(credential);
      _auth.currentUser!.reauthenticateWithCredential(credential);
      User firebaseUser = authResult.user!;
      print("User to be deleted: $firebaseUser");
      await firebaseUser
          .delete()
          .whenComplete(() => OnboardScreen().launch(context, isNewTask: true));
      return true;
    } catch (e) {
      log(e);
      print(e.toString());
      return null;
    }
  }

  Future<void> signUpWithEmailPassword(
      {required String email,
      required String password,
      String? displayName,
      String? photoUrl}) async {
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await signInWithEmailPassword(
          email: value.user!.email!,
          password: password,
          displayName: displayName,
          photoUrl: photoUrl);
    }).catchError((error) {
      throw 'Email already exists';
    });
  }

  /// Sign In with Email Address and Password
  Future<void> signInWithEmailPassword(
      {required String email,
      required String password,
      String? displayName,
      String? photoUrl}) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      final User user = value.user!;

      /// Create user
      UserModel userModel = UserModel();

      userModel.email = user.email;
      userModel.uid = user.uid;
      userModel.name = displayName.validate();
      userModel.createdAt = DateTime.now();
      userModel.photoUrl = photoUrl.validate();
      userModel.loginType = LoginTypeApp;
      userModel.masterPwd = '';

      if (!(await userDBService.isUserExists(user.email))) {
        log('User does not exist');

        await userDBService
            .addDocumentWithCustomId(user.uid, userModel.toJson())
            .then((value) {
          //
        }).catchError((e) {
          throw e;
        });
      }

      return userDBService.getUserByEmail(email).then((user) async {
        await setValue(USER_ID, user.uid);
        await setValue(USER_DISPLAY_NAME, user.name);
        await setValue(USER_EMAIL, user.email);
        await setValue(USER_PHOTO_URL, user.photoUrl.validate());
        await setValue(USER_MASTER_PWD, user.masterPwd.validate());
        await setValue(LOGIN_TYPE, user.loginType.validate());
        await setValue(IS_LOGGED_IN, true);

        await userDBService
            .updateDocument({'updatedAt': DateTime.now()}, user.uid);
      }).catchError((e) {
        throw e;
      });
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw "Please check your network connection and try again later.";
      }
      log(error.toString());
      throw "Invalid credentials. If you're a new user, please create an account.";
    });
  }

  /// Sign Out
  Future<void> signOutFromEmailPassword(BuildContext context) async {
    await removeKey(USER_DISPLAY_NAME);
    await removeKey(USER_EMAIL);
    await removeKey(USER_PHOTO_URL);
    await removeKey(IS_LOGGED_IN);
    await removeKey(USER_MASTER_PWD);
    await removeKey(FIT_COUNT);
    await removeKey(CROSS_COUNT);
    await removeKey(LOGIN_TYPE);
    await removeKey(PASSWORD);

    await manager.cancelAllNotification();

    appStore.setLoggedIn(false);

    OnboardScreen().launch(context, isNewTask: true);
    // LoginScreen().launch(context, isNewTask: true);
  }

  /// Sign In with Apple
  Future<void> appleLogIn() async {
    if (await TheAppleSignIn.isAvailable()) {
      AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode!),
          );
          final authResult = await _auth.signInWithCredential(credential);
          final user = authResult.user!;

          if (result.credential!.email != null) {
            await saveAppleData(result);
          }

          await loginFromFirebaseUser(
            user,
            LoginTypeApple,
            fullName:
                '${getStringAsync('appleGivenName')} ${getStringAsync('appleFamilyName')}',
          );
          break;
        case AuthorizationStatus.error:
          throw ("Sign in failed: ${result.error!.localizedDescription}");

        case AuthorizationStatus.cancelled:
          throw ('User cancelled');
      }
    } else {
      throw ('Apple SignIn is not available for your device');
    }
  }

  /// UserData provided only 1st time
  Future<void> saveAppleData(AuthorizationResult result) async {
    await setValue('appleEmail', result.credential!.email);
    await setValue('appleGivenName', result.credential!.fullName!.givenName);
    await setValue('appleFamilyName', result.credential!.fullName!.familyName);
  }

  Future<void> setUserDetailPreference(UserModel user) async {
    await setValue(USER_ID, user.uid);
    await setValue(USER_DISPLAY_NAME, user.name);
    await setValue(USER_EMAIL, user.email);
    await setValue(USER_PHOTO_URL, user.photoUrl.validate());
    await setValue(USER_MASTER_PWD, user.masterPwd.validate());
    await setValue(IS_LOGGED_IN, true);

    appStore.setLoggedIn(true);
  }

  Future<UserModel> loginFromFirebaseUser(User currentUser, String loginType,
      {String? fullName}) async {
    UserModel userModel = UserModel();

    if (await userService.isUserExist(currentUser.email, loginType)) {
      ///Return user data
      await userService.getUserByEmail(currentUser.email).then((user) async {
        userModel = user;
      }).catchError((e) {
        throw e;
      });
    } else {
      /// Create user
      userModel.uid = currentUser.uid.validate();
      userModel.email = currentUser.email.validate();
      userModel.name = (currentUser.displayName.validate());
      userModel.photoUrl = currentUser.photoURL.validate();
      userModel.loginType = loginType.validate();
      userModel.updatedAt = DateTime.now();
      userModel.createdAt = DateTime.now();

      await userService
          .addDocumentWithCustomId(currentUser.uid, userModel.toJson())
          .then((value) {
        //
      }).catchError((e) {
        throw e;
      });
    }

    await setValue(LOGIN_TYPE, loginType);
    await setUserDetailPreference(userModel);

    return userModel;
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }

  /// Request for Reset Password
  Future<void> resetPassword({required String newPassword}) async {
    await _auth.currentUser!.updatePassword(newPassword).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}
