import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/common.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import '../../models/notes_model.dart';

/// Create a 4-digit password for locking notes
class SetMasterPasswordDialogWidget extends StatefulWidget {
  static String tag = '/SetMasterPasswordScreen';
  final String? userId;
  final NotesModel? notesModel;

  SetMasterPasswordDialogWidget({this.userId, this.notesModel});

  @override
  SetMasterPasswordDialogWidgetState createState() =>
      SetMasterPasswordDialogWidgetState();
}

class SetMasterPasswordDialogWidgetState extends State<SetMasterPasswordDialogWidget> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  TextEditingController pwdController = TextEditingController();
  TextEditingController confPwdController = TextEditingController();

  VoidCallback? onTap;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Form(
        key: _form,
        child: Column(
          children: [
            AlertDialog(
              title: Text(create_lock_note_pwd,
                style: TextStyle(
                  color: getBoolAsync(IS_DARK_MODE)
                      ? AppColors.kHabitOrange
                      : AppColors.kTextBlack
              ),
              ),
              content: Column(
                children: [
                  AppTextField(
                    controller: pwdController,
                    textFieldType: TextFieldType.PASSWORD,
                    keyboardType: TextInputType.phone,
                    errorThisFieldRequired: errorThisFieldRequired,
                    cursorColor: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kHabitDark,
                    maxLines: 1,
                    maxLength: 4,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return errorThisFieldRequired;
                      } else if (val.length < 4) {
                        return pwd_length;
                      }
                      return null;
                    },
                    decoration: appTextFieldInputDeco(hint: password),
                  ).paddingBottom(16),
                  AppTextField(
                    controller: confPwdController,
                    textFieldType: TextFieldType.PASSWORD,
                    keyboardType: TextInputType.phone,
                    cursorColor: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kHabitDark,
                    maxLines: 1,
                    maxLength: 4,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return errorThisFieldRequired;
                      } else if (val.length < 4) {
                        return pwd_length;
                      } else if (pwdController.text.trim() != val.trim()) {
                        return pwd_not_same;
                      }
                      return null;
                    },
                    decoration: appTextFieldInputDeco(hint: confirm_pwd),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      finish(context);
                    },
                    child: Text(cancel, style: primaryTextStyle())),
                TextButton(
                    onPressed: () {
                      setMasterPassword();
                    },
                    child: Text(submit,
                        style: primaryTextStyle(
                          color: AppColors.kHabitOrange,
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setMasterPassword() {
    if (_form.currentState!.validate()) {
      userDBService.updateDocument({'masterPwd': pwdController.text.trim()},
          widget.userId).then((value) {
        notesService.updateDocument(
            {'isLock': true}, widget.notesModel!.noteId).then((value) async {
          toast('Password set successfully');
          await setValue(USER_MASTER_PWD, pwdController.text.trim());

          pwdController.clear();
          confPwdController.clear();

          finish(context);
        }).catchError((error) {
          toast(error.toString());
        });
      }).catchError((error) {
        toast(error.toString());
      });
    }
  }
}
