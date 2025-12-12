// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/professional_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _professionalCollection = 'professionals';

  // 1. Stream for all professionals (for real-time list viewing)
  Stream<List<Professional>> getProfessionals() {
    return _db.collection(_professionalCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Professional.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // 2. Stream for a single professional (for a detail view)
  Stream<Professional> getProfessionalById(String id) {
    return _db.collection(_professionalCollection).doc(id).snapshots().map((snapshot) {
      return Professional.fromFirestore(snapshot.data()!, snapshot.id);
    });
  }
  
  // 3. (Optional) Filtered list (e.g., for search)
  Future<List<Professional>> searchProfessionals(String specialty) async {
    final snapshot = await _db.collection(_professionalCollection)
        .where('specialty', isEqualTo: specialty)
        .get();
    
    return snapshot.docs.map((doc) {
      return Professional.fromFirestore(doc.data(), doc.id);
    }).toList();
  }
}