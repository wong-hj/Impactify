import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impactify_management/constants/impoints.dart';
import 'package:impactify_management/constants/sdg.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/tag.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_buttons.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:filter_list/filter_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_tag_pill.dart';

class AddSpeech extends StatefulWidget {
  const AddSpeech({super.key});

  @override
  State<AddSpeech> createState() => _AddSpeechState();
}

class _AddSpeechState extends State<AddSpeech> {
  @override
  void initState() {
    super.initState();
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      activityProvider.fetchAllTags();
      activityProvider.fetchAllProjectsByOrganizer();
    });
  }
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  String? selectedProject;
  DateTime? selectedDateTime;
  List<Tag>? selectedTags;

  void _removeTag(Tag tag) {
    setState(() {
      selectedTags!.remove(tag);
    });
  }

  void openFilterDelegate() async {
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    await FilterListDelegate.show<Tag>(
      context: context,
      list: activityProvider.tags,
      selectedListData: selectedTags,
      theme: FilterListDelegateThemeData(
        listTileTheme: ListTileThemeData(
          dense: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          tileColor: Colors.white,
          selectedTileColor: AppColors.tertiary,
          titleTextStyle: GoogleFonts.poppins(),
        ),
      ),
      onItemSearch: (tag, query) {
        return tag.name.toLowerCase().contains(query.toLowerCase());
      },
      tileLabel: (tag) => tag!.name,
      emptySearchChild: Center(child: Text('No tags found')),
      searchFieldHint: 'Search Here..',
      onApplyButtonClick: (list) {
        setState(() {
          selectedTags = list;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider =
        Provider.of<ActivityProvider>(context);

    List<DropdownMenuItem<String>> projectDropdownItems =
        activityProvider.projects.map((project) {
      return DropdownMenuItem<String>(
        value: project.eventID,
        child: Text(
          project.title,
          style: GoogleFonts.merriweather(fontSize: 14),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: Text('Host your Speech', style: GoogleFonts.merriweather())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _image == null
                    ? SizedBox.shrink()
                    : Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20) // Adjust the radius as needed
                            ),
                        child: Image.file(
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          File(_image!.path),
                        ),
                      ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
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
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFormField(
                        controller: _titleController,
                        placeholderText: 'Title',
                        errorText: 'Please Insert Title.',
                        onChanged: (value) {
                          // Handle text field changes
                        },
                      ),
                      CustomTextFormField(
                        controller: _venueController,
                        placeholderText: 'Venue',
                        errorText: 'Please Insert Venue.',
                        onChanged: (value) {
                          // Handle text field changes
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2030, 12, 31), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      print('confirm $date');
                      setState(() {
                        selectedDateTime = date;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedDateTime != null
                              ? 'Host Date - ${DateFormat('dd MMMM yyyy, HH:mm').format(selectedDateTime!).toUpperCase()}'
                              : 'Host Date',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 200,
                    child: CustomMultiLineTextForm(
                        controller: _aboutController,
                        placeholderText: 'Speech Description',
                        errorText: 'Please insert speech description.')),
                SizedBox(height: 10),
              
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      barrierColor: Colors.black.withAlpha(100),
                      isExpanded: true,
                      hint: Text(
                        'For Project:',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      items: projectDropdownItems,
                      value: selectedProject,
                      onChanged: (String? value) async {
                        setState(() {
                          selectedProject = value!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: openFilterDelegate,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Click to add tags (Optional)', style: GoogleFonts.poppins()),
                        Icon(Icons.tag)
                      ],
                    ),
            
                    // Handle tap
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                    onTap: _showAddTagDialog,
                    child: CustomIconText(
                        text: "Couldn't find the tag you want? Add Here!",
                        icon: Icons.info_outline,
                        size: 13,
                        color: Colors.blue)),
                SizedBox(height: 10),
                if (selectedTags != null)
                  TagPills(
                    tags: selectedTags,
                    onRemove: _removeTag,
                  ),
                SizedBox(height: 20),
                CustomPrimaryButton(text: 'List Speech', onPressed: () async {
                  if (
                    _formKey.currentState!.validate() 
                    &&
                      _image != null && selectedDateTime != null && selectedProject !=null) {
                    //print("::: REACH1");
                    _addSpeech();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Please fill out all fields and select an image'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                })
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

  Future<void> _addSpeech() async {
    print("::: REACH");
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);

    List<String>? tagIDs;
    
    if (selectedTags != null) {
      tagIDs = selectedTags!.map((tag) => tag.tagID).toList();
    }

    final data = {
      'title': _titleController.text.trim(),
      'location': _venueController.text.trim(),
      'description': _aboutController.text,
      'tags': tagIDs ?? null,
      'eventID': selectedProject,
      'hostDate': Timestamp.fromDate(selectedDateTime ?? DateTime.now()),
      'createdAt': Timestamp.now(),
      'recording': "",
      'status' : 'active',
      'type': 'speech'
    };
    print("::: ${data}");
    try {
      await activityProvider.addSpeech(_image, data);
    } catch (e) {
      print("::: ERROR $e");
    }
    

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speech Listed!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }


  void _showAddTagDialog() {
    final TextEditingController _tagController = TextEditingController();
    final activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Tag', style: GoogleFonts.poppins(fontSize: 18)),
          content: CustomTextField(
              controller: _tagController, placeholderText: 'Tag'),
          actions: [
            TextButton(
              child:
                  Text('Cancel', style: GoogleFonts.poppins(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  Text('Add', style: GoogleFonts.poppins(color: Colors.green)),
              onPressed: () async {
                if (_tagController.text.isNotEmpty) {
                  await activityProvider.addTag(_tagController.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Please Enter a tag.',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      showCloseIcon: true,
                    ),
                  );
                }
                setState(() {
                  
                });
                Navigator.of(context).pop();
              },
            ),
          ],
          elevation: 24,
        );
      },
    );
  }
}