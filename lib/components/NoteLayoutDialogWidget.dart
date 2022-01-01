import 'package:flutter/material.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/Constants.dart';

class NoteLayoutDialogWidget extends StatefulWidget {
  static String tag = '/NoteLayoutDialogWidget';
  final Function(int, int)? onLayoutSelect;

  NoteLayoutDialogWidget({this.onLayoutSelect});

  @override
  NoteLayoutDialogWidgetState createState() => NoteLayoutDialogWidgetState();
}

class NoteLayoutDialogWidgetState extends State<NoteLayoutDialogWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.grid_view, color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.scaffoldSecondaryDark),
            title: Text('GridView', style: primaryTextStyle()),
            onTap: () async {
              await setValue(SELECTED_LAYOUT_TYPE_DASHBOARD, GRID_VIEW);
              widget.onLayoutSelect!(1, 2);
              finish(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.grid_on_rounded, color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.scaffoldSecondaryDark),
            title: Text('GridView', style: primaryTextStyle()),
            onTap: () async {
              await setValue(SELECTED_LAYOUT_TYPE_DASHBOARD, GRID_VIEW_2);
              widget.onLayoutSelect!(1, 3);
              finish(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.view_agenda_outlined, color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.scaffoldSecondaryDark),
            title: Text('ListView', style: primaryTextStyle()),
            onTap: () async {
              await setValue(SELECTED_LAYOUT_TYPE_DASHBOARD, LIST_VIEW);
              widget.onLayoutSelect!(2, 2);
              finish(context);
            },
          ),
        ],
      ).paddingBottom(8),
    );
  }
}
