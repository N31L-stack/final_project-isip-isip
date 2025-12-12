// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- 1. DATA MODEL FOR A BOOKING ---
class Booking {
  final String id; // The Firestore Document ID (Crucial for cancelling/updating)
  final String professionalName;
  final String date;
  final String time;
  final String sessionType;
  final String status;
  final String fee;

  Booking({
    required this.id,
    required this.professionalName,
    required this.date,
    required this.time,
    required this.sessionType,
    required this.status,
    required this.fee,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      professionalName: data['professionalName'] ?? 'Unknown Professional',
      date: data['date'] ?? 'N/A',
      time: data['time'] ?? 'N/A',
      sessionType: data['sessionType'] ?? 'N/A',
      status: data['status'] ?? 'Pending',
      fee: data['fee'] ?? '₱0/session',
    );
  }
}

// --- 2. USER BOOKINGS PAGE (StatefulWidget for easier refreshing) ---
class UserBookingsPage extends StatefulWidget {
  const UserBookingsPage({super.key});

  @override
  State<UserBookingsPage> createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  // Key to trigger a refresh of the FutureBuilder
  Key _futureKey = UniqueKey();
  
  // Function to fetch bookings for the current user
  Future<List<Booking>> fetchUserBookings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Return an empty list if no user is logged in
      return []; 
    }

    final String clientId = user.uid;

    // Query the 'bookings' collection
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('clientId', isEqualTo: clientId) // Filter by the current user's ID
        .orderBy('timestamp', descending: true) // Sort by the most recent booking
        .get();

    // Map the documents to our Booking model
    return snapshot.docs.map((doc) {
      return Booking.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  // --- NEW: CANCELLATION LOGIC ---
  Future<void> cancelBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'Cancelled'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment successfully cancelled.'),
          backgroundColor: Color(0xFFF44336), // Red for cancellation
        ),
      );

      // Refresh the UI by changing the FutureBuilder's key
      setState(() {
        _futureKey = UniqueKey();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to cancel booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
        title: const Text('My Appointments'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          // Use the key to trigger a refresh when needed (e.g., after cancellation)
          child: FutureBuilder<List<Booking>>(
            key: _futureKey, 
            future: fetchUserBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF5B9BD5)));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading bookings: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 64, color: Color(0xFF5B9BD5)),
                      SizedBox(height: 16),
                      Text(
                        'No appointments booked yet.',
                        style: TextStyle(fontSize: 18, color: Color(0xFF333333)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start by choosing a professional!',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // Display the list of bookings
              final bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  // Pass the cancellation function to the card
                  return BookingCard(
                    booking: booking,
                    onCancel: cancelBooking, 
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- 3. BOOKING CARD WIDGET (MODIFIED to accept onCancel function) ---
class BookingCard extends StatelessWidget {
  final Booking booking;
  final Function(String) onCancel; // Function to call when cancellation is requested

  const BookingCard({
    super.key, 
    required this.booking,
    required this.onCancel,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(0xFF4CAF50); // Green
      case 'Pending':
        return const Color(0xFFFFC107); // Amber
      case 'Cancelled':
        return const Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }

  // Confirmation dialog handler
  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: Text('Are you sure you want to cancel your appointment with ${booking.professionalName} on ${booking.date} at ${booking.time}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, Keep it'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              onCancel(booking.id); // Execute cancellation function
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Color(0xFFF44336))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCancellable = booking.status == 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.professionalName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    color: _getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildDetailRow(Icons.calendar_today, 'Date', booking.date),
          _buildDetailRow(Icons.access_time, 'Time', booking.time),
          _buildDetailRow(Icons.videocam_outlined, 'Type', booking.sessionType),
          _buildDetailRow(Icons.money, 'Fee', booking.fee, isPrice: true),
          
          if (isCancellable)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Cancel Appointment'),
                  onPressed: () => _showCancelConfirmation(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF44336),
                    side: const BorderSide(color: Color(0xFFF44336), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF5B9BD5)),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
                color: isPrice ? const Color(0xFF5B9BD5) : const Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}