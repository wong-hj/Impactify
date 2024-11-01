import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class SignUp extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();

  SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Text("Greetings, Register Now to be Part of Us!",
                      style: AppTextStyles.authHead),
                  const SizedBox(height: 70),
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
                    controller: _fullnameController,
                    placeholderText: 'Fullname',
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                  const SizedBox(height: 20),
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
                        final username = _usernameController.text.trim();
                        final fullname = _fullnameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();

                        if (username.isNotEmpty &&
                            fullname.isNotEmpty &&
                            email.isNotEmpty &&
                            password.isNotEmpty) {
                          await authNotifier.signUpWithEmail(email, password, fullname, username);
                          if (authState.firebaseUser != null) {
                            Navigator.pushReplacementNamed(
                                context, '/homeScreen');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Something Went Wrong Please Try Again.',
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                                showCloseIcon: true,
                              ),
                            );
                          }
                        } else {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.warning,
                            body: Center(
                              child: Text(
                                'Please fill in all relevant fields.',
                                style: TextStyle(),
                              ),
                            ),
                            btnOkOnPress: () {},
                            btnOkColor: AppColors.secondary,
                          )..show();
                        }
                      },
                      text: "Register"),
                  const SizedBox(height: 50),
                  const Text("or", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                          text: "Google Sign In",
                          onPressed: () async {
                            await authNotifier.signInWithGoogle();
                            if (authState.userData != null) {
                              Navigator.pushReplacementNamed(
                                  context, '/homeScreen');
                            }
                          },
                          imagePath: "assets/google.png"),
                    ],
                  ),
                ],
              ),
            ),
            if (authState.isLoading)
              Container(
                color: AppColors.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitWanderingCubes(
                      color: AppColors.primary,
                      size: 70.0,
                    ),
                    SizedBox(height: 10),
                    Text("Registering...",
                        style: GoogleFonts.nunito(
                            color: AppColors.primary, fontSize: 20))
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
