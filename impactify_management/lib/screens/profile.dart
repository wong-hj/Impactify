import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/constants/placeholderURL.dart';
import 'package:impactify_management/providers/user_provider.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_buttons.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _organizationNameController =
      TextEditingController();

  final TextEditingController _ssmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _ssmURL;
  PlatformFile? ssmPdfFile;
  bool hasFile = false;

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
  void initState() {
    super.initState();
    // Fetch user data and set it to the text controllers
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final user = userProvider.user;
    if (user != null) {
      _fullNameController.text = user.fullName;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _organizationNameController.text = user.organizationName;

      if (user.ssm != null) {
        _ssmController.text = user.ssm!;
        setState(() {
          _ssmURL = user.ssmURL;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Form(
            key: _formKey,
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
                            backgroundImage: _image == null
                                ? NetworkImage(
                                    userProvider.user?.profileImage ??
                                        userPlaceholder)
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
                  errorText: 'Please Insert Full Name.',
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _usernameController,
                  placeholderText: 'Username',
                  keyboardType: TextInputType.name,
                  errorText: 'Please Insert Username.',
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _emailController,
                  placeholderText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  errorText: 'Please Insert Email.',
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  controller: _organizationNameController,
                  placeholderText: 'Organization Name / Party Name',
                  errorText: 'Please Insert Valid Organization / Party Name.',
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    // Handle text field changes
                  },
                ),
                SizedBox(height: 20),
                if (userProvider.user?.ssm == null) ...[
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
                ] else ...[
                  CustomTextFormField(
                    controller: _ssmController,
                    placeholderText: 'SSM Registration Number',
                    enabled: false,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/pdfViewer',
                            arguments: userProvider.user?.ssmURL);
                      },
                      child: Text('View SSM PDF >')),
                ],
                SizedBox(height: 50),
                CustomPrimaryButton(
                    onPressed: () {
                      _updateProfile();
                    },
                    text: "Update")
              ],
            ),
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
      'organization': _organizationNameController.text.trim(),
    };
    if (_formKey.currentState!.validate()) {
      final ssmURLExists = userProvider.user?.ssmURL != null;
      print("SSMURLEXIST:" + ssmURLExists.toString());
      if ((_ssmController.text.isNotEmpty && (ssmPdfFile != null || ssmURLExists)) ||
          (_ssmController.text.isEmpty && ssmPdfFile == null)) {


             // Add SSM data to the data map if it's valid
      if (_ssmController.text.isNotEmpty) {
        data['ssm'] = _ssmController.text.trim();
      }

        await userProvider.updateUserData(data, _image, ssmPdfFile?.xFile);
        setState(() {
          _image = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Profile updated successfully, Please check your mail inbox to verify updated email.'),
            backgroundColor: Colors.green,
          ),
        );
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
