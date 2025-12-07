import 'package:flutter/material.dart';
import 'dart:async';
import 'professionals.dart';
import 'forum.dart'; // ADD: use ForumScreen from forum.dart
import 'settings.dart'; // ADD
import 'journal.dart';

// --- 1. ROOT SCREEN WITH 5-TAB NAVIGATION ---
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
  const DashboardScreen(),               // 0
  const JournalScreen(),                 // 1 
  const ProfessionalPage(),              // 2
  const ForumContent(),                  // 3
  const SettingsScreen(),                // 4
];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.forum_outlined), label: 'Forum'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'), // ADD
        ],
      ),
    );
  }
}

// --- 2. DASHBOARD SCREEN ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color startColor = Color(0xFFC8E6F0);
  static const Color endColor = Color(0xFFE8F6D6);

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
                  const Text('How are you feeling today?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF333333))),
                  const SizedBox(height: 40),
                  const _DashboardMoodRow(),
                  const SizedBox(height: 20),
                  const Text("You're doing great!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF555555))),
                  const SizedBox(height: 80),
                  const _ActionButtonsRow(),
                  const SizedBox(height: 40),
                  const _DailyInsightCard(text: "Daily Insight: \"The only way out is through.\""),
                  const SizedBox(height: 40),
                  const _SectionHeader(title: 'Reflection and Tracking'),
                  const SizedBox(height: 15),
                  const _MoodTrendCard(),
                  const SizedBox(height: 15),
                  const _MetricCard(title: 'Journal Consistency', icon: Icons.book_outlined, color: Color(0xFF5B9BD5), content: 'You have written 3 times this week. Streak: 5 days.'),
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
}

// --- 3. MOOD LOGGING SCREEN ---
class MoodLoggingScreen extends StatefulWidget {
  final String? initialMood;
  const MoodLoggingScreen({super.key, this.initialMood});

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

  @override
  void initState() {
    super.initState();
    _selectedMoodScale = widget.initialMood;
  }

  void _selectMoodScale(String mood) => setState(() => _selectedMoodScale = mood);
  void _toggleEmotion(String emotion) => setState(() => _selectedEmotions.contains(emotion) ? _selectedEmotions.remove(emotion) : _selectedEmotions.add(emotion));

  void _logMood() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logged Mood: $_selectedMoodScale. Emotions: ${_selectedEmotions.join(', ')}')));
    Navigator.pop(context);
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: isSelected ? entry.value.darken(0.3) : entry.value, borderRadius: BorderRadius.circular(20), border: isSelected ? Border.all(color: Colors.black54, width: 1.5) : null),
                          child: Text(entry.key, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
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
                        label: Row(mainAxisSize: MainAxisSize.min, children: [Text(emotion, style: TextStyle(color: isSelected ? Colors.white : const Color(0xFF5B9BD5), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)), if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16)]),
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
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5B9BD5), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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

// --- 4. COMMUNITY FORUM SCREEN ---
class CommunityForumScreen extends StatelessWidget {
  const CommunityForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {'title': 'Dealing with Burnout', 'replies': 15, 'time': '2h ago', 'author': 'Sarah M.'},
      {'title': 'How do you practice self-care?', 'replies': 23, 'time': '4h ago', 'author': 'Alex K.'},
      {'title': 'Managing anxiety at work', 'replies': 31, 'time': '5h ago', 'author': 'Jordan P.'},
      {'title': 'Sleep tips that actually work', 'replies': 18, 'time': '1d ago', 'author': 'Emily R.'},
      {'title': 'Celebrating small wins today', 'replies': 42, 'time': '1d ago', 'author': 'Mike T.'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Community Forum kuno ah'), backgroundColor: const Color(0xFF5B9BD5), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForumThreadPage(
                    title: topic['title'] as String,
                    author: topic['author'] as String,
                    time: topic['time'] as String,
                    replyCount: topic['replies'] as int,
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]),
              child: Row(
                children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFE0C0F8).withOpacity(0.3), shape: BoxShape.circle), child: const Icon(Icons.forum, color: Color(0xFF9575CD))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(topic['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
                        const SizedBox(height: 4),
                        Text('${topic['replies']} replies • ${topic['time']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// FORUM THREAD PAGE
class ForumThreadPage extends StatefulWidget {
  final String title;
  final String author;
  final String time;
  final int replyCount;

  const ForumThreadPage({
    super.key,
    required this.title,
    required this.author,
    required this.time,
    required this.replyCount,
  });

  @override
  State<ForumThreadPage> createState() => _ForumThreadPageState();
}

class _ForumThreadPageState extends State<ForumThreadPage> {
  final TextEditingController _replyController = TextEditingController();
  final List<Map<String, String>> _replies = [];

  @override
  void initState() {
    super.initState();
    // Mock existing replies
    _replies.addAll([
      {'author': 'Jessica L.', 'time': '1h ago', 'message': 'I totally relate to this. Taking regular breaks has really helped me manage my stress levels.'},
      {'author': 'Chris D.', 'time': '2h ago', 'message': 'Have you tried meditation? It made a huge difference for me. Just 10 minutes a day.'},
      {'author': 'Priya S.', 'time': '3h ago', 'message': 'Setting boundaries at work was a game changer. Don\'t be afraid to say no sometimes!'},
      {'author': 'Tom W.', 'time': '4h ago', 'message': 'Thanks for sharing this. It helps to know we\'re not alone in these struggles.'},
      {'author': 'Maria G.', 'time': '5h ago', 'message': 'I recommend talking to a professional. They can provide personalized strategies that really work.'},
    ]);
  }

  void _postReply() {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      _replies.insert(0, {
        'author': 'You',
        'time': 'Just now',
        'message': _replyController.text.trim(),
      });
      _replyController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reply posted!'), backgroundColor: Color(0xFF4CAF50)),
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Thread'),
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Original Post
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFE0C0F8),
                      child: Text(widget.author[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text(widget.author, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Text('• ${widget.time}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'I\'ve been feeling really overwhelmed lately and would love to hear how others cope with similar situations. Any advice would be greatly appreciated!',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Replies Section
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _replies.length,
              itemBuilder: (context, index) {
                final reply = _replies[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: reply['author'] == 'You' ? const Color(0xFFE3F2FD) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: reply['author'] == 'You' ? const Color(0xFF5B9BD5) : Colors.grey.shade300,
                            child: Text(reply['author']![0], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Text(reply['author']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(width: 8),
                          Text('• ${reply['time']}', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reply['message']!,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Reply Input
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF5B9BD5),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _postReply,
                  ),
                ),
              ],
            ),
          ),
        ],
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

// --- WIDGETS ---

class _DashboardMoodRow extends StatelessWidget {
  const _DashboardMoodRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _DashboardMoodButton(Icons.sentiment_satisfied_alt, const Color(0xFF90EE90), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodLoggingScreen(initialMood: 'Wonderful')))),
        _DashboardMoodButton(Icons.horizontal_rule, const Color(0xFFF0E68C), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodLoggingScreen(initialMood: 'Good')))),
        _DashboardMoodButton(Icons.horizontal_rule, Colors.orange.shade300, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodLoggingScreen(initialMood: 'Neutral')))),
        _DashboardMoodButton(Icons.sentiment_dissatisfied, const Color(0xFFADD8E6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodLoggingScreen(initialMood: 'Sad')))),
        _DashboardMoodButton(Icons.sentiment_very_dissatisfied, const Color(0xFF5B9BD5), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodLoggingScreen(initialMood: 'Awful')))),
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
  Widget build(BuildContext context) => Align(alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF444444))));
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
        _ActionButton(title: 'Professional Help', icon: Icons.medical_services_outlined, color: const Color(0xFFE0C0F8), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfessionalPage()))),
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
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]), child: Text(text, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF444444)), textAlign: TextAlign.center));
}

class _MoodTrendCard extends StatelessWidget {
  const _MoodTrendCard();

  @override
  Widget build(BuildContext context) {
    final moodData = [3.0, 3.5, 2.5, 4.0, 4.2, 4.5, 4.8];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: const Border(left: BorderSide(color: Color(0xFF4DB8B8), width: 4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.trending_up, color: Color(0xFF4DB8B8), size: 28), SizedBox(width: 15), Text('Mood Trend (7 Days)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555)))]),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final height = (moodData[index] / 5) * 100;
                return Column(mainAxisAlignment: MainAxisAlignment.end, children: [Container(width: 30, height: height, decoration: BoxDecoration(color: const Color(0xFF4DB8B8), borderRadius: BorderRadius.circular(4))), const SizedBox(height: 4), Text(days[index], style: const TextStyle(fontSize: 10, color: Color(0xFF777777)))]);
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border(left: BorderSide(color: color, width: 4)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))]),
      child: Row(children: [Icon(icon, color: color, size: 28), const SizedBox(width: 15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555))), const SizedBox(height: 4), Text(content, style: const TextStyle(fontSize: 13, color: Color(0xFF777777)), maxLines: 2, overflow: TextOverflow.ellipsis)]))]),
    );
  }
}

class _CallToReflectionCard extends StatelessWidget {
  const _CallToReflectionCard();

  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.lightBlue.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.lightBlue.shade200)), child: const Text('✨ Call to Reflection: See how your sleep correlates with your mood.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF5B9BD5))));
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
      {'title': 'Cognitive Distortions', 'icon': Icons.lightbulb_outline, 'color': Colors.amber.shade400, 'content': 'Cognitive distortions are patterns of thinking that reinforce negative thoughts. Common examples:\n\n• All-or-nothing thinking\n• Overgeneralization\n• Mental filtering\n• Jumping to conclusions\n\nRecognizing these patterns helps develop healthier thought processes.'},
      {'title': 'Sleep Hygiene Tips', 'icon': Icons.hotel_outlined, 'color': Colors.blueGrey.shade400, 'content': 'Better sleep hygiene improves mood:\n\n• Consistent sleep schedule\n• Cool, dark bedroom\n• Avoid screens before bed\n• No caffeine after 2PM\n• Regular exercise\n\nQuality sleep is essential for mental health.'},
      {'title': 'Self-Compassion', 'icon': Icons.favorite_border, 'color': Colors.red.shade400, 'content': 'Self-compassion means treating yourself with kindness:\n\n• Acknowledge your feelings\n• Be understanding with yourself\n• Remember everyone struggles\n• Practice positive self-talk\n\nThis builds emotional resilience.'},
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
                decoration: BoxDecoration(color: (article['color'] as Color).withOpacity(0.4), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(article['icon'] as IconData, color: Colors.black87, size: 24), const SizedBox(width: 8), Expanded(child: Text(article['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2))]), const Text('Tap to read', style: TextStyle(fontSize: 13, color: Colors.black87))]),
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
    showDialog(
      context: context,
      builder: (context) => const _MeditationTimerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showTimerDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFC9F0C9).withOpacity(0.4), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [Icon(Icons.spa_outlined, color: Colors.black87, size: 24), SizedBox(width: 8), Expanded(child: Text('Guided Practice: Forest Walk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)))]),
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
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
        decoration: BoxDecoration(color: const Color(0xFFE0C0F8).withOpacity(0.4), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [Icon(Icons.forum_outlined, color: Colors.black87, size: 24), SizedBox(width: 8), Expanded(child: Text('Community: Trending Topic', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)))]),
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