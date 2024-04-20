import 'package:view_point/data/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:view_point/data/models/response_model.dart';

class FirebaseServices {
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
    try{
      await FirebaseFirestore.instance.collection('responses').add(response.toMap());
    } catch(e) {
      rethrow;
    }
  }
}
