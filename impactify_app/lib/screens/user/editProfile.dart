import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
   final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _introductionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 120,
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              _image == null ? NetworkImage('https://shorturl.at/CV4Xb') as ImageProvider
                              : FileImage(
                                
                                File(_image!.path),
                                
                              ),
                              
                        ),
                      ),
                      Positioned(
                        bottom: -3,
                        right: -12,
                        child: Container(
                            child: ElevatedButton(
                          onPressed: () {
                            getImage();
                          },
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: AppColors.secondary,
                            foregroundColor: AppColors.primary,
                          ),
                        )),
                      ),
                      //),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: _fullNameController,
                placeholderText: 'Full Name',
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  // Handle text field changes
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: _usernameController,
                placeholderText: 'Username',
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  // Handle text field changes
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: _emailController,
                placeholderText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // Handle text field changes
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                controller: _introductionController,
                placeholderText: 'Brief Introduction',
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  // Handle text field changes
                },
              ),
              SizedBox(height: 50),
              CustomPrimaryButton(onPressed: () {}, text: "Update")
            ],
          ),
        ),
      ),
    );
  }
  Future getImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _image = image;
    });
  }
}


