import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'colors.dart';
import 'constants.dart';
import 'string_constant.dart';

/// Notes Colour Palette
List<Color> getNoteColors() {
  List<Color> colors = [];
  colors.add(getColorFromHex('#FFFFFF'));
  colors.add(getColorFromHex('#FF9D9D'));
  colors.add(getColorFromHex('#FFB347'));
  colors.add(getColorFromHex('#FFF498'));
  colors.add(getColorFromHex('#91F48F'));
  colors.add(getColorFromHex('#CBF0F8'));
  colors.add(getColorFromHex('#AECBFA'));
  colors.add(getColorFromHex('#D7AEFB'));
  colors.add(getColorFromHex('#FC98FF'));
  colors.add(getColorFromHex('#9DFFFF'));
  colors.add(getColorFromHex('#B59BFF'));
  colors.add(getColorFromHex('#624AF2'));
  colors.add(getColorFromHex('#FCDDEC'));
  colors.add(getColorFromHex('#F1F1F1'));
  colors.add(getColorFromHex('#CD5C5C'));
  colors.add(getColorFromHex('#E2CBB1'));
  colors.add(getColorFromHex('#C4C4C4'));
  colors.add(getColorFromHex('#2F4F4F'));

  return colors;
}

class SelectNoteColor extends StatelessWidget {
  final Function(Color)? onTap;

  SelectNoteColor({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: getNoteColors().map((e) {
        return Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: e,
              border: Border.all(color: Colors.grey.shade300)),
        ).onTap(() {
          onTap!(e);
        });
      }).toList(),
    );
  }
}

Widget commonCacheImageWidget(String? url, double height,
    {double? width, BoxFit? fit}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder:
            placeholderWidgetFn() as Widget Function(BuildContext, String)?,
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return Image.network(url!, height: height, width: width, fit: fit);
    }
  } else if (url.validate().isEmpty) {
    return placeholderWidget();
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit);
  }
}

Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() => CircleAvatar(
    child: Icon(Icons.person, color: Colors.black),
    radius: imageRadius - 10,
    backgroundColor: Colors.grey.shade300);

subscriptionInputDecoration({String? name}) {
  return InputDecoration(
    counterText: '',
    border: InputBorder.none,
    hintText: name,
    hintStyle: secondaryTextStyle(),
    fillColor: Colors.grey.withOpacity(0.2),
    focusColor: Colors.grey.withOpacity(0.2),
    filled: true,
    contentPadding: EdgeInsets.only(left: 8),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

Widget getLayoutTypeIcon() {
  String type =
      getStringAsync(SELECTED_LAYOUT_TYPE_DASHBOARD, defaultValue: GRID_VIEW);
  if (type == GRID_VIEW) {
    return Icon(Icons.grid_view);
  } else if (type == LIST_VIEW) {
    return Icon(Icons.view_agenda_outlined);
  } else {
    return Icon(Icons.grid_on_rounded);
  }
}

appTextFieldInputDeco({String? hint, double? counterSize}) {
  return InputDecoration(
    labelText: hint.validate(),
    labelStyle: primaryTextStyle(),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: appStore.isDarkMode ? Colors.white : Colors.grey)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: appStore.isDarkMode ? Colors.white : Colors.grey)),
    border: OutlineInputBorder(borderSide: BorderSide()),
    counterStyle: primaryTextStyle(size: counterSize as int? ?? 12),
  );
}

Widget noDataWidget(BuildContext context) {
  return Observer(
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppImages.empty),
        // Image.asset(AppImages.empty, height: 80, fit: BoxFit.fitHeight),
        8.height,
        Text(home_empty_note,
                style: boldTextStyle(
                    color: appStore.isDarkMode
                        ? Colors.white
                        : AppColors.kHabitDark))
            .center(),
      ],
    ).center(),
  );
}
