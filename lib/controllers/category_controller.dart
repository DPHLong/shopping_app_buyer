import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uber_shop_app/models/category_model.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCategories();
  }

  void _fetchCategories() async {
    try {
      _firestore
          .collection('categories')
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        categories.assignAll(
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CategoryModel(
              categoryImage: data['imageUrl'],
              categoryName: data['categoryName'],
            );
          }),
        );
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
