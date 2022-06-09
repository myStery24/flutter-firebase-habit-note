import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import 'custom_page_view_model.dart';

class HelpAccountSettingsScreen extends StatefulWidget {
  static String tag = '/HelpAccountSettingsScreen';

  const HelpAccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<HelpAccountSettingsScreen> createState() =>
      _HelpAccountSettingsScreenState();
}

class _HelpAccountSettingsScreenState extends State<HelpAccountSettingsScreen> {
  PageController _pageController =
      PageController(); // Keep track of which page you're on
  final int pages = 3;
  final int lastPage = 3;
  bool onLastPage = false; // Keep track of the last page

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
      // PageView allows you to swipe horizontally between pages
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                // Check if on last page, if index is 2, then true
                // index starts with 0 for first page
                onLastPage = (index == 2);
              });
            },
            children: [
              CustomPageView(
                  title: 'Settings',
                  image: AppHelp.helpAcc,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: 'How to Change Master Password?',
                  image: AppHelp.helpAcc1,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: 'How to Change Account Password?',
                  image: AppHelp.helpAcc2,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Skip
                  InkWell(
                      child: Text('SKIP'),
                      // jump to the last page
                      onTap: () => _pageController.jumpToPage(lastPage)),

                  /// Dot indicator
                  SmoothPageIndicator(
                      controller: _pageController, // PageController
                      count: pages,
                      effect: ScrollingDotsEffect(
                        fixedCenter: true,
                        spacing: 16,
                        dotColor: AppColors.kHintTextLightGrey,
                        activeDotColor: AppColors.kHabitOrange,
                      ), // your preferred effect
                      onDotClicked: (index) {
                        _pageController.animateToPage(index,
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeIn);
                      }),

                  /// Next or done
                  onLastPage
                      // true
                      ? InkWell(
                          child: Text(
                            'DONE',
                            style: TextStyle(
                                color: AppColors.kHabitOrange, fontSize: 18),
                          ),
                          onTap: () => Navigator.pop(context))
                      // false
                      : InkWell(
                          child: Text('NEXT'),
                          onTap: () => _pageController.nextPage(
                              duration: const Duration(microseconds: 500),
                              curve: Curves.easeInOut)),
                ]),
          ),
        ],
      ),
    );
  }
}
