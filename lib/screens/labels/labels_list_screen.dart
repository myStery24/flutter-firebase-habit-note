import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import '../../models/labels_model.dart';
import 'components/custom_labels_widget.dart';

class LabelsListScreen extends StatefulWidget {
  final LabelsModel? labelsModel;

  LabelsListScreen({this.labelsModel});

  @override
  _LabelsListScreenState createState() => _LabelsListScreenState();
}

class _LabelsListScreenState extends State<LabelsListScreen> {
  final _formKey = GlobalKey<ScaffoldState>();

  TextEditingController _labelNameController = TextEditingController();
  TextEditingController _newLabelNameController = new TextEditingController();
  final CollectionReference _labelsRef = FirebaseFirestore.instance
      .collection('labels'); // Collection of label in firebase firestore
  List _selectedLabels = [];
  bool kIsUpdate = false;

  FocusNode labelFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
        appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : Colors.white,
        statusBarIconBrightness: Brightness.light,
        delayInMilliSeconds: 100);

    kIsUpdate = widget.labelsModel != null;

    if (kIsUpdate) {
      _labelNameController.text = widget.labelsModel!.labelName!;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : Colors.white,
        delayInMilliSeconds: 100);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(labels),
        actions: [
          IconButton(
            icon: Icon(Icons.contact_support_outlined),
            tooltip: 'Swipe Action to Delete Label',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Swipe Action to Delete Label',
                    style: TextStyle(
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kHabitOrange
                            : AppColors.kTextBlack,
                        fontWeight: TextFontWeight.bold),
                  ),
                  content: Text(
                    'Swiping to the left or to the right to delete/remove a created label.',
                    style: TextStyle(
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kTextWhite
                            : AppColors.kTextBlack),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Got it !',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: AppColors.kHabitOrange,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Tap outside to dismiss
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.height,

              /// Info
              labelsInfoBox(),
              Divider(thickness: 2, endIndent: 10, indent: 10),
              15.height,

              /// Create labels
              CreateLabelSectionTitleWidget(),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: kIsUpdate ? true : false,
                        controller: _labelNameController,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: AppColors.kHabitOrange,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Add labels...',
                          hintStyle:
                              TextStyle(color: AppColors.kHintTextLightGrey),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: IconButton(
                        color: Colors.transparent,
                        tooltip: 'Add label',
                        icon: Icon(
                          Icons.add,
                          color: AppColors.kHabitOrange,
                          size: 24,
                          semanticLabel: 'Add label',
                        ),
                        onPressed: () {
                          hideKeyboard(context);
                          if (_labelNameController.text.trim().isEmptyOrNull) {
                            toast('Please enter a name for the label');
                          } else {
                            /// Create a document to save the labels in database
                            _saveLabel().then((value) {}).catchError((error) {
                              appStore.setLoading(false);
                              toast(error.toString());
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              15.height,

              /// Display label
              LabelsSectionTitleWidget(),

              /// Show all the created labels in list
              /// StreamBuilder() keeps persistence connection with Firestore database
              StreamBuilder(
                stream: _labelsRef
                    .where('userId', isEqualTo: getStringAsync(USER_ID))
                    .snapshots(), // Build connection
                // stream: labelsService.labels(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  /// snapshot contains all the data in database in Firestore
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 8),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length, // number of rows
                        itemBuilder: (context, index) {
                          final DocumentSnapshot labelSnapshot =
                              snapshot.data!.docs[index];

                          /// Swipe action to delete
                          return Dismissible(
                            /// Create labels
                            child: LabelWidget(
                              text: labelSnapshot['labelName'].toString(),
                              onTap: () {
                                _editLabel(labelSnapshot);
                              },
                            ),

                            /// Swipe
                            background: SwipeActionBackground(),
                            key: Key(labelSnapshot.id),
                            onDismissed: (direction) {
                              setState(() {
                                _deleteLabel(labelSnapshot.id);
                                //snapshot.data!.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return snapWidgetHelper(snapshot);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Save to database
  Future<void> _saveLabel() async {
    if (_labelNameController.text.isNotEmpty) {
      appStore.setLoading(true);

      LabelsModel model = LabelsModel();

      model.labelName = _labelNameController.text.trim();
      model.userId = getStringAsync(USER_ID);

      if (kIsUpdate) {
        model.labelId = widget.labelsModel!.labelId;

        labelsService
            .updateDocument(model.toJson(), model.labelId)
            .then((value) {
          finish(context, model);

          appStore.setLoading(false);
        }).catchError((error) {
          appStore.setLoading(false);

          toast(error.toString());
        });
      } else {
        labelsService.addDocument(model.toJson()).then((value) {
          appStore.setLoading(false);
        }).catchError((error) {
          appStore.setLoading(false);

          toast(error.toString());
        });
      }
      setState(() {
        toast("Added a new label");
        _labelNameController.text = "";
      });
    }
  }

  /// Edit the label
  Future<void> _editLabel(DocumentSnapshot? labelSnapshot) async {
    // If the database collection of labels is not empty
    if (labelSnapshot != null) {
      _newLabelNameController.text = labelSnapshot[
          'labelName']; // Get the old label name and store in the text controller
    }

    /// Show a sheet to edit the label
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,

                /// Prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _newLabelNameController,
                  cursorColor: appStore.isDarkMode
                      ? AppColors.kHabitOrange
                      : AppColors.kHabitDark,
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit,
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kHabitOrange
                            : AppColors.kTextBlack),
                    labelText: 'Edit label',
                    labelStyle: TextStyle(
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kTextWhite
                            : AppColors.kTextBlack),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.orange.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text(cancel,
                          style: boldTextStyle(
                              color: AppColors.kHabitDark.withOpacity(0.5))),
                      padding: EdgeInsets.all(8.0),
                      color: Colors.grey.shade300,
                      width: 70,
                      height: 36,
                      onTap: () async {
                        finish(context);
                      },
                    ),
                    AppButton(
                      shapeBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text('Save changes',
                          style: boldTextStyle(
                              color: appStore.isDarkMode
                                  ? AppColors.kHabitDark
                                  : Colors.white)),
                      padding: EdgeInsets.all(8.0),
                      color: AppColors.kHabitOrange,
                      width: 70,
                      height: 36,
                      onTap: () async {
                        hideKeyboard(context);
                        finish(context);

                        final String newLabelName = _newLabelNameController
                            .text; // save the new changes

                        /// Pass to the update method
                        await _labelsRef
                            .doc(labelSnapshot!.id) // pass the document id
                            .update({"labelName": newLabelName}); // update
                        //_newLabelNameController.text = '';
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  /// Delete the label
  Future<void> _deleteLabel(String labelId) async {
    // await _selectedLabels.doc(labelId).delete();

    labelsService.removeDocument(labelId).then((value) {
      toast('Label deleted');
    }).catchError((error) {
      toast(error.toString());
    });
  }

  /// Tick the label to add to notes
  void _onLabelSelected(bool selected, String labelName) {
    if (selected) {
      setState(() {
        _selectedLabels.add(labelName);
      });
    } else {
      setState(() {
        _selectedLabels.remove(labelName);
      });
    }
  }
}
