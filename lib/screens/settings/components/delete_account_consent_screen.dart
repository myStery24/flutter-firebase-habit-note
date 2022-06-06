import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/configs/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../configs/colors.dart';
import '../../../main.dart';

class DeleteAccountConsentScreen extends StatefulWidget {
  static String tag = '/DeleteAccountConsentScreen';

  const DeleteAccountConsentScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountConsentScreen> createState() => _DeleteAccountConsentScreenState();
}

class _DeleteAccountConsentScreenState extends State<DeleteAccountConsentScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appStore.isDarkMode
          ? AppColors.kScaffoldColorDark
          : AppColors.kScaffoldColor,
      appBar: AppBar(
        title: Text('Delete My Account'),
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
                      Icons.person_remove,
                      size: size.height * 0.075,
                      color: AppColors.kHabitOrange,
                    ),
                    SizedBox(width: size.width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request to delete my account',
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
                            'HaBIT Note Admin',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                              fontSize: size.height * 0.017,
                              fontWeight: FontWeight.bold,
                              color: getBoolAsync(IS_DARK_MODE)
                                  ? AppColors.kTextWhite.withOpacity(0.85)
                                  : AppColors.kTextBlack.withOpacity(0.85),
                            ),
                          ),
                          Text(
                            'Last Updated: June 3, 2022',
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
                    future: rootBundle.loadString(AppMarkdown.deleteAccount),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return Markdown(
                          selectable: false,
                          data: snapshot.requireData,
                          onTapLink: (text, href, title) {
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
              SizedBox(height: size.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}
