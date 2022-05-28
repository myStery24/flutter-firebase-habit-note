import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_note/models/labels_model.dart';
import 'package:habit_note/screens/dashboard/dashboard_screen.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../models/notes_model.dart';
import '../../../widgets/custom_chips.dart';

/// TODO : Add labels to note, save to Firestore, map to the note
/// ISSUE: The label does not save once exited the note editor
class AddNotesScreen extends StatefulWidget {
  static String tag = '/AddNotesScreen';
  final NotesModel? notesModel;
  final LabelsModel? labelsModel;

  AddNotesScreen({this.notesModel, this.labelsModel});

  @override
  AddNotesScreenState createState() => AddNotesScreenState();
}

class AddNotesScreenState extends State<AddNotesScreen> {
  List<String> collaborateList = [];
  List<String> _selectedLabels = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController _newLabelController = new TextEditingController();

  FocusNode noteNode = FocusNode();
  FocusNode _labelNode = FocusNode();

  Color? _kSelectColor;

  bool _kIsUpdateNote = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light, delayInMilliSeconds: 100);

    _kIsUpdateNote = widget.notesModel != null;

    if (!_kIsUpdateNote) {
      collaborateList.add(getStringAsync(USER_EMAIL));
    }

    if (_kIsUpdateNote) {
      titleController.text = widget.notesModel!.noteTitle!;
      notesController.text = widget.notesModel!.note!;
      //_newLabelController.text = widget.notesModel!.noteLabel!;
      _kSelectColor = getColorFromHex(widget.notesModel!.color!);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode
            ? AppColors.kPrimaryVariantColorDark
            : AppColors.kAppBarColor,
        delayInMilliSeconds: 100);
    addNotes();
    // saveLabel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        add_note,
        color: _kSelectColor ?? Colors.white,
        textColor: AppColors.kHabitDark,
        systemUiOverlayStyle: SystemUiOverlayStyle.light,
        // brightness: Brightness.light,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            color: AppColors.kHabitDark,
            onPressed: () async {
              hideKeyboard(context);
              finish(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded),
            color: AppColors.kHabitDark,
            onPressed: () async {
              hideKeyboard(context);

              noteColorPicker();
            },
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        color: _kSelectColor ?? Colors.white,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        child: Container(
          height: double.infinity,
          child: Column(
            children: [
              _kIsUpdateNote && widget.notesModel!.collaborateWith!.first != getStringAsync(USER_EMAIL)
                  ? Row(
                      children: [
                        Text('$shared_by :',
                            style: boldTextStyle(color: Colors.black, size: 18)),
                        4.width,
                        Text(
                            widget.notesModel!.collaborateWith!.first.validate(),
                            style: boldTextStyle(color: Colors.black, size: 18)),
                      ],
                    )
                  : SizedBox(),
              /// Title
              TextField(
                autofocus: _kIsUpdateNote ? false : true,
                controller: titleController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: AppColors.kHintTextLightGrey)),
                style: boldTextStyle(size: 20, color: Colors.black),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                onSubmitted: (val) {
                  FocusScope.of(context).requestFocus(noteNode);
                },
                maxLines: 1,
              ),
              /// Content
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: TextField(
                  controller: notesController,
                  focusNode: noteNode,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type something awesome here',
                      hintStyle: TextStyle(color: AppColors.kHintTextLightGrey)),
                  style: primaryTextStyle(color: Colors.black),
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ).expand(),
              /// Labels
              Divider(),
              TagEditor(
                // autofocus: _kIsUpdateNote ? false : true,
                controller: _newLabelController,
                length: _selectedLabels.length,
                focusNode: _labelNode,
                delimiters: [',', ' '],
                hasAddButton: true,
                resetTextOnSubmitted: true,
                textStyle: const TextStyle(color: AppColors.kTextBlack), // Text color of the label
                onSubmitted: (outstandingValue) {
                  setState(() {
                    _selectedLabels.add(outstandingValue);

                  });
                },
                inputDecoration: const InputDecoration(
                  hintMaxLines: 2,
                  border: InputBorder.none,
                  hintText: 'Sorry, adding labels is not working in current version...',
                ),
                onTagChanged: (newValue) {
                  setState(() {
                    _selectedLabels.add(newValue);
                  });
                },
                tagBuilder: (context, index) => CustomChips(
                  index: index,
                  label: _selectedLabels[index],
                  onDeleted: _onDelete,
                ),
                // InputFormatters example, this disallow \ and /
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Add a [Note] to the note list
  void addNotes() {
    if (titleController.text.trim().isNotEmpty ||
        notesController.text.trim().isNotEmpty) {
      NotesModel notesData = NotesModel();

      notesData.userId = getStringAsync(USER_ID);
      notesData.noteTitle = titleController.text.trim();
      notesData.note = notesController.text.trim();

      if (_kSelectColor != null) {
        notesData.color = _kSelectColor!.toHex().toString();
      } else {
        notesData.color = Colors.white.toHex();
      }

      if (_kIsUpdateNote) {
        notesData.noteId = widget.notesModel!.noteId;
        notesData.noteLabel = widget.notesModel!.noteLabel;
        notesData.createdAt = widget.notesModel!.createdAt;
        notesData.updatedAt = DateTime.now();
        notesData.checkListModel = widget.notesModel!.checkListModel.validate();
        notesData.collaborateWith = widget.notesModel!.collaborateWith.validate();
        notesData.isLock = widget.notesModel!.isLock;

        notesService
            .updateDocument(notesData.toJson(), notesData.noteId)
            .then((value) {})
            .catchError((error) {
          log(error.toString());
        });
      } else {
        notesData.createdAt = DateTime.now();
        notesData.updatedAt = DateTime.now();
        notesData.collaborateWith = collaborateList.validate();
        notesData.checkListModel = [];

        notesService
            .addDocument(notesData.toJson())
            .then((value) {})
            .catchError((error) {
          toast(error.toString());
        });
      }
    }
  }

  /// Notes Options: Delete + Colour
  noteColorPicker() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IgnorePointer(
                ignoring: _kIsUpdateNote ? false : true,
                child: ListTile(
                  leading: Icon(Icons.delete_forever_outlined,
                      color: appStore.isDarkMode
                          ? AppColors.kHabitOrange
                          : AppColors.kScaffoldSecondaryDark),
                  title: Text(delete_note, style: primaryTextStyle()),
                  onTap: () {
                    if (widget.notesModel == null ||
                        widget.notesModel!.collaborateWith!.first == getStringAsync(USER_EMAIL)) {
                      notesService
                          .removeDocument(widget.notesModel!.noteId)
                          .then((value) {
                        toast('Note deleted');
                        finish(context);
                        DashboardScreen().launch(context, isNewTask: true);
                      }).catchError((error) {
                        toast(error.toString());
                      });
                    } else {
                      toast(share_note_change_not_allow);
                    }
                  },
                ),
              ),

              /// Collaborator
              // ListTile(
              //   leading: Icon(Icons.person_add_alt_1_rounded,
              //       color: appStore.isDarkMode
              //           ? AppColors.kHabitOrange
              //           : AppColors.scaffoldSecondaryDark),
              //   title: Text(collaborator, style: primaryTextStyle()),
              //   onTap: () async {
              //     finish(context);
              //     if (widget.notesModel == null ||
              //         widget.notesModel!.collaborateWith!.first ==
              //             getStringAsync(USER_EMAIL)) {
              //       List<String>? list = await NoteCollaboratorScreen(
              //               notesModel: widget.notesModel)
              //           .launch(context);
              //       if (list != null) {
              //         collaborateList.addAll(list);
              //       }
              //     } else {
              //       toast(share_note_change_not_allow);
              //     }
              //   },
              // ),
              Divider(thickness: 1),
              Text(select_colour, style: boldTextStyle()),
              20.height,
              SelectNoteColor(onTap: (color) {
                setState(() {
                  setStatusBarColor(Colors.transparent,
                      delayInMilliSeconds: 100);
                  _kSelectColor = color;
                });
              }),
            ],
          ),
        );
      },
    );
  }

  /// Save label to Firestore labels collection
  void saveLabel() async {
    if (_newLabelController.text.trim().isNotEmpty) {
      LabelsModel labelsData = LabelsModel();

      labelsData.labelName = _newLabelController.text.trim();

      await FirebaseFirestore.instance.collection('labels').add({
        "noteLabel": _newLabelController.text,
      },
      );
      setState(() {
        notesService
            .addDocument(labelsData.toJson())
            .then((value) {})
            .catchError((error) {
          toast(error.toString());
        });
      });
    }
  }

  /// Delete the labels by pressing x
  void _onDelete(index) {
    setState(() {
      _selectedLabels.removeAt(index);
    });
  }
}
