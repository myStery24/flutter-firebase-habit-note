import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import '../../../models/notes_model.dart';

// TODO: Collaborator
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
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light, delayInMilliSeconds: 100);

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
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark, delayInMilliSeconds: 100);
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
            child: Text(save,
              style: TextStyle(
                color: getBoolAsync(IS_DARK_MODE)
                    ? AppColors.kHabitOrange
                    : AppColors.kTextBlack,
              ),
            ),
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
                      commonCacheImageWidget(getStringAsync(USER_PHOTO_URL).validate(), imageRadius, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                      16.width,
                      Text(userMail.validate(), style: primaryTextStyle(size: 18), overflow: TextOverflow.ellipsis).expand(),
                    ],
                  ).paddingAll(16),
                  Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: collaborateWithList!.length,
                    itemBuilder: (_, index) {
                      var collabData = collaborateWithList![index];

                      return collabData != getStringAsync(USER_EMAIL)
                          ? Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Text(collabData![0].validate(), style: boldTextStyle(size: 14, color: white)),
                              radius: 20,
                              backgroundColor: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kHabitDark,
                            ),
                            16.width,
                            Text(collabData.validate(), style: primaryTextStyle()).expand(),
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
          Observer(builder: (_) => Loader(color: appStore.isDarkMode ? AppColors.kHabitDark : AppColors.kHabitOrange).visible(appStore.isLoading)),
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
          cursorColor: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kHabitDark,
          decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter an email to share with', hintStyle: primaryTextStyle(color: Colors.grey)),
          keyboardType: TextInputType.emailAddress,
          textFieldType: TextFieldType.EMAIL,
          textInputAction: TextInputAction.done,
          maxLines: 1,
          errorInvalidEmail: AppStrings.kInvalidEmailError,
          errorThisFieldRequired: errorThisFieldRequired,
          onFieldSubmitted: (val) {
            if (_formKey.currentState!.validate()) {
              if (userEmailController.text.trim() != userMail.validate()) {
                if (!collaborateWithList!.any((element) => element == userEmailController.text.trim())) {
                  userDBService.getUserByEmail(userEmailController.text.trim()).then((value) {
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
      title: Text('Enter your email\'s password for sending an email to your friend', style: primaryTextStyle()),
      // (_) means there is an argument
      builder: (_) => new AppTextField(
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
