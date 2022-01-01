import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mighty_notes/components/CustomButton.dart';
import 'package:mighty_notes/screens/DashboardScreen.dart';
import 'package:mighty_notes/screens/LoginScreen.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Common.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:mighty_notes/utils/StringConstant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

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
    //
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              SizedBox(height: screenHeight * .02),
              Text(
                'Create Account,',
                style: GoogleFonts.roboto(
                  color: getBoolAsync(IS_DARK_MODE, defaultValue: true)
                      ? Colors.white
                      : Colors.black,
                  fontSize: 28.0,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Let's get to know you !",
                style: GoogleFonts.roboto(
                  color: getBoolAsync(IS_DARK_MODE, defaultValue: true)
                      ? Colors.white
                      : Colors.black,
                  fontSize: 28.0,
                  fontWeight: TextFontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                'Enter your details to continue',
                style: GoogleFonts.roboto(
                  color: getBoolAsync(IS_DARK_MODE, defaultValue: true)
                      ? Colors.white
                      : Colors.black,
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
                            // commonCacheImageWidget(
                            //     getBoolAsync(IS_DARK_MODE, defaultValue: true)
                            //         ? dark_mode_image
                            //         : light_mode_image,
                            //     150,
                            //     fit: BoxFit.cover),
                            // Text('Create Account', style: boldTextStyle(size: 30)),
                            // 30.height,
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
                                  ? Colors.white
                                  : AppColors.kHabitDark,
                              decoration:
                                  appTextFieldInputDeco(hint: 'Display Name'),
                              errorInvalidEmail: 'Enter valid email',
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
                                  ? Colors.white
                                  : AppColors.kHabitDark,
                              decoration:
                                  appTextFieldInputDeco(hint: 'Email Address'),
                              errorInvalidEmail: 'Enter valid email',
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
                                  ? Colors.white
                                  : AppColors.kHabitDark,
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
                                  ? Colors.white
                                  : AppColors.kHabitDark,
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
                                    : pwd_not_match;
                              },
                            ),
                            32.height,
                            /// Login Screen
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
                                                defaultValue: true)
                                            ? Colors.white
                                            : Colors.black,
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
                                        defaultValue: true)
                                    ? Colors.white
                                    : Colors.black,
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
