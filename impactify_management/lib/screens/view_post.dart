import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/providers/post_provider.dart';
import 'package:impactify_management/theming/custom_themes.dart';
import 'package:impactify_management/widgets/custom_empty.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:impactify_management/widgets/custom_post.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_management/providers/activity_provider.dart';
import 'package:impactify_management/providers/post_provider.dart';
import 'package:impactify_management/widgets/custom_loading.dart';
import 'package:impactify_management/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({super.key});

  @override
  State<ViewPost> createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  String? selectedActivity;

  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    // Fetch posts when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postProvider.fetchAllPostsByOrganizerID();
      activityProvider.fetchAllActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    final postProvider = Provider.of<PostProvider>(context);

    // Create a map of titles and IDs
    Map<String, String> activityMap = {
      for (var activity in activityProvider.activities)
        activity.title: activity.id
    };

    // Create the list of dropdown items
    List<DropdownMenuItem<String>> dropdownItems = activityMap.entries.map((entry) {
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                buttonStyleData: ButtonStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    //color: Colors.redAccent,
                  ),
                  elevation: 20,
                ),
                barrierColor: Colors.black.withAlpha(100),
                isExpanded: true,
                hint: CustomIconText(
                  text: 'Project / Speech Participated (All)',
                  icon: Icons.event,
                  size: 14,
                  color: AppColors.primary,
                ),
                items: dropdownItems,
                value: selectedActivity,
                onChanged: (String? value) async {
                  await postProvider.fetchAllPostsByActivityID(value!);
                  setState(() {
                    selectedActivity = value;
                  });
                },
              ),
            ),
            SizedBox(height: 15),
            if (postProvider.isLoading)
              Expanded(
                child:  CustomLoading(text: 'Fetching interesting Posts!'),
                
              )
            else if (postProvider.posts?.isEmpty ?? false)
              Expanded(child: EmptyWidget(text: 'No Posts after Filtered.\nPlease Try Again.', image: 'assets/no-filter.png'))
              
            else
            
              Expanded(
                child: ListView.builder(
                  itemCount: postProvider.posts?.length ?? 0,
                  itemBuilder: (context, index) {
                    final post = postProvider.posts?[index] ?? null;
                    return CommunityPost(
                      postID: post!.postID,
                      profileImage: post.user!.profileImage,
                      name: post.user!.username,
                      bio: post.user!.introduction,
                      date: post.createdAt,
                      postImage: post.postImage,
                      postTitle: post.title,
                      postDescription: post.description,
                      likes: post.likes,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

