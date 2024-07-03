import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class SignUp extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Greetings, Register Now to be Part of Us!",
                    style: AppTextStyles.authHead),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: _usernameController,
                  placeholderText: 'Username',
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _controller,
                  placeholderText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passController,
                  placeholderText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 40),
                CustomPrimaryButton(onPressed: () {}, text: "Register"),
                const SizedBox(height: 50),
                const Text("or", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                        onPressed: () {}, imagePath: "assets/google.png"),
                    const SizedBox(width: 20),
                    CustomIconButton(
                        onPressed: () {}, imagePath: "assets/facebook.png"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
