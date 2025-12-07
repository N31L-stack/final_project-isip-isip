// lib/appointment_models.dart
class Appointment {
  final String id;
  final String client;
  final String professional;
  final String date;
  final String time;
  final String type;
  final String status;

  Appointment({
    required this.id,
    required this.client,
    required this.professional,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
  });
}

class AppointmentData {
  static List<Appointment> _appointments = [
    Appointment(
      id: '1',
      client: 'John Doe',
      professional: 'Dr. Anya Sharma',
      date: 'Dec 10, 2025',
      time: '2:00 PM',
      type: 'Video Call',
      status: 'pending',
    ),
    Appointment(
      id: '2',
      client: 'Jane Smith',
      professional: 'Mark Chen',
      date: 'Dec 11, 2025',
      time: '10:30 AM',
      type: 'In-Person',
      status: 'pending',
    ),
    Appointment(
      id: '3',
      client: 'Robert Johnson',
      professional: 'Sarah Lee, Psy.D.',
      date: 'Dec 12, 2025',
      time: '3:00 PM',
      type: 'Video Call',
      status: 'pending',
    ),
    Appointment(
      id: '4',
      client: 'Maria Garcia',
      professional: 'Dr. Anya Sharma',
      date: 'Dec 5, 2025',
      time: '11:00 AM',
      type: 'Video Call',
      status: 'accepted',
    ),
    Appointment(
      id: '5',
      client: 'David Wilson',
      professional: 'Mark Chen',
      date: 'Dec 5, 2025',
      time: '3:30 PM',
      type: 'In-Person',
      status: 'accepted',
    ),
  ];

  static List<Appointment> getPendingRequests() {
    return _appointments.where((a) => a.status == 'pending').toList();
  }

  static List<Appointment> getScheduledAppointments() {
    return _appointments.where((a) => a.status == 'accepted').toList();
  }

  static void acceptAppointment(String id) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = Appointment(
        id: _appointments[index].id,
        client: _appointments[index].client,
        professional: _appointments[index].professional,
        date: _appointments[index].date,
        time: _appointments[index].time,
        type: _appointments[index].type,
        status: 'accepted',
      );
    }
  }

  static void declineAppointment(String id) {
    _appointments.removeWhere((a) => a.id == id);
  }
}