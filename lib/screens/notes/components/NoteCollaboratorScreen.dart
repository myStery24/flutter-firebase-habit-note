import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:habit_note/model/notes_model.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class NoteCollaboratorScreen extends StatefulWidget {
  static String tag = '/NoteCollaboratorScreen';
  final NotesModel? notesModel;

  NoteCollaboratorScreen({this.notesModel});

  @override
  NoteCollaboratorScreenState createState() => NoteCollaboratorScreenState();
}

class NoteCollaboratorScreenState extends State<NoteCollaboratorScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String?>? collaborateWithList = [];

  TextEditingController userEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? userMail;

  bool mIsUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? AppColors.kHabitDark : Colors.white,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );

    userMail = getStringAsync(USER_EMAIL);
    mIsUpdate = widget.notesModel != null;
    if (mIsUpdate) {
      collaborateWithList = widget.notesModel!.collaborateWith;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.dark, delayInMilliSeconds: 100);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(collaborators),
        actions: [
          TextButton(
            onPressed: () async {
              sendEmailToCollaborators(collaborateWithList!).then((value) {
                finish(context, collaborateWithList);
              }).catchError((error) {
                toast(error.toString());
              });
            },
            child: Text(save, style: primaryTextStyle()),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Row(
                    children: [
                      commonCacheImageWidget(
                              getStringAsync(USER_PHOTO_URL).validate(),
                              imageRadius,
                              fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(60),
                      16.width,
                      Text(userMail.validate(),
                          style: primaryTextStyle(size: 18),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ).paddingAll(16),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: collaborateWithList!.length,
                    itemBuilder: (_, index) {
                      var collaData = collaborateWithList![index];

                      return collaData != getStringAsync(USER_EMAIL)
                          ? Container(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    child: Text(collaData![0].validate(),
                                        style: boldTextStyle(
                                            size: 14, color: white)),
                                    radius: 20,
                                    backgroundColor: appStore.isDarkMode
                                        ? AppColors.kHabitOrange
                                        : AppColors.kHabitDark,
                                  ),
                                  16.width,
                                  Text(collaData.validate(),
                                          style: primaryTextStyle())
                                      .expand(),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        collaborateWithList!.removeAt(index);
                                      });
                                    },
                                  )
                                ],
                              ).paddingAll(16),
                            )
                          : SizedBox();
                    },
                  ),
                  addCollaborateItemWidget(),
                ],
              ),
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

  Widget addCollaborateItemWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.person_add).paddingOnly(left: 8, right: 16),
        AppTextField(
          controller: userEmailController,
          cursorColor:
              appStore.isDarkMode ? Colors.white : AppColors.kHabitDark,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter email to share with',
              hintStyle: primaryTextStyle(color: Colors.grey)),
          keyboardType: TextInputType.emailAddress,
          textFieldType: TextFieldType.EMAIL,
          textInputAction: TextInputAction.done,
          maxLines: 1,
          errorInvalidEmail: 'Enter valid email',
          errorThisFieldRequired: errorThisFieldRequired,
          onFieldSubmitted: (val) {
            if (_formKey.currentState!.validate()) {
              if (userEmailController.text.trim() != userMail.validate()) {
                if (!collaborateWithList!.any(
                    (element) => element == userEmailController.text.trim())) {
                  userDBService
                      .getUserByEmail(userEmailController.text.trim())
                      .then((value) {
                    collaborateWithList!.add(value.email);

                    userEmailController.clear();
                    setState(() {});
                  }).catchError((error) {
                    toast(error.toString());
                  });
                } else {
                  toast(email_already_exits);
                }
              } else {
                toast(email_already_exits);
              }
            }
          },
        ).expand(),
      ],
    ).paddingAll(8);
  }

  Future<void> sendEmailToCollaborators(List<String?> emailList) async {
    List<String?> userMailList = [];
    userMailList.addAll(emailList);
    if (userMailList.first == getStringAsync(USER_EMAIL)) {
      userMailList.removeAt(0);
    }
    String? password = await showInDialog(
      context,
      title: Text('Enter your email\'s password for send email to your friend',
          style: primaryTextStyle()),
      child: AppTextField(
        controller: passwordController,
        textFieldType: TextFieldType.PASSWORD,
        isPassword: true,
        errorThisFieldRequired: errorThisFieldRequired,
        decoration: appTextFieldInputDeco(hint: 'Enter password'),
      ),
      actions: [
        TextButton(
            onPressed: () {
              hideKeyboard(context);

              finish(context);
            },
            child: Text(cancel, style: primaryTextStyle())),
        TextButton(
            onPressed: () {
              hideKeyboard(context);

              finish(context, passwordController.text.trim());
            },
            child: Text(submit, style: primaryTextStyle())),
      ],
    );
    if (password != null) {
      appStore.setLoading(true);
      String username = getStringAsync(USER_EMAIL);
      String pwd = password;

      // ignore: deprecated_member_use
      final smtpServer = gmail(username, pwd);

      final message = Message()
        ..from = Address(username, getStringAsync(USER_DISPLAY_NAME))
        ..recipients.addAll(userMailList)
        ..subject = 'Share notes by your friend';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
        appStore.setLoading(false);
      } on MailerException catch (e) {
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }

        appStore.setLoading(false);

        throw e.message.toString();
      }
    }
  }
}
