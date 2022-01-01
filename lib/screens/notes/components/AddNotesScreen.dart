import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mighty_notes/model/notes_model.dart';
import 'package:mighty_notes/screens/DashboardScreen.dart';
import 'package:mighty_notes/screens/notes/components/NoteCollaboratorScreen.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Common.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:mighty_notes/utils/StringConstant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

class AddNotesScreen extends StatefulWidget {
  static String tag = '/AddNotesScreen';
  final NotesModel? notesModel;

  AddNotesScreen({this.notesModel});

  @override
  AddNotesScreenState createState() => AddNotesScreenState();
}

class AddNotesScreenState extends State<AddNotesScreen> {
  List<String> collaborateList = [];

  // InterstitialAd? myInterstitial;

  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  FocusNode noteNode = FocusNode();

  Color? _mSelectColor;

  bool _mIsUpdateNote = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    log(adShowCount);
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark, delayInMilliSeconds: 100);

    _mIsUpdateNote = widget.notesModel != null;

    if (!_mIsUpdateNote) {
      collaborateList.add(getStringAsync(USER_EMAIL));
    }

    if (_mIsUpdateNote) {
      titleController.text = widget.notesModel!.noteTitle!;
      notesController.text = widget.notesModel!.note!;
      _mSelectColor = getColorFromHex(widget.notesModel!.color!);
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
  //     adUnitId: kReleaseMode ? mAdMobInterstitialId : InterstitialAd.testAdUnitId,
  //     request: AdRequest(keywords: testDevices),
  //     adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ads) {
  //       this.myInterstitial = ads;
  //     }, onAdFailedToLoad: (LoadAdError error) {
  //       print('InterstitialAd failed to load: $error');
  //     }),
  //   );
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // void showInterstitialAd() {
  //   if (myInterstitial == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   myInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
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
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? AppColors.kHabitDark : Colors.white, delayInMilliSeconds: 100);
    addNotes();
    // showInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBarWidget(
        add_note,
        color: _mSelectColor ?? AppColors.kHabitWhite,
        textColor: AppColors.kHabitDark,
        brightness: Brightness.light,
        actions: [
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
        color: _mSelectColor ?? Colors.white,
        height: double.infinity,
        padding: EdgeInsets.all(16),
        child: Container(
          height: double.infinity,
          child: Column(
            children: [
              _mIsUpdateNote && widget.notesModel!.collaborateWith!.first != getStringAsync(USER_EMAIL)
                  ? Row(
                      children: [
                        Text('$shared_by :', style: boldTextStyle(color: Colors.black, size: 18)),
                        4.width,
                        Text(widget.notesModel!.collaborateWith!.first.validate(), style: boldTextStyle(color: Colors.black, size: 18)),
                      ],
                    )
                  : SizedBox(),
              TextField(
                autofocus: _mIsUpdateNote ? false : true,
                controller: titleController,
                cursorColor: Colors.black,
                decoration: InputDecoration(border: InputBorder.none, hintText: 'Title'),
                style: boldTextStyle(size: 20, color: Colors.black),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                onSubmitted: (val) {
                  FocusScope.of(context).requestFocus(noteNode);
                },
                maxLines: 1,
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: TextField(
                  controller: notesController,
                  focusNode: noteNode,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Type something awesome here'),
                  style: primaryTextStyle(color: Colors.black),
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ).expand(),
            ],
          ),
        ),
      ),
    );
  }

  void addNotes() {
    if (titleController.text.trim().isNotEmpty || notesController.text.trim().isNotEmpty) {
      NotesModel notesData = NotesModel();

      notesData.userId = getStringAsync(USER_ID);
      notesData.noteTitle = titleController.text.trim();
      notesData.note = notesController.text.trim();

      if (_mSelectColor != null) {
        notesData.color = _mSelectColor!.toHex().toString();
      } else {
        notesData.color = Colors.white.toHex();
      }

      if (_mIsUpdateNote) {
        notesData.noteId = widget.notesModel!.noteId;
        notesData.createdAt = widget.notesModel!.createdAt;
        notesData.updatedAt = DateTime.now();
        notesData.checkListModel = widget.notesModel!.checkListModel.validate();
        notesData.collaborateWith = widget.notesModel!.collaborateWith.validate();
        notesData.isLock = widget.notesModel!.isLock;

        notesService.updateDocument(notesData.toJson(), notesData.noteId).then((value) {}).catchError((error) {
          log(error.toString());
        });
      } else {
        notesData.createdAt = DateTime.now();
        notesData.updatedAt = DateTime.now();
        notesData.collaborateWith = collaborateList.validate();
        notesData.checkListModel = [];

        notesService.addDocument(notesData.toJson()).then((value) {}).catchError((error) {
          toast(error.toString());
        });
      }
    }
  }

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
                ignoring: _mIsUpdateNote ? false : true,
                child: ListTile(
                  leading: Icon(Icons.delete_rounded, color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.scaffoldSecondaryDark),
                  title: Text(delete_note, style: primaryTextStyle()),
                  onTap: () {
                    if (widget.notesModel == null || widget.notesModel!.collaborateWith!.first == getStringAsync(USER_EMAIL)) {
                      notesService.removeDocument(widget.notesModel!.noteId).then((value) {
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
              ListTile(
                leading: Icon(Icons.person_add_alt_1_rounded, color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.scaffoldSecondaryDark),
                title: Text(collaborator, style: primaryTextStyle()),
                onTap: () async {
                  finish(context);
                  if (widget.notesModel == null || widget.notesModel!.collaborateWith!.first == getStringAsync(USER_EMAIL)) {
                    List<String>? list = await NoteCollaboratorScreen(notesModel: widget.notesModel).launch(context);
                    if (list != null) {
                      collaborateList.addAll(list);
                    }
                  } else {
                    toast(share_note_change_not_allow);
                  }
                },
              ),
              Divider(thickness: 1),
              Text(select_color, style: boldTextStyle()),
              20.height,
              SelectNoteColor(onTap: (color) {
                setState(() {
                  setStatusBarColor(Colors.transparent, delayInMilliSeconds: 100);
                  _mSelectColor = color;
                });
              }),
            ],
          ),
        );
      },
    );
  }
}
