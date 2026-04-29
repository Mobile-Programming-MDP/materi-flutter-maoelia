import 'package:fasum_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _postCollection = _firestore.collection(
    'posts',
  );

  static Future<void> addPosts(Post post) async {
    Map<String, dynamic> newPost = {
      'image': post.image,
      'description': post.description,
      'category': post.category,
      'longitude': post.longitude,
      'latitude': post.latitude,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'user_id': post.userId,
      'userFullName': post.userFullName,
    };
    await _postCollection.add(newPost);
  }
}
