import 'package:bheeshma_naturals_admin/data/entitites/notification.dart';
import 'package:bheeshma_naturals_admin/data/providers/notification_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationCard extends StatelessWidget {
  final BheeshmaNotification notification;
  const NotificationCard(
    this.notification, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.network(
              notification.image,
              width: 200,
              height: ((notification.body.length / 36) * 20).floor() + 100,
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  notification.body,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact),
                      onPressed: () {},
                      child: Text(
                        notification.cta,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.route,
                          size: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(notification.route),
                        notification.payload.toString() != ""
                            ? Opacity(
                                opacity: 0.5,
                                child: Text(
                                  "?args=${notification.payload}",
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () async {
              await Provider.of<NotificationProvider>(context, listen: false)
                  .deleteNotification(notification.id, notification.uid);
            },
            icon: Icon(Icons.delete),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}

void showNotificationBottomSheet(
    BuildContext context, NotificationProvider notificationProvider) {
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  var ctaController = TextEditingController();
  var routeController = TextEditingController(text: "Notifications Page");
  var payloadController = TextEditingController();
  var uidController = TextEditingController();
  var finalImage =
      'https://civis.eu/storage/files/header-stm-2022-summer-school-on-natural-drug-products-1200x630.png?token=b9d821a2ff08ad9ad692fcfe2ee359ed';
  var imageController = TextEditingController();

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          imageController.addListener(() {
            setSheetState(() {});
          });
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'send notifications'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'Everything naturals at one place'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          child: imageController.text.isNotEmpty
                              ? Image.network(
                                  imageController.text,
                                  width: 240,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      width: 240,
                                      height: 150,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.photo_library),
                                          Text("Type an image URL"),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 240,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.photo_library),
                                      Text("Type an Image URL"),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none),
                                    labelText: 'Title',
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer),
                                controller: titleController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: 'Description',
                                ),
                                controller: bodyController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: 'Image URL',
                                ),
                                controller: imageController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              labelText: 'CTA',
                            ),
                            controller: ctaController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            onChanged: (_) {
                              routeController.text = _ ?? routeController.text;
                              setSheetState(() {});
                            },
                            value: routeController.text,
                            items: {
                              "Home Page",
                              "Product Page",
                              "Review Page",
                              "Profile Page",
                              "Wishlist Page",
                              "Notifications Page",
                              "Orders Page"
                            }
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              labelText: 'Route',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        routeController.text == "Product Page"
                            ? Expanded(
                                child: Consumer<ProductProvider>(
                                    builder: (context, productProvider, _) {
                                  return DropdownButtonFormField<String>(
                                    onChanged: (_) {
                                      payloadController.text =
                                          _ ?? payloadController.text;
                                      setSheetState(() {});
                                    },
                                    value: payloadController.text.isEmpty
                                        ? null
                                        : payloadController.text,
                                    items: productProvider.products
                                        .map((e) => DropdownMenuItem(
                                              value: e.id.toString(),
                                              child: Text(
                                                e.name,
                                              ),
                                            ))
                                        .toList(),
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      labelText: 'Arguments',
                                    ),
                                  );
                                }),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      // if (titleController.text.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please enter a title')));
                      //   return;
                      // }
                      // if (bodyController.text.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please enter a description')));
                      //   return;
                      // }
                      // if (ctaController.text.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please enter a CTA')));
                      //   return;
                      // }
                      // if (routeController.text.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please enter a route')));
                      //   return;
                      // }
                      // if (payloadController.text.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Please enter a payload')));
                      //   return;
                      // }
                      // if (imageController.text.isEmpty) {
                      //   imageController.text = finalImage;
                      // }
                      try {
                        Navigator.pop(context);
                        // NetworkImage(imageController.text);
                        showDialog(
                          context: context,
                          builder: (context) {
                            var currentStep = 0;
                            return StatefulBuilder(
                                builder: (context, setDialogState) {
                              return AlertDialog(
                                title: Text('Sending Notification...'),
                                content: SizedBox(
                                  height: 300,
                                  width: 400,
                                  child: Stepper(
                                    currentStep: currentStep,
                                    steps: [
                                      Step(
                                        title: Text("Open Firebase Console"),
                                        content: FilledButton(
                                          child: Text("Open Console"),
                                          onPressed: () {
                                            launchUrlString(
                                                "https://console.firebase.google.com/project/bheeshma-naturals/messaging");
                                          },
                                        ),
                                        subtitle: Text(
                                            "Tap on the link below to open Firebase console"),
                                        isActive: currentStep == 0,
                                        state: currentStep > 0
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: Text("Create New Campaign"),
                                        content: Text("Choose `notification`"),
                                        isActive: currentStep == 1,
                                        state: currentStep > 1
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: Text("Enter Title and Text"),
                                        content: Text(
                                            "Enter the title of the notification"),
                                        isActive: currentStep == 2,
                                        state: currentStep > 2
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: Text("Enter Notification Image"),
                                        content: Text(
                                            "Enter the title of the notification"),
                                        isActive: currentStep == 3,
                                        state: currentStep > 3
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: Text("Enter Target"),
                                        content: Text(
                                            "Choose `bheeshmaorganics (android)`"),
                                        isActive: currentStep == 4,
                                        state: currentStep > 4
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                      Step(
                                        title: Text("Go to Additional options"),
                                        subtitle: Text(
                                            "Enter the following data in custom data"),
                                        content: Container(
                                          child: SelectableText(
                                              'cta: ${ctaController.text}\nroute: ${routeController.text}\npayload: ${payloadController.text}'),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceVariant),
                                        ),
                                        isActive: currentStep == 5,
                                        state: currentStep > 5
                                            ? StepState.complete
                                            : StepState.indexed,
                                      ),
                                    ],
                                    onStepContinue: () {
                                      if (currentStep == 5) {
                                        Navigator.pop(context);
                                        return;
                                      }
                                      currentStep++;
                                      setDialogState(() {});
                                    },
                                    onStepTapped: (_) {
                                      currentStep = _;
                                      setDialogState(() {});
                                    },
                                  ),
                                ),
                              );
                            });
                          },
                        );
                        // await notificationProvider.sendNotification(
                        //   BheeshmaNotification(
                        //     title: titleController.text,
                        //     body: bodyController.text,
                        //     image: imageController.text,
                        //     type: 'general',
                        //     id: notificationProvider.notification.length
                        //         .toString(),
                        //     updatedAt: DateTime.now().toString(),
                        //     cta: ctaController.text,
                        //     payload: payloadController.text,
                        //     route: getRouteFromPage(routeController.text),
                        //   ),
                        // );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter a valid image url')));
                        return;
                      }

                      // Navigator.pop(context);
                    },
                    child: Text('Send'),
                  ),
                ]),
              ],
            ),
          );
        },
      );
    },
  );
}

getRouteFromPage(String text) {
  final pages = [
    "Home Page",
    "Product Page",
    "Review Page",
    "Profile Page",
    "Wishlist Page",
    "Notifications Page",
    "Orders Page"
  ];
  final routes = [
    '/home',
    '/product',
    '/review',
    '/profile',
    '/wishlist',
    '/notifications',
    '/orders',
  ];
  return routes[pages.indexOf(text)];
}
