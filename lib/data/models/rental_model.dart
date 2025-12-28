import 'package:cloud_firestore/cloud_firestore.dart';

class RentalModel {
  final String id;
  final String userId;
  final String bookId;
  final String bookTitle;
  final String? bookCoverImage;
  final String? authorName;
  final String? category;
  final int rentalDays;
  final int totalPrice;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  RentalModel({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    this.bookCoverImage,
    this.authorName,
    this.category,
    required this.rentalDays,
    required this.totalPrice,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory RentalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RentalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      bookId: data['bookId'] ?? '',
      bookTitle: data['bookTitle'] ?? '',
      bookCoverImage: data['bookCoverImage'],
      authorName: data['authorName'],
      category: data['category'],
      rentalDays: data['rentalDays'] ?? 0,
      totalPrice: data['totalPrice'] ?? 0,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'bookCoverImage': bookCoverImage,
      'authorName': authorName,
      'category': category,
      'rentalDays': rentalDays,
      'totalPrice': totalPrice,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
