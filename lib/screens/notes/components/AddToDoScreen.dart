import 'package:flutter/material.dart';
import 'package:habit_note/model/notes_model.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/constants.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../DashboardScreen.dart';
import 'NoteCollaboratorScreen.dart';

class AddToDoScreen extends StatefulWidget {
  static String tag = '/AddToDoScreen';

  final NotesModel? notesModel;

  AddToDoScreen({this.notesModel});

  @override
  AddToDoScreenState createState() => AddToDoScreenState();
}

class AddToDoScreenState extends State<AddToDoScreen> {
  List<String> collaborateList = [];

  // InterstitialAd? myInterstitial;

  TextEditingController todoController = TextEditingController();
  TextEditingController? textController;

  Color? _kSelectColor;

  List<CheckListModel> _checkList = [];

  bool _mIsUpdateTodo = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // log(adShowCount);

    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light, delayInMilliSeconds: 100);

    _mIsUpdateTodo = widget.notesModel != null;

    if (!_mIsUpdateTodo) {
      collaborateList.add(getStringAsync(USER_EMAIL));
    }

    if (_mIsUpdateTodo) {
      _kSelectColor = getColorFromHex(widget.notesModel!.color!);
      _checkList.addAll(widget.notesModel!.checkListModel!);
    }

    // if (!disabled_ads) {
    //   if (adShowCount < 5) {
    //     adShowCount++;
    //   } else {
    //     adShowCount = 0;
    //     buildInterstitialAd();
    //   }
    // }
  }

  // void buildInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId:
  //         kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
  //     request: AdRequest(keywords: testDevices),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ads) {
  //         this.myInterstitial = ads;
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {
  //         print('InterstitialAd failed to load: $error');
  //       },
  //     ),
  //   );
  // }

  // void showInterstitialAd() {
  //   if (myInterstitial == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   myInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       buildInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       buildInterstitialAd();
  //     },
  //   );
  //   myInterstitial!.show();
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? AppColors.kHabitDark : Colors.white,
        delayInMilliSeconds: 100);
    addToDoList();
    // showInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        add_todo,
        color: _kSelectColor ?? AppColors.kHabitWhite,
        textColor: AppColors.kHabitDark,
        brightness: Brightness.light,
        actions: [
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
              _mIsUpdateTodo &&
                      widget.notesModel!.collaborateWith!.first !=
                          getStringAsync(USER_EMAIL)
                  ? Row(
                      children: [
                        Text('$shared_by :',
                            style:
                                boldTextStyle(color: Colors.black, size: 18)),
                        4.width,
                        Text(
                            widget.notesModel!.collaborateWith!.first
                                .validate(),
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
        IconButton(icon: Icon(Icons.add), onPressed: null),
        TextField(
          autofocus: _mIsUpdateTodo ? false : true,
          controller: todoController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              border: InputBorder.none, hintText: "What's on your mind ?"),
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

      if (_mIsUpdateTodo) {
        notesData.createdAt = widget.notesModel!.createdAt;
        notesData.noteId = widget.notesModel!.noteId;
        notesData.collaborateWith =
            widget.notesModel!.collaborateWith.validate();
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

  /// To-do Options: Delete + Colour
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
                ignoring: _mIsUpdateTodo ? false : true,
                child: ListTile(
                  leading: Icon(Icons.delete_forever_outlined,
                      color: appStore.isDarkMode
                          ? AppColors.kHabitOrange
                          : AppColors.scaffoldSecondaryDark),
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
              // TODO: Collaborator Feature
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
}
