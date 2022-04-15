import 'package:flutter/material.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class LockNoteDialogWidget extends StatefulWidget {
  static String tag = '/LockNoteDialogWidget';
  final Function(bool)? onSubmit;

  LockNoteDialogWidget({this.onSubmit});

  @override
  LockNoteDialogWidgetState createState() => LockNoteDialogWidgetState();
}

class LockNoteDialogWidgetState extends State<LockNoteDialogWidget> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();

  TextEditingController masterPwdController = TextEditingController();

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
    return Container(
      width: context.width(),
      child: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: AlertDialog(
          title: Text('Lock & Unlock note'),
          content: AppTextField(
            autoFocus: true,
            controller: masterPwdController,
            textFieldType: TextFieldType.PASSWORD,
            keyboardType: TextInputType.phone,
            errorThisFieldRequired: errorThisFieldRequired,
            cursorColor: appStore.isDarkMode ? Colors.white : AppColors.kHabitDark,
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
            decoration: appTextFieldInputDeco(hint: enter_master_pwd),
          ),
          actions: [
            TextButton(
              onPressed: () {
                finish(context);
                masterPwdController.clear();
              },
              child: Text(cancel, style: primaryTextStyle()),
            ),
            TextButton(
              onPressed: () async {
                if (_form.currentState!.validate()) {
                  if (masterPwdController.text.trim() == getStringAsync(USER_MASTER_PWD)) {
                    widget.onSubmit!(true);
                    await 2.seconds.delay;
                    masterPwdController.clear();
                  } else {
                    toast(invalid_pwd);
                  }
                }
              },
              child: Text(submit,
                  style: primaryTextStyle(
                    color: AppColors.kHabitOrange,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
