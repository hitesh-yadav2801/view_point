import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String videoUrl;
  final List<String> questions;

  Video({
    required this.videoUrl,
    required this.questions,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    try {
      return Video(
        videoUrl: json['video_url'] ?? '',
        questions: List<String>.from(json['questions'] ?? []),
      );
    } catch (e) {
      // Log the error or handle it as needed
      throw FormatException('Error parsing Video from JSON', e);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'video_url': videoUrl,
      'questions': questions,
    };
  }

  Video copyWith({
    String? videoUrl,
    List<String>? questions,
  }) {
    return Video(
      videoUrl: videoUrl ?? this.videoUrl,
      questions: questions ?? this.questions,
    );
  }
}

class CategoryModel {
  final String categoryName;
  final List<Video> videos;
  final DocumentReference? documentReference;

  CategoryModel({
    required this.categoryName,
    required this.videos,
    this.documentReference,
  });

  factory CategoryModel.fromFireStore(DocumentSnapshot snapshot) {
    try {
      final data = snapshot.data() as Map<String, dynamic>;
      return CategoryModel.fromJson(data, snapshot.reference);
    } catch (e) {
      // Log the error or handle it as needed
      throw FormatException('Error parsing CategoryModel from Firestore', e);
    }
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json, DocumentReference documentReference) {
    try {
      var videosFromJson = json['videos'] as List<dynamic>? ?? [];
      List<Video> videoList = videosFromJson
          .map((videoJson) => Video.fromJson(videoJson as Map<String, dynamic>))
          .toList();

      return CategoryModel(
        categoryName: json['category_name'] ?? '',
        videos: videoList,
        documentReference: documentReference,
      );
    } catch (e) {
      // Log the error or handle it as needed
      throw FormatException('Error parsing CategoryModel from JSON', e);
    }
  }

  CategoryModel copyWith({
    String? categoryName,
    List<Video>? videos,
    DocumentReference? documentReference,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      videos: videos ?? this.videos,
      documentReference: documentReference ?? this.documentReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_name': categoryName,
      'videos': videos.map((video) => video.toMap()).toList(),
    };
  }
}

// class CategoryModel {
//   final String categoryName;
//   final List<String> questions;
//   final String videoUrl;
//   final DocumentReference? documentReference;
//
//   CategoryModel({
//     required this.categoryName,
//     required this.questions,
//     required this.videoUrl,
//     this.documentReference,
//   });
//
//   factory CategoryModel.fromFireStore(DocumentSnapshot snapshot) {
//     final data = snapshot.data() as Map<String, dynamic>;
//     return CategoryModel.fromJson(data, snapshot.reference);
//   }
//
//   factory CategoryModel.fromJson(Map<String, dynamic> json, DocumentReference documentReference) {
//     return CategoryModel(
//       categoryName: json['category_name'] ?? '',
//       questions: List<String>.from(json['questions']),
//       videoUrl: json['video_url'] ?? '',
//       documentReference: documentReference,
//     );
//   }
//
//   CategoryModel copyWith({
//     String? categoryName,
//     List<String>? questions,
//     String? videoUrl,
//     DocumentReference? documentReference,
//   }) {
//     return CategoryModel(
//       categoryName: categoryName ?? this.categoryName,
//       questions: questions ?? this.questions,
//       videoUrl: videoUrl ?? this.videoUrl,
//       documentReference: documentReference ?? this.documentReference,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'category_name': categoryName,
//       'questions': questions,
//       'video_url': videoUrl,
//       // 'document_reference': documentReference,
//     };
//   }
// }
