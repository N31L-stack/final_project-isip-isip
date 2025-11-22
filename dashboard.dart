import 'package:flutter/material.dart';
import 'dart:async';

// Main function to run the app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5B9BD5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B9BD5)),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}

// --- 1. ROOT SCREEN WITH 5-TAB NAVIGATION ---
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(),
    const Center(child: Text('Journal Module')),
    const ResourcesTabScreen(),
    const CommunityForumScreen(),
    const Center(child: Text('Settings & Metrics')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_outlined), activeIcon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), activeIcon: Icon(Icons.people_alt), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Forum'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        onTap: _onItemTapped,
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

// --- 3. RESOURCES TAB SCREEN ---
class ResourcesTabScreen extends StatefulWidget {
  const ResourcesTabScreen({super.key});

  @override
  State<ResourcesTabScreen> createState() => _ResourcesTabScreenState();
}

class _ResourcesTabScreenState extends State<ResourcesTabScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    print('Building ResourcesTabScreen'); // Debug print
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Resources'),
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CategoryChip('All', _selectedCategory == 'All', () => setState(() => _selectedCategory = 'All')),
                    const SizedBox(width: 8),
                    _CategoryChip('Meditation', _selectedCategory == 'Meditation', () => setState(() => _selectedCategory = 'Meditation')),
                    const SizedBox(width: 8),
                    _CategoryChip('Education', _selectedCategory == 'Education', () => setState(() => _selectedCategory = 'Education')),
                    const SizedBox(width: 8),
                    _CategoryChip('Professional Help', _selectedCategory == 'Professional Help', () => setState(() => _selectedCategory = 'Professional Help')),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meditation Section
                  if (_selectedCategory == 'All' || _selectedCategory == 'Meditation') ...[
                    const _ResourceSectionHeader(title: 'Guided Meditations', icon: Icons.spa),
                    const SizedBox(height: 12),
                    _MeditationResourceCard(
                      title: 'Forest Walk Meditation',
                      duration: '10 min',
                      description: 'Ground yourself with nature sounds and guided breathing.',
                      color: const Color(0xFFC9F0C9),
                      onTap: () => _showMeditationTimer(context, 'Forest Walk Meditation', 600),
                    ),
                    const SizedBox(height: 12),
                    _MeditationResourceCard(
                      title: 'Body Scan Relaxation',
                      duration: '15 min',
                      description: 'Release tension and connect with your body.',
                      color: const Color(0xFFB3E5FC),
                      onTap: () => _showMeditationTimer(context, 'Body Scan Relaxation', 900),
                    ),
                    const SizedBox(height: 12),
                    _MeditationResourceCard(
                      title: 'Breathing Exercise',
                      duration: '5 min',
                      description: 'Quick calming technique for stressful moments.',
                      color: const Color(0xFFFFE082),
                      onTap: () => _showMeditationTimer(context, 'Breathing Exercise', 300),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Educational Content Section
                  if (_selectedCategory == 'All' || _selectedCategory == 'Education') ...[
                    const _ResourceSectionHeader(title: 'Educational Content', icon: Icons.school),
                    const SizedBox(height: 12),
                    _EducationalResourceCard(
                      title: 'Cognitive Distortions',
                      icon: Icons.lightbulb_outline,
                      color: Colors.amber.shade400,
                      content: 'Cognitive distortions are patterns of thinking that reinforce negative thoughts. Common examples:\n\n• All-or-nothing thinking\n• Overgeneralization\n• Mental filtering\n• Jumping to conclusions\n• Catastrophizing\n• Personalization\n\nRecognizing these patterns is the first step to developing healthier thought processes and improving mental wellbeing.',
                    ),
                    const SizedBox(height: 12),
                    _EducationalResourceCard(
                      title: 'Sleep Hygiene Tips',
                      icon: Icons.hotel_outlined,
                      color: Colors.blueGrey.shade400,
                      content: 'Better sleep hygiene improves mood and mental health:\n\n• Maintain a consistent sleep schedule\n• Keep bedroom cool and dark\n• Avoid screens 1 hour before bed\n• No caffeine after 2PM\n• Regular exercise (but not before bed)\n• Limit daytime naps to 20 minutes\n• Create a relaxing bedtime routine\n\nQuality sleep is essential for emotional regulation and mental health.',
                    ),
                    const SizedBox(height: 12),
                    _EducationalResourceCard(
                      title: 'Self-Compassion',
                      icon: Icons.favorite_border,
                      color: Colors.red.shade400,
                      content: 'Self-compassion means treating yourself with kindness:\n\n• Acknowledge your feelings without judgment\n• Be understanding with yourself during difficult times\n• Remember that everyone struggles\n• Practice positive self-talk\n• Treat yourself as you would a good friend\n• Accept imperfection as part of being human\n\nSelf-compassion builds emotional resilience and reduces anxiety.',
                    ),
                    const SizedBox(height: 12),
                    _EducationalResourceCard(
                      title: 'Managing Anxiety',
                      icon: Icons.psychology_outlined,
                      color: Colors.purple.shade300,
                      content: 'Practical strategies for managing anxiety:\n\n• Grounding techniques (5-4-3-2-1 method)\n• Progressive muscle relaxation\n• Journaling your worries\n• Regular physical activity\n• Limiting caffeine and alcohol\n• Connecting with supportive people\n• Mindfulness meditation\n\nAnxiety is manageable with the right tools and support.',
                    ),
                    const SizedBox(height: 12),
                    _EducationalResourceCard(
                      title: 'Building Healthy Habits',
                      icon: Icons.fitness_center_outlined,
                      color: Colors.green.shade400,
                      content: 'Small steps to build sustainable healthy habits:\n\n• Start with one habit at a time\n• Make it easy and specific\n• Track your progress\n• Celebrate small wins\n• Be patient with yourself\n• Link new habits to existing routines\n• Focus on consistency over perfection\n\nHealthy habits compound over time to improve overall wellbeing.',
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Professional Help Section
                  if (_selectedCategory == 'All' || _selectedCategory == 'Professional Help') ...[
                    const _ResourceSectionHeader(title: 'Professional Help', icon: Icons.medical_services),
                    const SizedBox(height: 12),
                    _ProfessionalHelpCard(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesScreen())),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMeditationTimer(BuildContext context, String title, int seconds) {
    showDialog(
      context: context,
      builder: (context) => _MeditationTimerDialog(title: title, initialSeconds: seconds),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip(this.label, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5B9BD5) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ResourceSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ResourceSectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5B9BD5), size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}

class _MeditationResourceCard extends StatelessWidget {
  final String title;
  final String duration;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _MeditationResourceCard({
    required this.title,
    required this.duration,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_arrow, size: 32, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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

class _EducationalResourceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  const _EducationalResourceCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });

  void _showContent(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showContent(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to read more',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
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

class _ProfessionalHelpCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ProfessionalHelpCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0C0F8), Color(0xFFC0D9F6)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medical_services, color: Color(0xFF7B1FA2), size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Connect with Professionals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Access therapists, counselors, and mental health professionals who can provide personalized support.',
              style: TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.4),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Browse available resources',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7B1FA2),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.grey.shade700),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- 4. MOOD LOGGING SCREEN ---
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

// --- 5. COMMUNITY FORUM SCREEN ---
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
      appBar: AppBar(title: const Text('Community Forum'), backgroundColor: const Color(0xFF5B9BD5), foregroundColor: Colors.white),
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
        _ActionButton(title: 'Professional Help', icon: Icons.medical_services_outlined, color: const Color(0xFFE0C0F8), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesScreen()))),
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
      builder: (context) => const _MeditationTimerDialog(title: 'Forest Walk Meditation', initialSeconds: 600),
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
  final String title;
  final int initialSeconds;

  const _MeditationTimerDialog({
    this.title = 'Meditation',
    this.initialSeconds = 600,
  });

  @override
  State<_MeditationTimerDialog> createState() => _MeditationTimerDialogState();
}

class _MeditationTimerDialogState extends State<_MeditationTimerDialog> {
  Timer? _timer;
  late int _secondsRemaining;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.initialSeconds;
  }

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
      _secondsRemaining = widget.initialSeconds;
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
            Row(
              children: [
                const Icon(Icons.spa, color: Color(0xFF4CAF50), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                ),
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

// --- RESOURCES SCREEN (PROFESSIONAL HELP) ---
class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Professional Support",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Connect with Licensed Professionals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          _buildProfessionalCard(
            context,
            name: "Dr. Melissa Santos",
            rating: 4.9,
            experience: "12 Years Experience",
            price: "₱1,799/session",
            specialty: "Clinical Psychology",
            color: Colors.blue.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Psychologist Alex Cruz",
            rating: 4.7,
            experience: "8 Years Experience",
            price: "₱1,499/session",
            specialty: "Cognitive Behavioral Therapy",
            color: Colors.purple.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Dr. Anya Sharma",
            rating: 4.9,
            experience: "12 Years Experience",
            price: "₱2,500/session",
            specialty: "Anxiety & Depression",
            color: Colors.green.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Mark Chen, LMFT",
            rating: 4.8,
            experience: "8 Years Experience",
            price: "₱2,000/session",
            specialty: "Marriage & Family Therapy",
            color: Colors.orange.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Sarah Lee, Psy.D.",
            rating: 5.0,
            experience: "15 Years Experience",
            price: "₱3,000/session",
            specialty: "Trauma & PTSD",
            color: Colors.pink.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Dr. James Rodriguez",
            rating: 4.7,
            experience: "10 Years Experience",
            price: "₱3,500/session",
            specialty: "Child & Adolescent",
            color: Colors.cyan.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Emily Thompson",
            rating: 4.9,
            experience: "7 Years Experience",
            price: "₱2,200/session",
            specialty: "Stress Management",
            color: Colors.teal.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Dr. Michael Park",
            rating: 4.8,
            experience: "11 Years Experience",
            price: "₱2,800/session",
            specialty: "Depression & Mood Disorders",
            color: Colors.indigo.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Lisa Martinez, LCSW",
            rating: 4.9,
            experience: "9 Years Experience",
            price: "₱2,400/session",
            specialty: "Life Transitions",
            color: Colors.amber.shade100,
          ),
          const SizedBox(height: 12),
          _buildProfessionalCard(
            context,
            name: "Dr. Robert Kim",
            rating: 4.7,
            experience: "13 Years Experience",
            price: "₱3,200/session",
            specialty: "OCD & Anxiety Disorders",
            color: Colors.lime.shade100,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfessionalCard(
    BuildContext context, {
    required String name,
    required double rating,
    required String experience,
    required String price,
    required String specialty,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.work_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(specialty, style: const TextStyle(fontWeight: FontWeight.w600))),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(experience),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Text('$rating / 5.0'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.payments_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5B9BD5))),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contact this professional to schedule a session and begin your journey to better mental health.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Booking request sent to $name'),
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9BD5),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Book Session'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name[0],
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        experience,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5B9BD5),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B9BD5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5B9BD5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}