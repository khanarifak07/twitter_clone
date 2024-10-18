import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:twitter_clone/Utilities/utilities.dart';
import 'package:twitter_clone/models/post_model.dart';
import 'package:twitter_clone/models/user_model.dart';

class DatabaseService {
  static final _firebaseFirestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  static final _firebaseStorage = FirebaseStorage.instance;

  //save user info to database
  static Future<void> saveUserInfoInFirebase({
    required String name,
    required String email,
  }) async {
    //get the user id
    String uid = _auth.currentUser!.uid;
    //get the username from email
    String username = email.split(
        '@')[0]; //eg arif@gmail.com --> [arif, gmail.com] --> output --> arif
    //create user profile
    UserModel user = UserModel(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
      profile: '',
    );
    //convert user into map {}
    final userMap = user.toJson();
    //save the data in firebase in a users collections
    await _firebaseFirestore.collection('Users').doc(uid).set(userMap);
  }

  //get the user from database
  static Future<UserModel?> getUserInfoFromFirebase(String uid) async {
    try {
      //retrieve user doc from firebase
      DocumentSnapshot userDoc =
          await _firebaseFirestore.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        //convert doc to user model
        return UserModel.fromJson(userDoc);
      } else {
        // Handle the case where the document doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any errors
      log("Error fetching user data: $e");
      return null;
    }
  }

  //update user details
  static Future<void> updateUserDetailsInFirebase(String uid, String name,
      String email, String username, String bio) async {
    try {
      //user model
      UserModel user = UserModel(
        uid: uid,
        name: name,
        email: email,
        username: username,
        bio: bio,
        profile: '',
      );
      //coonvert to map to store in firebase
      var userMap = user.toJson();
      //get the current user
      await _firebaseFirestore.collection('Users').doc(uid).update(userMap);
      // await _firebaseFirestore.collection('Users').doc(uid).update({'bio': bio}); //to update single fields
    } catch (e) {
      log('Something went wrong while updating data $e');
    }
  }

  //update user bio in firebase
  static Future<void> updateBioInFirebase(String bio, String uid) async {
    try {
      await _firebaseFirestore
          .collection('Users')
          .doc(uid)
          .update({'bio': bio});
    } catch (e) {
      log('Error while updating bio in firebase $e');
    }
  }

  //update name email and username
  static Future<void> updateNameEmailAndUsernameInFirebase(
      String uid, String name, String email, String username) async {
    try {
      await _firebaseFirestore.collection('Users').doc(uid).update({
        'name': name,
        'email': email,
        'username': username,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  //upload profile image
  static Future<void> uploadProfileImageFirebase(File image, String uid) async {
    try {
      //get the storage reference
      final storageRef = _firebaseStorage
          .ref()
          .child('profile_images/${path.basename(image.path)}');
      //upload the task
      final uploadTask = storageRef.putFile(image);
      // Check the upload progress
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        log('Upload progress: ${taskSnapshot.bytesTransferred}/${taskSnapshot.totalBytes}');
      });
      //take the task snapshot
      final taskSnapshot = await uploadTask.whenComplete(() {});
      //get the downloadURL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      log('Image uploaded successfully! Download URL: $downloadUrl');
      //update in the firebase
      await _firebaseFirestore.collection('Users').doc(uid).update({
        'profile': downloadUrl,
      });
    } catch (e) {
      log('Error while uploading profile image $e');
    }
  }

  //reauthenticate user
  static Future<void> reauthenticateUser(
      BuildContext context, String password) async {
    try {
      //get the current user
      final user = _auth.currentUser;
      //get the email auth provider credentila
      final credential =
          EmailAuthProvider.credential(email: user!.email!, password: password);
      //reauthenticate
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      Utilities.showSnackBar(context, 'Error while reauthenticating user : $e');
    }
  }

  //update email method
  static Future<void> verifyAndUpdateEmail(
      BuildContext context, String newEmail, String currentPassword) async {
    try {
      //reauhenticate user
      await reauthenticateUser(context, currentPassword);
      //
      final user = _auth.currentUser;
      //
      await user!.verifyBeforeUpdateEmail(newEmail);
      //save to firebase
      await _firebaseFirestore.collection('Users').doc(user.uid).update({
        'email': newEmail,
      });
      //
      log('Verification email sent. Please check your new email to verify');
    } catch (e) {
      log('Error while updating user email : $e');
    }
  }

  //change password
  static Future<void> changePassword(
      BuildContext context, String password, String newPassword) async {
    try {
      //reauthnticate user
      await reauthenticateUser(context, password);
      //
      final user = _auth.currentUser;
      //
      await user!.updatePassword(newPassword);
    } catch (e) {
      log("Error while updating password $e");
    }
  }

//POST

//post message in firebase
  static Future<void> postMessageInFirebase(String message) async {
    try {
      //current user id
      String uid = _auth.currentUser!.uid;
      //get the current user
      UserModel? user = await getUserInfoFromFirebase(uid);
      //create a new post
      PostModel newPost = PostModel(
        id: "", //Auto generated by Firebase
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        likeCount: 0,
        likedBy: [],
        timestamp: Timestamp.now(),
      );
      //convert post model into map to store in firebase
      Map<String, dynamic> post = newPost.toJson();
      //store in firebase
      DocumentReference docRef =
          await _firebaseFirestore.collection('Posts').add(post);
      //
      // Get the auto-generated ID
      String postId = docRef.id;

      // Update the post with the auto-generated ID
      await docRef.update({'id': postId});

      log("Post added successfully with ID: $postId");
    } catch (e) {
      log("Error while posting message $e");
    }
  }

//get all post from firebase
  static Future<List<PostModel>?> getAllPostsFromFirebase() async {
    try {
      //get all post
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('Posts')
          .orderBy('timestamp', descending: true)
          .get();
      //convert each documnet from map to model
      return snapshot.docs.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      log('Error while getting all posts $e');
    }
    return null;
  }

//delete post
  static Future<void> deletePost(String postId) async {
    try {
      // await _firebaseFirestore.collection('Posts').doc(postId).delete();
      DocumentReference docRef =
          _firebaseFirestore.collection('Posts').doc(postId);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        log("Error: Document with postId $postId does not exist.");
        return;
      }

      await docRef.delete();
      log("Successfully deleted post with postId: $postId");
    } catch (e) {
      log("Error while deleting post: $e");
    }
  }

//LIKES

  static Future<void> toggleLikesInFirebase(String postId) async {
    try {
      //get the current user uid
      String uid = FirebaseAuth.instance.currentUser!.uid;
      //go to the for the post
      DocumentReference documentReference =
          _firebaseFirestore.collection('Posts').doc(postId);
      //execute like
      await _firebaseFirestore.runTransaction((transaction) async {
        //get post document
        DocumentSnapshot documentSnapshot =
            await transaction.get(documentReference);
        //get likes of users who liked the post
        List<String> likedBy =
            List<String>.from(documentSnapshot['likedBy'] ?? []);
        //get like count
        int currentLikeCount = documentSnapshot['likeCount'];
        //if user is not like the post --> then like
        if (!likedBy.contains(uid)) {
          likedBy.add(uid);
          currentLikeCount++;
        } else {
          likedBy.remove(uid);
          currentLikeCount--;
        }
        //update in firebase
        transaction.update(documentReference, {
          'likedBy': likedBy,
          'likeCount': currentLikeCount,
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }
}



// 1. DocumentSnapshot:
// Represents: A single document.
// Use Case: When you retrieve a specific document by its ID.

// Properties and Methods:
// exists: Indicates whether the document exists in the database.
// id: The ID of the document.
// data(): Returns a Map<String, dynamic> containing the document's data.
// get(String field): Retrieves a specific field from the document.
// reference: Provides a reference to the document.

//Example
// DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc('userID').get();
// if (docSnapshot.exists) {
//   print(docSnapshot.data());
// }


// 2. QuerySnapshot:
// Represents: A collection of documents.
// Use Case: When you retrieve multiple documents from a collection or a query (e.g., fetching all documents in a collection or filtering documents based on some criteria).

// Properties and Methods:
// docs: A list of DocumentSnapshot objects representing each document in the query results.
// size: The number of documents in the QuerySnapshot.
// isEmpty: A boolean indicating if the query returned any documents.
// metadata: Metadata about the query, such as whether it was served from cache.

//Example
// QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('age', isGreaterThan: 18).get();
// for (var doc in querySnapshot.docs) {
//   print(doc.data());
// }

// 1. DocumentReference
// Purpose: Represents a reference to a specific document in Firestore.
// Usage: Used to perform operations on a document, such as reading, updating, or deleting.

// Methods:
// get(): Fetches the document's current state (returns a DocumentSnapshot).
// set(data): Creates or updates the document with the provided data.
// update(data): Updates the document with new data, without overwriting existing fields.
// delete(): Deletes the document.
// collection(path): Gets a reference to a subcollection within this document.

//Example
// DocumentReference docRef = FirebaseFirestore.instance.collection('Posts').doc('postId');

