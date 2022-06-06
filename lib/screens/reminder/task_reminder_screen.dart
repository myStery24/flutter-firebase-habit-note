import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';

import 'components/add_task_screen.dart';

// TODO
/// List all the subscriptions
class TaskReminderScreen extends StatefulWidget {
  @override
  TaskReminderScreenState createState() => TaskReminderScreenState();
}

class TaskReminderScreenState extends State<TaskReminderScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(
        appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : Colors.white,
        statusBarIconBrightness: Brightness.light,
        delayInMilliSeconds: 100);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(
        appStore.isDarkMode ? AppColors.kPrimaryVariantColorDark : Colors.white,
        delayInMilliSeconds: 100);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Reminder'),
      ),
      floatingActionButton: Observer(
        builder: (_) => FloatingActionButton.extended(
          backgroundColor: AppColors.kHabitOrange,
          label: Text(
            'Add task',
            style: TextStyle(
              color: appStore.isDarkMode
                  ? AppColors.kTextBlack
                  : AppColors.kTextWhite,
            ),
          ),
          icon: Icon(Icons.add,
              color: appStore.isDarkMode ? AppColors.kHabitDark : Colors.white),
          onPressed: () {
            AddTaskScreen().launch(context);
          },
        ),
      ),
      body: Column(
        children: [
          15.height,
          _addTaskBar(),
          _addDateBar(),
        ],
      ),

      /// Show the list of created reminder
    );
  }

  /// Top task bar with date
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // horizontal
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: GoogleFonts.lato(
                    color: AppColors.kHintTextLightGrey,
                    fontSize: 24.0,
                    fontWeight: TextFontWeight.bold,
                  ),
                ), // format the current date time and return as a date format
                Text(
                  'Today',
                  style: GoogleFonts.lato(
                      color: getBoolAsync(IS_DARK_MODE)
                          ? AppColors.kTextWhite
                          : AppColors.kTextBlack,
                      fontSize: 24.0,
                      fontWeight: TextFontWeight.bold),
                ),
              ],
            ),
          ),
          // Observer(
          //   builder: (_) => CustomButton2(
          //     text: '+ Add task',
          //     textColor: getBoolAsync(IS_DARK_MODE)
          //         ? AppColors.kTextBlack
          //         : AppColors.kTextWhite,
          //     onPressed: () {
          //       AddTaskScreen().launch(context);
          //     },
          //     color: AppColors.kHabitOrange,
          //   ),
          // ),
        ],
      ),
    );
  }

  /// Scrollable date timeline
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        // today's date
        selectionColor: AppColors.kHabitOrange,
        selectedTextColor: AppColors.kTextWhite,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: TextFontWeight.medium,
            color: AppColors.kHintTextLightGrey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: TextFontWeight.medium,
            color: AppColors.kHintTextLightGrey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: TextFontWeight.medium,
            color: AppColors.kHintTextLightGrey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }
}
