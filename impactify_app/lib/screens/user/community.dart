import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:impactify_app/providers/post_provider.dart';
import 'package:impactify_app/providers/user_provider.dart';
import 'package:impactify_app/screens/user/addPost.dart';
import 'package:impactify_app/theming/custom_themes.dart';
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
              SizedBox(height: 20),
              // Post Content
              Expanded(
                child: postProvider.isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            CustomLoading(text: 'Fetching interesting Posts!')
                          ])
                    : ListView.builder(
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
