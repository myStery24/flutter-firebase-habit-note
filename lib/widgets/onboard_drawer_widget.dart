import 'package:flutter/material.dart';
import 'package:habit_note/screens/password/forgot_password_screen.dart';
import 'package:habit_note/screens/policies/privacy_policy_screen.dart';
import 'package:habit_note/widgets/custom_richtext_widget.dart';

import '../configs/colors.dart';
import '../configs/constants.dart';
import '../screens/policies/terms_of_use_screen.dart';

class OnboardDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20.0);

  const OnboardDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.kHabitLinearGradient,
          ),
        ),
        child: ListView(
          children: <Widget>[
            // Custom header
            _buildHeader(context),
            const SizedBox(height: 24.0),
            // Custom drawer
            _buildMenuItem(
              text: 'Forgot Password',
              icon: Icons.lock,
              onClicked: () => _selectedItem(context, 0),
            ),
            const SizedBox(height: 24.0),
            const Divider(color: AppColors.kPrimaryVariantColorDark),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: AppColors.kPrimaryVariantColorDark,
                  radius: 3,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    textStyle: const TextStyle(fontSize: 16.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsOfUseScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Terms of Use',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Create a header to display app name and version
  Widget _buildHeader(BuildContext context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
          child: CustomRichTextWidget(
            primaryText: 'Habit Note ',
            secondaryText: AppStrings.appVersionText,
          ),
          // RichText(
          //   text: TextSpan(
          //     children: <TextSpan>[
          //       TextSpan(
          //         text: "HaBIT Note ",
          //         style: GoogleFonts.fugazOne(
          //           color: Colors.black,
          //           fontSize: 28.0,
          //           fontWeight: TextFontWeight.regular,
          //         ),
          //       ),
          //       TextSpan(
          //         text: AppStrings.appVersionText,
          //         style: GoogleFonts.lato(
          //           color: Colors.black,
          //           fontSize: 12.0,
          //           fontWeight: TextFontWeight.regular,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      );

  // Create an item of the navigation drawer
  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    const hoverColor = Colors.black45;
    const fontSize = 16.0;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(color: color, fontSize: fontSize),
      ),
      hoverColor: hoverColor,
      // Navigate to another screen
      onTap: onClicked,
    );
  }

  void _selectedItem(BuildContext context, int index) {
    // Close the navigation drawer
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ForgotPasswordScreen(),
          ),
        );
        break;
    }
  }
}
