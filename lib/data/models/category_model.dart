import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryName;
  final List<String> questions;
  final String videoUrl;
  final DocumentReference? documentReference;

  CategoryModel({
    required this.categoryName,
    required this.questions,
    required this.videoUrl,
    this.documentReference,
  });

  factory CategoryModel.fromFireStore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CategoryModel.fromJson(data, snapshot.reference);
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json, DocumentReference documentReference) {
    return CategoryModel(
      categoryName: json['category_name'] ?? '',
      questions: List<String>.from(json['questions']),
      videoUrl: json['video_url'] ?? '',
      documentReference: documentReference,
    );
  }

  CategoryModel copyWith({
    String? categoryName,
    List<String>? questions,
    String? videoUrl,
    DocumentReference? documentReference,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      questions: questions ?? this.questions,
      videoUrl: videoUrl ?? this.videoUrl,
      documentReference: documentReference ?? this.documentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_name': categoryName,
      'questions': questions,
      'video_url': videoUrl,
      // 'document_reference': documentReference,
    };
  }
}
