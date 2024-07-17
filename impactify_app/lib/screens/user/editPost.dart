import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/models/post.dart';
import 'package:impactify_app/providers/event_provider.dart';
import 'package:impactify_app/providers/post_provider.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_app/widgets/custom_buttons.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:impactify_app/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  EditPost();

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  String? selectedActivity;
  XFile? _image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _titleController = TextEditingController(text: args['currentTitle']);
      _descriptionController =
          TextEditingController(text: args['currentDescription']);

      Provider.of<EventProvider>(context, listen: false)
          .fetchPastParticipatedActivities();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Create a map of titles and IDs
    Map<String, String> activityMap = {
      for (var activity in eventProvider.pastActivities)
        activity.title: activity.id
    };

    // Create the list of dropdown items
    List<DropdownMenuItem<String>> dropdownItems =
        activityMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.value,
        child: Text(
          entry.key,
          style: GoogleFonts.merriweather(fontSize: 14),
        ),
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Share your ',
                style: GoogleFonts.merriweather(fontSize: 24),
              ),
              TextSpan(
                text: 'Thoughts!',
                style: GoogleFonts.merriweather(
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image == null
                    ? Image.network(
                        args['postImage'],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      )
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
                      icon:
                          Icon(Icons.image_outlined, color: AppColors.primary),
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
                eventProvider.isLoading
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.event,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Project / Speech Participated',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.placeholder,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SpinKitCircle(size: 20, color: AppColors.primary)
                          ],
                        ))
                    : DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: CustomIconText(
                              text: 'Project / Speech Participated',
                              icon: Icons.event,
                              size: 14,
                              color: AppColors.primary),
                          items: dropdownItems,
                          value: args['activityID'],
                          //selectedActivity != null ? args['activityID'] : selectedActivity,
                          onChanged: (String? value) {
                            setState(() {
                              selectedActivity = value;
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
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Your Title Here...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.placeholder),
                      maxLines: null,
                      expands: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                Container(
                  height: 200,
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.placeholder),
                    maxLines: null, // Makes the TextField multiline
                    expands: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                CustomPrimaryButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updatePost();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please fill out all fields and select an image'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    text: "Edit Post")
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

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  void _updatePost() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String _selectedActivity;
    if (selectedActivity == null) {
      _selectedActivity = args['activityID'];
    } else {
      _selectedActivity = selectedActivity!;
    }
    await postProvider.updatePost(
        args['postID'],
        _image,
        _titleController.text.trim(),
        _descriptionController.text,
        _selectedActivity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}
