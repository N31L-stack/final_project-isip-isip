import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';
import 'appointment.dart';

class ProfessionalPage extends StatefulWidget {
  const ProfessionalPage({super.key});

  @override
  State<ProfessionalPage> createState() => _ProfessionalPageState();
}

class _ProfessionalPageState extends State<ProfessionalPage> {
  final List<Map<String, dynamic>> professionals = [
    {
      'name': 'Dr. Sarah Johnson',
      'specialty': 'Clinical Psychologist',
      'experience': '12 years',
      'rating': 4.8,
      'available': true,
      'imageUrl': '',
      'description': 'Specializes in anxiety disorders and cognitive behavioral therapy.',
      'consultationFee': '\$120/session',
    },
    // ... add other professionals
  ];

  // Mock appointments list (in real app, fetch from backend)
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    // Initialize notification service
    NotificationService().initialize();
  }

  void _showAppointmentDialog(Map<String, dynamic> professional) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Book Appointment'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'With ${professional['name']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Date picker
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Select Date'),
                    subtitle: Text(
                      DateFormat('MMM dd, yyyy').format(selectedDate),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null && picked != selectedDate) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  
                  // Time picker
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Select Time'),
                    subtitle: Text(selectedTime.format(context)),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                  ),
                  
                  // Reason field
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Reason for appointment',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _bookAppointment(
                    professional: professional,
                    date: selectedDate,
                    time: selectedTime,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Book Appointment'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _bookAppointment({
    required Map<String, dynamic> professional,
    required DateTime date,
    required TimeOfDay time,
  }) {
    final appointmentDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    
    final newAppointment = Appointment(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      clientId: 'client_001', // Replace with actual user ID
      clientName: 'Current User', // Replace with actual username
      professionalId: 'prof_${professional['name']}',
      professionalName: professional['name'],
      dateTime: appointmentDateTime,
      reason: 'Consultation',
      status: AppointmentStatus.pending,
      createdAt: DateTime.now(),
    );
    
    setState(() {
      appointments.add(newAppointment);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment request sent! You will be notified when it\'s reviewed.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'My Appointments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        if (appointments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No appointments yet. Book one with a professional!',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _buildAppointmentCard(appointment);
            },
          ),
      ],
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    Color statusColor;
    switch (appointment.status) {
      case AppointmentStatus.accepted:
        statusColor = Colors.green;
        break;
      case AppointmentStatus.declined:
        statusColor = Colors.red;
        break;
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appointment.professionalName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(
                    appointment.status.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('MMM dd, yyyy • hh:mm a').format(appointment.dateTime),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(appointment.reason),
            if (appointment.status == AppointmentStatus.accepted)
              const SizedBox(height: 8),
            if (appointment.status == AppointmentStatus.accepted)
              const Text(
                '✅ Your appointment has been confirmed!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Professional Help'),
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Professionals List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                final professional = professionals[index];
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFF5B9BD5),
                              child: Text(
                                professional['name'][0],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    professional['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(professional['specialty']),
                                  Text('${professional['experience']} experience'),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 16),
                                      Text(' ${professional['rating']}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(professional['description']),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              professional['consultationFee'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF5B9BD5),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _showAppointmentDialog(professional),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5B9BD5),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Book Appointment'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            // Appointments Section
            _buildAppointmentsSection(),
          ],
        ),
      ),
    );
  }
}