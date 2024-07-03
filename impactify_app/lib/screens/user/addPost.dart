import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_text.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Share your ',
                style: GoogleFonts.nunito(fontSize: 24),
              ),
              TextSpan(
                text: 'Thoughts!',
                style: GoogleFonts.nunito(
                    fontSize: 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      File(_image!.path),
                    ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      getImage();
                    },
                    icon: Icon(Icons.image_outlined, color: AppColors.primary),
                    label: Text(
                      'Pick an Image',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                  Text(
                    ' or ',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      getImageFromCamera();
                    },
                    icon: Icon(Icons.camera_alt_outlined,
                        color: AppColors.primary),
                    label: Text(
                      'Take A Picture',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // Add some space before the separator
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: CustomIconText(
                      text: 'Event / Project Participated',
                      icon: Icons.event,
                      size: 14),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  value: selectedEvent,
                  onChanged: (String? value) {
                    setState(() {
                      selectedEvent = value;
                    });
                  },
                ),
              ),

              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Your Title Here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.placeholder),
                    maxLines: null,
                    expands: true,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 200,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Description here...',
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.placeholder),
                  maxLines: null, // Makes the TextField multiline
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(height: 10),
              CustomPrimaryButton(onPressed: () {}, text: "Share")
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

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
}
