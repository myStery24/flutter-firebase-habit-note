import 'package:flutter/material.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String tag = '/ForgotPasswordScreen';

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgotEmailController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    return GestureDetector(
      // Dismiss the keyboard when the tap is outside events
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(forgot_pwd),
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.height,
                  Text('Forgot your password ?', style: boldTextStyle(size: 22)),
                  15.height,
                  Text(
                      'Please enter your email address. We will send you an email with instructions to reset your password.',
                      style: primaryTextStyle(size: 14)),
                  20.height,
                  AppTextField(
                    controller: forgotEmailController,
                    textFieldType: TextFieldType.EMAIL,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kHabitDark,
                    decoration: appTextFieldInputDeco(hint: 'Email address'),
                    errorInvalidEmail: AppStrings.kInvalidEmailError,
                    errorThisFieldRequired: errorThisFieldRequired,
                  ),
                  20.height,
                  AppButton(
                    child: Text(
                      reset_acc_pwd,
                      style: boldTextStyle(
                          color: appStore.isDarkMode
                              ? AppColors.kTextBlack
                              : AppColors.kTextWhite,
                          weight: TextFontWeight.bold),
                    ),
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kHabitOrange,
                    width: context.width(),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        service
                            .forgotPassword(
                                email: forgotEmailController.text.trim())
                            .then((value) {
                          toast(
                              'Reset password link has been sent to your email');
                          finish(context);
                        }).catchError((error) {
                          toast(error.toString());
                        });
                      }
                    },
                  ),
                ],
              ),
            ).center(),
          ),
        ),
      ),
    );
  }
}
