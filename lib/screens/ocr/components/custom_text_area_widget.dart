import 'package:flutter/material.dart';
import 'package:habit_note/main.dart';

import '../../../configs/colors.dart';

class RecognisedTextAreaWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const RecognisedTextAreaWidget({
    Key? key,
    required this.text,
    this.fontSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Flexible(
          child: Container(
            // height: 245,
            height: size.width / 2,
            decoration: BoxDecoration(
                color: Colors.white12,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: SelectableText(
              text.isNotEmpty ? text : '+ Give me a photo or an image +',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: fontSize,
                  color: appStore.isDarkMode
                      ? Colors.white60
                      : AppColors.kTextBlack),
              showCursor: true,
              scrollPhysics: ClampingScrollPhysics(),
              toolbarOptions:
                  ToolbarOptions(copy: true, selectAll: true, paste: false),
            ),
          ),
        ),
      ],
    );
  }
}
