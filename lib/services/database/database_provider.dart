import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/Utilities/utilities.dart';
import 'package:twitter_clone/models/post_model.dart';
import 'package:twitter_clone/models/user_model.dart';
import 'package:twitter_clone/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider() {
    loadUserProfileData();
    loadAllPosts();
  }

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final postMessageCtrl = TextEditingController();
  final _auth = FirebaseAuth.instance;
  UserModel? user;
  XFile? profileImage;
  bool isLoading = false;

  List<PostModel> posts = [];

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  //load user profile data
  Future<void> loadUserProfileData() async {
    user =
        await DatabaseService.getUserInfoFromFirebase(_auth.currentUser!.uid);
    if (user != null) {
      nameCtrl.text = user!.name;
      emailCtrl.text = user!.email;
      bioCtrl.text = user!.bio;
      usernameCtrl.text = user!.username;
      profileImage = user!.profile.isNotEmpty
          ? XFile(user!.profile) // Assuming profileImage is a URL or local path
          : null;
    }
    notifyListeners();
  }

  //select image for profile
  Future<void> selectProfile() async {
    try {
      // Step 1: Pick an image from the gallery
      var pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        // Step 2: Crop the image
        CroppedFile? croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: const CropAspectRatio(
              ratioX: 1.0, ratioY: 1.0), // 1:1 aspect ratio (square)
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
            ),
          ],
        );

        if (croppedImage != null) {
          // Convert CroppedFile to XFile and assign to profileImage
          profileImage = XFile(croppedImage.path);
          notifyListeners(); // Notify listeners to update the UI

          //update profile image to firebase
          await uploadProfileImage(File(profileImage!.path));
        }
      }
    } catch (e) {
      log('Error while selecting profile image: $e');
    }
  }

  //update user data
  Future<void> updateUserData(
      String name, String email, String username, String bio) async {
    await DatabaseService.updateUserDetailsInFirebase(
      _auth.currentUser!.uid,
      name,
      email,
      username,
      bio,
    );
    await loadUserProfileData();
  }

  //update user bio
  Future<void> updateUserBio(String bio, BuildContext context) async {
    try {
      DatabaseService.updateBioInFirebase(bio, _auth.currentUser!.uid);
      //navigate back to profile screen
      Navigator.pop(context);
      //load the latest data
      await loadUserProfileData();
    } catch (e) {
      log('Error while updating bio $e');
    }
  }

  Future<void> updateNameEmailAndUsername(BuildContext context) async {
    DatabaseService.updateNameEmailAndUsernameInFirebase(
      _auth.currentUser!.uid,
      nameCtrl.text,
      emailCtrl.text,
      usernameCtrl.text,
    );
    Navigator.pop(context);
    await loadUserProfileData();
  }

  //
  Future<void> uploadProfileImage(File image) async {
    DatabaseService.uploadProfileImageFirebase(image, _auth.currentUser!.uid);
    await loadUserProfileData();
  }

  //verify and update email
  Future<void> verifyAndEmailUpdate(
    BuildContext context,
    String newEmail,
    String currentPassword,
  ) async {
    try {
      //set loading to true
      setLoading(true);
      //verify and update email
      DatabaseService.verifyAndUpdateEmail(context, newEmail, currentPassword);
      //
      Utilities.showSnackBar(context,
          'Verification email sent. Please check your new email to verify');
    } catch (e) {
      log("Error while verifying and updating email $e");
    } finally {
      setLoading(false);
    }
  }

  //change password
  Future<void> changeCurrentPassword(
      BuildContext context, String password, String newPassword) async {
    try {
      //
      setLoading(true);
      //
      DatabaseService.changePassword(context, password, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      // Clear the fields after successful update
      passCtrl.clear();
      newPassCtrl.clear();
    } catch (e) {
      log('error while updating password');
    } finally {
      setLoading(false);
    }
  }

//POST

//add post
  Future<void> addPost(String message, BuildContext context) async {
    //
    setLoading(true);
    await DatabaseService.postMessageInFirebase(message);
    //Navigate pop
    Navigator.pop(context);
    //load all posts
    await loadAllPosts();
    //clear the controllers
    postMessageCtrl.clear();
    //
    setLoading(false);
  }

//get all posts
  Future<void> loadAllPosts() async {
    List<PostModel>? allPosts = await DatabaseService.getAllPostsFromFirebase();
    posts = allPosts!;
    iniliazeLikeMap();
    notifyListeners();
  }

//delete post
  Future<void> postDelete(BuildContext context, String postId) async {
    //
    setLoading(true);
    await DatabaseService.deletePost(postId);
    //
    Utilities.showSnackBar(context, "Post deleted successfully");
    //load latest post
    await loadAllPosts();
    //
    Navigator.pop(context);
    //
    setLoading(false);
  }

//LIKES

//local map to track like counts for each post
  Map<String, int> _likeCounts = {
//postId : Counts
  };

//local list to track post liked by current user
  List<String> _likedPost = [];

//does current user like this post
  bool isPostLikedByCurrentUser(String postId) => _likedPost.contains(postId);

//get the likes count for this post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

//iniliaze like map locally
  void iniliazeLikeMap() {
    //get the current user id
    String uid = FirebaseAuth.instance.currentUser!.uid;
    //clear liked post when new user signs in
    _likedPost.clear();
    //for each post get like data
    for (var post in posts) {
      //update like count map
      _likeCounts[post.id] = post.likeCount;
      //if the user already liked the post
      if (post.likedBy.contains(uid)) {
        //add the post id to the local list of liked post
        _likedPost.add(post.id);
      }
    }
  }

//toggle like
  Future<void> toggleLike(String postId) async {
    //First part will update the local values so that the UI feels immediate and responsive
    //and goes back to original values if it is fails

    //store original values in case if it fails
    final likedPostsOriginal = _likedPost;
    final likeCountsOriginal = _likeCounts;

    //perform like/unlike
    if (_likedPost.contains(postId)) {
      _likedPost.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPost.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }
    //update UI
    notifyListeners();
    //update data in firebase
    try {
      await DatabaseService.toggleLikesInFirebase(postId);
    } catch (e) {
      //revert back to original if anything fails
      _likedPost = likedPostsOriginal;
      _likeCounts = likeCountsOriginal;

      //update UI
      notifyListeners();
    }
  }

//dispose the controllers
  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    newPassCtrl.dispose();
    usernameCtrl.dispose();
    bioCtrl.dispose();
    postMessageCtrl.dispose();
    super.dispose();
  }
}
