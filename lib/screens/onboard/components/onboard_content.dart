import 'package:flutter/material.dart';

import 'onboard_screen_data.dart';
import 'page_indicator.dart';

// ignore: must_be_immutable
class OnboardContent extends StatefulWidget {
  // Number of onboard pages
  @required
  late final int numOfPages;

  @required
  List<Map<String, String>> onboardData = [];

  /// Bool for circle (dot) page indicator
  bool isPageIndicatorCircle = false;

  /// Class constructor
  OnboardContent({
    Key? key,
    // Number of pages
    numOfPages = 3,

    // Provide the content for each screen
    // image (only asset image accepted) | heading | body text
    onboardData = const [
      {
        "scr 1 image": "assets/images/onboard.png",
        "scr 1 heading": "Take Notes\n",
        "scr 1 body text": "Quickly capture what's on your mind"
      },
      {
        "scr 2 image": "assets/images/onboard_1.png",
        "scr 2 heading": "To-dos \n",
        "scr 2 body text": "List out your day-to-day tasks"
      },
      {
        "scr 3 image": "assets/images/onboard_2.png",
        "scr 3 heading": "Image to Text Converter \n",
        "scr 3 body text": "Upload your images and convert to text"
      },
    ],

    /// Page indicator have two types: Rounded rectangular (default) or circle (dot)
    /// Pass true for circle (dot)
    isPageIndicatorCircle = false,
  }) : super(key: key) {
    this.numOfPages = numOfPages;
    this.onboardData = onboardData;
    this.isPageIndicatorCircle = isPageIndicatorCircle;
  }

  @override
  _OnboardContentState createState() => _OnboardContentState();
}

class _OnboardContentState extends State<OnboardContent> {
  // PageController will control the view of screens
  final PageController _pageController = PageController(initialPage: 0);

  // The page viewport that is currently displaying
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // var onBoardPage = MediaQuery.of(context).orientation == Orientation.landscape;

    return SafeArea(
      child: SizedBox(
        // Center images in the column
        width: size.width,
        height: size.height * 0.6,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
          //padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: size.height * 0.5,
                // height: onBoardPage ? size.height * 0.8 : size.height * 0.5,
                child: PageView(
                  physics: const ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (int page) {
                    // Setting current page for page indicator
                    setState(() {
                      _currentPage = page;
                    });
                  },

                  /// Onboard screen data
                  children:
                      onboardScreenData(widget.numOfPages, widget.onboardData),
                ),
              ),

              /// The space between the text and dot indicator
              SizedBox(height: size.width * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                /// Dot indicator
                children: buildPageIndicator(widget.numOfPages, _currentPage,
                    widget.isPageIndicatorCircle),
              ),

              /// The space between the dot indicator and the buttons
              SizedBox(height: size.width * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}
