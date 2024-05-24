import 'package:bheeshma_naturals_admin/data/entitites/advertisements.dart';
import 'package:bheeshma_naturals_admin/data/providers/advertisement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvertisementItem extends StatelessWidget {
  final Advertisement advertisement;
  const AdvertisementItem(this.advertisement, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<AdvertisementProvider>(
          builder: (context, advertisementProvider, _) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    advertisement.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showAdvertisementBottomSheet(
                          context, advertisementProvider,
                          advertisement: advertisement);
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () async {
                      await advertisementProvider
                          .deleteAdvertisement(advertisement.id);
                    },
                    icon: const Icon(
                      Icons.delete,
                    ),
                    color: Colors.red.shade200,
                    iconSize: 20,
                  ),
                ],
              ),
              Text(
                advertisement.subtitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                advertisement.description,
              ),
              Row(
                children: [
                  Icon(
                    Icons.help,
                    size: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    advertisement.cta,
                  ),
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
                  Text(advertisement.route),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "?args=" + advertisement.arguments.toString(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

Future<dynamic> showAdvertisementBottomSheet(
    BuildContext context, AdvertisementProvider advertisementProvider,
    {Advertisement? advertisement}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        var nameController = TextEditingController(text: advertisement?.title);
        var descriptionController =
            TextEditingController(text: advertisement?.description);
        var subtitleController =
            TextEditingController(text: advertisement?.subtitle);
        var ctaController = TextEditingController(text: advertisement?.cta);
        var routeController = TextEditingController(text: advertisement?.route);
        var argumentsController =
            TextEditingController(text: advertisement?.arguments.toString());

        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  advertisement == null
                      ? 'Add advertisement'.toUpperCase()
                      : 'Update advertisement'.toUpperCase(),
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
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelText: 'Title',
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        controller: nameController,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Subtitle',
                        ),
                        controller: subtitleController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  controller: descriptionController,
                  maxLines: null,
                ),
                const SizedBox(
                  height: 12,
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
                        controller: argumentsController,
                      ),
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
                      if (nameController.text.isEmpty ||
                          subtitleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          ctaController.text.isEmpty ||
                          routeController.text.isEmpty ||
                          argumentsController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                        return;
                      }
                      if (advertisement != null) {
                        await advertisementProvider.updateAdvertisement(
                          Advertisement(
                            id: advertisement.id,
                            title: nameController.text,
                            subtitle: subtitleController.text,
                            description: descriptionController.text,
                            cta: ctaController.text,
                            route: routeController.text,
                            arguments: argumentsController.text,
                          ),
                        );
                      } else {
                        await advertisementProvider.addAdvertisement(
                          Advertisement(
                            id: DateTime.now().toString(),
                            title: nameController.text,
                            subtitle: subtitleController.text,
                            description: descriptionController.text,
                            cta: ctaController.text,
                            route: routeController.text,
                            arguments: argumentsController.text,
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: Text(advertisement == null ? 'Add' : 'Update'),
                  ),
                ]),
              ],
            ),
          );
        });
      });
}

Future<dynamic> showImageAdvertisementBottomSheet(
    BuildContext context, AdvertisementProvider advertisementProvider,
    {ImageAdvertisement? advertisement}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        var nameController = TextEditingController(text: advertisement?.url);

        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  advertisement == null
                      ? 'Add advertisement'.toUpperCase()
                      : 'Update advertisement'.toUpperCase(),
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
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelText: 'URL',
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        controller: nameController,
                      ),
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
                  advertisement != null
                      ? OutlinedButton(
                          onPressed: () {
                            advertisementProvider
                                .deleteImageAdvertisement(advertisement.id);
                            Navigator.pop(context);
                          },
                          child: const Text("Delete"),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 24,
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                        return;
                      }
                      if (advertisement != null) {
                        await advertisementProvider.updateImageAdvertisement(
                            ImageAdvertisement(
                                url: nameController.text,
                                id: advertisement.id));
                      } else {
                        await advertisementProvider.addImageAdvertisement(
                            ImageAdvertisement(
                                url: nameController.text, id: ""));
                      }

                      Navigator.pop(context);
                    },
                    child: Text(advertisement == null ? 'Add' : 'Update'),
                  ),
                ]),
              ],
            ),
          );
        });
      });
}
