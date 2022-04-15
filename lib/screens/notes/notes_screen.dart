import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/model/notes_model.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/components/dashboard_drawer_widget.dart';
import 'package:habit_note/screens/notes/components/filter_note_by_colour_dialog_widget.dart';
import 'package:habit_note/screens/notes/components/lock_note_dialog_widget.dart';
import 'package:habit_note/screens/notes/components/note_layout_dialog_widget.dart';
import 'package:habit_note/screens/notes/components/set_master_password_dialog_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'components/add_notes_screen.dart';
import 'components/add_todo_screen.dart';

class NotesScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  String colorFilter = '';

  String? name;
  String? userEmail;
  String? imageUrl;

  DateTime? currentBackPressTime;

  late int crossAxisCount;
  late int fitWithCount;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
      appStore.isDarkMode ? AppColors.kHabitDarkGrey : AppColors.kHabitWhite,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.light : Brightness.dark,
      delayInMilliSeconds: 100,
    );

    setState(() {});

    fitWithCount = getIntAsync(FIT_COUNT, defaultValue: 1);
    crossAxisCount = getIntAsync(CROSS_COUNT, defaultValue: 2);
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
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) > 2.seconds) {
            currentBackPressTime = now;
            toast(AppStrings.pressAgain);
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          key: _scaffoldState,
          appBar: AppBar(
            title: Text(
              AppStrings.appName.validate(),
              style: GoogleFonts.fugazOne(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.color_lens_outlined),
                tooltip: 'Filter by colour',
                onPressed: () {
                  filterByColor();
                },
              ),
              IconButton(
                icon: getLayoutTypeIcon(),
                tooltip: 'Change view',
                onPressed: () async {
                  noteLayoutDialog();
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.menu_rounded),
              color: AppColors.kHabitOrange,
              onPressed: () {
                _scaffoldState.currentState!.openDrawer();
              },
            ),
          ),
          drawer: DashboardDrawerWidget(),
          body: StreamBuilder<List<NotesModel>>(
            stream: notesService.fetchNotes(color: colorFilter),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.length == 0) {
                  return noDataWidget(context).center();
                } else {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 8.0, top: 16.0, right: 8, bottom: 90),
                    child: StaggeredGrid.count(
                      crossAxisCount:
                          getStringAsync(SELECTED_LAYOUT_TYPE_DASHBOARD) ==
                                  LIST_VIEW
                              ? 1
                              : crossAxisCount,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: snapshot.data!.map((e) {
                        NotesModel notes = e;

                        if (notes.checkListModel.validate().isNotEmpty) {
                          return GestureDetector(
                            onLongPress: () {
                              HapticFeedback.vibrate();
                              lockNoteOption(notesModel: notes);
                            },
                            child: Container(
                              decoration: boxDecorationWithShadow(
                                borderRadius: BorderRadius.circular(8),
                                backgroundColor: getColorFromHex(notes.color!),
                                spreadRadius: 0.0,
                                blurRadius: 0.0,
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  notes.isLock.validate()
                                      ? Container(
                                              child: Icon(Icons.lock,
                                                  color: AppColors.kHabitDark))
                                          .paddingOnly(top: 16)
                                          .center()
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: notes.checkListModel!
                                              .take(5)
                                              .length,
                                          itemBuilder: (_, index) {
                                            CheckListModel checkListData =
                                                notes.checkListModel![index];

                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 12,
                                                  width: 12,
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: checkListData
                                                          .isCompleted!
                                                      ? Icon(Icons.check,
                                                          size: 10,
                                                          color: Colors.black)
                                                      : SizedBox(),
                                                ).paddingAll(8),
                                                Text(
                                                  checkListData.todo.validate(),
                                                  style: primaryTextStyle(
                                                    decoration: checkListData
                                                            .isCompleted!
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                    color: checkListData
                                                            .isCompleted!
                                                        ? Colors.grey
                                                        : Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).expand(),
                                              ],
                                            );
                                          },
                                        ).paddingTop(8),
                                  notes.checkListModel!.length > 5
                                      ? Text('more...',
                                              style: secondaryTextStyle())
                                          .paddingLeft(8)
                                      : SizedBox(),
                                  Align(
                                    child: Text(
                                        formatTime(notes
                                            .updatedAt!.millisecondsSinceEpoch
                                            .validate()),
                                        style: secondaryTextStyle(
                                            size: 10,
                                            color: Colors.grey.shade900)),
                                    alignment: Alignment.bottomRight,
                                  ).paddingAll(16),
                                  notes.collaborateWith!.first !=
                                          getStringAsync(USER_EMAIL)
                                      ? Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300),
                                          child: Text(
                                              notes.collaborateWith!.first![0],
                                              style: boldTextStyle(
                                                  color: Colors.black,
                                                  size: 12)),
                                        ).paddingOnly(left: 16, bottom: 16)
                                      : SizedBox()
                                ],
                              ),
                            ).onTap(() {
                              if (notes.isLock.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (_) => LockNoteDialogWidget(
                                      onSubmit: (aIsRight) {
                                    finish(context);
                                    AddToDoScreen(notesModel: notes)
                                        .launch(context);
                                  }),
                                );
                              } else {
                                AddToDoScreen(notesModel: notes)
                                    .launch(context);
                              }
                            }),
                          );
                        } else {
                          return GestureDetector(
                            onLongPress: () {
                              HapticFeedback.vibrate();
                              lockNoteOption(notesModel: notes);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: boxDecorationWithShadow(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius),
                                backgroundColor: getColorFromHex(notes.color!),
                                spreadRadius: 0.0,
                                blurRadius: 0.0,
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  notes.isLock.validate()
                                      ? Container(
                                              child: Icon(Icons.lock,
                                                  color: AppColors.kHabitDark))
                                          .paddingOnly(top: 8, bottom: 8)
                                          .center()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(notes.noteTitle.validate(),
                                                style: boldTextStyle(
                                                    color: Colors.black),
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            Text(notes.note!,
                                                style: primaryTextStyle(
                                                    size: 12,
                                                    color: Colors.black),
                                                maxLines: 10,
                                                textAlign: TextAlign.start,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ],
                                        ),
                                  Align(
                                    child: Text(
                                        formatTime(notes
                                            .updatedAt!.millisecondsSinceEpoch
                                            .validate()),
                                        style: secondaryTextStyle(
                                            size: 10,
                                            color: Colors.grey.shade900)),
                                    alignment: Alignment.bottomRight,
                                  ),
                                  notes.collaborateWith!.first !=
                                          getStringAsync(USER_EMAIL)
                                      ? Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300),
                                          child: Text(
                                              notes.collaborateWith!.first![0],
                                              style: boldTextStyle(
                                                  color: Colors.black,
                                                  size: 12)),
                                        )
                                      : SizedBox()
                                ],
                              ).paddingAll(16).onTap(() {
                                if (notes.isLock.validate()) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => LockNoteDialogWidget(
                                        onSubmit: (aIsRight) {
                                      finish(context);
                                      AddNotesScreen(notesModel: notes)
                                          .launch(context);
                                    }),
                                  );
                                } else {
                                  AddNotesScreen(notesModel: notes)
                                      .launch(context);
                                }
                              }),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  );
                }
              }
              return snapWidgetHelper(snapshot,
                  loadingWidget: Loader(
                      color: appStore.isDarkMode
                          ? AppColors.kHabitDark
                          : AppColors.kHabitOrange));
            },
          ),
          floatingActionButton: Observer(
            builder: (_) => FloatingActionButton(
              backgroundColor: appStore.isDarkMode
                  ? AppColors.kHabitOrange
                  : AppColors.kHabitOrange,
              child: Icon(Icons.add,
                  color: appStore.isDarkMode
                      ? AppColors.kHabitDark
                      : Colors.white),
              onPressed: () {
                selectNoteType();
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      ),
    );
  }

  lockNoteOption({NotesModel? notesModel}) {
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

              /// Lock Note
              ListTile(
                leading: Icon(
                    notesModel!.isLock!
                        ? Icons.lock_open_rounded
                        : Icons.lock_outline_rounded,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(notesModel.isLock! ? unlock_note : lock_note,
                    style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  if (getStringAsync(USER_MASTER_PWD).isNotEmpty) {
                    if (notesModel.collaborateWith!.first ==
                        getStringAsync(USER_EMAIL)) {
                      lockNoteDialog(notesModel);
                    } else {
                      toast(share_note_change_not_allow);
                    }
                  } else {
                    setLockNoteDialog(notesModel);
                  }
                },
              ),

              /// Delete Note
              ListTile(
                leading: Icon(Icons.delete_forever_outlined,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(delete_note, style: primaryTextStyle()),
                onTap: () async {
                  finish(context);
                  if (notesModel.collaborateWith!.first ==
                      getStringAsync(USER_EMAIL)) {
                    bool deleted = await showInDialog(
                      context,
                      title: Text(delete_note,
                          style: primaryTextStyle(
                            weight: TextFontWeight.bold,
                          )),
                      child: Text(confirm_to_delete_note,
                          style: primaryTextStyle()),
                      actions: [
                        TextButton(
                            onPressed: () {
                              finish(context, false);
                            },
                            child: Text(cancel, style: primaryTextStyle())),
                        TextButton(
                            onPressed: () {
                              finish(context, true);
                            },
                            child: Text(delete,
                                style: primaryTextStyle(
                                  color: AppColors.kHabitOrange,
                                ))),
                      ],
                    );
                    if (deleted) {
                      notesService
                          .removeDocument(notesModel.noteId)
                          .then((value) {
                        toast('Note deleted');
                      }).catchError((error) {
                        toast(error.toString());
                      });
                    }
                  } else {
                    toast(share_note_change_not_allow);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  selectNoteType() {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              Text('Create new', style: secondaryTextStyle(size: 18))
                  .center()
                  .paddingAll(8),
              Divider(height: 16),
              ListTile(
                leading: Icon(Icons.keyboard_outlined,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(add_note, style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  AddNotesScreen().launch(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.check_box_outlined,
                    color: appStore.isDarkMode
                        ? AppColors.kHabitOrange
                        : AppColors.scaffoldSecondaryDark),
                title: Text(add_todo, style: primaryTextStyle()),
                onTap: () {
                  finish(context);
                  AddToDoScreen().launch(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  noteLayoutDialog() {
    return showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      titleTextStyle: primaryTextStyle(size: 20),
      title: Text(select_layout).paddingBottom(16),
      builder: (_) => new NoteLayoutDialogWidget(
          onLayoutSelect: (fitCount, crossCount) async {
        await setValue(FIT_COUNT, fitCount);
        await setValue(CROSS_COUNT, crossCount);
        setState(() {
          fitWithCount = fitCount;
          crossAxisCount = crossCount;
        });
      }),
    );
  }

  setLockNoteDialog(NotesModel? notesModel) {
    return showDialog(
      context: context,
      builder: (_) {
        return SetMasterPasswordDialogWidget(
            userId: getStringAsync(USER_ID), notesModel: notesModel);
      },
    );
  }

  lockNoteDialog(NotesModel? notesModel) {
    return showDialog(
      context: context,
      builder: (_) {
        return LockNoteDialogWidget(
          onSubmit: (aIsRightPWD) {
            if (aIsRightPWD) {
              if (notesModel!.isLock == true) {
                notesModel.isLock = false;
              } else {
                notesModel.isLock = true;
              }

              notesService.updateDocument({'isLock': notesModel.isLock},
                  notesModel.noteId).then((value) {
                finish(context);
              }).catchError((error) {
                toast(error.toString());
              });
            }
          },
        );
      },
    );
  }

  filterByColor() {
    return showInDialog(
      context,
      title: Text('Filter by colour'),
      titleTextStyle: primaryTextStyle(size: 22),
      contentPadding: EdgeInsets.all(16),
      builder: (_) => new FilterNoteByColorDialogWidget(onColorTap: (color) {
        setState(() {
          colorFilter = color;
        });
      }),
    );
  }
}
