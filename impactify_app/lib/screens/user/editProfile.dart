import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/providers/auth_provider.dart';
import 'package:impactify_app/providers/user_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    // Fetch user data and set it to the text controllers
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkCurrentUser(); // Ensure the user data is fetched

    final user = authProvider.userData;
    if (user != null) {
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _introductionController.text = user.introduction;
      
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
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
                              _image == null ? NetworkImage(authProvider.userData!.profileImage) as ImageProvider
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
              CustomPrimaryButton(onPressed: () {
                _updateProfile();
              }, text: "Update")
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

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = {
      'fullName': _fullNameController.text.trim(),
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'introduction': _introductionController.text.trim(),
    };
    await userProvider.updateUserData(data, _image);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}


