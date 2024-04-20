import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryName;
  final List<String> questions;
  final String videoUrl;
  final DocumentReference documentReference; // Document reference field

  CategoryModel({
    required this.categoryName,
    required this.questions,
    required this.videoUrl,
    required this.documentReference, // Initialize the document reference
  });

  factory CategoryModel.fromFireStore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CategoryModel.fromJson(data, snapshot.reference); // Pass document reference
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json, DocumentReference documentReference) {
    return CategoryModel(
      categoryName: json['category_name'] ?? '',
      questions: List<String>.from(json['questions']),
      videoUrl: json['video_url'] ?? '',
      documentReference: documentReference,
    );
  }
}
