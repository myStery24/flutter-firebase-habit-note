import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/screens/settings/components/delete_account_consent_screen.dart';
import 'package:habit_note/widgets/custom_richtext_widget.dart';
import 'package:habit_note/widgets/custom_setting_item_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import '../../../models/user_model.dart';
import '../../password/change_account_password_screen.dart';
import '../../password/change_master_password_screen.dart';
import '../../policies/privacy_policy_screen.dart';
import '../../policies/terms_of_use_screen.dart';
import 'about_screen.dart';

class SettingsCategory extends StatefulWidget {
  const SettingsCategory({Key? key}) : super(key: key);

  @override
  State<SettingsCategory> createState() => _SettingsCategoryState();
}

class _SettingsCategoryState extends State<SettingsCategory> {
  late String name;
  String? userEmail;
  String? imageUrl;
  XFile? imageFile; // Store user picked image

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    name = getStringAsync(USER_DISPLAY_NAME);
    userEmail = getStringAsync(USER_EMAIL);
    imageUrl = getStringAsync(USER_PHOTO_URL);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: ListView(padding: EdgeInsets.all(12.0), children: [
        /// User Profile Card
        InkWell(
          highlightColor: AppColors.kHabitOrange.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            selectOption(context); // Pick images
          },
          child: Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            shadowColor: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kHabitDark,
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  /// Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: commonCacheImageWidget(
                                imageUrl, imageRadius + 60,
                                fit: BoxFit.cover)
                            .cornerRadiusWithClipRRect(60)
                            .paddingBottom(8),
                        radius: imageRadius,
                      ),
                      Positioned(
                        bottom: 5,
                        right: 0,
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: AppColors.kHabitOrange,
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      /// Username
                      Text(
                        name,
                        style: GoogleFonts.lato(
                          fontSize: 18.0,
                          color: getBoolAsync(IS_DARK_MODE)
                              ? AppColors.kHabitOrange
                              : AppColors.kTextBlack,
                          fontWeight: TextFontWeight.medium,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: size.height * 0.01),

                      /// Email
                      Text(userEmail.validate(),
                          style: GoogleFonts.lato(
                            fontSize: 14.0,
                            color: getBoolAsync(IS_DARK_MODE)
                                ? AppColors.kTextWhite.withOpacity(0.7)
                                : AppColors.kGrayColor,
                            fontWeight: TextFontWeight.light,
                          ),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * .01),
        Divider(
          thickness: 2,
        ),

        /// Light/ Dark mode
        SettingItemWidget(
          title: 'THEME',
        ),
        ListTile(
          leading: Icon(
            Icons.light_mode_outlined,
            semanticLabel: 'light mode',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          // adaptive = both Android and iOS
          title: Switch.adaptive(
            value: appStore.isDarkMode,
            activeColor: AppColors.kHabitOrange,
            activeTrackColor: AppColors.kScaffoldSecondaryDark,
            inactiveThumbColor: AppColors.kHabitDark,
            inactiveTrackColor: AppColors.kScaffoldSecondaryDark,
            onChanged: (val) async {
              appStore.setDarkMode(val);
              await setValue(IS_DARK_MODE, val);
            },
          ),
          trailing: Icon(
            Icons.dark_mode,
            semanticLabel: 'dark mode',
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
        ),
        SizedBox(height: size.height * .01),
        Divider(
          thickness: 2,
        ),
        SettingItemWidget(
          title: 'LOGIN & SECURITY',
        ),

        /// Unlock/ lock notes password
        CustomSettingItemWidget(
            leadingIcon: Icons.pin_outlined,
            trailingIcon: Icons.keyboard_arrow_right,
            semanticLabel: 'reset master password',
            title: settings_change_master_pwd,
            onTap: () {
              finish(context);
              ChangeMasterPasswordScreen().launch(context);
            }),
        Divider(
          thickness: 2,
        ),

        /// Reset Account password
        CustomSettingItemWidget(
            leadingIcon: Icons.password_outlined,
            trailingIcon: Icons.keyboard_arrow_right,
            semanticLabel: 'reset account password',
            title: settings_change_pwd,
            onTap: () {
              finish(context);
              ChangeAppPasswordScreen().launch(context);
            }),
        Divider(
          thickness: 2,
        ),

        SettingItemWidget(
          title: 'INFO',
        ),

        /// About App
        CustomSettingItemWidget(
            leadingIcon: Icons.info_outline,
            trailingIcon: Icons.keyboard_arrow_right,
            semanticLabel: 'about us',
            title: settings_info_about_us,
            onTap: () {
              finish(context);
              AboutAppScreen().launch(context);
            }),
        Divider(
          thickness: 2,
        ),

        /// Privacy Policy
        CustomSettingItemWidget(
            leadingIcon: Icons.policy_outlined,
            trailingIcon: Icons.keyboard_arrow_right,
            semanticLabel: 'privacy policy',
            title: settings_info_pp,
            onTap: () {
              finish(context);
              PrivacyPolicyScreen().launch(context);
            }),
        Divider(
          thickness: 2,
        ),

        /// Terms of Use
        CustomSettingItemWidget(
            leadingIcon: Icons.article_outlined,
            trailingIcon: Icons.keyboard_arrow_right,
            semanticLabel: 'terms of use',
            title: settings_info_tou,
            onTap: () {
              finish(context);
              TermsOfUseScreen().launch(context);
            }),
        Divider(
          thickness: 2,
        ),

        /// Request to delete user account
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(size.width, 50),
              textStyle: TextStyle(fontSize: 18.0),
              primary: Colors.red, // foreground
              side: BorderSide(width: 3.0, color: Colors.red),
            ),
            onPressed: () {
              finish(context);
              DeleteAccountConsentScreen().launch(context);
            },
            child: Text('Delete My Account'),
          ),
        ),
        SizedBox(height: size.height * .03),
        Container(
          margin: EdgeInsets.all(8.0),
          child: Center(
            child: CustomRichTextWidget(
              primaryText: 'HaBIT Note ',
              primaryFontSize: 18.0,
              secondaryText: AppStrings.appVersionText2,
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
            ),
          ),
        ),
        SizedBox(height: size.height * .02),
      ]),
    );
  }

  /// A dialog box with two options
  Future<void> selectOption(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // dismiss when click outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take photo'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Get image
  Future<void> getImage(ImageSource source) async {
    try {
      /// Launch the device's camera or native gallery and get an image source
      final pickedImage = await ImagePicker().pickImage(source: source);

      // If there is an image
      if (pickedImage != null) {
        imageFile = pickedImage; // set the image path to the imageFile object
        uploadImage(); // call the upload image function
        toast('Uploading...');
      }
    } catch (e) {
      toast('Error occurred. Please try again later.');
    }
  }

  /// Upload to Firebase
  Future<String?> uploadImage() async {
    final path =
        'image/${getStringAsync(USER_ID)}'; // path of user profile picture
    Reference storageRef =
        FirebaseStorage.instance.ref().child(path); // storage reference
    final userImage = File(imageFile!.path);
    UploadTask uploadTask = storageRef.putFile(userImage);

    uploadTask.whenComplete(() async {
      imageUrl = await storageRef.getDownloadURL();
      _userRef.doc(getStringAsync(USER_ID)).update({
        "photoUrl": imageUrl,
        "updatedAt": DateTime.now(),
      });

      /// Update the UI
      setState(() {
        UserModel userData = UserModel();
        userData.photoUrl = getStringAsync(USER_PHOTO_URL);
      });
      toast('Changes saved');
    }).catchError((error) {
      toast(error.toString());
      toast('Error occurred when saving. Please try again later.');
    });
    return imageUrl;
  }
}
