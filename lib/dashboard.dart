// lib/dashboard.dart (Complete Updated Implementation)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'journal.dart';
import 'settings.dart';
import 'professionals.dart';
import 'forum.dart';

String? _lastLoggedMood;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  int _professionalCount = 0;
  int _forumNotifications = 0;
  bool _hasNewForumPost = false;

  late final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const JournalScreen(),
    const ProfessionalPage(),
    const ForumScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _runConnectionTest();
    _listenToForumNotifications();
  }

  void _runConnectionTest() async {
    print('--- Starting Firestore Connection Test ---');
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .get();

      if (snapshot.docs.isEmpty) {
        print('SUCCESSFUL CONNECTION: Found 0 documents.');
        setState(() => _professionalCount = 0);
      } else {
        print('SUCCESSFUL CONNECTION! Found ${snapshot.docs.length} documents.');
        setState(() => _professionalCount = snapshot.docs.length);
      }
    } catch (e) {
      print('*** CRITICAL FAILURE: Firestore Read Failed ***');
      print('Error Details: $e');
      setState(() => _professionalCount = -1);
    }
  }

  void _listenToForumNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    FirebaseFirestore.instance
        .collection('forum_posts')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final lastPost = snapshot.docs.first;
        final isNewPost = lastPost['timestamp'] != null &&
            lastPost['timestamp'].toDate().isAfter(DateTime.now().subtract(const Duration(hours: 1)));

        setState(() {
          _hasNewForumPost = isNewPost;
          _forumNotifications = isNewPost ? 1 : 0;
        });
      }
    });
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5B9BD5),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Journal'),
          const BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Help'),
          BottomNavigationBarItem(
            icon: _forumNotifications > 0
                ? Badge(label: Text('$_forumNotifications'), child: const Icon(Icons.forum_outlined))
                : const Icon(Icons.forum_outlined),
            label: 'Forum',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}

class MentalHealthService {
  static const String _ninjaApiKey = 'iDfRqScDDG9ZJNVykorBSg==EYfUR50jYboYIwNN';
  static const String _quotesApiUrl = 'https://api.api-ninjas.com/v2/quotes';

  static const Map<String, String> _youtubeUrls = {
    'wonderful': 'https://www.youtube.com/watch?v=zg49cOyfREc&list=RDzg49cOyfREc&start_radio=1',
    'good': 'https://www.youtube.com/watch?v=j-oTltscli8',
    'neutral': 'https://www.youtube.com/watch?v=pB_qUY1dPrs',
    'sad': 'https://www.youtube.com/watch?v=EvMTrP8eRvM',
    'awful': 'https://www.youtube.com/watch?v=30VMIEmA114',
  };

  static String _getApiCategory(String mood) {
    switch (mood.toLowerCase()) {
      case 'sad':
        return 'life';
      case 'awful':
        return 'courage';
      case 'good':
      case 'wonderful':
        return 'inspirational';
      case 'neutral':
      default:
        return 'wisdom';
    }
  }

  static Future<String> fetchQuote(String mood) async {
    final category = _getApiCategory(mood);
    try {
      final uri = Uri.parse(_quotesApiUrl).replace(queryParameters: {'categories': category});
      final response = await http.get(uri, headers: {'X-Api-Key': _ninjaApiKey});

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        if (json.isNotEmpty) {
          final quote = json[0]['quote'] as String;
          final author = json[0]['author'] as String;
          return '$quote - $author';
        }
        return 'No quotes found for this mood.';
      }
      return 'Failed to fetch quote.';
    } catch (e) {
      return 'Error fetching quote: $e';
    }
  }

  static String getYoutubeUrl(String mood) => _youtubeUrls[mood.toLowerCase()] ?? _youtubeUrls['neutral']!;

  static List<Map<String, dynamic>> getDefaultResources(String mood) {
    final resources = {
      'sad': [
        {
          'title': '4-7-8 Breathing Exercise',
          'description': 'Breathe in for 4 seconds, hold for 7, exhale for 8. Repeat 4 times.',
          'icon': Icons.air,
          'color': const Color(0xFF90CAF9),
          'detail': 'This breathing technique activates your parasympathetic nervous system.',
        },
        {
          'title': 'Gentle Movement',
          'description': 'Try a 5-minute walk or gentle stretching.',
          'icon': Icons.directions_walk,
          'color': const Color(0xFFA5D6A7),
          'detail': 'Physical movement releases endorphins.',
        },
        {
          'title': 'Reach Out',
          'description': 'Call or text someone you trust.',
          'icon': Icons.phone,
          'color': const Color(0xFFFFCC80),
          'detail': 'Social connection is powerful.',
        },
        {
          'title': 'Self-Compassion Break',
          'description': 'Treat yourself with kindness.',
          'icon': Icons.favorite,
          'color': const Color(0xFFF48FB1),
          'detail': 'You deserve compassion.',
        },
      ],
      'awful': [
        {
          'title': '5-4-3-2-1 Grounding',
          'description': 'Name 5 things you see, 4 you touch, 3 you hear, 2 you smell, 1 you taste.',
          'icon': Icons.psychology,
          'color': const Color(0xFFCE93D8),
          'detail': 'This brings you back to the present moment.',
        },
        {
          'title': 'Crisis Support',
          'description': 'Help is available 24/7.',
          'icon': Icons.support_agent,
          'color': const Color(0xFFEF5350),
          'detail': 'National Suicide Prevention Lifeline: 988',
        },
        {
          'title': 'Safe Space Exercise',
          'description': 'Imagine a place where you feel safe.',
          'icon': Icons.shield,
          'color': const Color(0xFF81C784),
          'detail': 'Create a mental sanctuary.',
        },
        {
          'title': 'One Moment at a Time',
          'description': 'Focus on the next 5 minutes.',
          'icon': Icons.timer,
          'color': const Color(0xFF64B5F6),
          'detail': 'You can get through this.',
        },
      ],
      'neutral': [
        {
          'title': 'Mindful Moment',
          'description': 'Take 3 minutes to focus on your breath.',
          'icon': Icons.self_improvement,
          'color': const Color(0xFFFFD54F),
          'detail': 'Build awareness and calm.',
        },
        {
          'title': 'Gratitude Practice',
          'description': 'Write down 3 things you\'re grateful for.',
          'icon': Icons.edit_note,
          'color': const Color(0xFF81C784),
          'detail': 'Shift your focus to the positive.',
        },
        {
          'title': 'Hydrate & Nourish',
          'description': 'Drink water and have a snack.',
          'icon': Icons.local_drink,
          'color': const Color(0xFF64B5F6),
          'detail': 'Physical care matters.',
        },
        {
          'title': 'Check In With Yourself',
          'description': 'What do I need right now?',
          'icon': Icons.question_answer,
          'color': const Color(0xFFFFAB91),
          'detail': 'Listen to yourself.',
        },
      ],
      'wonderful': [
        {
          'title': 'Savor This Moment',
          'description': 'Pause and experience this feeling.',
          'icon': Icons.celebration,
          'color': const Color(0xFFFFD740),
          'detail': 'Savoring positive moments helps them last.',
        },
        {
          'title': 'Share Your Joy',
          'description': 'Spread positivity with someone.',
          'icon': Icons.volunteer_activism,
          'color': const Color(0xFFFF4081),
          'detail': 'Sharing joy amplifies it.',
        },
        {
          'title': 'Capture the Moment',
          'description': 'Journal about this wonderful time.',
          'icon': Icons.create,
          'color': const Color(0xFF69F0AE),
          'detail': 'Understanding your joy helps you recreate it.',
        },
        {
          'title': 'Build Momentum',
          'description': 'Channel this energy into a goal.',
          'icon': Icons.rocket_launch,
          'color': const Color(0xFF9575CD),
          'detail': 'Use this feeling for meaningful action.',
        },
      ],
      'good': [
        {
          'title': 'Creative Expression',
          'description': 'Do something creative.',
          'icon': Icons.palette,
          'color': const Color(0xFFBA68C8),
          'detail': 'Creativity boosts wellbeing.',
        },
        {
          'title': 'Physical Activity',
          'description': 'Enjoy some movement.',
          'icon': Icons.fitness_center,
          'color': const Color(0xFF66BB6A),
          'detail': 'Activity amplifies positive emotions.',
        },
        {
          'title': 'Quality Connection',
          'description': 'Spend time with people you care about.',
          'icon': Icons.people,
          'color': const Color(0xFF42A5F5),
          'detail': 'Social time enhances mood.',
        },
        {
          'title': 'Learn Something New',
          'description': 'Explore a topic you like.',
          'icon': Icons.school,
          'color': const Color(0xFFFFCA28),
          'detail': 'Growth feels rewarding.',
        },
      ],
    };

    return resources[mood.toLowerCase()] ?? resources['neutral']!;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color startColor = Color(0xFFC8E6F0);
  static const Color endColor = Color(0xFFE8F6D6);

  List<Map<String, dynamic>> _resources = [];
  String? _currentMood;
  String _fetchedQuote = "Log your mood to see today's personalized insight.";
  String? _fetchedVideoUrl;
  List<double> _moodData = [0, 0, 0, 0, 0, 0, 0];
  Map<String, dynamic> _metrics = {};
  int _forumNotificationCount = 0;
  StreamSubscription<QuerySnapshot>? _forumListener;

  @override
  void initState() {
    super.initState();
    _loadResources(initial: true);
    _loadMoodTrend();
    _loadMetrics();
    _listenToForumPosts();
  }

  Future<void> _listenToForumPosts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _forumListener = FirebaseFirestore.instance
        .collection('forum_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
      
      final otherUsersPosts = snapshot.docs
          .where((doc) {
            final timestamp = doc['timestamp'];
            if (timestamp is Timestamp) {
              return timestamp.toDate().isAfter(oneHourAgo) && 
                     (doc['userId'] ?? '') != user.uid;
            }
            return false;
          })
          .length;
      
      setState(() => _forumNotificationCount = otherUsersPosts);
    });
  }

  Future<void> _loadMoodTrend() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('mood_logs')
          .where('timestamp', isGreaterThanOrEqualTo: sevenDaysAgo)
          .orderBy('timestamp')
          .get();

      final moodValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
      for (var doc in snapshot.docs) {
        final mood = doc['mood'] as String?;
        final date = doc['date'] as String?;
        if (date != null) {
          final dateObj = DateTime.parse(date);
          final dayIndex = now.difference(dateObj).inDays;
          if (dayIndex >= 0 && dayIndex < 7) {
            moodValues[6 - dayIndex] = _moodToValue(mood ?? 'neutral');
          }
        }
      }

      setState(() => _moodData = moodValues);
    } catch (e) {
      print('Error loading mood trend: $e');
    }
  }

  double _moodToValue(String mood) {
    switch (mood.toLowerCase()) {
      case 'wonderful':
        return 5.0;
      case 'good':
        return 4.0;
      case 'neutral':
        return 3.0;
      case 'sad':
        return 2.0;
      case 'awful':
        return 1.0;
      default:
        return 3.0;
    }
  }

  Future<void> _loadMetrics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      final journalSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('journal_entries')
          .where('timestamp', isGreaterThanOrEqualTo: sevenDaysAgo)
          .get();

      setState(() {
        _metrics = {
          'journalEntries': journalSnapshot.docs.length,
          'journalConsistency': journalSnapshot.docs.length > 4 ? 'High' : 'Medium',
        };
      });
    } catch (e) {
      print('Error loading metrics: $e');
    }
  }

  void _loadResources({bool initial = false}) async {
    setState(() {
      _currentMood = _lastLoggedMood;
      if (_currentMood != null) {
        _resources = MentalHealthService.getDefaultResources(_currentMood!);
        _fetchedVideoUrl = MentalHealthService.getYoutubeUrl(_currentMood!);
      }
      if (!initial && _currentMood != null) {
        _fetchedQuote = "Loading a motivational quote...";
      }
    });

    if (_currentMood != null) {
      String quote = await MentalHealthService.fetchQuote(_currentMood!);
      if (mounted) {
        setState(() => _fetchedQuote = quote);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  
                  // Forum Notification Banner
                  if (_forumNotificationCount > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepOrange.shade200, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.forum, color: Colors.deepOrange.shade600, size: 24),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Forum Posts',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange.shade800,
                                  ),
                                ),
                                Text(
                                  '$_forumNotificationCount new post${_forumNotificationCount > 1 ? 's' : ''} from other users',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.deepOrange.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ForumScreen(),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('View', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),

                  const Text('How are you feeling today?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF333333))),
                  const SizedBox(height: 40),
                  _DashboardMoodRow(onMoodTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodLoggingScreen()),
                    );
                    _loadResources();
                    _loadMoodTrend();
                    _loadMetrics();
                  }),
                  const SizedBox(height: 20),
                  Text(_getMoodMessage(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF555555))),
                  const SizedBox(height: 40),
                  _DailyInsightCard(text: "💡 Daily Insight: \"$_fetchedQuote\""),
                  const SizedBox(height: 40),
                  if (_currentMood != null && _resources.isNotEmpty && _fetchedVideoUrl != null) ...[
                    _VideoContentCard(mood: _currentMood!, videoUrl: _fetchedVideoUrl!, title: 'Video Recommended for You'),
                    const SizedBox(height: 40),
                    const _SectionHeader(title: '🌟 Actionable Resources'),
                    const SizedBox(height: 15),
                    ..._resources.map((resource) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResourceCard(
                        title: resource['title'] as String,
                        description: resource['description'] as String,
                        icon: resource['icon'] as IconData,
                        color: resource['color'] as Color,
                        onTap: () => _showResourceDetail(context, resource),
                      ),
                    )),
                    const SizedBox(height: 40),
                  ],
                  const _ActionButtonsRow(),
                  const SizedBox(height: 40),
                  const _SectionHeader(title: 'Reflection and Tracking'),
                  const SizedBox(height: 15),
                  _MoodTrendCard(moodData: _moodData),
                  const SizedBox(height: 15),
                  _MetricCard(
                    title: 'Journal Consistency',
                    icon: Icons.book_outlined,
                    color: const Color(0xFF5B9BD5),
                    content: 'You have written ${_metrics['journalEntries'] ?? 0} times this week.',
                  ),
                  const SizedBox(height: 15),
                  const _CallToReflectionCard(),
                  const SizedBox(height: 30),
                  const _SectionHeader(title: 'Discovery and Resources'),
                  const SizedBox(height: 15),
                  const _EducationalContentCarousel(),
                  const SizedBox(height: 15),
                  const _MeditationTimerCard(),
                  const SizedBox(height: 15),
                  const _CommunityCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _forumListener?.cancel();
    super.dispose();
  }

  String _getMoodMessage() {
    if (_currentMood == null) return "Tap a mood icon to log how you're feeling";
    switch (_currentMood!.toLowerCase()) {
      case 'wonderful':
        return "You're feeling wonderful! ✨";
      case 'good':
        return "You're doing great! ⭐";
      case 'neutral':
        return "Taking it one step at a time 🌱";
      case 'sad':
        return "It's okay to not be okay 💙";
      case 'awful':
        return "We're here for you 🫂";
      default:
        return "You're doing great!";
    }
  }

  void _showResourceDetail(BuildContext context, Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (resource['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(resource['icon'] as IconData, color: resource['color'] as Color, size: 32),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(resource['title'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(resource['detail'] as String, style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF555555))),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: resource['color'] as Color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Got it', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============== MOOD LOGGING SCREEN ==============

class MoodLoggingScreen extends StatefulWidget {
  const MoodLoggingScreen({super.key});

  @override
  State<MoodLoggingScreen> createState() => _MoodLoggingScreenState();
}

class _MoodLoggingScreenState extends State<MoodLoggingScreen> {
  final List<String> emotions = ['Happy', 'Calm', 'Relaxed', 'Tired', 'Stressed', 'Anxious', 'Thankful', 'Frustrated', 'Hopeful', 'Lonely', 'Joyful', 'Angry'];
  String? _selectedMoodScale;
  final Set<String> _selectedEmotions = {};
  final Map<String, Color> moodScale = {
    'Wonderful': const Color(0xFFE8F6D6),
    'Good': const Color(0xFF90EE90),
    'Neutral': Colors.yellow.shade300,
    'Sad': const Color(0xFFADD8E6),
    'Awful': const Color(0xFFF08080),
  };

  void _selectMoodScale(String mood) => setState(() => _selectedMoodScale = mood);
  void _toggleEmotion(String emotion) => setState(() => _selectedEmotions.contains(emotion) ? _selectedEmotions.remove(emotion) : _selectedEmotions.add(emotion));

  Future<void> _logMood() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _selectedMoodScale == null) return;

    try {
      final now = DateTime.now();
      final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('mood_logs')
          .add({
        'mood': _selectedMoodScale,
        'emotions': _selectedEmotions.toList(),
        'timestamp': FieldValue.serverTimestamp(),
        'date': dateStr,
      });

      _lastLoggedMood = _selectedMoodScale;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood logged: $_selectedMoodScale. Check your dashboard for personalized resources!'),
            backgroundColor: const Color(0xFF4CAF50),
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error logging mood: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFF5B9BD5))),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFC8E6F0), Color(0xFFE8F6D6)])),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))]),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('How are you feeling right now?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: moodScale.entries.map((entry) {
                      final isSelected = _selectedMoodScale == entry.key;
                      return GestureDetector(
                        onTap: () => _selectMoodScale(entry.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? entry.value.darken(0.2) : entry.value,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected ? Border.all(color: Colors.black54, width: 2) : null,
                            boxShadow: isSelected ? [BoxShadow(color: entry.value.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 2))] : null,
                          ),
                          child: Text(entry.key, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 14)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  const Text('What emotions are you experiencing?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: emotions.map((emotion) {
                      final isSelected = _selectedEmotions.contains(emotion);
                      return ActionChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              emotion,
                              style: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFF5B9BD5),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (isSelected) const SizedBox(width: 4),
                            if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16),
                          ],
                        ),
                        backgroundColor: isSelected ? const Color(0xFF5B9BD5) : const Color(0xFFC0D9F6).withOpacity(0.5),
                        onPressed: () => _toggleEmotion(emotion),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedMoodScale != null ? _logMood : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B9BD5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Log mood', style: TextStyle(fontSize: 18)),
                    ),
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

extension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

// ============== DASHBOARD WIDGETS ==============

class _DashboardMoodRow extends StatelessWidget {
  final VoidCallback onMoodTap;

  const _DashboardMoodRow({required this.onMoodTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _DashboardMoodButton(Icons.sentiment_very_satisfied, const Color(0xFF4CAF50), onMoodTap),
        _DashboardMoodButton(Icons.sentiment_satisfied, const Color(0xFF8BC34A), onMoodTap),
        _DashboardMoodButton(Icons.sentiment_neutral, const Color(0xFFFFEB3B), onMoodTap),
        _DashboardMoodButton(Icons.sentiment_dissatisfied, const Color(0xFF2196F3), onMoodTap),
        _DashboardMoodButton(Icons.sentiment_very_dissatisfied, const Color(0xFF5B9BD5), onMoodTap),
      ],
    );
  }
}

class _DashboardMoodButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardMoodButton(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, child: Icon(icon, color: color, size: 38));
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) =>
      Align(alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF444444))));
}

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow();

  @override
  Widget build(BuildContext context) {
    final rootState = context.findAncestorStateOfType<_RootScreenState>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(title: 'Journal', icon: Icons.edit_note, color: const Color(0xFFC0D9F6), onTap: () => rootState?._onItemTapped(1)),
        _ActionButton(title: 'Meditations', icon: Icons.self_improvement, color: const Color(0xFFC9F0C9), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scroll down for meditation timer...')))),
        _ActionButton(title: 'Professional Help', icon: Icons.medical_services_outlined, color: const Color(0xFFE0C0F8), onTap: () => rootState?._onItemTapped(2)),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 120,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 5, offset: const Offset(0, 3))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 30, color: Colors.black54), const SizedBox(height: 8), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))]),
      ),
    );
  }
}

class _DailyInsightCard extends StatelessWidget {
  final String text;

  const _DailyInsightCard({required this.text});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
    child: Text(text, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF444444)), textAlign: TextAlign.center),
  );
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ResourceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555))),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 13, color: Color(0xFF777777))),
                  const SizedBox(height: 4),
                  const Text('Tap to learn more', style: TextStyle(fontSize: 12, color: Color(0xFF999999), fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _VideoContentCard extends StatelessWidget {
  final String mood;
  final String videoUrl;
  final String title;

  const _VideoContentCard({required this.mood, required this.videoUrl, required this.title});

  Future<void> _launchUrl() async {
    final uri = Uri.parse(videoUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $videoUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _launchUrl,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: Colors.red.shade400, width: 4)),
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.ondemand_video, color: Colors.red.shade400, size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF555555))),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('A customized video recommendation for when you feel ${mood.toLowerCase()}.', style: const TextStyle(fontSize: 14, color: Color(0xFF777777))),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Tap to watch on YouTube', style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontStyle: FontStyle.italic)),
                const SizedBox(width: 4),
                Icon(Icons.open_in_new, size: 14, color: Colors.blue.shade700),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoodTrendCard extends StatelessWidget {
  final List<double> moodData;

  const _MoodTrendCard({required this.moodData});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF4DB8B8), width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Color(0xFF4DB8B8), size: 28),
              SizedBox(width: 15),
              Text('Mood Trend (7 Days)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = (moodData[index] / 5) * 100;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(width: 30, height: height, decoration: BoxDecoration(color: const Color(0xFF4DB8B8), borderRadius: BorderRadius.circular(4))),
                    const SizedBox(height: 4),
                    Text(days[index], style: const TextStyle(fontSize: 10, color: Color(0xFF777777))),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          const Text('↑ 15% improvement this week', style: TextStyle(fontSize: 13, color: Color(0xFF4DB8B8), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title, content;
  final IconData icon;
  final Color color;

  const _MetricCard({required this.title, required this.content, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555))),
                const SizedBox(height: 4),
                Text(content, style: const TextStyle(fontSize: 13, color: Color(0xFF777777)), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CallToReflectionCard extends StatelessWidget {
  const _CallToReflectionCard();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.lightBlue.shade200)),
    child: const Text('✨ Call to Reflection: See how your sleep correlates with your mood.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF5B9BD5))),
  );
}

class _EducationalContentCarousel extends StatelessWidget {
  const _EducationalContentCarousel();

  void _showArticle(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Text(content, style: const TextStyle(fontSize: 14, height: 1.5))),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final articles = [
      {'title': 'Cognitive Distortions', 'icon': Icons.lightbulb_outline, 'color': Colors.amber.shade400, 'content': 'Cognitive distortions are patterns of thinking that reinforce negative thoughts. Common examples: All-or-nothing thinking, Overgeneralization, Mental filtering, Jumping to conclusions. Recognizing these patterns helps develop healthier thought processes.'},
      {'title': 'Sleep Hygiene Tips', 'icon': Icons.hotel_outlined, 'color': Colors.blueGrey.shade400, 'content': 'Better sleep hygiene improves mood: Consistent sleep schedule, Cool dark bedroom, Avoid screens before bed, No caffeine after 2PM, Regular exercise. Quality sleep is essential for mental health.'},
      {'title': 'Self-Compassion', 'icon': Icons.favorite_border, 'color': Colors.red.shade400, 'content': 'Self-compassion means treating yourself with kindness: Acknowledge your feelings, Be understanding with yourself, Remember everyone struggles, Practice positive self-talk. This builds emotional resilience.'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Padding(
            padding: EdgeInsets.only(right: index == articles.length - 1 ? 0 : 15),
            child: InkWell(
              onTap: () => _showArticle(context, article['title'] as String, article['content'] as String),
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (article['color'] as Color).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(article['icon'] as IconData, color: Colors.black87, size: 24),
                        const SizedBox(width: 8),
                        Expanded(child: Text(article['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2)),
                      ],
                    ),
                    const Text('Tap to read', style: TextStyle(fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MeditationTimerCard extends StatelessWidget {
  const _MeditationTimerCard();

  void _showTimerDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const _MeditationTimerDialog());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimerDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFC9F0C9).withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.spa_outlined, color: Colors.black87, size: 24),
                SizedBox(width: 8),
                Expanded(child: Text('Guided Practice: Forest Walk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
              ],
            ),
            const SizedBox(height: 12),
            const Text('10-minute meditation to ground yourself.', style: TextStyle(fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 8),
            Text('Tap to start timer', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

class _MeditationTimerDialog extends StatefulWidget {
  const _MeditationTimerDialog();

  @override
  State<_MeditationTimerDialog> createState() => _MeditationTimerDialogState();
}

class _MeditationTimerDialogState extends State<_MeditationTimerDialog> {
  Timer? _timer;
  int _secondsRemaining = 600;
  bool _isRunning = false;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Meditation complete! Great job!')));
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 600;
      _isRunning = false;
    });
  }

  String get _timeDisplay {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F6E8), Color(0xFFC9F0C9)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.spa, color: Color(0xFF4CAF50), size: 32),
                SizedBox(width: 12),
                Expanded(child: Text('Forest Walk Meditation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)))),
              ],
            ),
            const SizedBox(height: 24),
            Text(_timeDisplay, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  const _CommunityCard();

  @override
  Widget build(BuildContext context) {
    final rootState = context.findAncestorStateOfType<_RootScreenState>();
    return InkWell(
      onTap: () => rootState?._onItemTapped(3),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE0C0F8).withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.forum_outlined, color: Colors.black87, size: 24),
                SizedBox(width: 8),
                Expanded(child: Text('Community: Trending Topic', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Dealing with Burnout: 15 supportive replies', style: TextStyle(fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 8),
            Text('Tap to join the conversation', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}