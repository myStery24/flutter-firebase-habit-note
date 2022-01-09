import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

// TODO: Text Recognition
class OCRScreen extends StatefulWidget {
  const OCRScreen({Key? key}) : super(key: key);

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  // String text = '';
  // late File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kHabitBackgroundLightGrey,
      appBar: AppBar(
        title: Text('Image to Text (OCR)'),
      ),
      floatingActionButton: Observer(
        builder: (_) => FloatingActionButton(
          child: Icon(Icons.camera,
              color: appStore.isDarkMode ? AppColors.kHabitDark : Colors.white),
          onPressed: () {
            // TODO: Open selection
            // AddSubscriptionReminderScreen().launch(context);
          },
          backgroundColor: appStore.isDarkMode
              ? AppColors.kHabitOrange
              : AppColors.kHabitOrange,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: Icon(Icons.photo, size: 80, color: Colors.black),
                  width: 350,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: 350,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    color: Colors.white,
                  ),
                ),

                /// Buttons
                Row(
                  children: [
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonPadding: EdgeInsets.all(8.0),
                      children: [
                        SizedBox(),
                        OutlinedButton(
                          onPressed: () {
                            // Respond to button press
                            toast(clear_image);
                          },
                          child: const Text(AppStrings.clear),
                          style: OutlinedButton.styleFrom(
                            primary: AppColors.kTextBlack,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(width: 1, color: Colors.black),
                            minimumSize: Size(120, 40),
                          ),
                        ),
                        SizedBox(),
                        ElevatedButton(
                          onPressed: () {
                            // Respond to button press
                            toast(no_image);
                          },
                          child: const Text(AppStrings.scan),
                          style: ElevatedButton.styleFrom(
                            elevation: 1,
                            primary: AppColors.kHabitOrange,
                            onPrimary: AppColors.kTextWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: Size(120, 40),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          // child: Text(
          //   'Todo: Text Recognition',
          //   style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          //   textAlign: TextAlign.center,
          // ),
        ),
      ),
    );
  }
}
