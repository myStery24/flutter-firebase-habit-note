import 'dart:io';

import 'package:camera/camera.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:habit_note/screens/ocr/components/text_detector_painter_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/dashboard_drawer_widget.dart';
import '../../main.dart';
import '../../utils/colours.dart';
import '../../utils/constants.dart';
import 'components/text_area_widget.dart';

/// StatefulWidget to track the selected image
class OCRScreen extends StatefulWidget {
  const OCRScreen({Key? key}) : super(key: key);

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  static String tag = '/OCRScreen';

  /// Nullable [XFile]
  XFile? imageFile; // Store user picked image
  String scannedText = ""; // Store the recognised text
  bool textScanning = false;
  CustomPaint? customPaint;

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

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
      builder: (_) => Scaffold(
        key: _scaffoldState,
        backgroundColor: appStore.isDarkMode
            ? AppColors.kHabitDarkGrey
            : AppColors.kScaffoldColor,
        appBar: AppBar(
          title: Text(
            AppStrings.ocrScreen,
            style: GoogleFonts.fugazOne(),
          ),
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
              icon:
                  Icon(Icons.clear_all, semanticLabel: 'clear image and text'),
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

        /// Sidebar Drawer
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

                  /// if the image state is not null, show the image else display a photo icon placeholder
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
                  children: <Widget>[
                    /// Detect Text
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: appStore.isDarkMode
                            ? AppColors
                                .kPrimaryVariantColorDark // Colors.white12
                            : AppColors.kHabitOrange,
                        shadowColor: getBoolAsync(IS_DARK_MODE,
                                defaultValue: false)
                            ? AppColors.kHabitOrange
                            : AppColors
                                .kPrimaryVariantColorDark, // Colors.white12,
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: [
                                  Text(
                                    'Detect image',
                                    style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: getBoolAsync(IS_DARK_MODE,
                                              defaultValue: false)
                                          ? AppColors.kHabitOrange
                                          : AppColors.kTextWhite,
                                      fontWeight: TextFontWeight.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Loading
                    SizedBox(
                      width: 8.0,
                    ),
                    if (textScanning)
                      const CircularProgressIndicator(
                        color: AppColors.kHabitOrange,
                      ),
                    if (!textScanning)
                      Icon(Icons.arrow_right_alt,
                          size: 20,
                          color: appStore.isDarkMode
                              ? Colors.white60
                              : Colors.black),
                    SizedBox(
                      width: 8.0,
                    ),

                    /// Text
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        color: appStore.isDarkMode
                            ? AppColors.kPrimaryVariantColorDark
                            : AppColors.kHabitOrange,
                        shadowColor: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kHabitOrange
                            : AppColors.kPrimaryVariantColorDark,
                        elevation: 5,
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: [
                                  Text(
                                    'Text',
                                    style: GoogleFonts.lato(
                                      fontSize: 18.0,
                                      color: getBoolAsync(IS_DARK_MODE,
                                              defaultValue: false)
                                          ? AppColors.kHabitOrange
                                          : AppColors.kTextWhite,
                                      fontWeight: TextFontWeight.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
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
              Divider(height: 16),
              ListTile(
                leading: Icon(Icons.camera_alt,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(from_camera, style: primaryTextStyle()),
                onTap: () async {
                  finish(context);
                  await availableCameras();

                  /// Take a photo
                  await getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(from_gallery, style: primaryTextStyle()),
                // todo
                /// not asking permission
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
    final textDetectorV2 = GoogleMlKit.vision
        .textDetectorV2(); // final textDetector = GoogleMlKit.vision.textDetector();

    /// Call the method to perform text recognition
    RecognisedText recognisedText = await textDetectorV2.processImage(
        inputImage,
        script: TextRecognitionOptions
            .CHINESE); // RecognisedText recognisedText = await textDetector.processImage(inputImage);

    /// Close the detector
    await textDetectorV2.close();

    // Todo
    /// Draw boxes around detected text
    // if (inputImage.inputImageData?.size != null &&
    //     inputImage.inputImageData?.imageRotation != null) {
    //   final painter = TextDetectorPainter(
    //       recognisedText,
    //       inputImage.inputImageData!.size,
    //       inputImage.inputImageData!.imageRotation);
    //   customPaint = CustomPaint(painter: painter);
    // } else {
    //   customPaint = null;
    // }

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
