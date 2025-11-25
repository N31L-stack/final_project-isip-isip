import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ForumContent(), // REUSED CONTENT
    );
  }
}

// NEW: Reusable content widget (embed inside your existing tab page)
class ForumContent extends StatelessWidget {
  const ForumContent({super.key});

  static final List<_Post> _posts = <_Post>[
    // ...same demo posts...
    _Post(
      user: 'User-123',
      title: 'Feeling overwhelmed today',
      snippet: 'Lorum ipsum thoughts about busyness...',
      comments: 5,
      avatar: const CircleAvatar(backgroundColor: Color(0xFFE3F2FD), child: Icon(Icons.help, color: Color(0xFF5B9BD5))),
    ),
    _Post(
      user: 'User-456',
      title: 'Shared my feelings for the first time',
      snippet: 'Therapist: Blip response, watery small steps...',
      comments: 5,
      avatar: const CircleAvatar(backgroundImage: AssetImage('assets/anime.jpg'), backgroundColor: Colors.transparent),
    ),
    _Post(
      user: 'User-789',
      title: 'Shared my feelings for the first time',
      snippet: 'Lencett, thanks! How did you...',
      comments: 2,
      avatar: const CircleAvatar(backgroundImage: AssetImage('assets/avatar_2.png'), backgroundColor: Colors.transparent),
    ),
    _Post(
      user: 'User-789',
      title: 'How you cope with anxiety?',
      snippet: 'Exercising, journaling, or would you suggest...',
      comments: 15,
      avatar: const CircleAvatar(backgroundImage: AssetImage('assets/avatar_3.png'), backgroundColor: Colors.transparent),
    ),
  ];

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
                      'Anonymous Forum', // was: 'Anonymous Forum'
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
                  for (final p in _posts) _PostCard(post: p),
                  const SizedBox(height: 4),
                  const Divider(height: 1, thickness: 0.6, color: Color(0x11000000)),
                  const SizedBox(height: 14),
                  Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('New Post tapped')),
                            );
                          },
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

// ...existing _Post and _PostCard classes unchanged...
class _Post {
  final String user;
  final String title;
  final String snippet;
  final int comments;
  final Widget avatar;
  const _Post({
    required this.user,
    required this.title,
    required this.snippet,
    required this.comments,
    required this.avatar,
  });
}

class _PostCard extends StatelessWidget {
  final _Post post;
  const _PostCard({required this.post});

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
                      Text('Comment (${post.comments})', style: const TextStyle(fontSize: 12.5, color: Color(0x802E5A88))),
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
