import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/screens/password/ForgotPasswordScreen.dart';
import 'package:habit_note/screens/PrivacyPolicy.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/constants.dart';

import '../screens/TermsOfUse.dart';

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
            const Divider(color: AppColors.kHabitDarkGrey),
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
                        builder: (context) => const PrivacyPolicy(),
                      ),
                    );
                  },
                  child: const Text('Privacy Policy'),
                ),
                const CircleAvatar(
                  backgroundColor: AppColors.kHabitDarkGrey,
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
                        builder: (context) => const Terms(),
                      ),
                    );
                  },
                  child: const Text('Terms of Use'),
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
          padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "HaBIT Note\n",
                  style: GoogleFonts.fugazOne(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: TextFontWeight.regular,
                  ),
                ),
                TextSpan(
                  text: "V0.0.1",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: TextFontWeight.regular,
                  ),
                ),
              ],
            ),
          ),
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

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: const TextStyle(color: color),
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
