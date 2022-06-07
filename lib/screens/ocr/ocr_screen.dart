import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import 'components/custom_deco_box.dart';
import 'components/text_area_widget.dart';

/// StatefulWidget to track the selected image
class OCRScreen extends StatefulWidget {
  static String tag = '/OCRScreen';

  const OCRScreen({Key? key}) : super(key: key);

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  /// Nullable [XFile]
  XFile? imageFile; // Store user picked image
  String scannedText = ""; // Store the recognised text
  bool textScanning = false;

  // CustomPaint? _customPaint; // Draw boxes on a scanned image

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the screenWidth and screenHeight
    SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    return Observer(
      builder: (_) => SafeArea(
        child: Scaffold(
          key: _scaffoldState,
          backgroundColor: appStore.isDarkMode
              ? AppColors.kScaffoldColorDark
              : AppColors.kScaffoldColor,
          appBar: AppBar(
            title: Text(
              AppStrings.ocrScreen,
              style: GoogleFonts.fugazOne(),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: Icon(Icons.clear_all,
                    semanticLabel: 'clear image and text'),
                tooltip: 'Clear all',
                onPressed: () {
                  /// Clear image and scanned text
                  clear();
                },
              ),
              IconButton(
                icon: Icon(Icons.copy, semanticLabel: 'copy text'),
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
              child: Icon(
                Icons.add_photo_alternate,
                color: getBoolAsync(IS_DARK_MODE)
                    ? AppColors.kHabitDark
                    : Colors.white,
              ),
              backgroundColor: AppColors.kHabitOrange,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Image placeholder
                  Container(
                    width: size.width,
                    //height: size.height * 0.42,
                    height: size.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      color:
                          appStore.isDarkMode ? Colors.white12 : Colors.white,
                    ),

                    /// If the image state is not null,
                    child: imageFile != null
                        ? Image.file(File(imageFile!.path)) // show the image
                        : Icon(Icons.photo,
                            size: 80,
                            color: Colors
                                .black), // else display a photo icon placeholder
                  ),
                  SizedBox(height: 18.0),

                  /// Scanning
                  _scanningIndicator(),
                  SizedBox(height: 12.0),
                  if (!textScanning && imageFile == null)
                    Container(height: getProportionateScreenHeight(10.0)),

                  /// Display recognised text
                  RecognisedTextAreaWidget(text: scannedText),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Two decoration boxes and a scanning indicator
  _scanningIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /// Deco box 1
        CustomDecoBox(
            margin: const EdgeInsets.all(8.0),
            lightModeColor: AppColors.kHabitOrange,
            lightModeShadowColor: AppColors.kPrimaryVariantColorDark,
            darkModeColor: AppColors.kHabitDark,
            darkModeShadowColor: AppColors.kHabitOrange,
            padding: const EdgeInsets.all(10.0),
            text: 'Detect image',
            textColor: appStore.isDarkMode
                ? AppColors.kHabitOrange
                : AppColors.kTextWhite),
        SizedBox(width: 8.0),

        /// Loading
        if (textScanning)
          const CircularProgressIndicator(color: AppColors.kHabitOrange),
        if (!textScanning)
          Icon(Icons.arrow_right_alt,
              size: 20,
              color: appStore.isDarkMode ? Colors.white60 : Colors.black),

        /// Deco box 2
        SizedBox(width: 8.0),
        CustomDecoBox(
          margin: const EdgeInsets.all(8.0),
          lightModeColor: AppColors.kHabitOrange,
          lightModeShadowColor: AppColors.kPrimaryVariantColorDark,
          darkModeColor: AppColors.kHabitDark,
          darkModeShadowColor: AppColors.kHabitOrange,
          padding: const EdgeInsets.all(10.0),
          text: 'Text',
          textColor: appStore.isDarkMode
              ? AppColors.kHabitOrange
              : AppColors.kTextWhite,
        ),
      ],
    );
  }

  /// Camera or Gallery Options to select a photo or an image
  Future<void> cameraOrGallery() async {
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
              Divider(height: 16.0),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kScaffoldSecondaryDark),
                title: Text(from_camera, style: primaryTextStyle()),
                onTap: () async {
                  finish(context);

                  /// Take a photo
                  await getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.kScaffoldSecondaryDark),
                title: Text(from_gallery, style: primaryTextStyle()),
                onTap: () async {
                  finish(context);

                  /// Pick an image
                  await getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Upload image
  Future uploadOcrImage() async {
    // UploadTask? upload;
    final path =
        'ocrImages/user/${getStringAsync(USER_ID)}/${imageFile!.name}'; // Path to store the images
    final storageRef = _storage.ref().child(
        path); // A reference to the location of uploaded images in Firebase Storage
    final ocrImage =
        File(imageFile!.path); // Convert picked file/image to a file object

    storageRef.putFile(ocrImage); // Upload the file to Firebase Storage
    // upload = storageRef.putFile(ocrImage);
    // await upload.whenComplete(() => print('Uploaded image successfully'));
  }

  /// Get image
  Future<void> getImage(ImageSource source) async {
    try {
      /// Launch the device's camera or native gallery and get an image source
      final pickedImage = await ImagePicker().pickImage(source: source);

      // If there is an image
      if (pickedImage != null) {
        toast('Scanning image, please wait...');
        textScanning = true;
        imageFile = pickedImage; // set the image path to the imageFile object
        /// Update the state variables once the process is complete
        if (mounted) {
          uploadOcrImage(); // upload the image to firebase storage
          setState(() {}); // update the UI to show the image
        }
        await getRecognisedText(pickedImage); // scan text from the picked image
      }
    } catch (e) {
      toast('Error, please try again');
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning";
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Recognise text
  Future<void> getRecognisedText(XFile image) async {
    /// Load the selected image
    final inputImage = InputImage.fromFilePath(image.path);

    /// Instance of GoogleMLKit Vision class to initialize a text detector
    // final textDetectorV2 = GoogleMlKit.vision.textDetectorV2();
    final TextRecognizer _textRecognizer =
        TextRecognizer(script: TextRecognitionScript.chinese);

    /// Call the method to perform text recognition
    // RecognisedText recognisedText = await textDetectorV2.processImage(inputImage, script: TextRecognitionOptions.CHINESE);
    final recognisedText = await _textRecognizer.processImage(inputImage);

    /// Extract text
    scannedText = "";
    // One paragraph
    for (TextBlock block in recognisedText.blocks) {
      // One line of text within a paragraph
      for (TextLine line in block.lines) {
        // Each word within a line of text
        for (TextElement element in line.elements) {
          scannedText = scannedText + element.text + ' ';
        }
        scannedText = scannedText + '\n';
      }
    }

    if (scannedText.trim() == '') {
      scannedText =
          'Error: ${recognisedText.blocks.length} text blocks detected :(';
      if (imageFile != null) toast('No text is found, please try again');
    }

    /// Update the state variables once the text recognition is complete
    textScanning = false;

    /// Check widget mounted state after each AsyncTask finishes
    /// Check the widget is mounted before setting the state
    if (mounted) {
      setState(() {});
    }

    /// Close the detector
    // await textDetectorV2.close();
    await _textRecognizer.close();
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
    } else if (imageFile != null) {
      toast('Image cleared');
    } else {
      toast('Please provide an image');
    }
    imageFile = null;
    setText('');
  }
}
