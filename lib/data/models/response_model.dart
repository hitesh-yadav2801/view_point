import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseModel {
  final List<String> questions;
  final List<String> answers;
  final DocumentReference documentReference;

  ResponseModel({
    required this.questions,
    required this.answers,
    required this.documentReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'questions': questions,
      'answers': answers,
      'category_doc_ref': documentReference,
    };
  }
}
