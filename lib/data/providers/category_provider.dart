import 'package:bheeshma_naturals_admin/data/entitites/category.dart';
import 'package:bheeshma_naturals_admin/data/entitites/product.dart';
import 'package:bheeshma_naturals_admin/data/providers/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> categories = [
    // const Category(id: 0, name: 'Dry Fruits'),
    // const Category(id: 1, name: 'Herbals'),
    // const Category(id: 2, name: 'Grains & Pulses'),
    // const Category(id: 3, name: 'Spices'),
    // const Category(id: 4, name: 'Cold Pressed Oils'),
    // const Category(id: 5, name: 'Millets'),
    // const Category(id: 6, name: 'Hair care'),
    // const Category(id: 7, name: 'Body care'),
    // const Category(id: 8, name: 'Oral care'),
    // const Category(id: 9, name: 'Ice creams'),
    // const Category(id: 10, name: 'Gardening'),
    // const Category(id: 11, name: 'Bamboo'),
    // const Category(id: 12, name: 'Natural Sweetener'),
    // const Category(id: 13, name: 'Pooja Needs'),
  ];

  List<Subcategory> subcategories = [
    // const Subcategory(
    //   id: 0,
    //   name: 'Pistachio',
    //   category: Category(id: 0, name: 'Dry Fruits'),
    // ),
  ];

  Future<void> editSubcategory(Subcategory subcategory) async {
    await FirebaseFirestore.instance
        .collection('subcategory')
        .doc(subcategory.id.toString())
        .update({
      'id': subcategory.id,
      'name': subcategory.name,
      'category': subcategory.category.id,
    });
    var id =
        subcategories.indexWhere((element) => element.id == subcategory.id);
    subcategories[id] = subcategory;
    notifyListeners();
  }

  Future<void> addSubcategory(Subcategory subcategory) async {
    await FirebaseFirestore.instance
        .collection('subcategory')
        .doc(subcategory.id.toString())
        .set({
      'id': subcategory.id,
      'name': subcategory.name,
      'category': subcategory.category.id,
    });
    subcategories.add(subcategory);
    notifyListeners();
  }

  Future<void> deleteSubcategory(int id) async {
    await FirebaseFirestore.instance
        .collection('subcategory')
        .doc(id.toString())
        .delete();
    subcategories.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> editCategory(Category category) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(category.id.toString())
        .update({
      'id': category.id,
      'name': category.name,
    });
    var id = categories.indexWhere((element) => element.id == category.id);
    categories[id] = category;
    subcategories
        .where((element) => element.category.id == category.id)
        .forEach((element) {
      editSubcategory(
          Subcategory(id: element.id, name: element.name, category: category));
    });
    notifyListeners();
  }

  Future<void> addCategory(Category category, Function(String) onError) async {
    if (categories
        .where((element) => element.name == category.name)
        .isNotEmpty) {
      onError("Category already exists!");
      return;
    }
    await FirebaseFirestore.instance
        .collection('category')
        .doc(category.id.toString())
        .set({
      'id': category.id,
      'name': category.name,
    });
    categories.add(category);
    notifyListeners();
  }

  Future<void> deleteCategory(int id, ProductProvider productProvider) async {
    await FirebaseFirestore.instance
        .collection('category')
        .doc(id.toString())
        .delete();
    subcategories
        .where((element) => element.category.id == id)
        .forEach((element) {
      deleteSubcategory(element.id);
    });
    productProvider.products
        .where((element) => element.category.id == id)
        .forEach((element) {
      productProvider.deleteProduct(element.docId);
    });
    subcategories.removeWhere((element) => element.category.id == id);
    categories.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  fetchCategories() async {
    await FirebaseFirestore.instance.collection('category').get().then((value) {
      categories = value.docs.map((element) {
        final categoryData = element.data();
        return Category(id: categoryData['id'], name: categoryData['name']);
      }).toList();
      notifyListeners();
    });
  }

  fetchSubcategories() async {
    await FirebaseFirestore.instance
        .collection('subcategory')
        .get()
        .then((value) {
      subcategories = value.docs.map((element) {
        final categoryData = element.data();
        return Subcategory(
            id: categoryData['id'],
            name: categoryData['name'],
            category: categories
                .where((element) => element.id == categoryData['category'])
                .first);
      }).toList();
      notifyListeners();
    });
  }
}
