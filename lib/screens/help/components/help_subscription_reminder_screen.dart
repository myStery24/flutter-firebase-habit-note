import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import 'custom_page_view_model.dart';

class HelpSubscriptionReminderScreen extends StatefulWidget {
  const HelpSubscriptionReminderScreen({Key? key}) : super(key: key);

  @override
  State<HelpSubscriptionReminderScreen> createState() => _HelpSubscriptionReminderScreenState();
}

class _HelpSubscriptionReminderScreenState extends State<HelpSubscriptionReminderScreen> {
  PageController _pageController =
  PageController(); // Keep track of which page you're on
  final int pages = 3;
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
      appBar: AppBar(
        title: Text(
          AppStrings.help_sub_reminder_title,
          style: GoogleFonts.fugazOne(),
        ),
      ),
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
                title: 'How to create note?',
                image: AppImages.onboard,
                fontWeight: TextFontWeight.bold,
                subtitle: 'Your description here if any',
              ),
              CustomPageView(
                title: 'How to delete note?',
                image: AppImages.onboard,
                fontWeight: TextFontWeight.bold,
                subtitle: 'Your description here if any',
              ),
              CustomPageView(
                title: 'How to lock & unlock note?',
                image: AppImages.onboard,
                fontWeight: TextFontWeight.bold,
                subtitle: 'Your description here if any',
              ),
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
                    onTap: () =>
                        _pageController.jumpToPage(3), // jump to the last page
                  ),

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
