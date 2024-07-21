import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/constants/impoints.dart';
import 'package:impactify_management/constants/sdg.dart';
import 'package:impactify_management/models/project.dart';
import 'package:impactify_management/models/user.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_buttons.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:filter_list/filter_list.dart';

import '../widgets/custom_tag_pill.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  String? selectedImpoints;
  String? selectedSdg;
  DateTime? selectedDateTime;
  List<User1>? selectedUserList = [];

  List<User1> userList = [
    User1(name: "Jon", avatar: ""),
    User1(name: "Lindsey ", avatar: ""),
    User1(name: "Valarie ", avatar: ""),
    User1(name: "Elyse ", avatar: ""),
    User1(name: "Ethel ", avatar: ""),
    User1(name: "Emelyan ", avatar: ""),
    User1(name: "Catherine ", avatar: ""),
    User1(name: "Stepanida  ", avatar: ""),
    User1(name: "Carolina ", avatar: ""),
    User1(name: "Nail  ", avatar: ""),
    User1(name: "Kamil ", avatar: ""),
    User1(name: "Mariana ", avatar: ""),
    User1(name: "Katerina ", avatar: ""),
  ];

  void _removeTag(User1 tag) {
    setState(() {
      selectedUserList!.remove(tag);
    });
  }

  void openFilterDelegate() async {
    await FilterListDelegate.show<User1>(
      context: context,
      list: userList,
      selectedListData: selectedUserList,
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
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      tileLabel: (user) => user!.name,
      emptySearchChild: Center(child: Text('No user found')),
      searchFieldHint: 'Search Here..',
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = list;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> impointsDropdownItems =
        impoints.map((impoint) {
      return DropdownMenuItem<String>(
        value: impoint,
        child: Text(
          impoint,
          style: GoogleFonts.merriweather(fontSize: 14),
        ),
      );
    }).toList();

    List<DropdownMenuItem<String>> sdgDropdownItems =
        sdgMap.entries.map((entry) {
      return DropdownMenuItem<String>(
        value: entry.key,
        child: Text(
          entry.value,
          style: GoogleFonts.merriweather(fontSize: 14),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: Text('List your Project', style: GoogleFonts.merriweather())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Handle image picking
                },
                child: Row(
                  children: [
                    Icon(Icons.image_outlined, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Pick an Image...',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Divider(),
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
                        selectedDateTime != null ? 'Host Date - ${selectedDateTime}' : 'Host Date',
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
                      placeholderText: 'Project Description',
                      errorText: 'Please insert project description.')),
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
                      'Impoints',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    items: impointsDropdownItems,
                    value: selectedImpoints,
                    onChanged: (String? value) async {
                      setState(() {
                        selectedImpoints = value!;
                      });
                    },
                  ),
                ),
              ),
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
                      'Sustainable Development Goals',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    items: sdgDropdownItems,
                    value: selectedSdg,
                    onChanged: (String? value) async {
                      setState(() {
                        selectedSdg = value!;
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
                      Text('Click to add tags', style: GoogleFonts.poppins()),
                      Icon(Icons.tag)
                    ],
                  ),

                  // Handle tap
                ),
              ),
              SizedBox(height: 10),
              if (selectedUserList!.isNotEmpty)
                TagPills(
                  tags: selectedUserList,
                  onRemove: _removeTag,
                ),
              SizedBox(height: 20),
              CustomPrimaryButton(text: 'List Project', onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
