import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/screens/password/change_acccount_password_screen.dart';
import 'package:habit_note/screens/settings/components/about_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/privacy_policy_screen.dart';
import '../../../components/terms_of_use_screen.dart';
import '../../../main.dart';
import '../../../utils/colours.dart';
import '../../../utils/common.dart';
import '../../../utils/constants.dart';
import '../../password/change_master_password_screen.dart';
import '../../password/forgot_password_screen.dart';

class SettingsCategory extends StatefulWidget {
  const SettingsCategory({Key? key}) : super(key: key);

  @override
  State<SettingsCategory> createState() => _SettingsCategoryState();
}

class _SettingsCategoryState extends State<SettingsCategory> {
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
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: ListView(padding: EdgeInsets.all(12.0), children: [
        /// User Profile Card
        Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          shadowColor: getBoolAsync(IS_DARK_MODE)
              ? AppColors.kHabitOrange
              : AppColors.kPrimaryVariantColorDark,
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                /// Avatar
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: commonCacheImageWidget(imageUrl, imageRadius,
                          fit: BoxFit.cover)
                      .cornerRadiusWithClipRRect(60)
                      .paddingBottom(8),
                  radius: imageRadius,
                ),
                Column(
                  children: [
                    /// Username
                    Text(
                      name,
                      style: GoogleFonts.lato(
                        fontSize: 18.0,
                        color: getBoolAsync(IS_DARK_MODE)
                            ? AppColors.kHabitOrange
                            : AppColors.kTextBlack,
                        fontWeight: TextFontWeight.medium,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.01),

                    /// Email
                    Text(userEmail.validate(),
                        style: GoogleFonts.lato(
                          fontSize: 14.0,
                          color: getBoolAsync(IS_DARK_MODE)
                              ? AppColors.kHintTextLightGrey
                              : AppColors.grayColor,
                          fontWeight: TextFontWeight.light,
                        ),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * .01),
        Divider(
          thickness: 2,
        ),

        /// Light/ Dark mode
        SettingItemWidget(
          title: 'THEME',
        ),
        ListTile(
          leading: Icon(
            Icons.light_mode_outlined,
            semanticLabel: 'light mode',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          title: Switch(
            value: appStore.isDarkMode,
            activeTrackColor: AppColors.scaffoldSecondaryDark,
            inactiveThumbColor: AppColors.kHabitDark,
            inactiveTrackColor: AppColors.scaffoldSecondaryDark,
            onChanged: (val) async {
              appStore.setDarkMode(val);
              await setValue(IS_DARK_MODE, val);
            },
          ),
          trailing: Icon(
            Icons.dark_mode,
            semanticLabel: 'dark mode',
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
        ),
        SizedBox(height: size.height * .01),
        Divider(
          thickness: 2,
        ),
        SettingItemWidget(
          title: 'LOGIN & SECURITY',
        ),

        /// Unlock/ lock notes password
        ListTile(
          leading: Icon(
            Icons.pin_outlined,
            semanticLabel: 'reset master password',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          title: Text(
            settings_change_master_pwd,
            style: GoogleFonts.lato(
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
              fontWeight: TextFontWeight.regular,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          onTap: () {
            finish(context);
            ChangeMasterPasswordScreen().launch(context);
          },
        ),
        Divider(
          thickness: 2,
        ),

        /// Reset Account password
        ListTile(
          leading: Icon(
            Icons.password_outlined,
            semanticLabel: 'reset account password',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          title: Text(
            settings_change_pwd,
            style: GoogleFonts.lato(
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
              fontWeight: TextFontWeight.regular,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          onTap: () {
            finish(context);
            ChangeAppPasswordScreen().launch(context);
            // ForgotPasswordScreen().launch(context);
          },
        ),
        Divider(
          thickness: 2,
        ),

        SettingItemWidget(
          title: 'INFO',
        ),

        /// About App
        ListTile(
          leading: Icon(
            Icons.info_outline,
            semanticLabel: 'about us',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          title: Text(
            settings_info_about_us,
            style: GoogleFonts.lato(
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
              fontWeight: TextFontWeight.regular,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          onTap: () {
            finish(context);
            AboutAppScreen().launch(context);
          },
        ),
        Divider(
          thickness: 2,
        ),

        /// Privacy Policy
        ListTile(
          leading: Icon(
            Icons.policy_outlined,
            semanticLabel: 'privacy policy',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          title: Text(
            settings_info_pp,
            style: GoogleFonts.lato(
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
              fontWeight: TextFontWeight.regular,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          onTap: () {
            finish(context);
            PrivacyPolicyScreen().launch(context);
          },
        ),
        Divider(
          thickness: 2,
        ),

        /// Terms of Use
        ListTile(
          leading: Icon(
            Icons.article_outlined,
            semanticLabel: 'terms of use',
            size: 30,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          title: Text(
            settings_info_tou,
            style: GoogleFonts.lato(
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kTextWhite
                  : AppColors.kTextBlack,
              fontWeight: TextFontWeight.regular,
            ),
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kHabitOrange
                : AppColors.kPrimaryVariantColorDark,
          ),
          onTap: () {
            finish(context);
            TermsOfUseScreen().launch(context);
          },
        ),
        Divider(
          thickness: 2,
        ),
        SizedBox(height: size.height * .03),
        Container(
          margin: EdgeInsets.all(8.0),
          child: Center(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "HaBIT Note ",
                    style: GoogleFonts.fugazOne(
                      color: getBoolAsync(IS_DARK_MODE)
                          ? AppColors.kTextWhite
                          : AppColors.kTextBlack,
                      fontWeight: TextFontWeight.regular,
                    ),
                  ),
                  TextSpan(
                     text: AppStrings.appVersionText2,
                    semanticsLabel: 'version code',
                    style: GoogleFonts.lato(
                      color: getBoolAsync(IS_DARK_MODE)
                          ? AppColors.kTextWhite
                          : AppColors.kTextBlack,
                      fontWeight: TextFontWeight.regular,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * .03),
      ]),
    );
  }
}
