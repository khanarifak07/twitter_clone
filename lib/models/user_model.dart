// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;
  final String profile;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.username,
      required this.bio,
      required this.profile});

// convert firebase document to user profile (so that we can use in our app)
  factory UserModel.fromJson(DocumentSnapshot doc) {
    return UserModel(
        uid: doc['uid'] as String,
        name: doc['name'] as String,
        email: doc['email'] as String,
        username: doc['username'] as String,
        bio: doc['bio'] as String,
        profile: doc['profile'] as String);
  }

// convert user profile to map (so that we can store in database)
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile
    };
  }
}
