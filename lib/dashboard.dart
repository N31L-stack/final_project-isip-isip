import 'package:flutter/material.dart';
import 'resources.dart'; // <<< IMPORTED THE NEW FILE

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Isip-Isip App',
      theme: ThemeData(
        // Defining the primary calm colors
        primaryColor: const Color(0xFF5B9BD5), // Main blue tone
        hintColor: const Color(0xFF4DB8B8), // Teal/cyan tone
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}

// --- 1. ROOT SCREEN WITH 5-TAB NAVIGATION (Controls the bottom bar) ---
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  // Placeholder Screens for the Navigation Bar
  late final List<Widget> _widgetOptions = <Widget>[
    const DashboardScreen(), // Index 0: Home/Dashboard
    const Center(child: Text('Journal Module')), // Index 1: Journal
    const ResourcesScreen(), // Index 2: Resources (Now loaded from resources.dart)
    const Center(child: Text('Community Forum')), // Index 3: Forum
    const Center(child: Text('Settings & Metrics')), // Index 4: Settings
  ];

  // Function to change the selected index
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

// --- 2. THE DASHBOARD SCREEN (Central Hub) ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Gradient colors from the image
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
                  // --- ZONE 1: IMMEDIATE ACTION (Top visible area) ---
                  const SizedBox(height: 50),

                  // Mood Check-in Question
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // **FIXED COMPONENT:** Dashboard Mood Selection Icons row
                  const _DashboardMoodRow(),
                  const SizedBox(height: 20),

                  // Encouragement Text
                  const Text(
                    "You're doing great!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 80),

                  // Action Buttons Row (Journal, Meditations, Professional Help)
                  const _ActionButtonsRow(),
                  const SizedBox(height: 40),

                  // Daily Insight Card
                  const _DailyInsightCard(text: "Daily Insight: \"The only way out is through.\""),
                  const SizedBox(height: 40),

                  // --- ZONE 2: PERSONAL METRICS (Reflection and Tracking) ---
                  const _SectionHeader(title: 'Reflection and Tracking'),
                  const SizedBox(height: 15),

                  const _MetricCard(
                    title: 'Mood Trend (7 Days)',
                    icon: Icons.trending_up,
                    color: Color(0xFF4DB8B8), // Teal/cyan hintColor
                    content: 'Your overall mood trend has improved by 15% this week.',
                  ),
                  const SizedBox(height: 15),

                  const _MetricCard(
                    title: 'Journal Consistency',
                    icon: Icons.book_outlined,
                    color: Color(0xFF5B9BD5), // Primary blue
                    content: 'You have written 3 times this week. Streak: 5 days.',
                  ),
                  const SizedBox(height: 15),

                  // Call to Reflection
                  const _CallToReflectionCard(),

                  // --- ZONE 3: DISCOVERY AND RESOURCES (Exploration) ---
                  const SizedBox(height: 30),
                  const _SectionHeader(title: 'Discovery and Resources'),
                  const SizedBox(height: 15),

                  // Featured Educational Content (Horizontal Carousel)
                  const _EducationalContentCarousel(),
                  const SizedBox(height: 15),

                  // Guided Practice Highlight
                  const _ResourceCard(
                    title: 'Guided Practice: Forest Walk',
                    subtitle: '10-minute meditation to ground yourself.',
                    icon: Icons.spa_outlined,
                    color: Color(0xFFC9F0C9), // Light green
                  ),
                  const SizedBox(height: 15),

                  // Community Forum Snippet
                  const _ResourceCard(
                    title: 'Community: Trending Topic',
                    subtitle: 'Dealing with Burnout: 15 supportive replies.',
                    icon: Icons.forum_outlined,
                    color: Color(0xFFE0C0F8), // Light purple
                  ),

                  const SizedBox(height: 30), // Extra space for bottom nav bar padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 3. MOOD LOGGING SCREEN (Detailed screen for emotion tags) ---
// Kept in main.dart as it's tightly integrated with the Dashboard check-in
class MoodLoggingScreen extends StatefulWidget {
  final String? initialMood;

  const MoodLoggingScreen({super.key, this.initialMood});

  @override
  State<MoodLoggingScreen> createState() => _MoodLoggingScreenState();
}

class _MoodLoggingScreenState extends State<MoodLoggingScreen> {
  // Mock data for emotions, including the typos 'Frustafutal' and 'Urey' from the image
  final List<String> emotions = [
    'Happy', 'Calm', 'Relaxed', 'Tired',
    'Stressed', 'Anxious', 'Thankful',
    'Frustrated', 'Hopeful', 'Lonely',
    'Joyful', 'Frustafutal', 'Urey',
  ];

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

  void _selectMoodScale(String mood) {
    setState(() {
      _selectedMoodScale = mood;
    });
  }

  void _toggleEmotion(String emotion) {
    setState(() {
      if (_selectedEmotions.contains(emotion)) {
        _selectedEmotions.remove(emotion);
      } else {
        _selectedEmotions.add(emotion);
      }
    });
  }

  void _logMood() {
    final message = 'Logged Mood: $_selectedMoodScale. Emotions: ${_selectedEmotions.join(', ')}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    const Color startColor = Color(0xFFC8E6F0);
    const Color endColor = Color(0xFFE8F6D6);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5B9BD5)),
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView( 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Mood Scale Question 
                  const Text(
                    'How ar you feeling right now?', // Kept typo for accuracy
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 2. Mood Scale Selection Row 
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 10.0,
                    alignment: WrapAlignment.center,
                    children: [
                      // Mood Faces
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sentiment_satisfied_alt, color: const Color(0xFF90EE90), size: 38),
                          const SizedBox(width: 35),
                          Icon(Icons.sentiment_dissatisfied, color: Colors.yellow.shade600, size: 38),
                          const SizedBox(width: 35),
                          Icon(Icons.sentiment_dissatisfied, color: const Color(0xFFADD8E6), size: 38),
                          const SizedBox(width: 35),
                          Icon(Icons.sentiment_very_dissatisfied, color: const Color(0xFF5B9BD5), size: 38),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Mood Labels (Wrapped for better visual management)
                      ...moodScale.entries.map((entry) {
                        final mood = entry.key;
                        final color = entry.value;
                        final isSelected = _selectedMoodScale == mood;
                        return GestureDetector(
                          onTap: () => _selectMoodScale(mood),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? color.darken(0.3) : color,
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected ? Border.all(color: Colors.black54, width: 1.5) : null,
                            ),
                            child: Text(
                              mood,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 3. Emotion Tag Question 
                  const Text(
                    'What emotions yoru experiening?', // Kept typo for accuracy
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // 4. Emotion Tag Selection Grid
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
                                color: isSelected ? Colors.white : const Color(0xFF5B9BD5).darken(0.1),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16),
                          ],
                        ),
                        backgroundColor: isSelected ? const Color(0xFF5B9BD5) : const Color(0xFFC0D9F6).withOpacity(0.5),
                        onPressed: () => _toggleEmotion(emotion),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide.none,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // 5. Log Mood Button
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

// Extension to darken colors for contrast (used in the MoodLoggingScreen)
extension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

// --- SHARED WIDGETS (Kept in main.dart) ---

class _DashboardMoodRow extends StatelessWidget {
  const _DashboardMoodRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Happy/Wonderful (Green)
        _DashboardMoodButton(
          Icons.sentiment_satisfied_alt, 
          const Color(0xFF90EE90),
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MoodLoggingScreen(initialMood: 'Wonderful')),
            );
          },
        ),
        // Neutral/Good (Light Yellow)
        _DashboardMoodButton(
          Icons.horizontal_rule, 
          const Color(0xFFF0E68C),
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MoodLoggingScreen(initialMood: 'Good')),
            );
          },
        ),
        // Sad/Neutral (Orange)
        _DashboardMoodButton(
          Icons.horizontal_rule, 
          Colors.orange.shade300,
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MoodLoggingScreen(initialMood: 'Neutral')),
            );
          },
        ),
        // Down/Sad (Faded Blue)
        _DashboardMoodButton(
          Icons.sentiment_dissatisfied, 
          const Color(0xFFADD8E6),
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MoodLoggingScreen(initialMood: 'Sad')),
            );
          },
        ),
        // Awful/Crisis (Darker Blue)
        _DashboardMoodButton(
          Icons.sentiment_very_dissatisfied, 
          const Color(0xFF5B9BD5),
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MoodLoggingScreen(initialMood: 'Awful')),
            );
          },
        ),
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 38,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF444444),
        ),
      ),
    );
  }
}

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final rootState = context.findAncestorStateOfType<_RootScreenState>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Journal
        _ActionButton(
          title: 'Journal',
          icon: Icons.edit_note,
          color: const Color(0xFFC0D9F6), // Light Blue
          onTap: () {
            rootState?._onItemTapped(1);
          },
        ),
        // Meditations
        _ActionButton(
          title: 'Meditations',
          icon: Icons.self_improvement,
          color: const Color(0xFFC9F0C9), // Light Green
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Starting Quick Meditation...')),
            );
          },
        ),
        // Professional Help
        _ActionButton(
          title: 'Professional Help',
          icon: Icons.medical_services_outlined,
          color: const Color(0xFFE0C0F8), // Light Purple
          onTap: () {
            rootState?._onItemTapped(2);
          },
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: 120,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyInsightCard extends StatelessWidget {
  final String text;

  const _DailyInsightCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFF444444)),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _MetricCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555)),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CallToReflectionCard extends StatelessWidget {
  const _CallToReflectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.lightBlue.shade200),
      ),
      child: const Text(
        '✨ Call to Reflection: See how your sleep correlates with your mood.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF5B9BD5),
        ),
      ),
    );
  }
}

class _EducationalContentCarousel extends StatelessWidget {
  const _EducationalContentCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for rotating educational content
    final List<Map<String, dynamic>> contentList = [
      {'title': 'What are Cognitive Distortions?', 'icon': Icons.lightbulb_outline, 'color': Colors.amber.shade400},
      {'title': 'Tips for Better Sleep Hygiene', 'icon': Icons.hotel_outlined, 'color': Colors.blueGrey.shade400},
      {'title': 'The Power of Self-Compassion', 'icon': Icons.favorite_border, 'color': Colors.red.shade400},
    ];

    return SizedBox(
      height: 120, // Height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          final item = contentList[index];
          return Padding(
            padding: EdgeInsets.only(right: index == contentList.length - 1 ? 0 : 15),
            child: _ResourceCard(
              key: ValueKey(item['title']),
              title: item['title'] as String,
              subtitle: 'Read the full article now.',
              icon: item['icon'] as IconData,
              color: item['color'] as Color,
              width: 180, // Fixed width for carousel items
            ),
          );
        },
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double? width;

  const _ResourceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    const Color contrastColor = Colors.black87;

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on $title')),
        );
      },
      child: Container(
        width: width ?? double.infinity,
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: contrastColor, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: contrastColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: contrastColor),
            ),
          ],
        ),
      ),
    );
  }
}