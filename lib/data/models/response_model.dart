import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseModel {
  final String categoryName;
  final List<VideoResponse> videoResponses;
  final DocumentReference documentReference;

  ResponseModel({
    required this.categoryName,
    required this.videoResponses,
    required this.documentReference,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_name': categoryName,
      'video_responses': videoResponses.map((videoResponse) => videoResponse.toMap()).toList(),
      'category_doc_ref': documentReference,
    };
  }

  ResponseModel copyWith({
    String? categoryName,
    List<VideoResponse>? videoResponses,
    DocumentReference? documentReference,
  }) {
    return ResponseModel(
      categoryName: categoryName ?? this.categoryName,
      videoResponses: videoResponses ?? this.videoResponses,
      documentReference: documentReference ?? this.documentReference,
    );
  }
}

class VideoResponse {
  final List<String> questions;
  final List<String> answers;

  VideoResponse({
    required this.questions,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'questions': questions,
      'answers': answers,
    };
  }


  VideoResponse copyWith({
    List<String>? questions,
    List<String>? answers,
  }) {
    return VideoResponse(
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
    );
  }
}
