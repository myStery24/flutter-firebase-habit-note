import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/colors.dart';
import '../../configs/constants.dart';
import '../../main.dart';

class TermsOfUseScreen extends StatefulWidget {
  static String tag = '/TermsOfUseScreen';

  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
      appBar: AppBar(
        title: Text('Terms of Use'),
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(height: size.width * 0.008),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.035),
                child: Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: size.height * 0.075,
                      color: AppColors.kHabitOrange,
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HaBIT Note',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold,
                              color: getBoolAsync(IS_DARK_MODE)
                                  ? AppColors.kTextWhite.withOpacity(0.85)
                                  : AppColors.kTextBlack.withOpacity(0.85),
                            ),
                          ),
                          Text(
                            'Last Updated: Apr 10, 2022',
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
              Expanded(
                child: FutureBuilder(
                  future: rootBundle.loadString('assets/terms_of_use.md'),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                    if (snapshot.hasData) {
                      return Markdown(
                        selectable: false,
                        data: snapshot.requireData,
                        onTapLink: (text, href, title) {
                          href != null ? launch(href) : null;
                        },
                      );
                    }
                    return Center(
                      /// Markdown text displays here
                      child: Container(),
                    );
                  }),
              ),
              SizedBox(height: size.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}
