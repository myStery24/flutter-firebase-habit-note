import 'package:flutter/material.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:nb_utils/nb_utils.dart';

class FilterNoteByColorDialogWidget extends StatefulWidget {
  final Function(String)? onColorTap;

  FilterNoteByColorDialogWidget({this.onColorTap});

  @override
  _FilterNoteByColorDialogWidgetState createState() => _FilterNoteByColorDialogWidgetState();
}

class _FilterNoteByColorDialogWidgetState extends State<FilterNoteByColorDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.4,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(reset_filter_text, style: primaryTextStyle(size: 14)).center(),
            ).onTap(() {
              finish(context);
              widget.onColorTap!('');
            }).paddingOnly(top: 16, right: 16, bottom: 16),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: getNoteColors().map((e) {
                return Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: e, border: Border.all(color: Colors.grey.shade300)),
                ).onTap(() {
                  finish(context);
                  widget.onColorTap!(e.toHex());
                });
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
