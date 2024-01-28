import 'package:bheeshma_naturals_admin/data/entitites/category.dart';
import 'package:bheeshma_naturals_admin/data/entitites/product.dart';
import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> products = [
    // const Product(
    //     id: 0,
    //     name: 'Pistachio',
    //     price: [
    //       QuantityInfo(quantity: '250 G', price: 200, stock: 2),
    //       QuantityInfo(quantity: '500 G', price: 400, stock: 5),
    //     ],
    //     image:
    //         'https://i.pinimg.com/originals/94/c9/93/94c99322f92a7ab4030b130c5937239e.jpg',
    //     description:
    //         'Everything naturals at one place. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
    //     discount: 20,
    //     discountType: DiscountType.percentage,
    //     category: Category(id: 0, name: 'Dry Fruits'),
    //     cover:
    //         'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRQdjmIHq1Z6qXC5_oAMemSor5QrU6ECekYPbbsLbtCpX3e1d_c'),
    // const Product(
    //     id: 1,
    //     name: 'Dried Figs',
    //     price: [
    //       QuantityInfo(quantity: '250 G', price: 200, stock: 2),
    //       QuantityInfo(quantity: '500 G', price: 400, stock: 5),
    //       QuantityInfo(quantity: '1 KG', price: 800, stock: 10),
    //     ],
    //     image:
    //         'https://mir-s3-cdn-cf.behance.net/projects/404/83dcc0177167233.Y3JvcCwyODc2LDIyNTAsOTIsMA.jpg',
    //     description:
    //         'Everything naturals at one place. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
    //     discount: 20,
    //     discountType: DiscountType.percentage,
    //     category: Category(id: 0, name: 'Dry Fruits'),
    //     cover:
    //         'https://ayoubs.ca/cdn/shop/articles/dried_figs_460x@2x.png?v=1635282439'),
    // const Product(
    //   id: 2,
    //   name: 'Raisins',
    //   price: [
    //     QuantityInfo(quantity: '250 G', price: 200, stock: 0),
    //     QuantityInfo(quantity: '500 G', price: 400, stock: 5),
    //     QuantityInfo(quantity: '1 KG', price: 800, stock: 10),
    //   ],
    //   image:
    //       'https://i.pinimg.com/originals/4a/88/55/4a8855c5be2d15cbd79b1291d6d980d7.jpg',
    //   description:
    //       'Everything naturals at one place. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
    //   discount: 20,
    //   discountType: DiscountType.percentage,
    //   category: Category(id: 0, name: 'Dry Fruits'),
    //   cover:
    //       'https://www.amritahealthfoods.com/cdn/shop/articles/golden-raisins-lifestyle-7-1680954124667.png?v=1680954339',
    // ),
    // const Product(
    //   id: 3,
    //   name: 'Basmati Rice',
    //   price: [
    //     QuantityInfo(quantity: '250 G', price: 200, stock: 2),
    //     QuantityInfo(quantity: '500 G', price: 400, stock: 5),
    //     QuantityInfo(quantity: '1 KG', price: 800, stock: 0),
    //   ],
    //   image:
    //       'https://media.licdn.com/dms/image/D5622AQGmFXE1xknQOw/feedshare-shrink_1280/0/1687603556119?e=1708560000&v=beta&t=Ra5W1O1FxI4mc30gjYSlzPv2zd2bl870R8zbv77zOpo',
    //   description:
    //       'Everything naturals at one place. Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor.',
    //   discount: 0,
    //   discountType: DiscountType.percentage,
    //   category: Category(id: 0, name: 'Dry Fruits'),
    //   cover:
    //       'https://www.healthifyme.com/blog/wp-content/uploads/2023/01/shutterstock_400172368-1.jpg',
    // ),
  ];

  Future<void> updateProduct(Product product) async {
    print(product.docId);
    await FirebaseFirestore.instance
        .collection('products')
        .doc(product.docId)
        .update({
      'name': product.name,
      'price': product.price
          .map((e) =>
              {'quantity': e.quantity, 'price': e.price, 'stock': e.stock})
          .toList(),
      'image': product.image,
      'cover': product.cover,
      'category': product.category.id,
      'subcategory': product.subcategory?.id,
      'description': product.description,
      'discount': product.discount,
      'discountType': product.discountType == DiscountType.percentage ? 0 : 1,
    });
    var id = products.indexWhere((element) => element.id == product.id);
    products[id] = product;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newDoc = await FirebaseFirestore.instance.collection('products').add({
      'id': product.id,
      'name': product.name,
      'price': product.price
          .map((e) =>
              {'quantity': e.quantity, 'price': e.price, 'stock': e.stock})
          .toList(),
      'image': product.image,
      'cover': product.cover,
      'category': product.category.id,
      'subcategory': product.subcategory?.id,
      'description': product.description,
      'discount': product.discount,
      'discountType': product.discountType == DiscountType.percentage ? 0 : 1,
    });
    products.add(product.copyWith(docId: newDoc.id));
    notifyListeners();
  }

  Future<String> getImageURL(XFile image, {String? productName}) async {
    final storageRef = FirebaseStorage.instance.ref();
    // Create a reference to 'images/product.jpg'
    var fileName = (productName ?? DateTime.now().toString());
    if (fileName.isEmpty) {
      fileName = DateTime.now().toString();
    }
    final productImageRef = storageRef.child(
        "images/products/${fileName.replaceAll(" ", "-")}.${(image.mimeType ?? "image/png").split("/").last}");
    final imageBytes = await image.readAsBytes();
    await productImageRef.putData(
        imageBytes, SettableMetadata(contentType: image.mimeType));
    final imageURL = await productImageRef.getDownloadURL();
    print(imageURL);
    return imageURL;
  }

  deleteProduct(String? docId) async {
    if (docId == null) return;
    await FirebaseFirestore.instance.collection('products').doc(docId).delete();
    products.removeWhere((element) => element.docId == docId);
    notifyListeners();
  }

  Future<void> fetchProducts(
      List<Category> categories, List<Subcategory> subcategories) async {
    await FirebaseFirestore.instance.collection('products').get().then((value) {
      products = value.docs.map((element) {
        final categoryData = element.data();
        return Product(
          docId: element.id,
          id: categoryData['id'],
          name: categoryData['name'],
          price: (categoryData['price'] as List<dynamic>)
              .map((data) => QuantityInfo(
                  quantity: data['quantity'],
                  price: double.parse(data['price'].toString()),
                  stock: int.parse(data['stock'].toString())))
              .toList(),
          image: categoryData['image'],
          cover: categoryData['cover'],
          category: categories
              .where((element) => element.id == categoryData['category'])
              .first,
          description: categoryData['description'],
          discount: categoryData['discount'],
          discountType: categoryData['discountType'] == 0
              ? DiscountType.percentage
              : DiscountType.fixed,
          subcategory: categoryData['subcategory'] != null
              ? subcategories
                  .where((element) => element.id == categoryData['subcategory'])
                  .first
              : null,
        );
      }).toList();
      notifyListeners();
    });
  }
}
