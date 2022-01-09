// common
class AppStrings {
  // App name
  static const String appName = 'HaBIT Note';
  // App copyright
  static const String appCopyright =
      '© Copyright HABIT 2021. All rights reserved';

  // Button texts
  static const String createAccount = 'CREATE ACCOUNT';
  static const String login = 'LOG IN';
  static const String logout = 'LOG OUT';
  static const String exit = 'Exit';
  static const String optionNo = 'No';

  static const String clear = 'Clear Image';
  static const String scan = 'Scan for Text';

  // Handle form error
  final RegExp emailValidatorRegex =
  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String kNameNullError = 'Username is required';
  static const String kEmailNullError = 'Email is required';
  static const String kInvalidEmailError = 'Enter in the format: name@example.com';
  static const String kPassNullError = 'Cannot be blank';
  static const String kShortPassError = 'At least 6 characters';
  static const String kMatchPassError = 'Passwords do not match';

  // Handle Return/Back Button
  static const String pressAgain = 'Press back again to exit app';
}

// duration
const DAY = 'Day';
const WEEK = 'Week';
const MONTH = 'Month';
const YEAR = 'Year';

const ringgit_icon = 'RM';
const date_format = 'yyyy-MM-dd';
const datetime_format = 'yyyy-MM-dd HH:mm a';

const about = 'About';
const dark_mode = 'Dark Mode';
const help = 'Help';
const ocr = 'OCR';
const home_empty_note = 'Create your first note !';
const add_note = 'Add Note';
const add_todo = 'Add To-do';
const delete_note = 'Delete Note';
const delete_todo = 'Delete To-do';
const sub_reminder = 'Subscription Reminder';
const reset_acc_pwd = 'Reset password';
const lock_notes_pwd = 'Password Protection';
const change_master_pwd = 'Change master password';
const enter_master_pwd = 'Enter master password';
const log_out = 'Log Out';
const log_out_text = 'Are you sure you want to log out ?';
const clear_image = 'Image removed';
const no_image = 'Error, please upload an image';
const share_note_change_not_allow = 'This is shared note, changes are not allow';
const invalid_pwd = 'Invalid password';
const pwd_length = 'Password length must be 4';
const pwd_not_same = 'Password not same';
const confirm_pwd = 'Confirm password';
const add_subscription = 'Add Subscription';
const delete = 'Delete';
const update = 'Update';
const save = 'Save';
const password = 'Password';
const cancel = 'Cancel';
const submit = 'Submit';
const edit = 'Edit';
const reset_filter_text = 'Reset';
const INR = 'INR';
const name = 'Name';
const expired = 'Expired';
const description = 'Description';
const recurring = 'Recurring';
const one_time = 'One time';
const billing_period = 'Billing period';
const first_payment = 'First payment';
const exp_date = 'Expiry Date';
const pay_method = 'Payment method';
const select_colour = 'Select Colour';
const collaborator = 'Collaborator';
const collaborators = 'Collaborators';
const shared_by = 'Shared By';
const type_something_here = 'Type something awesome here';
const type_something_here2 = "What's your to-do ?";
const reset_pwd = 'Reset password';
const reset_master_pwd = 'Reset Master Password';
const current_pwd_invalid = 'Current password is invalid';
const new_pwd = 'New password';
const change_pwd = 'Change password';
const pwd_change_successfully = 'Password change successfully';
const pwd_reset_successfully = 'Password reset successfully';
const confirm_to_delete_note = 'Confirm to delete note ?';
const select_option = 'Select Option';
const unlock_note = 'Unlock Note';
const lock_note = 'Lock Note';
const select_layout = 'Select layout';
const forgot_pwd = 'Forgot Password';
const email_already_exits = 'This email is already exists';
const notification = 'Notification';
const on_same_day = 'On the Same day';
const with_social_media = 'with social media';
const continue_with_google = 'Continue with Google';
const continue_with_apple = 'Continue with apple';
const next_payment = 'Next Payment';
const subscription_exp = 'Subscription expired. No notification available';
const subscription_detail = 'Subscription Detail';
