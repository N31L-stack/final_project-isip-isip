import 'package:flutter/material.dart';

class ProfessionalPage extends StatelessWidget {
  const ProfessionalPage({super.key});

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: const [
              ProfessionalCard(
                name: "Dr. Anya Sharma",
                role: "Therapist",
                specialization: "CBT, Trauma",
                imageUrl: "https://i.pravatar.cc/150?img=1",
                rating: 4.9,
                experience: "12 years",
                price: "₱2,500/session",
              ),
              ProfessionalCard(
                name: "Mark Chen",
                role: "Counselor",
                specialization: "Family Conflict, Relationships",
                imageUrl: "https://i.pravatar.cc/150?img=12",
                rating: 4.8,
                experience: "8 years",
                price: "₱2,000/session",
              ),
              ProfessionalCard(
                name: "Sarah Lee, Psy.D.",
                role: "Psychologist",
                specialization: "Anxiety, Depression",
                imageUrl: "https://i.pravatar.cc/150?img=5",
                rating: 5.0,
                experience: "15 years",
                price: "₱3,000/session",
              ),
              ProfessionalCard(
                name: "Dr. James Rodriguez",
                role: "Psychiatrist",
                specialization: "Medication Management, ADHD",
                imageUrl: "https://i.pravatar.cc/150?img=33",
                rating: 4.7,
                experience: "10 years",
                price: "₱3,500/session",
              ),
              ProfessionalCard(
                name: "Emily Thompson",
                role: "Licensed Counselor",
                specialization: "Grief, Loss, Life Transitions",
                imageUrl: "https://i.pravatar.cc/150?img=9",
                rating: 4.9,
                experience: "7 years",
                price: "₱2,200/session",
              ),
              ProfessionalCard(
                name: "Dr. Michael Park",
                role: "Clinical Psychologist",
                specialization: "OCD, Panic Disorders",
                imageUrl: "https://i.pravatar.cc/150?img=14",
                rating: 4.8,
                experience: "11 years",
                price: "₱2,800/session",
              ),
              ProfessionalCard(
                name: "Lisa Martinez",
                role: "Therapist",
                specialization: "PTSD, Stress Management",
                imageUrl: "https://i.pravatar.cc/150?img=20",
                rating: 4.9,
                experience: "9 years",
                price: "₱2,400/session",
              ),
              ProfessionalCard(
                name: "Dr. Robert Kim",
                role: "Marriage Counselor",
                specialization: "Couples Therapy, Communication",
                imageUrl: "https://i.pravatar.cc/150?img=52",
                rating: 4.7,
                experience: "13 years",
                price: "₱3,200/session",
              ),
              ProfessionalCard(
                name: "Jennifer Williams",
                role: "Child Psychologist",
                specialization: "Children & Adolescents",
                imageUrl: "https://i.pravatar.cc/150?img=47",
                rating: 5.0,
                experience: "10 years",
                price: "₱2,600/session",
              ),
              ProfessionalCard(
                name: "Dr. David Brown",
                role: "Therapist",
                specialization: "Addiction, Substance Abuse",
                imageUrl: "https://i.pravatar.cc/150?img=56",
                rating: 4.8,
                experience: "14 years",
                price: "₱2,700/session",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfessionalCard extends StatelessWidget {
  final String name;
  final String role;
  final String specialization;
  final String imageUrl;
  final double rating;
  final String experience;
  final String price;

  const ProfessionalCard({
    super.key,
    required this.name,
    required this.role,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.price,
  });

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
                name: name,
                role: role,
                specialization: specialization,
                imageUrl: imageUrl,
                rating: rating,
                experience: experience,
                price: price,
              ),
            ),
          );
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                imageUrl,
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
                        name.substring(0, 1),
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
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
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
                        rating.toString(),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• $experience exp',
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

// PROFESSIONAL DETAIL PAGE
class ProfessionalDetailPage extends StatelessWidget {
  final String name;
  final String role;
  final String specialization;
  final String imageUrl;
  final double rating;
  final String experience;
  final String price;

  const ProfessionalDetailPage({
    super.key,
    required this.name,
    required this.role,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.price,
  });

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
                      imageUrl,
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
                              name.substring(0, 1),
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
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role,
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
                        rating.toString(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.work_outline, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        experience,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialization,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Licensed mental health professional with extensive experience in evidence-based therapeutic approaches. Committed to providing a safe, supportive environment for personal growth and healing.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Session Fee',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                      ),
                      Text(
                        price,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5B9BD5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          professionalName: name,
                          price: price,
                        ),
                      ),
                    );
                  },
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
                    "Book Appointment",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// BOOKING PAGE
class BookingPage extends StatefulWidget {
  final String professionalName;
  final String price;

  const BookingPage({
    super.key,
    required this.professionalName,
    required this.price,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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

  void _confirmBooking() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both date and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            Text('Professional: ${widget.professionalName}'),
            const SizedBox(height: 8),
            Text('Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
            const SizedBox(height: 8),
            Text('Time: $_selectedTime'),
            const SizedBox(height: 8),
            Text('Type: $_selectedType'),
            const SizedBox(height: 8),
            Text('Fee: ${widget.price}'),
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
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
                    widget.professionalName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Session Fee: ${widget.price}',
                    style: const TextStyle(fontSize: 16, color: Color(0xFF5B9BD5), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Session Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
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
                        color: _selectedDate == null ? Colors.grey.shade600 : const Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
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
                        color: isSelected ? const Color(0xFF5B9BD5) : Colors.grey.shade300,
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
                  "Confirm Booking",
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