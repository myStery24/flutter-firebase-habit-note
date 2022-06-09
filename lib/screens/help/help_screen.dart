import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/repository/help_category_json.dart';
import 'package:habit_note/screens/help/components/help_notes_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import 'components/help_account_settings_screen.dart';
import 'components/clipper.dart';
import 'components/custom_card.dart';
import '../../widgets/custom_heading.dart';
import 'components/help_ocr_screen.dart';
import 'components/help_subscription_reminder_screen.dart';

class HelpScreen extends StatefulWidget {
  static String tag = '/HelpScreen';

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
    // setStatusBarColor(
    //   AppColors.kHabitOrange,
    //   statusBarIconBrightness:
    //       appStore.isDarkMode ? Brightness.dark : Brightness.light,
    //   delayInMilliSeconds: 100,
    // );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    // setStatusBarColor(
    //   appStore.isDarkMode
    //       ? AppColors.kPrimaryVariantColorDark
    //       : AppColors.kAppBarColor,
    //   statusBarIconBrightness:
    //       appStore.isDarkMode ? Brightness.dark : Brightness.light,
    //   delayInMilliSeconds: 100,
    // );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
      appBar: AppBar(
        // elevation: 0.0,
        // backgroundColor: Colors.transparent,
        title: Text(
          AppStrings.helpScreen,
          style: GoogleFonts.fugazOne(),
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
                    height: 250.0,
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
                      SizedBox(height: spacer),

                      /// Heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomHeading(
                            title: 'Hi, $name!',
                            subTitle: 'How can we help you?',
                            color: AppColors.kTextWhite,
                          ),
                          // Container(
                          //   height: spacer,
                          //   width: spacer,
                          //   child: ClipRRect(
                          //     borderRadius:
                          //         BorderRadius.circular(imageRadius + 60),
                          //     child: Image.asset(
                          //       AppImages.userIcon3,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      // SizedBox(height: spacer),

                      /// Search
                      // CustomSearchField(
                      //   hintField: 'Search our Help articles...',
                      //   backgroundColor: AppColors.kTextWhite,
                      // ),
                      SizedBox(height: spacer),

                      /// Help banner
                      CustomBannerCard(),
                      SizedBox(height: spacer),

                      /// Help articles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Help articles',
                            style: GoogleFonts.lato(
                                fontSize: 25,
                                color: appStore.isDarkMode
                                    ? AppColors.kTextWhite
                                    : AppColors.kTextBlack,
                                fontWeight: TextFontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: smallSpacer),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(6.0),
                        child: Row(children: <Widget>[
                          /// Notes
                          Padding(
                            padding: const EdgeInsets.only(
                                right:
                                    30.0), // the space between one container to another
                            child: GestureDetector(
                              onTap: () {
                                HelpNotesScreen().launch(context);
                              },
                              child: CustomHelpCategoryCard(
                                title: AppStrings.help_note_title,
                                icon: AppLottie.notesLottie,
                              ),
                            ),
                          ),

                          /// OCR
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                HelpOCRScreen().launch(context);
                              },
                              child: CustomHelpCategoryCard(
                                title: AppStrings.help_ocr_title,
                                icon: AppLottie.ocrLottie,
                              ),
                            ),
                          ),

                          /// Subscription reminder
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                HelpSubscriptionReminderScreen()
                                    .launch(context);
                              },
                              child: CustomHelpCategoryCard(
                                title: AppStrings.help_sub_reminder_title,
                                icon: AppLottie.reminderLottie,
                              ),
                            ),
                          ),

                          /// My account settings
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: GestureDetector(
                              onTap: () {
                                HelpAccountSettingsScreen().launch(context);
                              },
                              child: CustomHelpCategoryCard(
                                title: AppStrings.help_account_title,
                                icon: AppLottie.settingsLottie,
                              ),
                            ),
                          ),
                        ]),
                      ),

                      /// Do not know how to pass to a new screen with corresponding data
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   padding: const EdgeInsets.all(6.0),
                      //   child: Wrap(
                      //     children:
                      //         List.generate(HelpCategoryJson.length, (index) {
                      //       // HelpCategoryJson.length = pass a context; index = counter
                      //       var data = HelpCategoryJson[index];
                      //
                      //       return Padding(
                      //         padding: const EdgeInsets.only(right: 30.0), // the space between one container to another
                      //         child: GestureDetector(
                      //           onTap: () { // Show the data in HelpArticlesJson.dart },
                      //           child: CustomHelpCategoryCard(
                      //             title: data['title'],
                      //             icon: data['icon'],
                      //           ),
                      //         ),
                      //       );
                      //     }),
                      //   ),
                      // ),
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
