import 'package:bheeshma_naturals_admin/data/entitites/coupon.dart';
import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CouponProvider extends ChangeNotifier {
  List<Coupon> coupons = [
    // Coupon(
    //     code: 'PITA100',
    //     id: 'pitamaha-2024',
    //     description:
    //         'Get flat 100₹ off on purchasing the Bheeshma Naturals food',
    //     name: 'Bheeshma Powerup',
    //     type: DiscountType.fixed,
    //     discount: 100,
    //     minimumOrderAmount: 500,
    //     maximumDiscountAmount: 100.0,
    //     validFrom: DateTime(2024, 01, 01),
    //     validTill: DateTime(2024, 02, 01),
    //     isActive: true,
    //     isVisible: true),
    // Coupon(
    //   code: 'MANAS20',
    //   id: 'developer-2024',
    //   description: 'Get flat 20% off on purchasing the Bheeshma Naturals food',
    //   name: 'Developer Deed',
    //   type: DiscountType.percentage,
    //   discount: 20,
    //   minimumOrderAmount: 300,
    //   maximumDiscountAmount: 300.0,
    //   validFrom: DateTime(2024, 01, 01),
    //   validTill: DateTime(2024, 02, 01),
    //   isActive: true,
    // ),
  ];

  Future<void> editCoupon(Coupon coupon) async {
    await FirebaseFirestore.instance
        .collection('coupons')
        .doc(coupon.id)
        .update({
      'code': coupon.code,
      'id': coupon.id,
      'description': coupon.description,
      'name': coupon.name,
      'type': coupon.type == DiscountType.percentage ? 0 : 1,
      'discount': coupon.discount,
      'min-order': coupon.minimumOrderAmount,
      'max-discount': coupon.maximumDiscountAmount,
      'valid-from': coupon.validFrom,
      'valid-till': coupon.validTill,
      'is-active': coupon.isActive,
      'is-visible': coupon.isVisible,
    });
    var id = coupons.indexWhere((element) => element.id == coupon.id);
    coupons[id] = coupon;
    notifyListeners();
  }

  Future<void> addCoupon(Coupon coupon) async {
    await FirebaseFirestore.instance.collection('coupons').doc(coupon.id).set({
      'code': coupon.code,
      'id': coupon.id,
      'description': coupon.description,
      'name': coupon.name,
      'type': coupon.type == DiscountType.percentage ? 0 : 1,
      'discount': coupon.discount,
      'min-order': coupon.minimumOrderAmount,
      'max-discount': coupon.maximumDiscountAmount,
      'valid-from': coupon.validFrom,
      'valid-till': coupon.validTill,
      'is-active': coupon.isActive,
      'is-visible': coupon.isVisible,
    });
    coupons.add(coupon);
    notifyListeners();
  }

  Future<void> deleteCoupon(String id) async {
    await FirebaseFirestore.instance.collection('coupons').doc(id).delete();
    coupons.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  fetchCoupons() async {
    await FirebaseFirestore.instance.collection('coupons').get().then((value) {
      coupons = value.docs.map((element) {
        final categoryData = element.data();
        return Coupon(
          code: categoryData['code'],
          id: categoryData['id'],
          description: categoryData['description'],
          name: categoryData['name'],
          type: categoryData['type'] == 0
              ? DiscountType.percentage
              : DiscountType.fixed,
          discount: categoryData['discount'],
          minimumOrderAmount: categoryData['min-order'],
          maximumDiscountAmount:
              double.parse(categoryData['max-discount'].toString()),
          validFrom: categoryData['valid-from'].toDate(),
          validTill: categoryData['valid-till'].toDate(),
          isActive: categoryData['is-active'],
          isVisible: categoryData['is-visible'],
        );
      }).toList();
      notifyListeners();
    });
  }
}
