import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

/// Reset the password (4 digit pin) that is used to lock notes
class ChangeMasterPasswordScreen extends StatefulWidget {
  static String tag = '/ChangeMasterPasswordScreen';

  @override
  ChangeMasterPasswordScreenState createState() =>
      ChangeMasterPasswordScreenState();
}

class ChangeMasterPasswordScreenState
    extends State<ChangeMasterPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController currentMasterPwdController = TextEditingController();
  TextEditingController newMasterPwdController = TextEditingController();
  TextEditingController confirmMasterPwdController = TextEditingController();

  FocusNode currentMasterPwdNode = FocusNode();
  FocusNode newMasterPwdNode = FocusNode();
  FocusNode confirmMasterPwdNode = FocusNode();

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
        title: Text(change_master_pwd),
        actions: [
          IconButton(
            icon: Icon(Icons.contact_support_outlined),
            tooltip: 'Support email',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    support_email,
                    style: TextStyle(
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kHabitOrange
                            : AppColors.kTextBlack,
                        fontWeight: TextFontWeight.bold),
                  ),
                  content: Text(
                    'Contact us at ai190244bim@gmail.com to reset your master password.',
                    style: TextStyle(
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kTextWhite
                            : AppColors.kTextBlack),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Got it !',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: AppColors.kHabitOrange,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
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
                    // Text('Forgot your master password ?',
                    //     style: boldTextStyle(size: 22)),
                    15.height,
                    Text(
                        "You can change your lock + unlock notes' password here. Please fill up the following fields to change your password. \nWrite to our support email if you forgot your current password.",
                        style: primaryTextStyle(size: 14)),
                    20.height,
                    AppTextField(
                      controller: currentMasterPwdController,
                      focus: currentMasterPwdNode,
                      nextFocus: newMasterPwdNode,
                      textFieldType: TextFieldType.PASSWORD,
                      keyboardType: TextInputType.text,
                      maxLength: 4,
                      isPassword: true,
                      cursorColor: appStore.isDarkMode
                          ? Colors.white
                          : AppColors.kHabitDark,
                      decoration: appTextFieldInputDeco(hint: current_pwd),
                      errorThisFieldRequired: errorThisFieldRequired,
                      validator: (val) {
                        if (val != getStringAsync(USER_MASTER_PWD)) {
                          return current_pwd_invalid;
                        }
                        return null;
                      },
                    ),
                    16.height,
                    AppTextField(
                      controller: newMasterPwdController,
                      focus: newMasterPwdNode,
                      nextFocus: confirmMasterPwdNode,
                      textFieldType: TextFieldType.PASSWORD,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      maxLength: 4,
                      cursorColor: appStore.isDarkMode
                          ? Colors.white
                          : AppColors.kHabitDark,
                      decoration: appTextFieldInputDeco(hint: new_pwd),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return errorThisFieldRequired;
                        } else if (val.length < 4) {
                          return pwd_length;
                        }
                        return null;
                      },
                    ),
                    16.height,
                    AppTextField(
                      controller: confirmMasterPwdController,
                      focus: confirmMasterPwdNode,
                      textFieldType: TextFieldType.PASSWORD,
                      keyboardType: TextInputType.text,
                      isPassword: true,
                      maxLength: 4,
                      cursorColor: appStore.isDarkMode
                          ? Colors.white
                          : AppColors.kHabitDark,
                      decoration: appTextFieldInputDeco(hint: confirm_new_pwd),
                      validator: (val) {
                        if (val!.trim().isEmpty) {
                          return errorThisFieldRequired;
                        } else if (val.length < 4) {
                          return pwd_length;
                        } else if (newMasterPwdController.text.trim() !=
                            val.trim()) {
                          return pwd_not_same;
                        }
                        return null;
                      },
                      onFieldSubmitted: (val) {
                        resetMasterPassword();
                      },
                    ),
                    16.height,
                    AppButton(
                      child: Text(change_master_pwd2,
                          style: boldTextStyle(
                              color: appStore.isDarkMode
                                  ? AppColors.kHabitDark
                                  : Colors.white)),
                      color: AppColors.kHabitOrange,
                      width: context.width(),
                      onTap: () {
                        resetMasterPassword();
                      },
                    ),
                  ],
                ),
              ).center(),
            ),
          ),
          Observer(
              builder: (_) => Loader(
                      color: appStore.isDarkMode
                          ? AppColors.kHabitDark
                          : AppColors.kHabitOrange)
                  .visible(appStore.isLoading)),
        ],
      ),
    );
  }

  void resetMasterPassword() {
    if (_formKey.currentState!.validate()) {
      appStore.setLoading(true);
      Map<String, dynamic> req = {
        'masterPwd': newMasterPwdController.text.trim(),
      };
      userService
          .updateDocument(req, getStringAsync(USER_ID))
          .then((value) async {
        await setValue(USER_MASTER_PWD, newMasterPwdController.text.trim());

        toast(pwd_reset_successfully);
        finish(context);

        appStore.setLoading(false);

        currentMasterPwdController.clear();
        newMasterPwdController.clear();
        confirmMasterPwdController.clear();
      }).catchError((error) {
        appStore.setLoading(false);

        toast(errorSomethingWentWrong);
      });
    }
  }
}
