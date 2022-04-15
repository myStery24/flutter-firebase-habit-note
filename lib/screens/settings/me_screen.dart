import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/screens/settings/components/settings_category_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../../utils/colours.dart';
import '../../utils/constants.dart';

class MeScreen extends StatefulWidget {
  static String tag = '/MeScreen';

  const MeScreen({Key? key}) : super(key: key);

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        backgroundColor: appStore.isDarkMode
            ? AppColors.kHabitDarkGrey
            : AppColors.kScaffoldColor,
        appBar: AppBar(
          title: Text(AppStrings.meScreen,
            style: GoogleFonts.fugazOne(),
          ),
          actions: [
            IconButton(
              tooltip: 'Log out',
                onPressed: (() async {
                  bool? res = await showConfirmDialog(context, log_out_text,
                      positiveText: log_out,
                      buttonColor: AppColors.kHabitOrange);

                  // ?? is the 'if null operator'
                  if (res ?? false) {
                    service.signOutFromEmailPassword(context);
                  }
                }),
                icon: Icon(Icons.logout)),
          ],
        ),
        body: SettingsCategory(),
      ),
    );
  }
}
