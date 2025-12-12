// lib/services/journal_service.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

// Represents a journal entry when interacting with Firebase
class FirebaseJournalEntry {
  final String? id; // Null for new entries, present for existing
  final String title;
  final String content;
  final String mood;
  final num? timestamp; // Use num for Firebase timestamp (milliseconds since epoch)
  final List<String> tags;
  final num? lastUpdated; // Timestamp for when the entry was last updated

  FirebaseJournalEntry({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
    this.timestamp,
    required this.tags,
    this.lastUpdated,
  });

  // Factory constructor to create from a Firebase DataSnapshot
  factory FirebaseJournalEntry.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>?;
    if (data == null) {
      throw Exception("Invalid journal entry snapshot: ${snapshot.key}");
    }
    return FirebaseJournalEntry(
      id: snapshot.key, // The key from the database is the ID
      title: data['title'] as String? ?? 'Untitled',
      content: data['content'] as String? ?? '',
      mood: data['mood'] as String? ?? 'Neutral',
      timestamp: data['timestamp'] as num?,
      tags: List<String>.from(data['tags'] ?? []),
      lastUpdated: data['lastUpdated'] as num?,
    );
  }

  // Convert to JSON for Firebase storage when creating a new entry
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'mood': mood,
      'timestamp': timestamp ?? ServerValue.timestamp, // Set server timestamp on creation
      'tags': tags,
      // lastUpdated is generally not set on initial creation unless specifically needed
    };
  }

  // Convert to JSON for updating existing entries
  // This specifically updates relevant fields and sets a new lastUpdated timestamp
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      'content': content,
      'mood': mood,
      'tags': tags,
      'lastUpdated': ServerValue.timestamp, // Always update 'lastUpdated' on modification
    };
  }
}

class JournalService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _journalsBaseRef = FirebaseDatabase.instance.ref('journals');

  // Helper to get the user-specific journal reference
  DatabaseReference? _getUserJournalsRef() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      // In a real app, you might want to log this or throw a specific exception,
      // or ensure this code path is only called when a user is known to be logged in.
      print("JournalService Error: No user logged in.");
      return null;
    }
    return _journalsBaseRef.child(currentUser.uid);
  }

  // CREATE: Add a new journal entry
  Future<void> createJournalEntry(FirebaseJournalEntry entry) async {
    final userJournalsRef = _getUserJournalsRef();
    if (userJournalsRef == null) return; // Exit if no user logged in

    try {
      // push() generates a unique ID, then set() stores the data
      await userJournalsRef.push().set(entry.toJson());
      print("Journal entry added successfully!");
    } catch (e) {
      print("Error adding journal entry: $e");
    }
  }

  // READ: Get a stream of all journal entries for the current user
  Stream<List<FirebaseJournalEntry>> getJournalEntriesStream() {
    final userJournalsRef = _getUserJournalsRef();
    if (userJournalsRef == null) {
      return Stream.value([]); // Return an empty stream if no user
    }

    // Use onValue to get real-time updates
    return userJournalsRef.onValue.map((event) {
      final List<FirebaseJournalEntry> entries = [];
      if (event.snapshot.exists && event.snapshot.value != null) {
        final Map<dynamic, dynamic> values = event.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          try {
            // Reconstruct FirebaseJournalEntry from each child snapshot
            entries.add(FirebaseJournalEntry.fromSnapshot(event.snapshot.child(key)));
          } catch (e) {
            print("Error parsing journal entry $key: $e");
          }
        });
      }
      // Sort entries by timestamp (newest first)
      entries.sort((a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));
      return entries;
    });
  }

  // READ: Fetch a single journal entry by ID (one-time fetch)
  Future<FirebaseJournalEntry?> getJournalEntryById(String journalId) async {
    final userJournalsRef = _getUserJournalsRef();
    if (userJournalsRef == null) return null;

    try {
      final snapshot = await userJournalsRef.child(journalId).get(); // Use .get() for one-time fetch
      if (snapshot.exists) {
        return FirebaseJournalEntry.fromSnapshot(snapshot);
      }
      return null; // Entry not found
    } catch (e) {
      print("Error fetching journal entry $journalId: $e");
      return null;
    }
  }

  // UPDATE: Modify an existing journal entry
  Future<void> updateJournalEntry(FirebaseJournalEntry entry) async {
    if (entry.id == null) {
      print("JournalService Error: Cannot update entry without an ID. Entry: ${entry.title}");
      return;
    }
    final userJournalsRef = _getUserJournalsRef();
    if (userJournalsRef == null) return;

    try {
      // Use update() to only modify specified fields
      await userJournalsRef.child(entry.id!).update(entry.toUpdateJson());
      print("Journal entry ${entry.id} updated successfully!");
    } catch (e) {
      print("Error updating journal entry: $e");
    }
  }

  // DELETE: Remove a specific journal entry
  Future<void> deleteJournalEntry(String journalId) async {
    final userJournalsRef = _getUserJournalsRef();
    if (userJournalsRef == null) return;

    try {
      await userJournalsRef.child(journalId).remove();
      print("Journal entry $journalId deleted successfully!");
    } catch (e) {
      print("Error deleting journal entry: $e");
    }
  }
}
