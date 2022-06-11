import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_note/widgets/custom_buttons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import 'custom_page_view_model.dart';

class HelpSubscriptionReminderScreen extends StatefulWidget {
  const HelpSubscriptionReminderScreen({Key? key}) : super(key: key);

  @override
  State<HelpSubscriptionReminderScreen> createState() =>
      _HelpSubscriptionReminderScreenState();
}

class _HelpSubscriptionReminderScreenState
    extends State<HelpSubscriptionReminderScreen> {
  PageController _pageController =
      PageController(); // Keep track of which page you're on
  final int pages = 5;
  final int lastPage = 5;
  bool onLastPage = false; // Keep track of the last page

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    /// When loading the onboard screen, set the orientation portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    /// When leaving the onboard screen,set back to normal (applies to all screens after login)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  onLastPage = (index == pages - 1);
                });
              },
              children: [
                CustomPageView(
                    title: 'Get Started with\nSubscription Reminder',
                    image: AppHelp.helpRmd,
                    fontWeight: TextFontWeight.bold,
                    subtitle: ''),
                CustomPageView(
                    title: 'Set a Recurring Subscription',
                    image: AppHelp.helpRmd1,
                    fontWeight: TextFontWeight.bold,
                    subtitle: ''),
                CustomPageView(
                    title: 'Set a One-time Subscription',
                    image: AppHelp.helpRmd2,
                    fontWeight: TextFontWeight.bold,
                    subtitle: ''),
                CustomPageView(
                    title:
                        'Set a Reminder for Any Subscription (Recurring/One-time)',
                    image: AppHelp.helpRmd3,
                    fontWeight: TextFontWeight.bold,
                    subtitle: ''),
                CustomPageView(
                    title: 'Local Push Notification',
                    image: AppHelp.helpRmd4,
                    fontWeight: TextFontWeight.bold,
                    subtitle: ''),
              ]),
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
                ]),
          ),
        ],
      ),
    );
  }
}
