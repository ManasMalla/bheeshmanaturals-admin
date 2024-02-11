import 'package:bheeshma_naturals_admin/data/entitites/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  List<BheeshmaNotification> notification = [
    // const BheeshmaNotification(
    //     title: 'Happy Sankranthi',
    //     body:
    //         'This sankranthi have a feast with your family with Bheeshma Naturals fresh organic rice! We have added a new product to our store. Check it out now!',
    //     image:
    //         'https://t4.ftcdn.net/jpg/04/03/98/77/360_F_403987784_eMB97Bj3m7peE5Hh2uKI2NFXj5Gwi9zC.jpg',
    //     type: 'discover',
    //     id: 'sankranthi',
    //     cta: 'Shop now',
    //     payload: '',
    //     route: '/home',
    //     updatedAt: '2024-01-12'),
  ];

  Future<void> deleteNotification(String id, String? uid) async {
    if (uid == null) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(id)
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(id)
          .delete();
    }
    notification.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future<void> sendNotification(
      BheeshmaNotification bheeshmaNotification) async {
    if (bheeshmaNotification.uid == null) {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(bheeshmaNotification.id)
          .set({
        'title': bheeshmaNotification.title,
        'body': bheeshmaNotification.body,
        'image': bheeshmaNotification.image,
        'type': bheeshmaNotification.type,
        'id': bheeshmaNotification.id,
        'updatedAt': bheeshmaNotification.updatedAt,
        'cta': bheeshmaNotification.cta,
        'payload': bheeshmaNotification.payload,
        'route': bheeshmaNotification.route,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(bheeshmaNotification.uid)
          .collection('notifications')
          .doc(bheeshmaNotification.id)
          .set({
        'title': bheeshmaNotification.title,
        'body': bheeshmaNotification.body,
        'image': bheeshmaNotification.image,
        'type': bheeshmaNotification.type,
        'id': bheeshmaNotification.id,
        'updatedAt': bheeshmaNotification.updatedAt,
        'cta': bheeshmaNotification.cta,
        'payload': bheeshmaNotification.payload,
        'route': bheeshmaNotification.route,
      });
    }

    notification.add(bheeshmaNotification);
    notifyListeners();
  }

  fetchNotification() async {
    await fetchGeneralNotifications().then((_) async {
      await fetchUserNotifications();
    });
  }

  fetchGeneralNotifications() async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .get()
        .then((value) {
      print(value);
      notification = value.docs.map((element) {
        final categoryData = element.data();
        return BheeshmaNotification(
          title: categoryData['title'],
          body: categoryData['body'],
          image: categoryData['image'],
          type: categoryData['type'],
          id: categoryData['id'],
          updatedAt: categoryData['updatedAt'],
          cta: categoryData['cta'] ?? 'Explore Now',
          payload: categoryData['payload'] ?? '',
          route: categoryData['route'] ?? '',
        );
      }).toList();
      notifyListeners();
    });
  }

  fetchUserNotifications() async {
    final userNotificationsGroup =
        await FirebaseFirestore.instance.collectionGroup('notifications').get();
    userNotificationsGroup.docs.forEach((element) {
      final notification = element.data();
      final bheeshmaNotification = BheeshmaNotification(
          title: notification['title'],
          body: notification['body'],
          image: notification['image'],
          type: notification['type'],
          id: notification['id'],
          updatedAt: notification['updatedAt'],
          cta: notification['cta'] ?? 'Explore Now',
          payload: notification['payload'] ?? '',
          route: notification['route'] ?? '',
          uid: element.reference.parent.parent?.id);
      this.notification.add(bheeshmaNotification);
    });
    notifyListeners();
  }
}
