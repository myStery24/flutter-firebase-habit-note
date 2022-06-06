import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';

/// Labels screen header
Widget labelsInfoBox() {
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            icon: Icon(
              Icons.label,
              color: getBoolAsync(IS_DARK_MODE)
                  ? AppColors.kHabitOrange
                  : AppColors.kHabitDark,
            ),
            onPressed: null),
        Text(
          "Manage all your notes' labels. \nAll in one place.",
          style: GoogleFonts.lato(
            fontSize: 18.0,
            color: getBoolAsync(IS_DARK_MODE)
                ? AppColors.kTextWhite
                : AppColors.kTextBlack,
            fontWeight: TextFontWeight.regular,
          ),
        ),
      ],
    ),
  );
}

/// [Create labels] Header
class CreateLabelSectionTitleWidget extends StatelessWidget {
  const CreateLabelSectionTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 5),
      child: Text(
        'Create a new label',
        style: GoogleFonts.lato(
          fontSize: 18.0,
          color: getBoolAsync(IS_DARK_MODE)
              ? AppColors.kTextWhite
              : AppColors.kTextBlack,
          fontWeight: TextFontWeight.bold,
        ),
      ),
    );
  }
}

/// [Labels in your notes] Header
class LabelsSectionTitleWidget extends StatelessWidget {
  const LabelsSectionTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 5),
      child: Text(
        'Labels in your notes',
        style: GoogleFonts.lato(
          fontSize: 18.0,
          color: getBoolAsync(IS_DARK_MODE)
              ? AppColors.kTextWhite
              : AppColors.kTextBlack,
          fontWeight: TextFontWeight.bold,
        ),
      ),
    );
  }
}

/// A container to display the created label with edit function button
class LabelWidget extends StatelessWidget {
  const LabelWidget({Key? key, required this.text, required this.onTap}) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 5, 16, 8),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x32000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// The label name
                      Text(
                        text,
                        style: primaryTextStyle(
                          color: AppColors.kTextBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  /// View all notes with this label button
                  AppButton(
                    shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Text('Edit',
                        style: boldTextStyle(
                            color: appStore.isDarkMode
                                ? AppColors.kHabitDark
                                : Colors.white)),
                    padding: EdgeInsets.all(8.0),
                    color: AppColors.kHabitOrange,
                    width: 70,
                    height: 36,
                    onTap: onTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The background when swiping the list
class SwipeActionBackground extends StatelessWidget {
  const SwipeActionBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              child: Icon(Icons.delete_forever_outlined),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 15.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Icon(Icons.delete_forever_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
