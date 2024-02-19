import 'package:bheeshma_naturals_admin/data/entitites/category.dart';
import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';

class Product {
  final String? docId;
  final int id;
  final String name;
  final List<QuantityInfo> price;

  final String cover;
  final Category category;
  final Subcategory? subcategory;
  final String image;
  final String description;
  final int discount;
  final DiscountType discountType;
  const Product({
    this.docId,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.cover,
    required this.category,
    this.subcategory,
    required this.description,
    required this.discount,
    required this.discountType,
  });

  List<QuantityInfo> get discountedPrices {
    return price
        .map((product) => QuantityInfo(
            discount: product.discount,
            quantity: product.quantity,
            price: discountType == DiscountType.percentage
                ? product.price - ((product.price * discount) / 100).ceil()
                : product.price - discount,
            stock: product.stock))
        .toList();
  }

  Product copyWith({required String docId}) {
    return Product(
      docId: docId,
      id: id,
      name: name,
      price: price,
      image: image,
      cover: cover,
      category: category,
      subcategory: subcategory,
      description: description,
      discount: discount,
      discountType: discountType,
    );
  }
}

class QuantityInfo {
  final String quantity;
  final double price;
  final int stock;
  final int discount;
  const QuantityInfo({
    required this.quantity,
    required this.price,
    required this.stock,
    required this.discount,
  });
}
