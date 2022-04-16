import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';

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
            leading: Icon(Icons.grid_view,
                color: appStore.isDarkMode
                    ? AppColors.kHabitOrange
                    : AppColors.kScaffoldSecondaryDark),
            title: Text('Grid view', style: primaryTextStyle()),
            onTap: () async {
              await setValue(SELECTED_LAYOUT_TYPE_DASHBOARD, GRID_VIEW);
              widget.onLayoutSelect!(1, 2);
              finish(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.grid_on_rounded,
                color: appStore.isDarkMode
                    ? AppColors.kHabitOrange
                    : AppColors.kScaffoldSecondaryDark),
            title: Text('Compact grid view', style: primaryTextStyle()),
            onTap: () async {
              await setValue(SELECTED_LAYOUT_TYPE_DASHBOARD, GRID_VIEW_2);
              widget.onLayoutSelect!(1, 3);
              finish(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.view_agenda_outlined,
                color: appStore.isDarkMode
                    ? AppColors.kHabitOrange
                    : AppColors.kScaffoldSecondaryDark),
            title: Text('List view', style: primaryTextStyle()),
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
