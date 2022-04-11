import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/DashboardDrawerWidget.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'components/text_area_widget.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({Key? key}) : super(key: key);

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  XFile? imageFile;
  String scannedText = "";
  bool textScanning = false;

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Observer(
      builder: (_) => Scaffold(
          key: _scaffoldState,
          backgroundColor: appStore.isDarkMode
              ? AppColors.kHabitDarkGrey
              : AppColors.kScaffoldColor,
          appBar: AppBar(
            title: Text(AppStrings.ocrScreen),
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.menu_rounded),
              color: AppColors.kHabitOrange,
              onPressed: () {
                _scaffoldState.currentState!.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.clear_all),
                tooltip: 'Clear all',
                onPressed: () {
                  /// Clear image and scanned text
                  clear();
                },
              ),
              IconButton(
                icon: Icon(Icons.copy),
                tooltip: 'Copy text',
                onPressed: () {
                  /// Copy scanned/recognised text to clipboard
                  copyToClipboard();
                },
              ),
            ],
          ),
          floatingActionButton: Observer(
            builder: (_) => FloatingActionButton(
              onPressed: () {
                cameraOrGallery();
              },
             child: Icon(Icons.add_photo_alternate,
                  color:
                      appStore.isDarkMode ? AppColors.kHabitDark : Colors.white),
              backgroundColor: appStore.isDarkMode
                  ? AppColors.kHabitOrange
                  : AppColors.kHabitOrange,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          drawer: DashboardDrawerWidget(),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Image placeholder
                    Container(
                      width: getProportionateScreenWidth(size.width * 0.8),
                      height: getProportionateScreenHeight(size.height * 0.3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        color: appStore.isDarkMode ? Colors.white12 : Colors.white,
                      ),
                      child: imageFile != null
                          ? Image.file(File(imageFile!.path))
                          : Icon(Icons.photo, size: 80, color: Colors.black),
                    ),
                    SizedBox(
                      height: 18.0,
                    ),

                    /// Scanning indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: getProportionateScreenWidth(130),
                          height: getProportionateScreenWidth(30),
                          decoration: BoxDecoration(
                            color: appStore.isDarkMode ? Colors.white12 : AppColors.kHabitOrange,
                            borderRadius: BorderRadius.circular(12),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Detect image',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kTextWhite,
                                fontSize: 16.0,
                                fontWeight: TextFontWeight.medium,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        if (textScanning) const CircularProgressIndicator(color: AppColors.kHabitOrange,),
                        if (!textScanning) Icon(Icons.arrow_right_alt, size: 20, color: appStore.isDarkMode ? Colors.white60 : Colors.black),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: getProportionateScreenWidth(130),
                          height: getProportionateScreenHeight(30),
                          decoration: BoxDecoration(
                            color: appStore.isDarkMode ? Colors.white12 : AppColors.kHabitOrange,
                            borderRadius: BorderRadius.circular(12),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Text',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kTextWhite,
                                fontSize: 16.0,
                                fontWeight: TextFontWeight.medium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    if (!textScanning && imageFile == null)
                    Container(
                      height: getProportionateScreenHeight(10.0),
                    ),

                    /// Recognised Text
                    RecognisedTextAreaWidget(
                      text: scannedText,
                    ),
                  ],
              ),
            ),
          ),
      ),
    );
  }

  cameraOrGallery() {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text(select_option, style: secondaryTextStyle(size: 18))
                  .center()
                  .paddingAll(8),
              Divider(height: 16),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(from_camera, style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(from_gallery, style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Image provider
  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        toast('Scanning image, please wait...');
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      toast('Error, please try again');
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      setState(() {});
    }
  }

  /// Text provider
  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
    if (scannedText.trim() == '')
      {
        if (imageFile != null)
        toast('No text is found, please try again');
      }
  }

  void copyToClipboard() {
    if (scannedText.trim() != '') {
      FlutterClipboard.copy(scannedText);
      toast('Copied to clipboard');
    } else {
      toast('Error, nothing to copy');
    }
  }

  /// Reset text area
  void setText(String newText) {
    setState(() {
      scannedText = newText;
    });
  }

  void clear() {
    if (imageFile != null && scannedText.trim() != '') {
      toast('Cleared');
    } else if (imageFile != null){
      toast('Image cleared');
    } else {
      toast('Please provide an image');
    }
    imageFile = null;
    setText('');
  }
}
