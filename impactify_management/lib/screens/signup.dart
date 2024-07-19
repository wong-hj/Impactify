import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/providers/auth_provider.dart';
import 'package:impactify_management/widgets/custom_buttons.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _fullnameController = TextEditingController();

  final TextEditingController _organizationController = TextEditingController();

  final TextEditingController _ssmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isAgreeTerm = false;
  bool hasFile = false;
  PlatformFile? ssmPdfFile;

  Future<void> _pickSSMPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;
      setState(() {
        ssmPdfFile = file;
        hasFile = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Register Now!\nBring your project.",
                      style: GoogleFonts.merriweather(fontSize: 30)),
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
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _fullnameController,
                    placeholderText: 'Fullname',
                    errorText: 'Please Insert Fullname',
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _usernameController,
                    placeholderText: 'Username',
                    errorText: 'Please Insert Username.',
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _organizationController,
                    placeholderText: 'Organization Name / Party Name',
                    errorText: 'Please Insert Valid Organization / Party Name.',
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _ssmController,
                    placeholderText: 'SSM Registration Number (If Applicable)',
                    onChanged: (value) {
                      // Handle text field changes
                      if (value.isEmpty) {
                        setState(() {
                          ssmPdfFile = null;
                        });
                      }
                      setState(() {
                        _ssmController.text = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _ssmController.text != "" ? _pickSSMPdfFile : null,
                    child: Container(
                      //color: Colors.white,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: _ssmController.text != ""
                              ? Colors.transparent
                              : Colors.grey[300],
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Icon(Icons.description_outlined,
                              color: _ssmController.text != ""
                                  ? Colors.black
                                  : Colors.grey),
                          Expanded(
                            child: Text(
                              ssmPdfFile != null
                                  ? 'SSM PDF Selected - ${ssmPdfFile!.name}'
                                  : 'Submit SSM (PDF)',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: _ssmController.text != ""
                                      ? Colors.black
                                      : Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: AppColors.primary,
                        value: isAgreeTerm,
                        onChanged: (bool? value) {
                          setState(
                            () {
                              isAgreeTerm = value!;
                            },
                          );
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text:
                                'I hereby state that I have read and understood the ',
                            style: TextStyle(color: Colors.black, fontSize: 10),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'terms and conditions.',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/terms');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomPrimaryButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final fullname = _fullnameController.text.trim();
                      final username = _usernameController.text.trim();
                      final organization = _organizationController.text.trim();
                      final ssmNumber = _ssmController.text.isNotEmpty ? _ssmController.text.trim() : null;
                      if (_formKey.currentState!.validate() && isAgreeTerm) {
                        if ((_ssmController.text.isNotEmpty &&
                                ssmPdfFile != null) ||
                            (_ssmController.text.isEmpty &&
                                ssmPdfFile == null)) {
                          // Proceed with registration logic
                          await authProvider.signUpWithEmail(email, password, fullname, username, organization, ssmNumber, ssmPdfFile?.xFile);
                          if(authProvider.firebaseUser != null) {
                            Navigator.pushReplacementNamed(
                            context, '/homeScreen');
                          
                          }
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please ensure SSM registration number and PDF file match.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                        //_addPost();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please fill out all fields and read terms and conditions.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      // await authProvider.signInWithEmail(email, password);
                      // if (authProvider.user != null) {
                      //   Navigator.pushReplacementNamed(
                      //       context, '/homeScreen');
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(
                      //       backgroundColor: Colors.red,
                      //       content: Text(
                      //         'Error Logging In, Please Try Again.',
                      //         style: GoogleFonts.poppins(color: Colors.white),
                      //       ),
                      //       showCloseIcon: true,
                      //     ),
                      //   );
                      // }
                    },
                    text: "Register",
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Back to ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(context, '/login');
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
        // if (authProvider.isLoading)
        //   Container(
        //     color: AppColors.background,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SpinKitWanderingCubes(
        //           color: AppColors.primary,
        //           size: 70.0,
        //         ),
        //         SizedBox(height: 10),
        //         Text("Logging you in...",
        //             style: GoogleFonts.merriweather(
        //                 color: AppColors.primary, fontSize: 20))
        //       ],
        //     ),
        //   )
      ),
    );
  }
}
