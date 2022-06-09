import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import 'custom_page_view_model.dart';

class HelpNotesScreen extends StatefulWidget {
  const HelpNotesScreen({Key? key}) : super(key: key);

  @override
  State<HelpNotesScreen> createState() => _HelpNotesScreenState();
}

class _HelpNotesScreenState extends State<HelpNotesScreen> {
  PageController _pageController =
      PageController(); // Keep track of which page you're on
  final int pages = 7;
  final int lastPage = 7;
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
                // Check if on last page, if index is 6, then true
                // index starts with 0 for first page
                onLastPage = (index == pages - 1);
              });
            },
            children: [
              CustomPageView(
                  title: 'Get Started with HaBIT Note',
                  image: AppHelp.helpNotes,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: "Notes",
                  image: AppHelp.helpNotes1,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: 'Note: Create and/or Edit',
                  image: AppHelp.helpNotes2,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: 'To-do: Create and/or Edit',
                  image: AppHelp.helpNotes3,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: 'Note & To-do Editor: Options',
                  image: AppHelp.helpNotes4,
                  fontWeight: TextFontWeight.bold,
                  subtitle: '1. Delete \t\t 2. Colour picker'),
              CustomPageView(
                  title: 'Lock & Delete',
                  image: AppHelp.helpNotes5,
                  fontWeight: TextFontWeight.bold,
                  subtitle: ''),
              CustomPageView(
                  title: 'Create & Manage Labels',
                  image: AppHelp.helpNotes6,
                  fontWeight: TextFontWeight.bold,
                  subtitle: 'Upcoming Feature'),
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
                      child: Text('SKIP'),
                      onTap: () =>
                          // jump to the last page
                          _pageController.jumpToPage(lastPage)),

                  /// Dot indicator
                  SmoothPageIndicator(
                      controller: _pageController, // PageController
                      count: pages,
                      effect: ScrollingDotsEffect(
                          fixedCenter: true,
                          spacing: 16,
                          dotColor: AppColors.kHintTextLightGrey,
                          activeDotColor:
                              AppColors.kHabitOrange), // your preferred effect
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
