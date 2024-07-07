import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/screens/user/home_screen.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({super.key});

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
                Text("Glad to see you again, stay impactful!",
                    style: AppTextStyles.authHead),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: _emailController,
                  placeholderText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  placeholderText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                const SizedBox(height: 40),
                CustomPrimaryButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      await context
                          .read<AuthProvider>()
                          .signInWithEmail(email, password);
                      if (context.read<AuthProvider>().user != null) {
                        Navigator.pushReplacementNamed(context, '/homeScreen');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Error Logging In, Please Try Again.', style: GoogleFonts.poppins(color: Colors.white)),
                            showCloseIcon: true,
                          ),
                        );
                      }
                    },
                    text: "Login"),
                const SizedBox(height: 50),
                const Text("or", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                        onPressed: () async {

                          await context
                          .read<AuthProvider>()
                          .signInWithGoogle();
                      if (context.read<AuthProvider>().user != null) {
                        Navigator.pushReplacementNamed(context, '/homeScreen');
                      }
                        }, imagePath: "assets/google.png"),
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
