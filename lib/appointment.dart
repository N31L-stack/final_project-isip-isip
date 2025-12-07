class Appointment {
  final String id;
  final String clientId;
  final String clientName;
  final String professionalId;
  final String professionalName;
  final DateTime dateTime;
  final String reason;
  final AppointmentStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Appointment({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.professionalId,
    required this.professionalName,
    required this.dateTime,
    required this.reason,
    this.status = AppointmentStatus.pending,
    this.createdAt,
    this.updatedAt,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] ?? '',
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      professionalId: map['professionalId'] ?? '',
      professionalName: map['professionalName'] ?? '',
      dateTime: DateTime.parse(map['dateTime']),
      reason: map['reason'] ?? '',
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${map['status']}',
        orElse: () => AppointmentStatus.pending,
      ),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'professionalId': professionalId,
      'professionalName': professionalName,
      'dateTime': dateTime.toIso8601String(),
      'reason': reason,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

enum AppointmentStatus {
  pending('Pending'),
  accepted('Accepted'),
  declined('Declined'),
  completed('Completed'),
  cancelled('Cancelled');

  final String name;
  const AppointmentStatus(this.name);
}