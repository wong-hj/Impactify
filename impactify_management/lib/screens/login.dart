import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/providers/auth_provider.dart';
import 'package:impactify_management/widgets/custom_buttons.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: authProvider.isLoading
            ? CustomLoading(text: 'Logging In...')
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/logo.png',
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text("Welcome Back.",
                            style: GoogleFonts.nunitoSans(fontSize: 30)),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          controller: _emailController,
                          placeholderText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          errorText: 'Please Insert Email.',
                          onChanged: (value) {
                            // Handle text field changes
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          controller: _passwordController,
                          placeholderText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          errorText:
                              'Please Insert Valid Password. (Atleast 6 Characters)',
                          onChanged: (value) {
                            // Handle text field changes
                          },
                        ),
                        const SizedBox(height: 40),
                        CustomPrimaryButton(
                          onPressed: () async {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            if (_formKey.currentState!.validate()) {
                              await authProvider.signInWithEmail(
                                  email, password);
                              if (authProvider.firebaseUser != null) {
                                Navigator.pushReplacementNamed(
                                    context, '/homeScreen');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      'Error Logging In, Please Try Again.',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill out all fields.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          text: "Login",
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text:
                                'Interested in Listing your projects and speeches? ',
                            style: TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Sign Up Now!',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, '/signup');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
