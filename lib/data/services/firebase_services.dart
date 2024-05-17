import 'dart:io';

import 'package:view_point/data/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:view_point/data/models/response_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  static Future<void> postCategories(
      {required CategoryModel categoryModel, required File file}) async {
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('videos/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(file);

      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => null).catchError((error) {
        throw error;
      });

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      //String downloadURL = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

      CategoryModel updatedCategoryModel =
          categoryModel.copyWith(videoUrl: downloadURL);

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
