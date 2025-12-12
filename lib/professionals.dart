// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// =========================================================================
// --- 1. DATA MODEL CLASS ---
// =========================================================================
class Professional {
  final String id;
  final String name;
  final String role;
  final String specialization;
  final String imageUrl;
  final double rating;
  final String experience;
  final String price;
  final String about;

  Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.price,
    this.about =
        'Licensed mental health professional with extensive experience in evidence-based therapeutic approaches. Committed to providing a safe, supportive environment for personal growth and healing.',
  });

  factory Professional.fromFirestore(Map<String, dynamic> data, String id) {
    return Professional(
      id: id,
      name: data['name'] ?? 'N/A',
      role: data['role'] ?? 'N/A',
      specialization: data['specialization'] ?? 'N/A',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      experience: data['experience'] ?? 'N/A',
      price: data['price'] ?? '₱0/session',
      about: data['about'] ??
          'Licensed mental health professional with extensive experience in evidence-based therapeutic approaches. Committed to providing a safe, supportive environment for personal growth and healing.',
    );
  }
}

// =========================================================================
// --- 2. PROFESSIONAL PAGE (LIST VIEW) ---
// =========================================================================
class ProfessionalPage extends StatelessWidget {
  const ProfessionalPage({super.key});

  Future<List<Professional>> fetchProfessionals() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('professionals').get();
    return snapshot.docs.map((doc) {
      return Professional.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B9BD5)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Find a Professional',
          style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.list_alt, color: Color(0xFF5B9BD5)),
            label: const Text('My Requests', style: TextStyle(color: Color(0xFF5B9BD5))),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientAppointmentStatusScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Professional>>(
            future: fetchProfessionals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5B9BD5)));
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading data: ${snapshot.error}'));
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final professionals = snapshot.data!;
                return ListView.builder(
                  itemCount: professionals.length,
                  itemBuilder: (context, index) {
                    final professional = professionals[index];
                    return ProfessionalCard(professional: professional);
                  },
                );
              }
              return const Center(
                  child: Text(
                      'No professionals found. Please check your Firestore collection.'));
            },
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// --- 3. PROFESSIONAL CARD ---
// =========================================================================
class ProfessionalCard extends StatelessWidget {
  final Professional professional;

  const ProfessionalCard({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessionalDetailPage(
                professional: professional,
              ),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                professional.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        professional.name.isNotEmpty ? professional.name.substring(0, 1) : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B9BD5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    professional.role,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        professional.rating.toString(),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${professional.experience} exp',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// --- 4. PROFESSIONAL DETAIL PAGE ---
// =========================================================================
class ProfessionalDetailPage extends StatelessWidget {
  final Professional professional;

  const ProfessionalDetailPage({super.key, required this.professional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
        title: const Text('Professional Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      professional.imageUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              professional.name.isNotEmpty ? professional.name.substring(0, 1) : '?',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B9BD5),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    professional.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    professional.role,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        professional.rating.toString(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.work_outline,
                          color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        professional.experience,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Specialization',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    professional.specialization,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    professional.about,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Session Fee',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333)),
                      ),
                      Text(
                        professional.price,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B9BD5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RequestProfessionalButton(
                professionalId: professional.id,
                professionalName: professional.name,
                professional: professional,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// --- 5. APPOINTMENT BOOKING PAGE ---
// =========================================================================
class AppointmentBookingPage extends StatefulWidget {
  final Professional professional;

  const AppointmentBookingPage({super.key, required this.professional});

  @override
  State<AppointmentBookingPage> createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  String _selectedType = 'In-Person';

  final List<String> _availableTimes = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  final List<String> _sessionTypes = ['In-Person', 'Video Call', 'Phone Call'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5B9BD5),
              onPrimary: Colors.white,
              onSurface: Color(0xFF333333),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both date and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User not logged in. Cannot confirm booking.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'professionalId': widget.professional.id,
        'professionalName': widget.professional.name,
        'clientId': user.uid,
        'date':
            '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
        'time': _selectedTime,
        'sessionType': _selectedType,
        'fee': widget.professional.price,
        'status': 'Confirmed',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 32),
              SizedBox(width: 12),
              Text('Booking Confirmed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Professional: ${widget.professional.name}'),
              const SizedBox(height: 8),
              Text(
                  'Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              const SizedBox(height: 8),
              Text('Time: $_selectedTime'),
              const SizedBox(height: 8),
              Text('Type: $_selectedType'),
              const SizedBox(height: 8),
              Text('Fee: ${widget.professional.price}'),
              const SizedBox(height: 16),
              Text(
                'You will receive a confirmation email shortly.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to confirm booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.professional.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Session Fee: ${widget.professional.price}',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF5B9BD5),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Session Type',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333)),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _sessionTypes.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  selectedColor: const Color(0xFF5B9BD5),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF333333),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Date',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333)),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF5B9BD5)),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Choose a date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedDate == null
                            ? Colors.grey.shade600
                            : const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Time',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333)),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: _availableTimes.length,
              itemBuilder: (context, index) {
                final time = _availableTimes[index];
                final isSelected = _selectedTime == time;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF5B9BD5) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5B9BD5)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF333333),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B9BD5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Confirm Appointment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// --- 6. REQUEST PROFESSIONAL BUTTON ---
// =========================================================================
class RequestProfessionalButton extends StatefulWidget {
  final String professionalId;
  final String professionalName;
  final Professional professional;

  const RequestProfessionalButton({
    super.key,
    required this.professionalId,
    required this.professionalName,
    required this.professional,
  });

  @override
  State<RequestProfessionalButton> createState() =>
      _RequestProfessionalButtonState();
}

class _RequestProfessionalButtonState extends State<RequestProfessionalButton> {
  bool _isLoading = false;
  String? _requestStatus;

  @override
  void initState() {
    super.initState();
    _checkRequestStatus();
  }

  Future<void> _checkRequestStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('professional_requests')
          .where('clientId', isEqualTo: user.uid)
          .where('professionalId', isEqualTo: widget.professionalId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        if (mounted) {
          setState(() => _requestStatus = data['status'] ?? 'pending');
        }
      } else {
        if (mounted) {
          setState(() => _requestStatus = null);
        }
      }
    } catch (e) {
      debugPrint('Error checking request status: $e');
      if (mounted) {
        setState(() => _requestStatus = null);
      }
    }
  }

  Future<void> _requestProfessional() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to request a professional')),
      );
      return;
    }

    if (_requestStatus != null && _requestStatus != 'rejected') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'A request is already $_requestStatus. Check your requests list.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final clientName = (userDoc.data() as Map<String, dynamic>?)?['displayName'] ??
          user.email ??
          'Unknown Client';

      await FirebaseFirestore.instance.collection('professional_requests').add({
        'clientId': user.uid,
        'clientName': clientName,
        'professionalId': widget.professionalId,
        'professionalName': widget.professionalName,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => _requestStatus = 'pending');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request sent successfully! The professional will review it.'),
            backgroundColor: Color(0xFF5B9BD5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending request: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_requestStatus == 'accepted') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.event_available, size: 20),
          label: const Text('Book Appointment'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentBookingPage(
                  professional: widget.professional,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }

    String buttonText;
    Color buttonColor;
    bool isDisabled = false;

    if (_isLoading) {
      buttonText = 'Sending Request...';
      buttonColor = Colors.grey;
      isDisabled = true;
    } else if (_requestStatus == 'pending') {
      buttonText = 'Request Pending...';
      buttonColor = Colors.orange.shade700;
      isDisabled = true;
    } else if (_requestStatus == 'rejected') {
      buttonText = 'Request Rejected (Tap to resend)';
      buttonColor = Colors.red.shade700;
      isDisabled = false;
    } else {
      buttonText = 'Request This Professional';
      buttonColor = const Color(0xFF5B9BD5);
      isDisabled = false;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : _requestProfessional,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: buttonColor.withOpacity(0.5),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// =========================================================================
// --- 7. CLIENT APPOINTMENT STATUS SCREEN (COMBINED) ---
// =========================================================================
class ClientAppointmentStatusScreen extends StatefulWidget {
  const ClientAppointmentStatusScreen({super.key});

  @override
  State<ClientAppointmentStatusScreen> createState() =>
      _ClientAppointmentStatusScreenState();
}

class _ClientAppointmentStatusScreenState
    extends State<ClientAppointmentStatusScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
          backgroundColor: const Color(0xFF5B9BD5),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.login, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Please log in to view requests'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Requests',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333)),
            ),
            const SizedBox(height: 16),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('professional_requests')
                  .where('clientId', isEqualTo: user?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: Colors.red.shade400),
                          const SizedBox(height: 16),
                          const Text(
                            'Error Loading Requests',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please check your Firestore Console for a missing index warning.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'No requests yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Request a professional to get started',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final data = requests[index].data() as Map<String, dynamic>?;
                    final requestId = requests[index].id;

                    if (data == null) {
                      return const SizedBox.shrink();
                    }

                    return _buildRequestCard(
                      requestId: requestId,
                      professionalId: data['professionalId'] as String? ?? '',
                      professionalName: data['professionalName'] as String? ?? 'Unknown',
                      status: data['status'] as String? ?? 'pending',
                      timestamp: data['timestamp'],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard({
    required String requestId,
    required String professionalId,
    required String professionalName,
    required String status,
    required dynamic timestamp,
  }) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
    }

    String timeAgo = 'Just now';
    if (timestamp != null && timestamp is Timestamp) {
      final now = DateTime.now();
      final requestTime = timestamp.toDate();
      final difference = now.difference(requestTime);

      if (difference.inHours < 1) {
        timeAgo = '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        timeAgo = '${difference.inHours}h ago';
      } else {
        timeAgo = '${requestTime.month}/${requestTime.day}/${requestTime.year}';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: statusColor, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request for $professionalName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timestamp == null ? 'Pending' : timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getStatusMessage(status),
                        style: TextStyle(
                          fontSize: 13,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (status.toLowerCase() == 'accepted') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Appointment confirmed! Save these details.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Appointment Confirmed'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return '✓ Your request has been accepted! You can now book an appointment.';
      case 'rejected':
        return '✗ Your request has been rejected. You can try requesting this professional again.';
      default:
        return '⏳ Your request is pending. The professional will review it shortly.';
    }
  }
}