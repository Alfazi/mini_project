import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/rental_model.dart';

class RentalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addRental(RentalModel rental) async {
    try {
      await _firestore.collection('rentals').add(rental.toFirestore());
    } catch (e) {
      throw Exception('Failed to add rental: $e');
    }
  }

  Stream<List<RentalModel>> getUserRentals() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('rentals')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final rentals = snapshot.docs
              .map((doc) => RentalModel.fromFirestore(doc))
              .toList();
          rentals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return rentals;
        });
  }

  Future<RentalModel?> getRentalById(String id) async {
    try {
      final doc = await _firestore.collection('rentals').doc(id).get();
      if (doc.exists) {
        return RentalModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get rental: $e');
    }
  }
}
