import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import 'widgets/clipper.dart';
import 'widgets/custom_heading.dart';
import 'widgets/custom_search_field.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late String name;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    name = getStringAsync(USER_DISPLAY_NAME);
    setStatusBarColor(
      AppColors.kHabitOrange,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.dark : Brightness.light,
      delayInMilliSeconds: 100,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    setStatusBarColor(
      appStore.isDarkMode
          ? AppColors.kPrimaryVariantColorDark
          : AppColors.kAppBarColor,
      statusBarIconBrightness:
          appStore.isDarkMode ? Brightness.dark : Brightness.light,
      delayInMilliSeconds: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          // title: Text(
          //   AppStrings.helpScreen,
          //   style: GoogleFonts.fugazOne(),
          // ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: spacer),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                ClipPath(
                  clipper: BottomClipper(),
                  child: Container(
                    width: size.width,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: AppColors.kHabitOrange,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: appPadding, right: appPadding),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: spacer + 24),

                      //heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomHeading(
                            title: 'Hi, $name !',
                            subTitle: 'How can we help you ?',
                            color: AppColors.kTextWhite,
                          ),
                          Container(
                            height: spacer,
                            width: spacer,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(imageRadius + 60),
                              child: Image.asset(
                                AppImages.userIcon3,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: spacer),

                      /// Search
                      CustomSearchField(
                        hintField: 'How to lock a note ?',
                        backgroundColor: AppColors.kTextWhite,
                      ),
                      SizedBox(height: spacer - 30.0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
