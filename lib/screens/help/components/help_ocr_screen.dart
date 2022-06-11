import 'package:flutter/material.dart';
import 'package:habit_note/widgets/custom_buttons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import 'custom_page_view_model.dart';

class HelpOCRScreen extends StatefulWidget {
  const HelpOCRScreen({Key? key}) : super(key: key);

  @override
  State<HelpOCRScreen> createState() => _HelpOCRScreenState();
}

class _HelpOCRScreenState extends State<HelpOCRScreen> {
  PageController _pageController =
      PageController(); // Keep track of which page you're on
  final int pages = 5;
  final int lastPage = 5;
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
          SizedBox(height: spacer),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                // Check if on last page, if index is 5, then true
                // index starts with 0 for first page
                onLastPage = (index == pages - 1);
              });
            },
            children: [
              CustomPageView(
                  title: 'Get Started with Optical Text Recognition (OCR)',
                  image: AppHelp.helpOCR,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: "Example 1",
                  image: AppHelp.helpOCR1,
                  fontWeight: TextFontWeight.bold,
                  subtitle: 'English'),
              CustomPageView(
                  title: 'Example 2',
                  image: AppHelp.helpOCR2,
                  fontWeight: TextFontWeight.bold,
                  subtitle: 'Chinese'),
              CustomPageView(
                  title: 'Example 3',
                  image: AppHelp.helpOCR3,
                  fontWeight: TextFontWeight.bold,
                  subtitle: 'Japanese'),
              CustomPageView(
                  title: 'Example 4',
                  image: AppHelp.helpOCR4,
                  fontWeight: TextFontWeight.bold,
                  subtitle: 'English, Chinese, Japanese'),
            ],
          ),

          /// Skip, Indicator, Next/Done
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Skip
                InkWell(
                    child: CustomSkipButton(),
                    // jump to the last page
                    onTap: () => _pageController.jumpToPage(lastPage)),

                /// Dot indicator
                SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: pages,
                    effect: ScrollingDotsEffect(
                      fixedCenter: true,
                      spacing: 14,
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
                        child: CustomDoneButton(),
                        onTap: () => Navigator.pop(context))
                    // false
                    : InkWell(
                        child: CustomNextButton(),
                        onTap: () => _pageController.nextPage(
                            duration: const Duration(microseconds: 500),
                            curve: Curves.easeInOut)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
