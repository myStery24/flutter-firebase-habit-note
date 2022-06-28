import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import '../../../models/images_model.dart';

/// Screen to choose photos and add a new feed post.
class AddImageScreen extends StatefulWidget {
  static String tag = '/AddImagesScreen';

  final ImagesModel? imagesModel;

  /// Create a [AddImageScreen].
  const AddImageScreen({Key? key, this.imagesModel}) : super(key: key);

  /// Material route to this screen.
  static Route get route =>
      MaterialPageRoute(builder: (_) => const AddImageScreen());

  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  static const double maxImageHeight = 1000;
  static const double maxImageWidth = 800;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final picker = ImagePicker();

  XFile? _pickedFile;
  String? imageUrl;
  bool isLoading = false;
  bool _kIsUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _kIsUpdate = widget.imagesModel != null;

    if (_kIsUpdate) {
      _titleController.text = widget.imagesModel!.title!;
      _descriptionController.text = widget.imagesModel!.description!;
      imageUrl = widget.imagesModel!.url!;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: _kIsUpdate ? Text('Edit Mode') : Text(add_image),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            color: appStore.isDarkMode
                ? AppColors.kHabitOrange
                : AppColors.kTextBlack,
            tooltip: 'Save',
            onPressed: () async {
              _postImage();
              hideKeyboard(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.clear_all, semanticLabel: 'clear image'),
            tooltip: 'Clear image',
            onPressed: () {
              /// Clear image
              _clear();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.kHabitOrange),
                  SizedBox(height: 12),
                  Text('Uploading...')
                ],
              ),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: [
                  InkWell(
                    onTap: _cameraOrGallery,
                    child: SizedBox(
                      height: 400,
                      child: (_pickedFile != null)
                          ? FadeInImage(
                              fit: BoxFit.contain,
                              placeholder: MemoryImage(kTransparentImage),
                              image: Image.file(File(_pickedFile!.path)).image,
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      AppColors.kHintTextLightGrey,
                                      AppColors.kHabitOrange
                                    ]),
                              ),
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _kIsUpdate
                                        ? Image.network(
                                            widget.imagesModel!.url!,
                                            fit: BoxFit.cover,
                                          )
                                        : Text(
                                            'Tap to select an image',
                                            style: TextStyle(
                                              color: AppColors.kTextWhite,
                                              fontSize: 18,
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(2.0, 1.0),
                                                  blurRadius: 3.0,
                                                  color: Colors.black54,
                                                ),
                                                Shadow(
                                                  offset: Offset(1.0, 1.5),
                                                  blurRadius: 5.0,
                                                  color: Colors.black54,
                                                ),
                                              ],
                                            ),
                                          ),
                                    8.height,
                                    _kIsUpdate
                                        ? SizedBox()
                                        : Icon(Icons.upload,
                                            color: AppColors.kTextWhite),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  18.height,

                  /// Title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _titleController,
                      cursorColor: appStore.isDarkMode
                          ? AppColors.kHabitOrange
                          : Colors.black,
                      decoration: InputDecoration(
                          hintText: 'Title', border: InputBorder.none),
                      style: boldTextStyle(
                          size: 20,
                          color: appStore.isDarkMode
                              ? AppColors.kTextWhite
                              : AppColors.kTextBlack),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                    ),
                  ),
                  8.height,

                  /// Description
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: null,
                        controller: _descriptionController,
                        cursorColor: appStore.isDarkMode
                            ? AppColors.kHabitOrange
                            : Colors.black,
                        decoration: const InputDecoration(
                          hintText: 'Type something awesome here',
                          border: InputBorder.none,
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Description field is empty';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Camera or Gallery Options to select a photo or an image
  Future<void> _cameraOrGallery() async {
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
                    _pickFile(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose photo'),
                  onTap: () {
                    _pickFile(ImageSource.gallery);
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

  Future<void> _pickFile(ImageSource source) async {
    _pickedFile = await picker.pickImage(
      source: source,
      maxHeight: maxImageHeight,
      maxWidth: maxImageWidth,
      imageQuality: 70,
    );
    setState(() {});
  }

  /// Post the image to Gallery tab
  Future<void> _postImage() async {
    if (_pickedFile == null) {
      toast('Please select an image first');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      toastLong('Please enter a description');
      return;
    }

    _setLoading(true);

    ImagesModel imagesData = ImagesModel();

    imagesData.userId = getStringAsync(USER_ID);
    imagesData.title = _titleController.text.trim();
    // imagesData.url =
    imagesData.description = _descriptionController.text.trim();

    if (_kIsUpdate) {
      imagesData.imageId = widget.imagesModel!.imageId;
      imagesData.createdAt = widget.imagesModel!.createdAt;
      imagesData.url = widget.imagesModel!.url;
      imagesData.updatedAt = DateTime.now();

      // TODO: Fix this method
      /// Error: This update method will overwrite the url in cloud firestore to null
      imagesService
          .updateDocument(imagesData.toJson(), imagesData.imageId)
          .then((value) {
        _setLoading(false, shouldCallSetState: false);
        toastLong('Note updated');
        Navigator.of(context).pop();
      }).catchError((error) {
        toast(error.toString());
      });
    } else {
      toastLong(
          'Your images will be uploaded. Sometimes this process might take longer than usual.');
      imagesService
          .postImage(getStringAsync(USER_ID), File(_pickedFile!.path),
              _titleController.text.trim(), _descriptionController.text.trim())
          .then((value) {
        /// When complete, do this
        toastLong('Image posted to Gallery');
        _setLoading(false, shouldCallSetState: false);
        Navigator.of(context).pop();
      }).catchError((error) {
        toast(error.toString());
      });
    }
    // _setLoading(false, shouldCallSetState: false);
    // toastLong('Image posted to Gallery');
    // Navigator.of(context).pop();
  }

  /// Set the loading state
  void _setLoading(bool state, {bool shouldCallSetState = true}) {
    if (isLoading != state) {
      isLoading = state;
      if (shouldCallSetState) {
        setState(() {});
      }
    }
  }

  /// Clear the image
  void _clear() {
    if (_pickedFile != null) {
      toast('Cleared');
    } else {
      toast('No image to clear');
    }
    setState(() {
      _pickedFile = null;
    });
  }
}
