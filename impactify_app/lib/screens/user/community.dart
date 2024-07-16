import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/providers/post_provider.dart';
import 'package:impactify_app/providers/user_provider.dart';
import 'package:impactify_app/screens/user/addPost.dart';
import 'package:impactify_app/screens/user/filterOption.dart';
import 'package:impactify_app/theming/custom_themes.dart';
import 'package:impactify_app/util/filter.dart';
import 'package:impactify_app/widgets/custom_loading.dart';
import 'package:impactify_app/widgets/custom_posts.dart';
import 'package:provider/provider.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  void initState() {
    super.initState();
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    // Fetch posts when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postProvider.fetchAllPosts();
      print(postProvider.posts?.length ?? "NO LENGTH");
    });
  }

  String selectedFilter = 'All';
  List<String> selectedTags = [];
  List<String> selectedTagIDs = [];
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addPost');
        },
        backgroundColor: AppColors.tertiary,
        foregroundColor: Colors.black,
        elevation: 10,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'The ',
                          style: GoogleFonts.nunito(fontSize: 24),
                        ),
                        TextSpan(
                          text: 'Community',
                          style: GoogleFonts.nunito(
                              fontSize: 24,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showFilterOptions(
                        context: context,
                        selectedFilter: selectedFilter,
                        selectedTags: selectedTags,
                        selectedTagIDs: selectedTagIDs,
                        selectedStartDate: selectedStartDate,
                        selectedEndDate: selectedEndDate,
                        onApplyFilters: (String filter,
                            List<String> tags,
                            List<String> tagIDs,
                            DateTime? startDate,
                            DateTime? endDate) {
                          setState(() {
                            selectedFilter = filter;
                            selectedTags = tags;
                            selectedTagIDs = tagIDs;
                            selectedStartDate = startDate;
                            selectedEndDate = endDate;
                          });
                          Provider.of<PostProvider>(context, listen: false)
                              .fetchFilteredPosts(
                                  filter, tagIDs, startDate, endDate);
                        },
                      );
                    },
                    icon: Icon(Icons.filter_list),
                    color: AppColors.primary,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Post Content
              if (postProvider.isLoading)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomLoading(text: 'Fetching interesting Posts!')
                    ],
                  ),
                )
              else if (postProvider.posts!.isEmpty)
                Center(
                  child: Text('No Posts after Filtered.\nPlease Try Again.',
                      style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: postProvider.posts?.length ?? 0,
                    itemBuilder: (context, index) {
                      final post = postProvider.posts![index];
                      return CommunityPost(
                        postID: post.postID,
                        profileImage: post.user!.profileImage,
                        type: post.activity!.type,
                        name: post.user!.username,
                        bio: post.user!.introduction,
                        date: post.createdAt,
                        postImage: post.postImage,
                        postTitle: post.title,
                        postDescription: post.description,
                        activity: post.activity!.title,
                        activityID: post.activityID,
                        likes: post.likes,
                        userID: userProvider.userData!.userID,
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
