import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_notes/screens/AboutScreen.dart';
import 'package:mighty_notes/screens/HelpScreen.dart';
import 'package:mighty_notes/screens/ocr/TextRecognitionScreen.dart';
import 'package:mighty_notes/screens/password/ChangeMasterPasswordScreen.dart';
import 'package:mighty_notes/screens/password/ForgotPasswordScreen.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Common.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:mighty_notes/utils/StringConstant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

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
            UserAccountsDrawerHeader(
              accountName: Text(name,
                  style: primaryTextStyle(size: 18),
                  overflow: TextOverflow.ellipsis),
              accountEmail: Text(userEmail.validate(),
                  style: secondaryTextStyle(size: 14),
                  overflow: TextOverflow.ellipsis),
              currentAccountPicture: commonCacheImageWidget(
                      imageUrl, imageRadius,
                      fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(60)
                  .paddingBottom(8),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 0.5, color: AppColors.kHabitOrange))),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Row(
                    children: [
                      appStore.isDarkMode
                          ? Icon(Icons.brightness_2)
                          : Icon(Icons.wb_sunny_rounded),
                      16.width,
                      Text(dark_mode, style: primaryTextStyle(size: 14))
                          .expand(),
                      Switch(
                        value: appStore.isDarkMode,
                        activeTrackColor: AppColors.scaffoldSecondaryDark,
                        inactiveThumbColor: AppColors.kHabitDark,
                        inactiveTrackColor: AppColors.scaffoldSecondaryDark,
                        onChanged: (val) async {
                          appStore.setDarkMode(val);
                          await setValue(IS_DARK_MODE, val);
                        },
                      ),
                    ],
                  )
                      .paddingOnly(left: 16, top: 4, right: 16, bottom: 4)
                      .onTap(() async {
                    if (getBoolAsync(IS_DARK_MODE)) {
                      appStore.setDarkMode(false);
                      await setValue(IS_DARK_MODE, false);
                    } else {
                      appStore.setDarkMode(true);
                      await setValue(IS_DARK_MODE, true);
                    }
                  }),
                  // Row(
                  //   children: [
                  //     Icon(Icons.notifications_active_outlined),
                  //     16.width,
                  //     Text(sub_reminder, style: primaryTextStyle(size: 14)).expand(),
                  //   ],
                  // ).paddingAll(16).onTap(() {
                  //   finish(context);
                  //   SubscriptionReminderListScreen().launch(context);
                  // }),
                  /// Reset Password
                  Row(
                    children: [
                      Icon(Icons.lock_outline_rounded),
                      16.width,
                      Text(reset_acc_pwd, style: primaryTextStyle(size: 14))
                          .expand(),
                    ],
                  ).paddingAll(16).onTap(() {
                    finish(context);
                    ForgotPasswordScreen().launch(context);
                    // ChangeAppPasswordScreen().launch(context);
                  }).visible(getStringAsync(LOGIN_TYPE) == LoginTypeApp),

                  /// Lock Notes with Password
                  Row(
                    children: [
                      Icon(Icons.lock_outline_rounded),
                      16.width,
                      Text(change_master_pwd, style: primaryTextStyle(size: 14))
                          .expand(),
                    ],
                  ).paddingAll(16).onTap(() {
                    finish(context);
                    ChangeMasterPasswordScreen().launch(context);
                  }),
                  const Divider(color: AppColors.kHabitOrange),
                  Row(
                    children: [
                      Icon(Icons.logout),
                      16.width,
                      Text(log_out, style: primaryTextStyle(size: 14)).expand(),
                    ],
                  ).paddingAll(16).onTap(() async {
                    bool? res = await showConfirmDialog(context, log_out_text,
                        positiveText: log_out,
                        buttonColor: AppColors.kHabitOrange);

                    if (res ?? false) {
                      service.signOutFromEmailPassword(context);
                    }
                  }),
                ],
              ),
            ).expand(),
          ],
        ),
      ),
    );
  }
}
