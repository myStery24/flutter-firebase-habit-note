import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../models/notes_model.dart';
import '../../dashboard/dashboard_screen.dart';
import 'note_collaborator_screen.dart';

class AddToDoScreen extends StatefulWidget {
  static String tag = '/AddToDoScreen';

  final NotesModel? notesModel;

  AddToDoScreen({this.notesModel});

  @override
  AddToDoScreenState createState() => AddToDoScreenState();
}

class AddToDoScreenState extends State<AddToDoScreen> {
  List<String> collaborateList = [];

  TextEditingController todoController = TextEditingController();
  TextEditingController? textController;

  Color? _kSelectColor;

  List<CheckListModel> _checkList = [];

  bool _kIsUpdateTodo = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light, delayInMilliSeconds: 100);

    _kIsUpdateTodo = widget.notesModel != null;

    if (!_kIsUpdateTodo) {
      collaborateList.add(getStringAsync(USER_EMAIL));
    }

    if (_kIsUpdateTodo) {
      _kSelectColor = getColorFromHex(widget.notesModel!.color!);
      _checkList.addAll(widget.notesModel!.checkListModel!);
    }

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : Colors.white,
        delayInMilliSeconds: 100);
    addToDoList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        add_todo,
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
            onPressed: () {
              hideKeyboard(context);
              toDoColorPicker();
            },
          )
        ],
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(right: 16),
        height: double.infinity,
        color: _kSelectColor ?? Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _kIsUpdateTodo && widget.notesModel!.collaborateWith!.first != getStringAsync(USER_EMAIL)
                  ? Row(
                children: [
                  Text('$shared_by :',
                      style:
                      boldTextStyle(color: Colors.black, size: 18)),
                  4.width,
                  Text(
                      widget.notesModel!.collaborateWith!.first.validate(),
                      style:
                      boldTextStyle(color: Colors.black, size: 18)),
                ],
              ).paddingLeft(16)
                  : SizedBox(),
              addCheckListItemWidget(),
              Divider(indent: 16),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _checkList.length,
                  itemBuilder: (_, index) {
                    CheckListModel checkListData = _checkList[index];
                    textController =
                        TextEditingController(text: checkListData.todo);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: checkListData.isCompleted,
                          fillColor: MaterialStateProperty.all(Colors.black),
                          onChanged: (val) {
                            setState(() {
                              checkListData.isCompleted =
                              !checkListData.isCompleted!;

                              if (checkListData.isCompleted!) {
                                _checkList.insert(
                                    _checkList.length, checkListData);
                                _checkList.removeAt(index);
                              } else if (!checkListData.isCompleted!) {
                                _checkList.removeAt(index);
                                _checkList.insert(0, checkListData);
                              }
                            });
                          },
                        ),
                        TextField(
                          controller: textController,
                          decoration: InputDecoration(border: InputBorder.none),
                          textInputAction: TextInputAction.done,
                          style: primaryTextStyle(
                            decoration: checkListData.isCompleted!
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: checkListData.isCompleted!
                                ? Colors.grey
                                : Colors.black,
                          ),
                          cursorColor: Colors.black,
                          textAlign: TextAlign.start,
                          maxLines: null,
                          onSubmitted: (val) {
                            checkListData.todo = val;
                            setState(() {});
                          },
                        ).expand(),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              _checkList.removeAt(index);
                            });
                          },
                        )
                      ],
                    ).paddingTop(8);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget addCheckListItemWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.add, color: AppColors.kHintTextLightGrey), onPressed: null),
        TextField(
          autofocus: _kIsUpdateTodo ? false : true,
          controller: todoController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              border: InputBorder.none, hintText: "What's on your mind ?",
              hintStyle: TextStyle(color: AppColors.kHintTextLightGrey)),
          style: primaryTextStyle(color: Colors.black),
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          maxLines: null,
          onEditingComplete: () {
            if (todoController.text.isNotEmpty) {
              setState(() {
                _checkList.add(CheckListModel(
                    todo: todoController.text, isCompleted: false));
                todoController.clear();
              });
            } else {
              toast(type_something_here2);
              // toast(type_something_here);
            }
          },
        ).expand(),
      ],
    );
  }

  void addToDoList() {
    if (_checkList.isNotEmpty) {
      NotesModel notesData = NotesModel();

      notesData.userId = getStringAsync(USER_ID);
      notesData.checkListModel = _checkList;
      notesData.updatedAt = DateTime.now();
      notesData.collaborateWith = collaborateList.validate();

      if (_kSelectColor != null) {
        notesData.color = _kSelectColor!.toHex().toString();
      } else {
        notesData.color = Colors.white.toHex();
      }

      if (_kIsUpdateTodo) {
        notesData.noteId = widget.notesModel!.noteId;
        notesData.createdAt = widget.notesModel!.createdAt;
        notesData.collaborateWith = widget.notesModel!.collaborateWith.validate();
        notesData.isLock = widget.notesModel!.isLock;

        notesService
            .updateDocument(notesData.toJson(), notesData.noteId)
            .then((value) {})
            .catchError((error) {
          toast(error.toString());
        });
      } else {
        notesData.createdAt = DateTime.now();
        notesService
            .addDocument(notesData.toJson())
            .then((value) {})
            .catchError((error) {
          toast(error.toString());
        });
      }
    }
  }

  /// To-do Options: Delete + Colour + Collaborator
  toDoColorPicker() {
    return showModalBottomSheet(
      context: context,
      elevation: 0,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IgnorePointer(
                ignoring: _kIsUpdateTodo ? false : true,
                child: ListTile(
                  leading: Icon(Icons.delete_forever_outlined,
                      color: appStore.isDarkMode
                          ? AppColors.kHabitOrange
                          : AppColors.kScaffoldSecondaryDark),
                  title: Text(delete_todo, style: primaryTextStyle()),
                  onTap: () {
                    if (widget.notesModel == null ||
                        widget.notesModel!.collaborateWith!.first ==
                            getStringAsync(USER_EMAIL)) {
                      notesService
                          .removeDocument(widget.notesModel!.noteId)
                          .then((value) {
                        toast('To-do deleted');
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
              //   title: Text(collaborators, style: primaryTextStyle()),
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
}
