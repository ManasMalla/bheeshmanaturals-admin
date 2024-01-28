import 'package:bheeshma_naturals_admin/data/entitites/address.dart';
import 'package:bheeshma_naturals_admin/data/entitites/coupon.dart';
import 'package:bheeshma_naturals_admin/data/entitites/order_item.dart';
import 'package:bheeshma_naturals_admin/data/entitites/payment_method.dart';

class Order {
  final String? uid;
  final int id;
  final List<OrderItem> products;
  final DateTime date;
  final List<int> status;
  final PaymentMethod paymentMethod;
  final Address shippingAddress;
  final Address billingAddress;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final Coupon? coupon;
  const Order({
    this.uid,
    required this.id,
    required this.products,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.billingAddress,
    this.coupon,
    this.razorpayOrderId,
    this.razorpayPaymentId,
  });

  Order copyWith({
    int? id,
    List<OrderItem>? products,
    DateTime? date,
    List<int>? status,
    PaymentMethod? paymentMethod,
    Address? shippingAddress,
    Address? billingAddress,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    Coupon? coupon,
  }) {
    return Order(
      uid: this.uid,
      id: id ?? this.id,
      products: products ?? this.products,
      date: date ?? this.date,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      razorpayOrderId: razorpayOrderId ?? this.razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId ?? this.razorpayPaymentId,
      coupon: coupon ?? this.coupon,
    );
  }
}
