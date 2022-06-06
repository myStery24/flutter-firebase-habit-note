import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:habit_note/screens/reminder/subscription_reminder_list_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';
import '../main.dart';
import '../screens/labels/labels_list_screen.dart';
import '../screens/reminder/task_reminder_screen.dart';
import 'custom_rich_text_widget.dart';

class DashboardDrawerWidget extends StatefulWidget {
  static String tag = '/DashboardDrawerWidget';

  @override
  DashboardDrawerWidgetState createState() => DashboardDrawerWidgetState();
}

class DashboardDrawerWidgetState extends State<DashboardDrawerWidget> {
  late String name;
  String? userEmail;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    name = getStringAsync(USER_DISPLAY_NAME);
    userEmail = getStringAsync(USER_EMAIL);
    imageUrl = getStringAsync(USER_PHOTO_URL);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Drawer(
        child: Column(
          children: [
            _sectionOne(),
            _sectionTwo(),
          ],
        ),
      ),
    );
  }

  _sectionOne() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 0, 16),
      child: Row(
        children: [
          CustomRichTextWidget(
            primaryText: 'HaBIT Note ',
            primaryFontSize: 24.0,
            secondaryText: AppStrings.appVersionText,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kTextWhite
                : AppColors.kTextBlack,
          )
        ],
      ),
    );
  }

  _sectionTwo() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          /// Label
          /// TODO: Assign labels to note
          Row(
            children: [
              Icon(Icons.label),
              16.width,
              Text('Labels', style: primaryTextStyle(size: 16)).expand(),
            ],
          ).paddingAll(16).onTap(() {
            finish(context);
            LabelsListScreen().launch(context);
          }),
          // const Divider(color: AppColors.kHabitOrange, thickness: 1),
          // Row(
          //   children: [
          //     Padding(
          //         padding: const EdgeInsets.only(
          //             left: 16.0, top: 16.0, bottom: 8.0),
          //         child: Text('REMINDER',
          //             style: primaryTextStyle(size: 14))),
          //   ],
          // ),

          /// TODO: Task Reminder with Notifications
          // Row(
          //   children: [
          //     Icon(Icons.notifications_active_outlined),
          //     16.width,
          //     Text('Task Reminder', style: primaryTextStyle(size: 16))
          //         .expand(),
          //   ],
          // ).paddingAll(16).onTap(() {
          //   finish(context);
          //   TaskReminderScreen().launch(context);
          // }),

          /// Subscription Reminder with Notifications
          Row(
            children: [
              Icon(Icons.notifications_active_outlined),
              16.width,
              Text(sub_reminder, style: primaryTextStyle(size: 16)).expand(),
            ],
          ).paddingAll(16).onTap(() {
            finish(context);
            SubscriptionReminderListScreen().launch(context);
          }),
          const Divider(color: AppColors.kHabitOrange, thickness: 1),
          // Row(
          //   children: [
          //     Padding(
          //         padding:
          //             const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          //         child: Text('THEME', style: primaryTextStyle(size: 14))),
          //   ],
          // ),
          /// Theme
          Row(
            children: [
              appStore.isDarkMode
                  ? Icon(Icons.brightness_2)
                  : Icon(Icons.wb_sunny_rounded),
              16.width,
              Text(dark_mode, style: primaryTextStyle(size: 16)).expand(),
              Switch.adaptive(
                value: appStore.isDarkMode,
                activeColor: AppColors.kHabitOrange,
                activeTrackColor: AppColors.kScaffoldSecondaryDark,
                inactiveThumbColor: AppColors.kHabitDark,
                inactiveTrackColor: AppColors.kScaffoldSecondaryDark,
                onChanged: (val) async {
                  appStore.setDarkMode(val);
                  await setValue(IS_DARK_MODE, val);
                },
              ),
            ],
          ).paddingOnly(left: 16, top: 4, right: 16, bottom: 4).onTap(() async {
            if (getBoolAsync(IS_DARK_MODE)) {
              appStore.setDarkMode(false);
              await setValue(IS_DARK_MODE, false);
            } else {
              appStore.setDarkMode(true);
              await setValue(IS_DARK_MODE, true);
            }
          }),
          const Divider(color: AppColors.kHabitOrange, thickness: 1),

          /// Log Out
          Row(
            children: [
              Icon(Icons.logout),
              16.width,
              Text(log_out, style: primaryTextStyle(size: 16)).expand(),
            ],
          ).paddingAll(16).onTap(() async {
            bool? res = await showConfirmDialog(context, log_out_text,
                positiveText: log_out, buttonColor: AppColors.kHabitOrange);
            // ?? is the 'if null operator'
            if (res ?? false) {
              service.signOutFromEmailPassword(context);
            }
          }),
        ],
      ),
    ).expand();
  }
}
