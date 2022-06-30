import 'package:flutter/material.dart';
import 'colors.dart';

const kAnimationDuration = Duration(milliseconds: 200);
const imageRadius = 40.0;
const double appPadding = 25.0;
const double spacer = 50.0;
const double smallSpacer = 30.0;
const double miniSpacer = 10.0;

/// Text
class TextFontWeight {
  static const thin = FontWeight.w100;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const bold = FontWeight.w700;
  static const black = FontWeight.w900;
}

/// Common
class AppStrings {
  // App name
  static const String appName = 'HaBIT Note';

  // App version
  static const String appVersionText = 'V0.1.2-beta2';
  static const String appVersionText2 = 'Version 0.1.2-beta2';

  // App copyright
  static const String appCopyright = '© Copyright HaBIT Note 2022. All rights reserved.';

  // Texts
  static const String createAccount = 'CREATE ACCOUNT';
  static const String login = 'LOG IN';
  static const String logout = 'LOG OUT';
  static const String back = 'BACK TO DASHBOARD';
  static const String exit = 'Exit';
  static const String optionNo = 'No';
  static const String galleryNotesScreen = 'Gallery';
  static const String ocrScreen = 'Image to Text';
  static const String helpScreen = 'Help';
  static const String meScreen = 'Me';
  static const String help_note_title = 'Notes';
  static const String help_ocr_title = 'Image to text (OCR)';
  static const String help_sub_reminder_title = 'Subscription reminder';
  static const String help_account_title = 'My account settings';

  // Handle form error
  final RegExp emailValidatorRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String kNameNullError = 'Username is required';
  static const String kEmailNullError = 'Email is required';
  static const String kInvalidEmailError = 'Enter in the format: name@example.com';
  static const String kPassNullError = 'Cannot be blank';
  static const String kShortPassError = 'At least 6 characters';
  static const String kMatchPassError = 'Passwords do not match';

  // Handle Return/Back Button
  static const String pressAgain = 'Press back again to exit app';
}

class AppImages {
  // Images route (directory)
  static const String imageDir = 'assets/images';

  // Images
  static const launcherIcon = '$imageDir/icon.png';
  static const launcherIcon2 = '$imageDir/icon_transparent.png';

  static const userIcon = '$imageDir/user.png';
  static const userIcon2 = '$imageDir/user_creativity.png';
  static const userIcon3 = '$imageDir/user_start-up.png';

  static const onboard = '$imageDir/onboard.png';
  static const onboard1 = '$imageDir/onboard_1.png';
  static const onboard2 = '$imageDir/onboard_2.png';
  static const success = '$imageDir/success_icon.svg';

  static const empty = '$imageDir/empty.png';
  static const appleLogo = '$imageDir/ic_apple.png';
  static const placeholder = '$imageDir/placeholder.png';
  static const search = '$imageDir/search_icon.svg';
  static const filter = '$imageDir/filter_icon.svg';
  static const notificationLogo = '$imageDir/logo_notification.png';
}

class AppMarkdown {
  // Markdown file route (directory)
  static const String imageDir = 'assets';

  static const aboutApp = '$imageDir/about_app.md';
  static const deleteAccount = '$imageDir/delete_account.md';
  static const privacyPolicy = '$imageDir/privacy_policy.md';
  static const termsOfUse = '$imageDir/terms_of_use.md';
}

class AppLottie {
  // Lottie animation route (directory)
  static const String imageDir = 'assets';

  static const helpLottie = '$imageDir/guy-talking-to-robot-ai-help.json';
  static const notesLottie = '$imageDir/notes.json';
  static const reminderLottie = '$imageDir/marking-a-calendar.json';
  static const ocrLottie = '$imageDir/document-ocr-scan.json';
  static const settingsLottie = '$imageDir/profile-lock.json';
}

class AppHelp {
  // Images route (directory)
  static const String imageDir = 'assets/help';

  static const helpNotes = '$imageDir/empty_dashboard.png';
  static const helpNotes1 = '$imageDir/notes.png';
  static const helpNotes2 = '$imageDir/note_editor.png';
  static const helpNotes3 = '$imageDir/todo_editor.png';
  static const helpNotes4 = '$imageDir/options_editor.png';
  static const helpNotes5 = '$imageDir/options_notes.png';
  static const helpNotes6 = '$imageDir/labels.png';

  static const helpOCR = '$imageDir/ocr.png';
  static const helpOCR1 = '$imageDir/ex1.png';
  static const helpOCR2 = '$imageDir/ex2.png';
  static const helpOCR3 = '$imageDir/ex3.png';
  static const helpOCR4 = '$imageDir/ex4.png';

  static const helpRmd = '$imageDir/sub_reminder_list.png';
  static const helpRmd1 = '$imageDir/reminder_recurring.png';
  static const helpRmd2 = '$imageDir/reminder_one_time.png';
  static const helpRmd3 = '$imageDir/reminder_setup.png';
  static const helpRmd4 = '$imageDir/reminder_example.png';

  static const helpAcc = '$imageDir/settings.png';
  static const helpAcc1 = '$imageDir/change_master_pwd.png';
  static const helpAcc2 = '$imageDir/change_acc_pwd.png';
}

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: AppColors.kHintTextLightGrey),
  );
}

// Login Type
const LoginTypeApp = 'app';
const LoginTypeGoogle = 'google';
const LoginTypeApple = 'apple';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const IS_FIRST_TIME = 'IS_FIRST_TIME';
const NOTE_ID = 'NOTE_ID';
const USER_ID = 'USER_ID';
const LABEL_ID = 'LABEL_ID';
const USERNAME = 'USERNAME';
const PASSWORD = 'PASSWORD';
const USER_EMAIL = 'USER_EMAIL';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_PHOTO_URL = 'USER_PHOTO_URL';
const USER_MASTER_PWD = 'USER_MASTER_PWD';
const IS_DARK_MODE = 'IS_DARK_MODE';
const LOGIN_TYPE = 'LOGIN_TYPE';

// Note views
const GRID_VIEW = 'GRID_VIEW';
const GRID_VIEW_2 = 'GRID_VIEW_2';
const LIST_VIEW = 'LIST_VIEW';
const FIT_COUNT = 'FIT_COUNT';
const CROSS_COUNT = 'CROSS_COUNT';
const SELECTED_LAYOUT_TYPE_DASHBOARD = 'SELECTED_LAYOUT_TYPE_DASHBOARD';

// Duration
const DAY = 'Day';
const WEEK = 'Week';
const MONTH = 'Month';
const YEAR = 'Year';

// Others
const name = 'Name';
const with_social_media = 'with social media';
const continue_with_google = 'Continue with Google';
const continue_with_apple = 'Continue with apple';
const email_already_exits = 'This email is already exists';
const forgot_pwd = 'Forgot Password';
const dark_mode = 'Dark Mode';
const home_empty_note = 'Create your first note !';
const add_note = 'Note';
const add_todo = 'To-do';
const add_image = 'Note with Image';
const delete_note = 'Delete note';
const delete_todo = 'Delete to-do';
const select_colour = 'Select colour';
const select_colour2 = 'SELECT COLOUR';
const delete = 'Delete';
const delete2 = 'DELETE';
const password = 'Password';
const cancel = 'Cancel';
const submit = 'Submit';
const reset_filter_text = 'Reset';
const type_something_here = 'Type something awesome here';
const type_something_here2 = "What's your to-do ?";
const confirm_to_delete_note = 'Confirm to delete note ?';
const select_option = 'Select option';
const unlock_note = 'Unlock note';
const lock_note = 'Lock note';
const lock_unlock_note = 'Lock & Unlock Note';
const create_lock_note_pwd = 'Create a master password';
const select_layout = 'Select layout';
const lock_notes_pwd = 'Password';
const reset_acc_pwd = 'RESET ACCOUNT PASSWORD';
const enter_master_pwd = 'Enter master password';
const change_master_pwd = 'Change Master Password';
const change_master_pwd2 = 'CHANGE MASTER PASSWORD';
const labels = 'Labels';
const edit = 'Edit';
const help = 'Help';
const ocr = 'OCR';
const add_todo_image = 'Add Image';
const from_camera = 'Take photo';
const from_gallery = 'Choose photo';
const clear = 'Cleared';
const no_image = 'Error, please upload an image';
const settings_change_master_pwd = 'Change Master Password';
const settings_change_pwd = 'Change Account Password';
const about = 'About';
const settings_info_about_us = 'About Us';
const settings_info_pp = 'Privacy Policy';
const settings_info_tou = 'Terms of Use';
const support_email = 'Support Email';
const invalid_pwd = 'Invalid/wrong password';
const pwd_length = 'Password length must be 4';
const pwd_not_same = 'Password not same';
const confirm_pwd = 'Confirm password';
const confirm_new_pwd = 'Confirm new password';
const current_pwd = 'Current password';
const current_pwd_invalid = 'Current password is invalid';
const new_pwd = 'New password';
const change_acc_pwd = 'Change Account Password';
const change_acc_pwd2 = 'CHANGE ACCOUNT PASSWORD';
const pwd_changed_successfully = 'Password changed successfully';
const pwd_reset_successfully = 'Password reset successfully';
const log_out = 'Log Out';
const log_out_text = 'Are you sure you want to log out ?';

const reminder_empty_note = 'Create your first reminder !';
const sub_reminder = 'Subscription Reminder';
const add_new_subscription = 'My Subscription';
const update = 'UPDATE';
const save = 'SAVE';
const MYR = 'MYR';
const ringgit_icon = 'RM';
const date_format = 'yyyy-MM-dd';
const datetime_format = 'yyyy-MM-dd HH:mm a';
const expired = 'EXPIRED';
const description = 'Description';
const recurring = 'Recurring';
const one_time = 'One time';
const billing_period = 'Billing period';
const first_payment = 'First payment';
const exp_date = 'Expiry date';
const pay_method = 'Payment method';
const shared_by = 'Shared By';
const reminder = 'Reminder';
const on_same_day = 'On the same day';
const next_payment = 'Next payment';
const subscription_exp = 'Subscription expired. Setting a notification is not allowed';
const subscription_detail = 'Subscription Detail';
const delete_sub = 'Delete subscription';
const confirm_to_delete_sub = 'Confirm to delete subscription ?';
const share_note_change_not_allow = 'This is shared note, changes are not allow';

const collaborator = 'Collaborator';
const collaborators = 'Collaborators';

/// Testing devices
List<String> testDevices = [''];