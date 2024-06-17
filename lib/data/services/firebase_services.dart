import 'dart:io';

import 'package:view_point/data/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:view_point/data/models/response_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  static Future<void> postCategories({
    required CategoryModel categoryModel,
    required List<File> files,
  }) async {
    try {
      List<Video> updatedVideos = [];

      for (int i = 0; i < files.length; i++) {
        File file = files[i];

        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('videos/${DateTime.now().millisecondsSinceEpoch}_$i');
        UploadTask uploadTask = storageReference.putFile(file);

        TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null).catchError((error) {
          throw error;
        });

        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        Video updatedVideo = categoryModel.videos[i].copyWith(videoUrl: downloadURL);
        updatedVideos.add(updatedVideo);
      }

      CategoryModel updatedCategoryModel = categoryModel.copyWith(videos: updatedVideos);

      await FirebaseFirestore.instance
          .collection('categories')
          .add(updatedCategoryModel.toMap());
    } catch (e) {
      rethrow;
    }
  }


  static Future<List<CategoryModel>> getCategories() async {
    try {
      List<CategoryModel> categories = [];
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      for (var element in querySnapshot.docs) {
        categories.add(CategoryModel.fromFireStore(element));
      }
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> postFeedback({required ResponseModel response}) async {
    try {
      await FirebaseFirestore.instance
          .collection('responses')
          .add(response.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
