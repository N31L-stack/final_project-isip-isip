import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';
import 'appointment.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  // Mock data - in real app, fetch from backend
  List<Appointment> appointments = [
    Appointment(
      id: '1',
      clientId: 'client_001',
      clientName: 'John Doe',
      professionalId: 'prof_1',
      professionalName: 'Dr. Sarah Johnson',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      reason: 'Anxiety management consultation',
      status: AppointmentStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Appointment(
      id: '2',
      clientId: 'client_002',
      clientName: 'Jane Smith',
      professionalId: 'prof_2',
      professionalName: 'Dr. Michael Chen',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      reason: 'Depression therapy session',
      status: AppointmentStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    // Add more mock appointments
  ];

  @override
  void initState() {
    super.initState();
    NotificationService().initialize();
  }

  void _updateAppointmentStatus(Appointment appointment, AppointmentStatus newStatus) {
    setState(() {
      final index = appointments.indexWhere((a) => a.id == appointment.id);
      if (index != -1) {
        appointments[index] = Appointment(
          id: appointment.id,
          clientId: appointment.clientId,
          clientName: appointment.clientName,
          professionalId: appointment.professionalId,
          professionalName: appointment.professionalName,
          dateTime: appointment.dateTime,
          reason: appointment.reason,
          status: newStatus,
          createdAt: appointment.createdAt,
          updatedAt: DateTime.now(),
        );
      }
    });

    // Send notification to client
    _sendStatusNotification(appointment, newStatus);
  }

  Future<void> _sendStatusNotification(
    Appointment appointment, 
    AppointmentStatus status
  ) async {
    final notificationService = NotificationService();
    
    String title;
    String body;
    
    switch (status) {
      case AppointmentStatus.accepted:
        title = 'Appointment Accepted! 🎉';
        body = 'Your appointment with ${appointment.professionalName} on ${DateFormat('MMM dd, yyyy').format(appointment.dateTime)} has been confirmed.';
        break;
      case AppointmentStatus.declined:
        title = 'Appointment Declined';
        body = 'Your appointment with ${appointment.professionalName} has been declined. Please book another time.';
        break;
      default:
        return;
    }
    
    await notificationService.showAppointmentNotification(
      title: title,
      body: body,
      appointmentId: appointment.id,
    );
    
    // Also schedule reminder for accepted appointments
    if (status == AppointmentStatus.accepted) {
      final reminderTime = appointment.dateTime.subtract(const Duration(hours: 1));
      if (reminderTime.isAfter(DateTime.now())) {
        await notificationService.scheduleReminderNotification(
          title: 'Appointment Reminder ⏰',
          body: 'You have an appointment with ${appointment.professionalName} in 1 hour.',
          appointmentTime: reminderTime,
        );
      }
    }
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    Color statusColor;
    IconData statusIcon;
    
    switch (appointment.status) {
      case AppointmentStatus.accepted:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case AppointmentStatus.declined:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.clientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'with ${appointment.professionalName}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(appointment.status.name),
                  backgroundColor: statusColor.withOpacity(0.2),
                  labelStyle: TextStyle(color: statusColor),
                  avatar: Icon(statusIcon, size: 16, color: statusColor),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(appointment.dateTime),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('hh:mm a').format(appointment.dateTime),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Reason: ${appointment.reason}',
              style: const TextStyle(fontSize: 14),
            ),
            
            const SizedBox(height: 12),
            
            if (appointment.status == AppointmentStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateAppointmentStatus(
                        appointment, 
                        AppointmentStatus.accepted
                      ),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateAppointmentStatus(
                        appointment, 
                        AppointmentStatus.declined
                      ),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Decline'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            
            if (appointment.updatedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Updated: ${DateFormat('MMM dd, hh:mm a').format(appointment.updatedAt!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
      appBar: AppBar(
        title: const Text('Admin Panel - Appointments'),
        backgroundColor: const Color(0xFF5B9BD5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Statistics Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      appointments.where((a) => a.status == AppointmentStatus.pending).length.toString(),
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Accepted',
                      appointments.where((a) => a.status == AppointmentStatus.accepted).length.toString(),
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Declined',
                      appointments.where((a) => a.status == AppointmentStatus.declined).length.toString(),
                      Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            // Appointments List
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'All Appointments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...appointments.map(_buildAppointmentCard).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}