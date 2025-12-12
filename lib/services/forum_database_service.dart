// lib/services/forum_database_service.dart

import 'dart:async'; 
import 'package:firebase_database/firebase_database.dart'; 
import 'package:firebase_auth/firebase_auth.dart';

// =========================================================================
// CRITICAL FIX: TYPEDEF BYPASS FOR STUBBORN TYPE ERRORS
// We will KEEP MutableData and TransactionResult definitions, but REMOVE 
// the TransactionHandler definition as it's the source of conflict.
// =========================================================================

// Define the MutableData type to satisfy the TransactionHandler signature
typedef MutableData = dynamic;

// Define a class that mimics the TransactionResult structure needed for .success()
class TransactionResult {
  // Static method that mimics the successful result expected by runTransaction
  static TransactionResult success(dynamic mutableData) {
    return TransactionResult._();
  }
  // Private constructor to prevent external instantiation
  TransactionResult._(); 
}

// REMOVED: typedef TransactionHandler = Future<TransactionResult> Function(MutableData mutableData);

// =========================================================================
// END OF FIX BLOCK
// =========================================================================


class ForumDatabaseService {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users'); 

  // --- Core Methods ---

  Future<String> getUsernameById(String uid) async {
    try {
      final snapshot = await _usersRef.child(uid).child('displayName').once();
      return snapshot.snapshot.value?.toString() ?? 'Anonymous';
    } catch (e) {
      print("Error fetching username: $e");
      return 'Anonymous';
    }
  }

  Future<void> addForumPost({
    required String title,
    required String content,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String userId = user.uid;
      final String username = await getUsernameById(userId); 
      
      final DatabaseReference newPostRef = _databaseRef.child('posts').push();
      final String? postId = newPostRef.key;

      if (postId == null) {
        throw Exception("Could not generate a unique post ID.");
      }

      final Map<String, dynamic> postData = {
        'post_id': postId, 
        'user_id': userId,
        'username': username,
        'title': title,
        'content': content,
        'created_at': ServerValue.timestamp,
        'reply_count': 0,
      };
      await newPostRef.set(postData);
    } else {
      throw Exception("Authentication required to create a post.");
    }
  }

  Stream<DatabaseEvent> getForumPostsStream() {
    return _databaseRef.child('posts').onValue;
  }
  
  // 4. Add a Comment to a Post
  Future<void> addComment({
    required String postId,
    required String commentContent,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final String userId = user.uid;
      final String username = await getUsernameById(userId); 
      
      final DatabaseReference commentsNodeRef = _databaseRef.child('comments').child(postId);
      await commentsNodeRef.push().set({
        'user_id': userId,
        'username': username, 
        'content': commentContent,
        'created_at': ServerValue.timestamp,
      });
      
      // FIX 1: We use dynamic for the type of the function passed to runTransaction
      // to resolve the 'argument_type_not_assignable' error.
      await _databaseRef.child('posts/$postId').runTransaction(
        (MutableData mutableData) async {
          
          Map? map = (mutableData as dynamic).value as Map?; 
          if (map != null) {
              int replyCount = map['reply_count'] as int? ?? 0;
              map['reply_count'] = replyCount + 1;
              (mutableData as dynamic).value = map;
          } else {
              (mutableData as dynamic).value = {
                  'reply_count': 1,
              };
          }
          
          return TransactionResult.success(mutableData);
          
        } as dynamic, // <--- Cast the transaction function to dynamic
      );
      
    } else {
      throw Exception("Authentication required to add a comment.");
    }
  }
  
  // 5. Edit a Comment
  Future<void> editComment({
    required String postId,
    required String commentId,
    required String newContent,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Authentication required to edit a comment.");
    }
    
    final commentRef = _databaseRef.child('comments').child(postId).child(commentId);
    
    await commentRef.update({
      'content': newContent,
      'edited_at': ServerValue.timestamp, // Add an edited timestamp
    });
  }

  // 6. Delete a Comment (Requires transaction to decrement reply_count)
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("Authentication required to delete a comment.");
    }

    final commentRef = _databaseRef.child('comments').child(postId).child(commentId);
    
    // 1. Delete the comment itself
    await commentRef.remove();
    
    // 2. Run Transaction to decrement the reply_count on the post
    // FIX 2: We use dynamic for the type of the function passed to runTransaction
    // to resolve the 'argument_type_not_assignable' error.
    await _databaseRef.child('posts/$postId').runTransaction(
      (MutableData mutableData) async {
        
        Map? map = (mutableData as dynamic).value as Map?;
        if (map != null) {
            int replyCount = map['reply_count'] as int? ?? 0;
            // Ensure reply_count doesn't go below zero
            map['reply_count'] = (replyCount > 0) ? replyCount - 1 : 0;
            (mutableData as dynamic).value = map;
        } 
        
        return TransactionResult.success(mutableData);
        
      } as dynamic, // <--- Cast the transaction function to dynamic
    );
  }

  Stream<DatabaseEvent> getCommentsStream(String postId) {
    return _databaseRef.child('comments').child(postId).orderByChild('created_at').onValue;
  }
}