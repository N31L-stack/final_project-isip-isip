// lib/models/professional_model.dart

class Professional {
  final String id; // Document ID
  final String uid; // Firebase Auth User ID
  final String name;
  final String specialty;
  final String clinicAddress;
  final bool teletherapy;
  final double rating;
  final String profilePictureUrl;

  Professional({
    required this.id,
    required this.uid,
    required this.name,
    required this.specialty,
    required this.clinicAddress,
    required this.teletherapy,
    required this.rating,
    required this.profilePictureUrl,
  });

  // Factory constructor to create a Professional object from a Firestore document
  factory Professional.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return Professional(
      id: documentId,
      uid: data['uid'] ?? '',
      name: data['name'] ?? 'Unknown Professional',
      specialty: data['specialty'] ?? 'General',
      clinicAddress: data['clinicAddress'] ?? 'N/A',
      teletherapy: data['teletherapy'] ?? false,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      profilePictureUrl: data['profilePictureUrl'] ?? '',
    );
  }

  // Method to convert the Professional object to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'specialty': specialty,
      'clinicAddress': clinicAddress,
      'teletherapy': teletherapy,
      'rating': rating,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}