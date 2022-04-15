import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/components/user_agreement_widget.dart';
import 'package:habit_note/components/custom_button.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../main.dart';
import '../../utils/routes.dart';
import '../dashboard_screen.dart';

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
      appStore.isDarkMode ? AppColors.kHabitDarkGrey : AppColors.kHabitBackgroundLightGrey,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .02),
              Text(
                'Create Account,',
                style: GoogleFonts.lato(
                  /// Check the state of whether dark mode button is toggled on
                  color: getBoolAsync(IS_DARK_MODE)
                  // is on
                      ? AppColors.kTextWhite
                  // if off
                      : AppColors.kTextBlack,
                  fontSize: 28.0,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Let's get to know you !",
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
                'Enter your details to continue',
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
                              decoration: appTextFieldInputDeco(hint: 'Display name'),
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
                                  appTextFieldInputDeco(hint: 'Email address'),
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
                                  hint: 'Confirm password'),
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
                              onTap: () {
                                Navigator.push(context, AppRoutes().loginScreen);
                              },
                              child: SizedBox(
                                width: screenWidth,
                                child: Container(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Already have an account ? ",
                                      style: TextStyle(
                                        color: getBoolAsync(IS_DARK_MODE)
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

                            /// Terms of Use and Privacy Policy
                            AgreementWidget(),
                            16.height,
                            CustomButton(
                              text: AppStrings.createAccount,
                              onPressed: () {
                                createAccount();
                              },
                            ),
                          ],
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
