// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String uid;
  final String name;
  final String username;
  final String message;
  final int likeCount;
  final List<String> likedBy;
  final Timestamp timestamp;
  PostModel({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.likeCount,
    required this.likedBy,
    required this.timestamp,
  });

//convert model to json (map) so that we can store in firebase
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'likeCount': likeCount,
      'likedBy': likedBy,
      'timestamp': timestamp,
    };
  }

  //convert firebase document to model so that we can use in our app
  factory PostModel.fromJson(DocumentSnapshot doc) {
    return PostModel(
      id: doc['id'] as String,
      uid: doc['uid'] as String,
      name: doc['name'] as String,
      username: doc['username'] as String,
      message: doc['message'] as String,
      likeCount: doc['likeCount'] as int,
      timestamp: doc['timestamp'],
      likedBy: List<String>.from(
          doc['likedBy'].map((item) => item as String).toList()),
    );
  }
}
