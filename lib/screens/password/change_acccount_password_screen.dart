import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/components/reset_account_password_widget.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/colours.dart';

/// Only works for account loginType = app
class ChangeAppPasswordScreen extends StatefulWidget {
  static String tag = '/ChangeAccPasswordScreen';

  @override
  ChangeAppPasswordScreenState createState() => ChangeAppPasswordScreenState();
}

class ChangeAppPasswordScreenState extends State<ChangeAppPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController currentPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

  FocusNode currentNode = FocusNode();
  FocusNode newPwdNode = FocusNode();
  FocusNode confirmPwdNode = FocusNode();

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(change_acc_pwd),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 15.height,
                    // Text('Forgot your account password ?',
                    //     style: boldTextStyle(size: 22)),
                    15.height,
                    Text(
                        'Please fill up the following fields to change your account password.',
                        style: primaryTextStyle(size: 14)),

                    /// Reset through email
                    ResetAccountPasswordWidget(),
                    20.height,
                    AppTextField(
                        controller: currentPwdController,
                        focus: currentNode,
                        nextFocus: newPwdNode,
                        textFieldType: TextFieldType.PASSWORD,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        cursorColor: appStore.isDarkMode
                            ? Colors.white
                            : AppColors.kHabitDark,
                        decoration: appTextFieldInputDeco(hint: current_pwd),
                        errorThisFieldRequired: errorThisFieldRequired,
                        validator: (val) {
                          if (val!.trim() != getStringAsync(PASSWORD)) {
                            return current_pwd_invalid;
                          }
                          return null;
                        }),
                    16.height,
                    AppTextField(
                      controller: newPwdController,
                      focus: newPwdNode,
                      nextFocus: confirmPwdNode,
                      textFieldType: TextFieldType.PASSWORD,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      cursorColor: appStore.isDarkMode
                          ? Colors.white
                          : AppColors.kHabitDark,
                      decoration: appTextFieldInputDeco(hint: new_pwd),
                      errorThisFieldRequired: errorThisFieldRequired,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              color: getBoolAsync(IS_DARK_MODE)
                                  ? AppColors.kHabitOrange
                                  : AppColors.kHabitDark,
                            ),
                            onPressed: null),
                        Text(
                          'Your password must have at least 6 characters.',
                          style: TextStyle(
                            color: getBoolAsync(IS_DARK_MODE)
                                ? AppColors.kTextWhite
                                : AppColors.kTextBlack,
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    AppTextField(
                      controller: confirmPwdController,
                      focus: confirmPwdNode,
                      textFieldType: TextFieldType.PASSWORD,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      cursorColor: appStore.isDarkMode
                          ? Colors.white
                          : AppColors.kHabitDark,
                      decoration: appTextFieldInputDeco(hint: confirm_new_pwd),
                      errorThisFieldRequired: errorThisFieldRequired,
                      validator: (value) {
                        if (value!.trim().isEmpty)
                          return errorThisFieldRequired;
                        if (value.trim().length < passwordLengthGlobal)
                          return 'Minimum password length should be $passwordLengthGlobal';
                        return newPwdController.text == value.trim()
                            ? null
                            : AppStrings.kMatchPassError;
                      },
                      onFieldSubmitted: (val) {
                        resetPassword();
                      },
                    ),
                    16.height,
                    AppButton(
                      child: Text(change_acc_pwd2,
                          style: boldTextStyle(
                              color: appStore.isDarkMode
                                  ? AppColors.kHabitDark
                                  : Colors.white)),
                      color: AppColors.kHabitOrange,
                      width: context.width(),
                      onTap: () {
                        resetPassword();
                      },
                    ),
                    16.height,
                    Divider(
                      thickness: 2,
                    ),
                    infoWidget(),
                  ],
                ),
              ).center(),
            ),
          ),
          Observer(
            builder: (_) => Loader(
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kHabitDark)
                .visible(appStore.isLoading),
          ),
        ],
      ),
    );
  }

  void resetPassword() {
    if (_formKey.currentState!.validate()) {
      appStore.setLoading(true);
      service
          .resetPassword(newPassword: newPwdController.text.trim())
          .then((value) async {
        appStore.setLoading(false);

        await setValue(PASSWORD, confirmPwdController.text.trim());

        finish(context);
        toast(pwd_changed_successfully);
      }).catchError((error) {
        appStore.setLoading(false);
        log(error.toString());
        toast(errorSomethingWentWrong);
      });
    }
  }

  Widget infoWidget() {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              child: Row(
                children: [
                  /// Info for account login through third-parties
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note: ',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'This section does not apply to accounts created through Google services/ third-party login.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
