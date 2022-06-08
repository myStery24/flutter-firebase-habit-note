import 'package:flutter/material.dart';
import 'package:habit_note/screens/settings/components/custom_user_profile_card.dart';
import 'package:habit_note/screens/settings/components/delete_account_consent_screen.dart';
import 'package:habit_note/widgets/custom_rich_text_widget.dart';
import 'package:habit_note/widgets/custom_setting_item_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import '../../password/change_account_password_screen.dart';
import '../../password/change_master_password_screen.dart';
import '../../policies/privacy_policy_screen.dart';
import '../../policies/terms_of_use_screen.dart';
import 'about_screen.dart';

class SettingsCategory extends StatefulWidget {
  const SettingsCategory({Key? key}) : super(key: key);

  @override
  State<SettingsCategory> createState() => _SettingsCategoryState();
}

class _SettingsCategoryState extends State<SettingsCategory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(12.0),
        children: [
          /// User Profile Card
          CustomUserProfileCard(),
          SizedBox(height: size.height * .01),
          Divider(thickness: 2),

          /// Light/ Dark mode
          SettingItemWidget(title: 'THEME'),
          ListTile(
            leading: Icon(Icons.light_mode_outlined,
                semanticLabel: 'light mode',
                size: 30,
                color: appStore.isDarkMode
                    ? AppColors.kHabitOrange
                    : AppColors.kPrimaryVariantColorDark),
            // adaptive = both Android and iOS
            title: Switch.adaptive(
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
            trailing: Icon(Icons.dark_mode,
                semanticLabel: 'dark mode',
                color: appStore.isDarkMode
                    ? AppColors.kHabitOrange
                    : AppColors.kPrimaryVariantColorDark),
          ),
          SizedBox(height: size.height * .01),
          Divider(thickness: 2),
          SettingItemWidget(title: 'LOGIN & SECURITY'),

          /// Unlock/ lock notes password
          CustomSettingItemWidget(
              leadingIcon: Icons.pin_outlined,
              trailingIcon: Icons.keyboard_arrow_right,
              semanticLabel: 'reset master password',
              title: settings_change_master_pwd,
              onTap: () {
                finish(context);
                ChangeMasterPasswordScreen().launch(context);
              }),
          Divider(thickness: 2),

          /// Reset Account password
          CustomSettingItemWidget(
              leadingIcon: Icons.password_outlined,
              trailingIcon: Icons.keyboard_arrow_right,
              semanticLabel: 'reset account password',
              title: settings_change_pwd,
              onTap: () {
                finish(context);
                ChangeAppPasswordScreen().launch(context);
              }),
          Divider(thickness: 2),
          SettingItemWidget(title: 'INFO'),

          /// About App
          CustomSettingItemWidget(
              leadingIcon: Icons.info_outline,
              trailingIcon: Icons.keyboard_arrow_right,
              semanticLabel: 'about us',
              title: settings_info_about_us,
              onTap: () {
                finish(context);
                AboutAppScreen().launch(context);
              }),
          Divider(thickness: 2),

          /// Privacy Policy
          CustomSettingItemWidget(
              leadingIcon: Icons.policy_outlined,
              trailingIcon: Icons.keyboard_arrow_right,
              semanticLabel: 'privacy policy',
              title: settings_info_pp,
              onTap: () {
                finish(context);
                PrivacyPolicyScreen().launch(context);
              }),
          Divider(thickness: 2),

          /// Terms of Use
          CustomSettingItemWidget(
              leadingIcon: Icons.article_outlined,
              trailingIcon: Icons.keyboard_arrow_right,
              semanticLabel: 'terms of use',
              title: settings_info_tou,
              onTap: () {
                finish(context);
                TermsOfUseScreen().launch(context);
              }),
          Divider(thickness: 2),

          /// Request to delete user account
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(size.width, 50),
                  textStyle: TextStyle(fontSize: 18.0),
                  primary: Colors.red, // foreground
                  side: BorderSide(width: 3.0, color: Colors.red)),
              onPressed: () {
                finish(context);
                DeleteAccountConsentScreen().launch(context);
              },
              child: Text('Delete My Account'),
            ),
          ),
          SizedBox(height: size.height * .03),
          Container(
            margin: EdgeInsets.all(8.0),
            child: Center(
                child: CustomRichTextWidget(
                    primaryText: 'HaBIT Note ',
                    primaryFontSize: 18.0,
                    secondaryText: AppStrings.appVersionText2,
                    color: getBoolAsync(IS_DARK_MODE)
                        ? AppColors.kTextWhite
                        : AppColors.kTextBlack)),
          ),
          SizedBox(height: size.height * .02)
        ],
      ),
    );
  }
}
