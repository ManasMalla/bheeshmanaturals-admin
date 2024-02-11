import 'package:bheeshma_naturals_admin/data/entitites/address.dart';
import 'package:bheeshma_naturals_admin/data/entitites/coupon.dart';
import 'package:bheeshma_naturals_admin/data/entitites/order.dart' as Order;
import 'package:bheeshma_naturals_admin/data/entitites/order_item.dart';
import 'package:bheeshma_naturals_admin/data/entitites/payment_method.dart';
import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  List<Order.Order> orders = [
    // Order.Order(
    //   id: 1,
    //   products: const [
    //     OrderItem(
    //         productName: 'Basmati Rice', quantity: 2, price: 800, size: '1 Kg'),
    //     OrderItem(
    //         productName: 'Raisins', quantity: 4, size: '250 g', price: 160),
    //     OrderItem(
    //         productName: 'Pistachio', quantity: 2, size: '250g', price: 160),
    //   ],
    //   date: DateTime(2024, 01, 13, 12, 30),
    //   status: [1, 0, 7],
    //   coupon: Coupon(
    //     code: 'MANAS20',
    //     id: 'developer-2024',
    //     description: 'Get flat 20% off on purchasing the Bheesma organics food',
    //     name: 'Developer Deed',
    //     type: DiscountType.percentage,
    //     discount: 20,
    //     minimumOrderAmount: 300,
    //     maximumDiscountAmount: 300.0,
    //     validFrom: DateTime(2024, 01, 01),
    //     validTill: DateTime(2024, 02, 01),
    //     isActive: true,
    //   ),
    //   paymentMethod: const CardPaymentMethod(
    //       name: 'Manas Malla',
    //       last4: '6789',
    //       cardIssuer: 'HDFC',
    //       cardNetwork: 'Mastercard',
    //       cardType: 'Debit'),
    //   shippingAddress: const Address(
    //     doorNumber: '50-103-4',
    //     building: 'Uma Sivam Residency',
    //     street: 'T.P.T Colony',
    //     city: 'Visakpatnam',
    //     state: 'Andhra Pradesh',
    //     pincode: '530013',
    //     landmark: 'Near Queens NRI Hospital',
    //     phoneNumber: '9059145216',
    //     name: 'Manas Malla',
    //     id: 0,
    //     type: 'Home',
    //     distance: 523000,
    //   ),
    //   billingAddress: const Address(
    //     doorNumber: '50-103-4',
    //     building: 'Uma Sivam Residency',
    //     street: 'T.P.T Colony',
    //     city: 'Visakpatnam',
    //     state: 'Andhra Pradesh',
    //     pincode: '530013',
    //     landmark: 'Near Queens NRI Hospital',
    //     phoneNumber: '9059145216',
    //     name: 'Manas Malla',
    //     id: 0,
    //     type: 'Home',
    //     distance: 523000,
    //   ),
    // )
  ];

  void rejectOrder(int id) {
    final order = orders.firstWhere((element) => element.id == id);
    final newOrder =
        order.copyWith(status: order.status.map((e) => 7).toList());

    updateOrder(id, newOrder);
  }

  void acceptOrder(int id) {
    final order = orders.firstWhere((element) => element.id == id);
    final newOrder =
        order.copyWith(status: order.status.map((e) => 1).toList());

    updateOrder(id, newOrder);
  }

  void rejectOrderItem(int id, int index) {
    final order = orders.firstWhere((element) => element.id == id);
    var status = order.status;
    status[index] = 7;
    final newOrder = order.copyWith(status: status);

    updateOrder(id, newOrder);
  }

  void updateOrderItem(int id, int index, String text) {
    final order = orders.firstWhere((element) => element.id == id);
    var status = order.status;
    status[index] = (status[index] == 1 || status[index] == 0) ? 2 : 3;
    final newOrder = order.copyWith(
      status: status,
    );
    updateOrder(id, newOrder);
  }

  void updateOrder(int id, Order.Order newOrder) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(newOrder.uid)
        .collection('orders')
        .doc(id.toString())
        .update({
      'status': newOrder.status,
    });
    orders[orders.indexWhere((element) => element.id == id)] = newOrder;
    notifyListeners();
  }

  fetchOrders() async {
    print("123");
    try {
      await FirebaseFirestore.instance
          .collectionGroup('orders')
          .get()
          .then((value) async {
        var futureOrders = value.docs.map((element) async {
          final categoryData = element.data();

          final products = (categoryData['products'] as List<dynamic>).map((e) {
            final orderItem = OrderItem(
              productName: e['productName'],
              size: e['size'],
              quantity: e['quantity'],
              price: double.parse(
                e['price'].toString(),
              ),
            );
            return orderItem;
          }).toList();
          final paymentMethodData = categoryData['payment-method'];
          final paymentMethod = categoryData['payment-method-type'] == 'card'
              ? CardPaymentMethod(
                  name: paymentMethodData['name'],
                  last4: paymentMethodData['last4'],
                  cardType: paymentMethodData['card-type'],
                  cardIssuer: paymentMethodData['card-issuer'],
                  cardNetwork: paymentMethodData['card-network'])
              : categoryData['payment-method-type'] == 'upi'
                  ? UPIPaymentMethod(
                      name: paymentMethodData['name'],
                      vpa: paymentMethodData['vpa'])
                  : categoryData['payment-method-type'] == 'wallet'
                      ? WalletPaymentMethod(
                          name: paymentMethodData['name'],
                          walletType: paymentMethodData['wallet-type'])
                      : const CashOnDeliveryPaymentMethod();

          final addresses = await FirebaseFirestore.instance
              .collection('users')
              .doc(element.reference.parent.parent?.id)
              .collection('addresses')
              .doc(categoryData['address'].toString())
              .get();
          final addressesData = addresses.data();
          final address = Address(
            doorNumber: addressesData?['door-number'] ?? "",
            building: addressesData?['building'] ?? "",
            street: addressesData?['street'] ?? "",
            city: addressesData?['city'] ?? "",
            state: addressesData?['state'] ?? "",
            pincode: addressesData?['pincode'] ?? "",
            landmark: addressesData?['landmark'] ?? "",
            phoneNumber: addressesData?['phone-number'] ?? "",
            name: addressesData?['name'] ?? "",
            id: addressesData?['id'] ?? 0,
            type: addressesData?['type'] ?? "",
            distance: addressesData?['distance'] ?? 0,
          );
          return Order.Order(
            uid: element.reference.parent.parent?.id,
            id: categoryData['id'],
            products: products,
            date: DateTime.fromMillisecondsSinceEpoch(
                categoryData['date'] * 1000),
            status: (categoryData['status'] as List<dynamic>)
                .map((e) => int.parse(e.toString()))
                .toList(),
            coupon: categoryData['coupon'] == null
                ? null
                : Coupon(
                    code: categoryData['coupon']['code'],
                    id: categoryData['coupon']['id'],
                    description: categoryData['coupon']['description'],
                    name: categoryData['coupon']['name'],
                    type: categoryData['coupon']['type'] == 0
                        ? DiscountType.percentage
                        : DiscountType.fixed,
                    discount: categoryData['coupon']['discount'],
                    minimumOrderAmount: categoryData['coupon']['min-order'],
                    maximumDiscountAmount: categoryData['coupon']
                        ['max-discount'],
                    validFrom: DateTime.fromMillisecondsSinceEpoch(
                        categoryData['coupon']['valid-from'] * 1000),
                    validTill: DateTime.fromMillisecondsSinceEpoch(
                        categoryData['coupon']['valid-till'] * 1000),
                    isActive: categoryData['coupon']['is-active'],
                  ),
            paymentMethod: paymentMethod,
            shippingAddress: address,
            billingAddress: address,
            razorpayOrderId: categoryData['razorpay-order-id'],
            razorpayPaymentId: categoryData['razorpay-payment-id'],
          );
        }).toList();
        orders = await Future.wait(futureOrders);
        orders.sort((a, b) => a.id.compareTo(b.id));
        final pendingOrders = orders
            .where((element) =>
                element.status.where((element) => element == 7).isEmpty)
            .toList();
        orders.removeWhere((element) =>
            element.status.where((element) => element == 7).isEmpty);
        orders.insertAll(0, pendingOrders);
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
}
