import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/models/post_model.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    super.key,
    required this.colorScheme,
    required this.postData,
    this.onUserTap,
    this.onPostTap,
    required this.databaseProvider,
  });

  final ColorScheme colorScheme;
  final PostModel postData;
  final Function()? onUserTap;
  final Function()? onPostTap;
  final DatabaseProvider databaseProvider;

  void _toggleLikes() {
    databaseProvider.toggleLike(postData.id);
  }

  @override
  Widget build(BuildContext context) {
    //does current user like this post
    bool currentUserLikePost =
        databaseProvider.isPostLikedByCurrentUser(postData.id);
    int likeCount = databaseProvider.getLikeCount(postData.id);
    return GestureDetector(
      onTap: onPostTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onUserTap,
              child: Row(
                children: [
                  Text(
                    postData.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  Text(
                    '\t\t@${postData.username}',
                    style: TextStyle(
                      color: colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showOptions(context, databaseProvider, postData.id);
                    },
                    child: Icon(
                      Icons.more_horiz,
                      color: colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(postData.message),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                    onTap: _toggleLikes,
                    child: currentUserLikePost
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : Icon(
                            Icons.favorite_outline,
                            color: colorScheme.primary,
                          )),
                const SizedBox(width: 5),
                Text(
                  likeCount == 0 ? "" : likeCount.toString(),
                  style: TextStyle(color: colorScheme.primary),
                )
              ],
            )
          ],
        ),
      ),
    );
    // : const SizedBox.shrink();
  }

  void _showOptions(
      BuildContext context, DatabaseProvider provider, String postId) {
    String currentUser = FirebaseAuth.instance.currentUser!.uid;
    bool isOwnPost = currentUser == postData.uid;
    showModalBottomSheet(
        context: context,
        builder: (index) {
          return Wrap(
            children: [
              if (isOwnPost)
                ListTile(
                  onTap: () {
                    databaseProvider.postDelete(context, postId);
                  },
                  leading: databaseProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.delete, color: colorScheme.primary),
                  title: Text(
                    "Delete",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else ...[
                ListTile(
                  onTap: () {
                    databaseProvider.postDelete(context, postId);
                  },
                  leading: databaseProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.flag, color: colorScheme.primary),
                  title: Text(
                    "Report",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    databaseProvider.postDelete(context, postId);
                  },
                  leading: databaseProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.block, color: colorScheme.primary),
                  title: Text(
                    "Block User",
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: Icon(Icons.cancel, color: colorScheme.primary),
                title: Text(
                  "Cancel",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
