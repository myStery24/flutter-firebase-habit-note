import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/components/CustomButton.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../main.dart';
import '../DashboardScreen.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = '/RegisterScreen';

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  FocusNode usernameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();
  FocusNode confPassNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? AppColors.kHabitDark : Colors.transparent,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );

    if (isIos) {
      TheAppleSignIn.onCredentialRevoked!.listen((_) {
        log("Credentials revoked");
      });
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.kHabitOrange),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .02),
              Text(
                'Create Account,',
                style: GoogleFonts.roboto(
                  color: getBoolAsync(IS_DARK_MODE, defaultValue: false)
                      ? AppColors.kTextWhite
                      : AppColors.kTextBlack,
                  fontSize: 28.0,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Let's get to know you !",
                style: GoogleFonts.roboto(
                  color: getBoolAsync(IS_DARK_MODE, defaultValue: false)
                      ? AppColors.kTextWhite
                      : AppColors.kTextBlack,
                  fontSize: 28.0,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Enter your details to continue',
                style: GoogleFonts.roboto(
                  color: getBoolAsync(IS_DARK_MODE, defaultValue: false)
                      ? AppColors.kTextWhite
                      : AppColors.kTextBlack,
                  fontSize: 14.0,
                  fontWeight: TextFontWeight.regular,
                ),
              ),
              SizedBox(height: screenHeight * .05),

              /// Form
              Container(
                child: Stack(
                  children: [
                    Form(
                      key: formState,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: SingleChildScrollView(
                        // padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            AppTextField(
                              autoFocus: false,
                              controller: usernameController,
                              focus: usernameNode,
                              nextFocus: emailNode,
                              textFieldType: TextFieldType.NAME,
                              textCapitalization: TextCapitalization.none,
                              textStyle: primaryTextStyle(),
                              keyboardType: TextInputType.text,
                              cursorColor: appStore.isDarkMode
                                  ? AppColors.kHabitOrange
                                  : AppColors.kHabitDark,
                              decoration:
                                  appTextFieldInputDeco(hint: 'Display Name'),
                              errorInvalidUsername: AppStrings.kNameNullError,
                              errorThisFieldRequired: errorThisFieldRequired,
                            ),
                            16.height,
                            AppTextField(
                              controller: emailController,
                              focus: emailNode,
                              nextFocus: passNode,
                              textFieldType: TextFieldType.EMAIL,
                              textCapitalization: TextCapitalization.none,
                              textStyle: primaryTextStyle(),
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: appStore.isDarkMode
                                  ? AppColors.kHabitOrange
                                  : AppColors.kHabitDark,
                              decoration:
                                  appTextFieldInputDeco(hint: 'Email Address'),
                              errorInvalidEmail: AppStrings.kInvalidEmailError,
                              errorThisFieldRequired: errorThisFieldRequired,
                            ),
                            16.height,
                            AppTextField(
                              controller: passController,
                              focus: passNode,
                              nextFocus: confPassNode,
                              textFieldType: TextFieldType.PASSWORD,
                              textStyle: primaryTextStyle(),
                              cursorColor: appStore.isDarkMode
                                  ? AppColors.kHabitWhite
                                  : AppColors.kHabitOrange,
                              decoration:
                                  appTextFieldInputDeco(hint: 'Password'),
                              errorThisFieldRequired: errorThisFieldRequired,
                            ),
                            16.height,
                            AppTextField(
                              controller: confirmController,
                              focus: confPassNode,
                              textFieldType: TextFieldType.PASSWORD,
                              textStyle: primaryTextStyle(),
                              cursorColor: appStore.isDarkMode
                                  ? AppColors.kHabitWhite
                                  : AppColors.kHabitOrange,
                              decoration: appTextFieldInputDeco(
                                  hint: 'Confirm Password'),
                              errorThisFieldRequired: errorThisFieldRequired,
                              onFieldSubmitted: (s) {
                                createAccount();
                              },
                              validator: (value) {
                                if (value!.trim().isEmpty)
                                  return errorThisFieldRequired;
                                if (value.trim().length < passwordLengthGlobal)
                                  return 'Minimum password length should be $passwordLengthGlobal';
                                return passController.text == value.trim()
                                    ? null
                                    : AppStrings.kMatchPassError;
                              },
                            ),
                            32.height,

                            /// Navigate to Login Screen
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen())),
                              child: SizedBox(
                                width: 600,
                                child: Container(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account ? ",
                                      style: TextStyle(
                                        color: getBoolAsync(IS_DARK_MODE,
                                                defaultValue: false)
                                            ? AppColors.kTextWhite
                                            : AppColors.kTextBlack,
                                        fontWeight: TextFontWeight.regular,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: "Login here",
                                            style: TextStyle(
                                              color: AppColors.kHabitOrange,
                                              fontWeight: TextFontWeight.bold,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            32.height,
                            // TODO: Add link to ToU and Privacy Policy
                            Text(
                              "By clicking the “CREATE ACCOUNT” button, you agree to our Terms of use and Privacy Policy",
                              style: GoogleFonts.roboto(
                                color: getBoolAsync(IS_DARK_MODE,
                                        defaultValue: false)
                                    ? AppColors.kTextWhite
                                    : AppColors.kTextBlack,
                                fontSize: 16.0,
                                fontWeight: TextFontWeight.regular,
                              ),
                            ),
                            16.height,
                            CustomButton(
                              text: AppStrings.createAccount,
                              onPressed: () {
                                createAccount();
                              },
                            ),
                            // AppButton(
                            //   width: context.width(),
                            //   color: PrimaryColor,
                            //   text: 'Sign Up',
                            //   onTap: () {
                            //     createAccount();
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ).center(),
                    // IconButton(
                    //   icon: Icon(Icons.arrow_back),
                    //   onPressed: () {
                    //     finish(context);
                    //   },
                    // ),
                    Observer(
                        builder: (_) => Loader(
                                color: appStore.isDarkMode
                                    ? AppColors.kHabitDark
                                    : AppColors.kHabitOrange)
                            .visible(appStore.isLoading)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createAccount() async {
    if (formState.currentState!.validate()) {
      appStore.setLoading(true);

      await service
          .signUpWithEmailPassword(
              email: emailController.text.trim(),
              password: passController.text.trim(),
              displayName: usernameController.text.trim())
          .then((value) async {
        appStore.setLoading(false);

        await setValue(PASSWORD, passController.text.trim());

        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error);
      });
    }
  }
}
