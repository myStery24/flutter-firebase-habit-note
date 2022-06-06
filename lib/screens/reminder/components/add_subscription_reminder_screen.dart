import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import '../../../models/subscription_model.dart';

/// Add reminder
class AddSubscriptionReminderScreen extends StatefulWidget {
  final SubscriptionModel? subscriptionModel;

  AddSubscriptionReminderScreen({this.subscriptionModel});

  @override
  AddSubscriptionReminderScreenState createState() =>
      AddSubscriptionReminderScreenState();
}

class AddSubscriptionReminderScreenState
    extends State<AddSubscriptionReminderScreen> {
  TextEditingController notificationUnitController = TextEditingController();

  String? durationUnit = DAY;
  DateTime? notificationTime;
  int? radioValue = 0;
  DateTime? date;

  bool isRightDate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.subscriptionModel!.dueDate != null) {
      date = widget.subscriptionModel!.dueDate;
    } else {
      date = widget.subscriptionModel!.nextPayDate;
    }
    notificationTime = DateTime.now();
    if (widget.subscriptionModel!.notificationId != null) {
      notificationTime = widget.subscriptionModel!.notificationDate;
      date = date!.subtract(Duration(hours: 00, minutes: 00));
    }
  }

  Future<void> showTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(notificationTime!),
        builder: (BuildContext context, Widget? child) {
          return appStore.isDarkMode
              ? Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.fromSwatch(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.deepOrange,
                    ),
                    dialogBackgroundColor: Colors.black,
                  ),
                  child: child!,
                )
              : Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.fromSwatch(
                      brightness: Brightness.light,
                      primarySwatch: Colors.deepOrange,
                    ),
                    dialogBackgroundColor: Colors.white,
                  ),
                  child: child!,
                );
        });
    if (picked != null) {
      setState(() {
        notificationTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, picked.hour, picked.minute);
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reminder),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.height,
            Row(
              children: [
                /// Option 1
                Radio(
                  activeColor: AppColors.kHabitOrange,
                  value: 0,
                  groupValue: radioValue,
                  onChanged: (dynamic val) {
                    setState(() {
                      radioValue = val;
                    });
                  },
                ),
                8.width,
                Text(on_same_day, style: primaryTextStyle()),
              ],
            ),
            16.height,
            Row(
              children: [
                /// Option 2
                Radio(
                  activeColor: AppColors.kHabitOrange,
                  value: 1,
                  groupValue: radioValue,
                  onChanged: (dynamic val) {
                    setState(() {
                      radioValue = val;
                    });
                  },
                ),

                /// Enter the number of day, week, month or year, default is 1
                AppTextField(
                  controller: notificationUnitController,
                  cursorColor: AppColors.kHabitOrange,
                  textStyle: primaryTextStyle(),
                  textFieldType: TextFieldType.PHONE,
                  decoration: subscriptionInputDecoration(name: '1'),
                ).expand(),
                16.width,

                /// The dropdown menu to choose day, week, month or year
                Container(
                  margin: EdgeInsets.only(right: 16),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.withOpacity(0.2)),
                  child: DropdownButton<String>(
                    value: durationUnit,
                    isExpanded: true,
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    onChanged: (String? newValue) {
                      setState(() {
                        durationUnit = newValue;
                      });
                    },
                    items: <String>[DAY, WEEK, MONTH, YEAR]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: primaryTextStyle()),
                      );
                    }).toList(),
                  ),
                ).expand(flex: 2),
              ],
            ),
            16.height,
            _reminderDateInfoBox(),
            16.height,

            /// Choose a notification time
            Text('Time', style: boldTextStyle()),
            10.height,
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showTime(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.kGrayColor.withOpacity(0.2),
                ),
                padding: EdgeInsets.all(8),
                child: Text(
                  "${notificationTime!.hour.toString().padLeft(2, '0')} : ${notificationTime!.minute.toString().padLeft(2, '0')} ${DateFormat('a').format(notificationTime!)}",
                  style: primaryTextStyle(),
                ),
              ).paddingTop(8),
            ),
            16.height,

            /// Save button
            AppButton(
              color: AppColors.kHabitOrange,
              width: context.width(),
              onTap: () {
                _handleRadioValueChange(radioValue);
              },
              child: Text(save,
                  style: boldTextStyle(
                      color: appStore.isDarkMode
                          ? AppColors.kHabitDark
                          : Colors.white)),
            ),
            Observer(
                builder: (_) => Loader(
                        color: appStore.isDarkMode
                            ? AppColors.kHabitDark
                            : AppColors.kHabitOrange)
                    .visible(appStore.isLoading))
          ],
        ).paddingOnly(left: 16, right: 16),
      ),
    );
  }

  bool forOneTime(int? value) {
    if (value == 0) {
      if (date!.difference(DateTime.now()).inDays >= 0) {
        return true;
      } else {
        return false;
      }
    } else if (value == 1) {
      log('Remain day ${date!.difference(DateTime.now()).inDays}');
      if (date!.difference(DateTime.now()).inDays >=
          notificationUnitController.text.trim().toInt()) {
        date = date!.subtract(Duration(
            days:
                notificationUnitController.text.trim().toInt(defaultValue: 1)));
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  bool forRecurring(int? value) {
    var durationUnit = widget.subscriptionModel!.durationUnit;

    if (value == 0) {
      if (date!.difference(DateTime.now()).inDays >= 0) {
        if (durationUnit == DAY) {
          date = widget.subscriptionModel!.nextPayDate;
          return true;
        } else if (durationUnit == WEEK) {
          date = widget.subscriptionModel!.nextPayDate;
          return true;
        } else if (durationUnit == MONTH) {
          date = widget.subscriptionModel!.nextPayDate;
          return true;
        } else if (durationUnit == YEAR) {
          date = widget.subscriptionModel!.nextPayDate;
          return true;
        }
      } else {
        return false;
      }
    } else if (value == 1) {
      if (durationUnit == DAY) {
        date = widget.subscriptionModel!.nextPayDate;
        if (date!.difference(DateTime.now()).inDays >=
            notificationUnitController.text.trim().toInt()) {
          date = date!.subtract(Duration(
              days: notificationUnitController.text
                  .trim()
                  .toInt(defaultValue: 1)));
          return true;
        } else {
          return false;
        }
      } else if (durationUnit == WEEK) {
        date = widget.subscriptionModel!.nextPayDate;
        if (date!.difference(DateTime.now()).inDays >=
            notificationUnitController.text.trim().toInt()) {
          date = date!.subtract(Duration(
              days: notificationUnitController.text
                  .trim()
                  .toInt(defaultValue: 1)));
          return true;
        } else {
          return false;
        }
      } else if (durationUnit == MONTH) {
        date = widget.subscriptionModel!.nextPayDate;
        if (date!.difference(DateTime.now()).inDays >=
            notificationUnitController.text.trim().toInt()) {
          date = date!.subtract(Duration(
              days: notificationUnitController.text
                  .trim()
                  .toInt(defaultValue: 1)));
          return true;
        } else {
          return false;
        }
      } else if (durationUnit == YEAR) {
        date = widget.subscriptionModel!.nextPayDate;
        if (date!.difference(DateTime.now()).inDays >=
            notificationUnitController.text.trim().toInt()) {
          date = date!.subtract(Duration(
              days: notificationUnitController.text
                  .trim()
                  .toInt(defaultValue: 1)));
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  _handleRadioValueChange(int? value) {
    appStore.setLoading(true);

    if (widget.subscriptionModel!.dueDate != null) {
      isRightDate = forOneTime(value);
    } else {
      isRightDate = forRecurring(value);
    }

    if (isRightDate) {
      var dateTime = currentTimeStamp();

      log('Notification date time ${date!.add(Duration(hours: notificationTime!.hour, minutes: notificationTime!.minute))}');

      subscriptionService.updateDocument({
        'notificationId': dateTime,
        'notificationDate': date!.add(Duration(
            hours: notificationTime!.hour, minutes: notificationTime!.minute)),
      }, widget.subscriptionModel!.id).then((value) async {
        await manager.showScheduleNotification(
          scheduledNotificationDateTime: date!.add(Duration(
              hours: notificationTime!.hour,
              minutes: notificationTime!.minute)),
          title: widget.subscriptionModel!.name,
          description: widget.subscriptionModel!.amount,
          id: dateTime,
        );
        finish(context);
        finish(context);

        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);

        log(error.toString());
      });
    } else {
      appStore.setLoading(false);

      toast('Invalid date');
    }
  }

  Widget _reminderDateInfoBox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            icon: Icon(
              Icons.info_outline,
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kHabitOrange
                  : AppColors.kHabitDark,
            ),
            onPressed: null),
        Text(
          'Set a date BEFORE the next payment/expiry \ndate. Not applicable to future reminder.',
          style: TextStyle(
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kTextWhite
                : AppColors.kTextBlack,
          ),
        ),
      ],
    );
  }
}
