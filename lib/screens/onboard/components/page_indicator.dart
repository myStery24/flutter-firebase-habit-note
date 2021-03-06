import 'package:flutter/material.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';

List<Widget> buildPageIndicator(
  int numPages,
  int currentPage,
  bool isPageIndicatorCircle,
) {
  List<Widget> list = [];

  for (int i = 0; i < numPages; i++) {
    list.add(i == currentPage
        ? _currentPageIndicator(true, isPageIndicatorCircle)
        : _currentPageIndicator(false, isPageIndicatorCircle));
  }
  return list;
}

/// Rounded rectangular page indicator
Widget _currentPageIndicator(bool isActive, bool isPageIndicatorCircle) {
  return AnimatedContainer(
    duration: kAnimationDuration,
    margin: const EdgeInsets.symmetric(horizontal: 8.0),
    height: 10.0,
    width: isPageIndicatorCircle ? 10.0 : 45.0,
    decoration: _pageIndicatorBoxDecoration(isActive, isPageIndicatorCircle),
  );
}

/// Circle (dot) page indicator
Decoration _pageIndicatorBoxDecoration(isActive, isPageIndicatorCircle) {
  return BoxDecoration(
    color: isActive ? AppColors.kHabitOrange : Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.orange.withOpacity(0.2), // color of shadow
        blurRadius: 2.0,
        spreadRadius: 2.5,
        offset: const Offset(3, 2), // Changes position of shadow
        // First parameter of offset is left-right
        // Second parameter is top to down
      ),
    ],
    borderRadius: BorderRadius.all(
      Radius.circular(
        isPageIndicatorCircle ? 5 : 100,
      ),
    ),
  );
}
