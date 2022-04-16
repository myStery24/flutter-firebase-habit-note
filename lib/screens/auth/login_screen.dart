import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/screens/auth/success_screen.dart';
import 'package:habit_note/screens/password/forgot_password_screen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../configs/colors.dart';
import '../../configs/common.dart';
import '../../configs/constants.dart';
import '../../configs/routes.dart';
import '../../main.dart';

import '../../widgets/custom_button.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : AppColors.kPrimaryVariantColor,
      statusBarIconBrightness: appStore.isDarkMode ? Brightness.dark : Brightness.light,
      delayInMilliSeconds: 100,
    );

    if (isIOS) {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.kHabitOrange),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GestureDetector(
          // Dismiss the keyboard when the tap is outside events
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                SizedBox(height: screenHeight * .02),
                Text(
                  'Log In,',
                  style: GoogleFonts.lato(
                    /// If in light mode, display text in black colour
                    color: getBoolAsync(IS_DARK_MODE)
                        ? AppColors.kTextWhite
                        : AppColors.kTextBlack,
                    fontSize: 28.0,
                    fontWeight: TextFontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * .01),
                Text(
                  "Welcome back !",
                  style: GoogleFonts.lato(
                    color: getBoolAsync(IS_DARK_MODE)
                        ? AppColors.kTextWhite
                        : AppColors.kTextBlack,
                    fontSize: 28.0,
                    fontWeight: TextFontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * .01),
                Text(
                  "Please login with your credentials",
                  style: GoogleFonts.lato(
                    color: getBoolAsync(IS_DARK_MODE)
                        ? AppColors.kTextWhite
                        : AppColors.kTextBlack,
                    fontSize: 14.0,
                    fontWeight: TextFontWeight.regular,
                  ),
                ),
                SizedBox(height: screenHeight * .05),

                /// Form
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Stack(
                    children: [
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: SingleChildScrollView(
                          // padding: EdgeInsets.all(16),
                          child: AutofillGroup(
                            child: Column(
                              children: [
                                AppTextField(
                                  controller: emailController,
                                  focus: emailNode,
                                  nextFocus: passwordNode,
                                  textStyle: primaryTextStyle(),
                                  textFieldType: TextFieldType.EMAIL,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: appStore.isDarkMode
                                      ? AppColors.kHabitOrange
                                      : AppColors.kHabitDark,
                                  decoration: appTextFieldInputDeco(hint: 'Email address'),
                                  autoFillHints: [AutofillHints.email],
                                  errorInvalidEmail: AppStrings.kInvalidEmailError,
                                  errorThisFieldRequired: errorThisFieldRequired,
                                ).paddingBottom(16),
                                AppTextField(
                                  controller: passController,
                                  focus: passwordNode,
                                  textStyle: primaryTextStyle(),
                                  textFieldType: TextFieldType.PASSWORD,
                                  cursorColor: appStore.isDarkMode
                                      ? AppColors.kHabitOrange
                                      : AppColors.kHabitDark,
                                  decoration: appTextFieldInputDeco(hint: 'Password'),
                                  autoFillHints: [AutofillHints.password],
                                  errorThisFieldRequired: errorThisFieldRequired,
                                  onFieldSubmitted: (s) {
                                    signIn();
                                  },
                                ),
                                16.height,
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('Forgot password ?',
                                          style: primaryTextStyle(),
                                          textAlign: TextAlign.end)
                                      .paddingSymmetric(vertical: 8, horizontal: 4)
                                      .onTap(() {
                                    ForgotPasswordScreen().launch(context);
                                  }),
                                ),
                                40.height,

                                /// Navigate to Create Account Screen
                                SizedBox(
                                  width: screenWidth,
                                  child: Container(
                                    child: Container(
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an account yet ? ",
                                          style: TextStyle(
                                            color: getBoolAsync(IS_DARK_MODE)
                                                ? AppColors.kTextWhite
                                                : AppColors.kTextBlack,
                                            fontWeight: TextFontWeight.regular,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "\nCreate an account here",
                                              style: TextStyle(
                                                color: AppColors.kHabitOrange,
                                                fontWeight: TextFontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(context, AppRoutes().createAccountScreen);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                40.height,

                                /// Log In Button
                                CustomButton(
                                  text: AppStrings.login,
                                  onPressed: () {
                                    signIn();
                                  },
                                ),
                                16.height,
                                Row(
                                  children: [
                                    Divider(thickness: 2, endIndent: 10, indent: 10)
                                        .expand(),
                                    Text(with_social_media,
                                        style: primaryTextStyle(size: 12)),
                                    Divider(thickness: 2, endIndent: 10, indent: 10)
                                        .expand(),
                                  ],
                                ),
                                16.height,

                                /// Google Button
                                AppButton(
                                  width: context.width(),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GoogleLogoWidget(),
                                      16.width,
                                      Text(
                                        continue_with_google,
                                        style: primaryTextStyle(
                                            color: AppColors.kTextBlack,
                                            size: 18,
                                            weight: TextFontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    appStore.setLoading(true);
                                    service.signInWithGoogle().then((value) async {
                                      await addNotification();

                                      appStore.setLoading(false);
                                      DashboardScreen()
                                          .launch(context, isNewTask: true);
                                    }).catchError((error) {
                                      appStore.setLoading(false);

                                      toast(error.toString());
                                    });
                                  },
                                ),
                                16.height,
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: boxDecorationRoundedWithShadow(30,
                                      backgroundColor: appStore.isDarkMode
                                          ? AppColors.kHabitDark
                                          : Colors.white),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/ic_apple.png',
                                          width: 23,
                                          height: 23,
                                          color:
                                              appStore.isDarkMode ? white : black),
                                      16.width,
                                      Text(continue_with_apple,
                                          style: primaryTextStyle(size: 18)),
                                    ],
                                  ).center(),
                                ).onTap(() async {
                                  hideKeyboard(context);

                                  appStore.setLoading(true);
                                  await service.appleLogIn().then((value) {
                                    DashboardScreen()
                                        .launch(context, isNewTask: true);
                                  }).catchError((e) {
                                    toast(e.toString());
                                  });
                                  appStore.setLoading(false);
                                }).visible(isIOS),
                              ],
                            ),
                          ),
                        ),
                      ).center(),
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
      ),
    );
  }

  signIn() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);
      service
          .signInWithEmailPassword(
              email: emailController.text.trim(),
              password: passController.text.trim())
          .then((value) async {
        await addNotification();

        await setValue(PASSWORD, passController.text.trim());

        appStore.setLoading(false);
        SuccessScreen().launch(context, isNewTask: true);
        // DashboardScreen().launch(context, isNewTask: true);
      }).catchError((error) {
        appStore.setLoading(false);

        toast(error.toString());
      });
    }
  }

  Future<void> addNotification() async {
    await subscriptionService.getSubscription().then((value) async {
      value.forEach((element) async {
        if (element.notificationDate != null) {
          if (element.notificationDate!.isAfter(DateTime.now())) {
            await manager.showScheduleNotification(
              scheduledNotificationDateTime: element.notificationDate!,
              id: element.notificationId!,
              title: element.name,
              description: element.amount,
            );
          }
        }
      });
    }).catchError((error) {
      toast(error.toString());
    });
  }
}
