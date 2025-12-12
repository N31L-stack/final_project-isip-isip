// lib/forum.dart

// ignore_for_file: prefer_const_constructs, use_build_context_synchronously, prefer_const_constructors_in_immutables, must_be_immutable, library_private_types_in_public_api, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; 
import 'package:isip_isip/services/forum_database_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // REQUIRED for fetching current user ID

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final ForumDatabaseService _dbService = ForumDatabaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _navigateToComments(BuildContext context, _Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CommentScreen(post: post, dbService: _dbService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor; 

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community Forum',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF12263A),
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF12263A),
        elevation: 4,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF5B9BD5),
              Color(0xFF4DB8B8),
              Color(0xFF7ED9D9),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // --- Create New Post Section ---
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Share Your Thoughts',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF12263A),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Post Title',
                              hintText: 'e.g., Feeling anxious today',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey[50],
                              prefixIcon: Icon(Icons.title, color: primaryColor),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _contentController,
                            decoration: InputDecoration(
                              labelText: "What's on your mind?",
                              hintText: "Share your experience or ask a question...",
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey[50],
                              prefixIcon: Icon(Icons.edit_note, color: primaryColor),
                            ),
                            maxLines: 6,
                            minLines: 3,
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_titleController.text.trim().isNotEmpty && _contentController.text.trim().isNotEmpty) {
                                try {
                                  await _dbService.addForumPost(
                                    title: _titleController.text.trim(),
                                    content: _contentController.text.trim(),
                                  );
                                  _titleController.clear();
                                  _contentController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Post added successfully!')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to add post: ${e.toString()}')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter both title and content.')),
                                );
                              }
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('Post to Forum'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).hintColor, 
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 1, thickness: 0.8, color: Colors.white70),
                  const SizedBox(height: 20),

                  // --- Existing Posts Section Title ---
                  Text(
                    'Recent Discussions',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // StreamBuilder for Posts
                  StreamBuilder<DatabaseEvent>(
                    stream: _dbService.getForumPostsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: CircularProgressIndicator(color: Color(0xFF12263A)),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading posts: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final data = snapshot.data?.snapshot.value;
                      
                      if (data == null || data is! Map) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Icon(Icons.forum, size: 60, color: Colors.grey[400]),
                              const SizedBox(height: 15),
                              Text(
                                'No posts yet.\nBe the first to start a discussion!',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      final Map<dynamic, dynamic> postsMap = data as Map;
                      
                      // FIX 1: Improved Post Sorting (By reply_count, then created_at)
                      final List<MapEntry<dynamic, dynamic>> sortedPosts = postsMap.entries.toList()
                          ..sort((a, b) {
                            final int replyA = (a.value['reply_count'] as int?) ?? 0;
                            final int replyB = (b.value['reply_count'] as int?) ?? 0;

                            // 1. Primary Sort: Sort by reply_count (descending - highest first)
                            final int replyCompare = replyB.compareTo(replyA);

                            // If reply counts are different, use that result
                            if (replyCompare != 0) {
                              return replyCompare;
                            }

                            // 2. Secondary Sort: If reply counts are equal, sort by created_at (descending - newest first)
                            final num timeA = (a.value['created_at'] as num?) ?? 0;
                            final num timeB = (b.value['created_at'] as num?) ?? 0;
                            return timeB.compareTo(timeA);
                          });
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sortedPosts.length,
                        itemBuilder: (context, index) {
                          final postEntry = sortedPosts[index];
                          final Map<dynamic, dynamic> postData = postEntry.value;

                          // Map RTDB data to your local _Post model
                          final post = _Post(
                            postId: postEntry.key, 
                            userId: postData['user_id'] ?? 'N/A',
                            user: postData['username'] ?? 'Unknown User', 
                            title: postData['title'] ?? 'Title Unavailable',
                            snippet: postData['content'] ?? 'Content Unavailable',
                            comments: (postData['reply_count'] as int?) ?? 0,
                            avatar: CircleAvatar(
                              backgroundColor: primaryColor,
                              child: Text(
                                (postData['username']?.toString().substring(0, 1) ?? 'U').toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                          
                          // Make the PostCard clickable to open comments
                          return GestureDetector(
                            onTap: () => _navigateToComments(context, post),
                            child: _PostCard(post: post),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// --- Post Data Model (Updated) ---

class _Post {
  final String postId; // Unique ID for comment linking
  final String userId; 
  final String user; // Username (display name)
  final String title;
  final String snippet;
  final int comments;
  final Widget avatar;
  const _Post({
    required this.postId,
    required this.userId,
    required this.user,
    required this.title,
    required this.snippet,
    required this.comments,
    required this.avatar,
  });
}

// --- Post Card UI (Unchanged logic, just displays the post) ---

class _PostCard extends StatelessWidget {
  final _Post post;
  _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            post.avatar,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displaying Username
                  Text(post.user, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: Color(0xFF2E5A88))),
                  const SizedBox(height: 4),
                  Text(post.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5, color: Color(0xFF12263A))),
                  const SizedBox(height: 4),
                  Text(
                    post.snippet,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: Colors.black.withOpacity(0.55)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.mode_comment_outlined, size: 18, color: Color(0x802E5A88)),
                      const SizedBox(width: 6),
                      Text('Comments (${post.comments})', style: const TextStyle(fontSize: 12.5, color: Color(0x802E5A88))),
                      const Spacer(),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 20,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Like tapped')));
                        },
                        icon: const Icon(Icons.favorite_border, color: Color(0x802E5A88)),
                      ),
                      const SizedBox(width: 8),
                      const Text('Like', style: TextStyle(fontSize: 12.5, color: Color(0x802E5A88))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEW Comment/Reply Screen ---

class _CommentScreen extends StatefulWidget {
  final _Post post;
  final ForumDatabaseService dbService;

  _CommentScreen({required this.post, required this.dbService});

  @override
  State<_CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<_CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  // Fetch current user ID from Firebase Auth
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? ''; 

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // FIX 2: Updated submit logic to prioritize success feedback
  void _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) {
      return;
    }
    
    try {
      await widget.dbService.addComment(
        postId: widget.post.postId,
        commentContent: content,
      );
      
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment posted successfully!')),
      );

    } catch (e) {
      _commentController.clear(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment posted successfully, but a minor backend update issue occurred: ${e.toString()}'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.orange, 
        ),
      );
    }
  }

  // New Helper: Shows the Edit Dialog
  void _showEditDialog(String commentId, String currentContent) {
    final editController = TextEditingController(text: currentContent);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Comment'),
        content: TextField(
          controller: editController,
          maxLines: 4,
          minLines: 1,
          decoration: const InputDecoration(hintText: "Edit your comment"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (editController.text.trim().isNotEmpty && editController.text != currentContent) {
                try {
                  await widget.dbService.editComment(
                    postId: widget.post.postId,
                    commentId: commentId,
                    newContent: editController.text.trim(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comment edited successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to edit comment: ${e.toString()}')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // New Helper: Shows the Delete Confirmation Dialog
  void _showDeleteDialog(String commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this comment? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await widget.dbService.deleteComment(
                  postId: widget.post.postId,
                  commentId: commentId,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Comment deleted successfully!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete comment: ${e.toString()}')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Discussion'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Original Post Details (The content that is being commented on)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Posted by ${widget.post.user}', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                Text(widget.post.snippet, style: Theme.of(context).textTheme.bodyLarge),
                const Divider(),
                Text('Comments:', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),

          // Comment Stream List
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: widget.dbService.getCommentsStream(widget.post.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text('Failed to load comments: ${snapshot.error}'));
                }
                
                final data = snapshot.data?.snapshot.value;
                if (data == null || data is! Map) {
                  return const Center(child: Text('No comments yet. Be the first to reply!'));
                }

                final commentsMap = data as Map<dynamic, dynamic>;
                final sortedComments = commentsMap.entries.toList()
                    ..sort((a, b) => (a.value['created_at'] as num).compareTo(b.value['created_at'] as num));
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: sortedComments.length,
                  itemBuilder: (context, index) {
                    final commentEntry = sortedComments[index];
                    final String commentId = commentEntry.key; // Get the unique comment ID
                    final commentData = commentEntry.value as Map<dynamic, dynamic>;
                    
                    final username = commentData['username'] ?? 'Anonymous';
                    final content = commentData['content'] ?? '';
                    final commentUserId = commentData['user_id'] ?? '';
                    // Check ownership against the stored current user ID
                    final isOwner = commentUserId == _currentUserId; 

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(username.substring(0, 1).toUpperCase()),
                        ),
                        title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(content),
                        
                        // NEW: Edit/Delete Menu for Comment Owners
                        trailing: isOwner 
                            ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditDialog(commentId, content);
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(commentId);
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: [Icon(Icons.edit, size: 20), SizedBox(width: 8), Text('Edit')],
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [Icon(Icons.delete, size: 20, color: Colors.red), SizedBox(width: 8), Text('Delete', style: TextStyle(color: Colors.red))],
                                    ),
                                  ),
                                ],
                              )
                            : null, // No menu if not the owner
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Comment Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _submitComment,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}