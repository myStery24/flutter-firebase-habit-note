import 'package:flutter/material.dart';
import 'package:habit_note/main.dart';
import 'package:habit_note/utils/colours.dart';

class RecognisedTextAreaWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const RecognisedTextAreaWidget({
    Key? key,
    required this.text,
    this.fontSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: appStore.isDarkMode ? Colors.white12 : Colors.transparent,
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: SelectableText(
                text.isNotEmpty ? text : 'Scan An Image To Get Text',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fontSize, color: appStore.isDarkMode ? Colors.white60 : AppColors.kTextBlack),
                showCursor: true,
                cursorColor: AppColors.kHabitOrange,
                scrollPhysics: ClampingScrollPhysics(),
              ),
            ),
          ),
        ],
      );
}
