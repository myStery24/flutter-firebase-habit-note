import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';
import 'licenses_screen.dart';

class AboutAppScreen extends StatefulWidget {
  static String tag = '/AboutAppScreen';

  const AboutAppScreen({Key? key}) : super(key: key);

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.kHabitOrange,
              expandedHeight: size.height * 0.20,
              floating: true, // appbar appears immediately
              pinned: true, // appbar pinned to top
              snap: false, // appbar displayed 0% or 100%
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'HaBIT Note',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: size.height * 0.020,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kTextBlack.withOpacity(0.85),
                  ),
                ),
                background: Image.asset(
                  AppImages.launcherIcon2,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                SizedBox(height: size.width * 0.03),
                Expanded(
                  child: FutureBuilder(
                      future: rootBundle.loadString(AppMarkdown.aboutApp),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Markdown(
                            selectable: false,
                            data: snapshot.requireData,
                            // open link in browser
                            onTapLink: (text, href, title) {
                              // href != null ? launch(href) : null;
                              href != null ? launchUrlString(href) : null;
                            },
                          );
                        }
                        return Center(
                          /// Markdown text displays here
                          child: Container(),
                        );
                      }),
                ),
                SizedBox(height: size.width * 0.008),
                Container(
                  width: size.width,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.035),
                  child: Row(
                    children: [
                      /// App copyright text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.appCopyright,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                fontSize: size.height * 0.017,
                                fontWeight: FontWeight.bold,
                                color: getBoolAsync(IS_DARK_MODE)
                                ? AppColors.kTextWhite.withOpacity(0.65)
                                : AppColors.kTextBlack.withOpacity(0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.width * 0.015),
              ],
            ),
          ),
        ),
      ),

      /// Normal appbar
      appBar: AppBar(
        title: Text('About Us'),
        actions: [
          /// Software licenses
          TextButton(
            onPressed: () {
              LicensesScreen().launch(context);
            },
            child: Text('LICENSES',
              style: TextStyle(
                color: getBoolAsync(IS_DARK_MODE)
                    ? AppColors.kHabitOrange
                    : AppColors.kTextBlack,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.copyright_outlined),
            tooltip: 'View licenses',
            onPressed: () {
              LicensesScreen().launch(context);
            },
          ),
        ],
      ),
    );
  }
}
