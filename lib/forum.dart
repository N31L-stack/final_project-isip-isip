import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForumContent(),
    );
  }
}

class ForumContent extends StatefulWidget {
  const ForumContent({super.key});

  @override
  State<ForumContent> createState() => _ForumContentState();
}

class _ForumContentState extends State<ForumContent> {
  List<_Post> _posts = <_Post>[
    _Post(
      id: '1',
      user: 'Conchitoww',
      title: 'Feeling overwhelmed today',
      snippet: 'Lorem ipsum thoughts about busyness...',
      comments: 5,
      likes: 12,
      isLiked: false,
      avatar: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text('C', style: TextStyle(color: Colors.blue[800])),
      ),
    ),
    _Post(
      id: '2',
      user: 'Cheetos',
      title: 'Shared my feelings for the first time',
      snippet: 'Therapist: Great response, taking small steps...',
      comments: 5,
      likes: 8,
      isLiked: true,
      avatar: CircleAvatar(
        backgroundColor: Colors.green[100],
        child: Text('C', style: TextStyle(color: Colors.green[800])),
      ),
    ),
    _Post(
      id: '3',
      user: 'Itsyourboy_con',
      title: 'Shared my feelings for the first time',
      snippet: 'Thanks everyone! How did you overcome anxiety?',
      comments: 2,
      likes: 3,
      isLiked: false,
      avatar: CircleAvatar(
        backgroundColor: Colors.orange[100],
        child: Text('I', style: TextStyle(color: Colors.orange[800])),
      ),
    ),
    _Post(
      id: '4',
      user: 'Just_Con',
      title: 'How you cope with anxiety?',
      snippet: 'Exercising, journaling, or would you suggest...',
      comments: 15,
      likes: 24,
      isLiked: false,
      avatar: CircleAvatar(
        backgroundColor: Colors.purple[100],
        child: Text('J', style: TextStyle(color: Colors.purple[800])),
      ),
    ),
  ];

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = _posts.indexWhere((p) => p.id == postId);
      if (postIndex != -1) {
        _posts[postIndex] = _posts[postIndex].copyWith(
          isLiked: !_posts[postIndex].isLiked,
          likes: _posts[postIndex].isLiked 
              ? _posts[postIndex].likes - 1 
              : _posts[postIndex].likes + 1,
        );
      }
    });
  }

  void _addComment(String postId) {
    showDialog(
      context: context,
      builder: (context) => CommentDialog(
        onCommentSubmitted: (comment) {
          setState(() {
            final postIndex = _posts.indexWhere((p) => p.id == postId);
            if (postIndex != -1) {
              _posts[postIndex] = _posts[postIndex].copyWith(
                comments: _posts[postIndex].comments + 1,
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Comment added: "$comment"'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _showNewPostDialog() {
    showDialog(
      context: context,
      builder: (context) => NewPostDialog(
        onPostSubmitted: (title, content) {
          final newPost = _Post(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            user: 'You',
            title: title,
            snippet: content.length > 100 ? '${content.substring(0, 100)}...' : content,
            comments: 0,
            likes: 0,
            isLiked: false,
            avatar: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: const Text('Y', style: TextStyle(color: Colors.blue)),
            ),
          );
          
          setState(() {
            _posts.insert(0, newPost);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New post published!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      'Community Forum',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF12263A),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(height: 1, thickness: 0.6, color: Color(0x11000000)),
                  const SizedBox(height: 8),
                  
                  // Posts
                  for (final post in _posts) 
                    _PostCard(
                      post: post,
                      onLikePressed: () => _toggleLike(post.id),
                      onCommentPressed: () => _addComment(post.id),
                    ),
                  
                  const SizedBox(height: 4),
                  const Divider(height: 1, thickness: 0.6, color: Color(0x11000000)),
                  const SizedBox(height: 14),
                  
                  // New Post Button
                  Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: _showNewPostDialog,
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF5B9BD5).withOpacity(0.10),
                              border: Border.all(color: const Color(0xFF5B9BD5), width: 1.2),
                            ),
                            child: const Icon(Icons.add, size: 28, color: Color(0xFF5B9BD5)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'New Post',
                          style: TextStyle(
                            color: Color(0xFF2E5A88),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Post {
  final String id;
  final String user;
  final String title;
  final String snippet;
  int comments;
  int likes;
  bool isLiked;
  final Widget avatar;

  _Post({
    required this.id,
    required this.user,
    required this.title,
    required this.snippet,
    required this.comments,
    required this.likes,
    required this.isLiked,
    required this.avatar,
  });

  _Post copyWith({
    int? comments,
    int? likes,
    bool? isLiked,
  }) {
    return _Post(
      id: id,
      user: user,
      title: title,
      snippet: snippet,
      comments: comments ?? this.comments,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      avatar: avatar,
    );
  }
}

class _PostCard extends StatelessWidget {
  final _Post post;
  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;

  const _PostCard({
    required this.post,
    required this.onLikePressed,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
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
                  Text(post.user, 
                    style: const TextStyle(
                      fontWeight: FontWeight.w700, 
                      fontSize: 14.5, 
                      color: Color(0xFF2E5A88)
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(post.title, 
                    style: const TextStyle(
                      fontWeight: FontWeight.w700, 
                      fontSize: 15.5, 
                      color: Color(0xFF12263A)
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.snippet,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5, 
                      color: Colors.black.withOpacity(0.55)
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Comment Button
                      InkWell(
                        onTap: onCommentPressed,
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            const Icon(Icons.mode_comment_outlined, size: 18, color: Color(0x802E5A88)),
                            const SizedBox(width: 6),
                            Text('Comment (${post.comments})', 
                              style: const TextStyle(
                                fontSize: 12.5, 
                                color: Color(0x802E5A88)
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Like Button
                      InkWell(
                        onTap: onLikePressed,
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            Icon(
                              post.isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: post.isLiked ? Colors.red : Color(0x802E5A88),
                            ),
                            const SizedBox(width: 6),
                            Text('Like (${post.likes})', 
                              style: TextStyle(
                                fontSize: 12.5, 
                                color: post.isLiked ? Colors.red : Color(0x802E5A88)
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Share Button
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 18,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Post shared!')),
                          );
                        },
                        icon: const Icon(Icons.share, color: Color(0x802E5A88)),
                      ),
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

// New Post Dialog
class NewPostDialog extends StatefulWidget {
  final Function(String title, String content) onPostSubmitted;

  const NewPostDialog({super.key, required this.onPostSubmitted});

  @override
  State<NewPostDialog> createState() => _NewPostDialogState();
}

class _NewPostDialogState extends State<NewPostDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Post',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5A88),
              ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Post Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF5B9BD5)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'What\'s on your mind?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF5B9BD5)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 5,
              maxLength: 500,
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF2E5A88),
                      side: const BorderSide(color: Color(0xFF2E5A88)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty || 
                          _contentController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in both title and content'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      widget.onPostSubmitted(
                        _titleController.text.trim(),
                        _contentController.text.trim(),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B9BD5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Publish'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}

// Comment Dialog
class CommentDialog extends StatefulWidget {
  final Function(String) onCommentSubmitted;

  const CommentDialog({super.key, required this.onCommentSubmitted});

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final _commentController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Comment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5A88),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Share your thoughts on this post',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write your comment here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF5B9BD5)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              maxLength: 300,
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF2E5A88),
                      side: const BorderSide(color: Color(0xFF2E5A88)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_commentController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please write a comment'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      widget.onCommentSubmitted(_commentController.text.trim());
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B9BD5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Post Comment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}