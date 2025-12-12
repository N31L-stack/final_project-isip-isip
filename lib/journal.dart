// lib/journal.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// --- FIREBASE JOURNAL ENTRY MODEL ---
class FirebaseJournalEntry {
  final String? id;
  final String title;
  final String content;
  final String mood;
  final List<String> tags;
  final Timestamp? timestamp;
  final Timestamp? lastUpdated;

  FirebaseJournalEntry({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
    this.tags = const [],
    this.timestamp,
    this.lastUpdated,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'mood': mood,
      'tags': tags,
      'timestamp': FieldValue.serverTimestamp(),
      'date': _getCurrentDateString(),
    };
  }

  // Convert to JSON for updates
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'content': content,
      'mood': mood,
      'tags': tags,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore document
  factory FirebaseJournalEntry.fromJson(Map<String, dynamic> json, String id) {
    return FirebaseJournalEntry(
      id: id,
      title: json['title'] ?? 'Untitled',
      content: json['content'] ?? '',
      mood: json['mood'] ?? 'Neutral',
      tags: List<String>.from(json['tags'] ?? []),
      timestamp: json['timestamp'] as Timestamp?,
      lastUpdated: json['lastUpdated'] as Timestamp?,
    );
  }

  static String _getCurrentDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}

// --- JOURNAL SERVICE ---
class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get journal entries stream
  Stream<List<FirebaseJournalEntry>> getJournalEntriesStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('journal_entries')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FirebaseJournalEntry.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  // Create journal entry
  Future<void> createJournalEntry(FirebaseJournalEntry entry) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journal_entries')
          .add(entry.toJson());
    } catch (e) {
      print('Error creating journal entry: $e');
      rethrow;
    }
  }

  // Update journal entry
  Future<void> updateJournalEntry(FirebaseJournalEntry entry) async {
    final user = _auth.currentUser;
    if (user == null || entry.id == null) throw Exception('Invalid entry or no user logged in');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journal_entries')
          .doc(entry.id)
          .update(entry.toUpdateJson());
    } catch (e) {
      print('Error updating journal entry: $e');
      rethrow;
    }
  }

  // Delete journal entry
  Future<void> deleteJournalEntry(String id) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('journal_entries')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error deleting journal entry: $e');
      rethrow;
    }
  }
}

// --- JOURNAL SCREEN ---
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalService _journalService = JournalService();
  Stream<List<FirebaseJournalEntry>>? _journalsStream;
  User? _currentUser;
  int _totalEntries = 0;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
        if (user != null) {
          _journalsStream = _journalService.getJournalEntriesStream();
          _loadTotalEntries();
        } else {
          _journalsStream = null;
        }
      });
    });
  }

  Future<void> _loadTotalEntries() async {
    if (_currentUser == null) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('journal_entries')
          .get();
      setState(() => _totalEntries = snapshot.docs.length);
    } catch (e) {
      print('Error loading total entries: $e');
    }
  }

  void _addNewEntry() {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to create a journal entry.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryEditor(
          onSave: (entry) async {
            await _journalService.createJournalEntry(entry);
            await _loadTotalEntries();
          },
        ),
      ),
    );
  }

  void _editEntry(FirebaseJournalEntry entry) {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to edit journal entries.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryEditor(
          entry: entry,
          onSave: (updatedEntry) async {
            await _journalService.updateJournalEntry(updatedEntry);
          },
        ),
      ),
    );
  }

  void _deleteEntry(String id) {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to delete journal entries.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _journalService.deleteJournalEntry(id);
              Navigator.pop(context);
              await _loadTotalEntries();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Journal entry deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC8E6F0), Color(0xFFE8F6D6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Journal',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Entries: $_totalEntries',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B9BD5),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5B9BD5).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white, size: 28),
                        onPressed: _addNewEntry,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _currentUser == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Please log in to view your journals',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _journalsStream == null
                        ? const Center(child: CircularProgressIndicator())
                        : StreamBuilder<List<FirebaseJournalEntry>>(
                            stream: _journalsStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              final entries = snapshot.data ?? [];
                              if (entries.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.book_outlined,
                                        size: 80,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No journal entries yet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                itemCount: entries.length,
                                itemBuilder: (context, index) {
                                  final entry = entries[index];
                                  return JournalEntryCard(
                                    entry: entry,
                                    onTap: () => _editEntry(entry),
                                    onDelete: () => _deleteEntry(entry.id!),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- JOURNAL ENTRY CARD ---
class JournalEntryCard extends StatelessWidget {
  final FirebaseJournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const JournalEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onDelete,
  });

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'wonderful':
        return const Color(0xFF90EE90);
      case 'calm':
      case 'relaxed':
        return const Color(0xFFADD8E6);
      case 'stressed':
      case 'anxious':
        return Colors.orange.shade300;
      case 'sad':
        return const Color(0xFF5B9BD5);
      default:
        return Colors.grey.shade400;
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown Date';
    
    final date = timestamp.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today, ${DateFormat.MMMd().format(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, ${DateFormat.MMMd().format(date)}';
    } else {
      return DateFormat.yMMMEd().format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(entry.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getMoodColor(entry.mood).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          entry.mood,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _getMoodColor(entry.mood),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: onDelete,
                        color: Colors.grey.shade600,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entry.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                entry.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (entry.tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  children: entry.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B9BD5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF5B9BD5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- JOURNAL ENTRY EDITOR ---
class JournalEntryEditor extends StatefulWidget {
  final FirebaseJournalEntry? entry;
  final Future<void> Function(FirebaseJournalEntry) onSave;

  const JournalEntryEditor({
    super.key,
    this.entry,
    required this.onSave,
  });

  @override
  State<JournalEntryEditor> createState() => _JournalEntryEditorState();
}

class _JournalEntryEditorState extends State<JournalEntryEditor> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;
  String _selectedMood = 'Neutral';
  final List<String> _tags = [];
  bool _isSaving = false;

  final List<String> _moods = [
    'Wonderful', 'Happy', 'Calm', 'Neutral', 'Tired', 'Stressed', 'Sad', 'Anxious',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _tagController = TextEditingController();
    _selectedMood = widget.entry?.mood ?? 'Neutral';
    if (widget.entry != null) {
      _tags.addAll(widget.entry!.tags);
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _saveEntry() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a title')),
      );
      return;
    }

    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final entryToSave = FirebaseJournalEntry(
        id: widget.entry?.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        mood: _selectedMood,
        tags: List.from(_tags),
        timestamp: widget.entry?.timestamp,
      );

      await widget.onSave(entryToSave);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Journal entry saved!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) {
      return DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    }
    final date = timestamp.toDate();
    return DateFormat('EEEE, MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
        title: Text(widget.entry == null ? 'New Journal Entry' : 'Edit Entry'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveEntry,
            child: Text(
              _isSaving ? 'Saving...' : 'Save',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC8E6F0), Color(0xFFE8F6D6)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatDate(widget.entry?.timestamp),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Entry Title',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood;
                  return InkWell(
                    onTap: () => setState(() => _selectedMood = mood),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF5B9BD5) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF5B9BD5) : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        mood,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF333333),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: 12,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts here...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tags (optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _tagController,
                        decoration: const InputDecoration(
                          hintText: 'Add a tag',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                        onSubmitted: (_) => _addTag(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Color(0xFF5B9BD5)),
                      onPressed: _addTag,
                    ),
                  ],
                ),
              ),
              if (_tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B9BD5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '#$tag',
                            style: const TextStyle(
                              color: Color(0xFF5B9BD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => _removeTag(tag),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFF5B9BD5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}