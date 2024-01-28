import 'package:bheeshma_naturals_admin/data/entitites/advertisements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdvertisementProvider extends ChangeNotifier {
  List<Advertisement> advertisement = [
    // Advertisement(
    //   id: '1',
    //   title: 'Amazing Almonds',
    //   subtitle: 'Rich in vitamin A',
    //   description:
    //       'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //   arguments: 3,
    // ),
    // Advertisement(
    //   id: '2',
    //   title: 'Pleasing Pistachio',
    //   subtitle: 'Rich in vitamin E',
    //   description:
    //       'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //   arguments: 0,
    //   cta: "Order Now",
    // ),
    // Advertisement(
    //     id: '3',
    //     title: 'Delicious Dried Figs',
    //     subtitle: 'Rich in vitamin C',
    //     description:
    //         'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //     arguments: 1),
    // Advertisement(
    //     id: '4',
    //     title: 'Ravishing Raisins',
    //     subtitle: 'Rich in vitamin B',
    //     description:
    //         'From the farms of California, Pellentesque ipsum libero, bibendum dictum eleifend a, mattis ac tortor. ',
    //     arguments: 2),
  ];

  Future<void> deleteAdvertisement(String advertisementId) async {
    await FirebaseFirestore.instance
        .collection('advertisements')
        .doc(advertisementId)
        .delete();
    advertisement.removeWhere((element) => element.id == advertisementId);
    notifyListeners();
  }

  Future<void> addAdvertisement(Advertisement newAdvertisement) async {
    final newAd =
        await FirebaseFirestore.instance.collection('advertisements').add({
      'title': newAdvertisement.title,
      'subtitle': newAdvertisement.subtitle,
      'description': newAdvertisement.description,
      'arguments': newAdvertisement.arguments,
      'cta': newAdvertisement.cta,
      'route': newAdvertisement.route,
    });
    advertisement.add(newAdvertisement.copyWith(id: newAd.id));
    notifyListeners();
  }

  Future<void> updateAdvertisement(Advertisement newAdvertisement) async {
    await FirebaseFirestore.instance
        .collection('advertisements')
        .doc(newAdvertisement.id)
        .update({
      'title': newAdvertisement.title,
      'subtitle': newAdvertisement.subtitle,
      'description': newAdvertisement.description,
      'arguments': newAdvertisement.arguments,
      'cta': newAdvertisement.cta,
      'route': newAdvertisement.route,
    });
    var id = advertisement
        .indexWhere((element) => element.id == newAdvertisement.id);
    advertisement[id] = newAdvertisement;
    notifyListeners();
  }

  fetchAdvertisements() async {
    await FirebaseFirestore.instance
        .collection('advertisements')
        .get()
        .then((value) {
      advertisement = value.docs.map((element) {
        final categoryData = element.data();
        return Advertisement(
          title: categoryData['title'],
          subtitle: categoryData['subtitle'],
          description: categoryData['description'],
          arguments: categoryData['arguments'],
          cta: categoryData['cta'] ?? 'Know More',
          route: categoryData['route'] ?? '/product',
          id: element.id,
        );
      }).toList();
      notifyListeners();
    });
  }
}
