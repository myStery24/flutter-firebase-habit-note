import 'package:flutter/material.dart';
import 'package:habit_note/utils/colours.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constants.dart';

class LicensesScreen extends StatefulWidget {
  static String tag = '/LicensesScreen';

  const LicensesScreen({Key? key}) : super(key: key);

  @override
  State<LicensesScreen> createState() => _LicensesScreenState();
}

class _LicensesScreenState extends State<LicensesScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(AppColors.kAppBarColorDark),
        ),
      ),
      child: LicensePage(
        applicationName: AppStrings.appName,
        applicationIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AppImages.logoLight,
              width: size.width * 0.15, height: size.height * 0.15),
        ),
        applicationVersion: AppStrings.appVersionText,
        applicationLegalese: AppStrings.appCopyright,
      ),
    );
  }
}
