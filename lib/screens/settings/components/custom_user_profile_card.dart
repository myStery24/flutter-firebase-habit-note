import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import '../../../models/user_model.dart';

class CustomUserProfileCard extends StatefulWidget {
  const CustomUserProfileCard({Key? key}) : super(key: key);

  @override
  State<CustomUserProfileCard> createState() => _CustomUserProfileCardState();
}

class _CustomUserProfileCardState extends State<CustomUserProfileCard> {
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
    return InkWell(
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
        shadowColor:
            appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kHabitDark,
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
                      child: commonCacheImageWidget(imageUrl, imageRadius + 60,
                              fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(60)
                          .paddingBottom(8),
                      radius: imageRadius),
                  PositionedDirectional(
                    end: 0,
                    bottom: 5,
                    child: ClipOval(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        color: AppColors.kHabitOrange,
                        child: Icon(Icons.edit, color: Colors.black, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  /// Username
                  Text(name,
                      style: GoogleFonts.lato(
                          fontSize: 18.0,
                          color: getBoolAsync(IS_DARK_MODE)
                              ? AppColors.kHabitOrange
                              : AppColors.kTextBlack,
                          fontWeight: TextFontWeight.medium),
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: size.height * 0.01),

                  /// Email
                  Text(userEmail.validate(),
                      style: GoogleFonts.lato(
                          fontSize: 14.0,
                          color: getBoolAsync(IS_DARK_MODE)
                              ? AppColors.kTextWhite.withOpacity(0.7)
                              : AppColors.kGrayColor,
                          fontWeight: TextFontWeight.light),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
      ),
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
    /// Launch the device's camera or native gallery and get an image source
    final pickedImage = await ImagePicker().pickImage(source: source);
    try {
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
        'profileImages/${getStringAsync(USER_ID)}'; // uploaded image name will be the user id
    // 'profileImages/user/${getStringAsync(USER_ID)}/${imageFile!.name}'; // path of user profile picture
    Reference storageRef =
        FirebaseStorage.instance.ref().child(path); // storage reference
    final userImage = File(imageFile!.path);
    UploadTask uploadTask = storageRef.putFile(userImage);

    uploadTask.whenComplete(() async {
      imageUrl = await storageRef.getDownloadURL();
      _userRef
          .doc(getStringAsync(USER_ID))
          .update({"photoUrl": imageUrl, "updatedAt": DateTime.now()});

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
