import 'package:bheeshma_naturals_admin/data/entitites/notification.dart';
import 'package:bheeshma_naturals_admin/data/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var routeController = TextEditingController();
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
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 240,
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.photo_library),
                                      Text("Add Image"),
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
                                  Text("Add Image"),
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
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: 'Route',
                                ),
                                controller: routeController,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelText: 'Arguments',
                                ),
                                controller: payloadController,
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
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
                      if (titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a title')));
                        return;
                      }
                      if (bodyController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a description')));
                        return;
                      }
                      if (ctaController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a CTA')));
                        return;
                      }
                      if (routeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a route')));
                        return;
                      }
                      if (payloadController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a payload')));
                        return;
                      }
                      if (imageController.text.isEmpty) {
                        imageController.text = finalImage;
                      }
                      try {
                        NetworkImage(imageController.text);
                        await notificationProvider.sendNotification(
                          BheeshmaNotification(
                            title: titleController.text,
                            body: bodyController.text,
                            image: imageController.text,
                            type: 'general',
                            id: notificationProvider.notification.length
                                .toString(),
                            updatedAt: DateTime.now().toString(),
                            cta: ctaController.text,
                            payload: payloadController.text,
                            route: routeController.text,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter a valid image url')));
                        return;
                      }

                      Navigator.pop(context);
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
