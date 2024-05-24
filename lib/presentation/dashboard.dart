import 'package:animations/animations.dart';
import 'package:bheeshma_naturals_admin/data/entitites/category.dart';
import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:bheeshma_naturals_admin/data/entitites/product.dart';
import 'package:bheeshma_naturals_admin/data/providers/advertisement_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/category_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/coupon_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/notification_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/order_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/product_provider.dart';
import 'package:bheeshma_naturals_admin/presentation/advertisment_item.dart';
import 'package:bheeshma_naturals_admin/presentation/categories.dart';
import 'package:bheeshma_naturals_admin/presentation/category_item.dart';
import 'package:bheeshma_naturals_admin/presentation/coupon_item.dart';
import 'package:bheeshma_naturals_admin/presentation/explore_card.dart';
import 'package:bheeshma_naturals_admin/presentation/notification_item.dart';
import 'package:bheeshma_naturals_admin/presentation/order_card.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var pageIndex = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OpenContainer(
        middleColor: Theme.of(context).colorScheme.background,
        openColor: Theme.of(context).colorScheme.background,
        closedColor: Theme.of(context).colorScheme.background,
        transitionDuration: const Duration(milliseconds: 500),
        closedBuilder: (BuildContext c, VoidCallback action) => pageIndex == 5
            ? const SizedBox()
            : FloatingActionButton(
                elevation: 0,
                child: const Icon(Icons.add),
                onPressed: () {
                  if (pageIndex == 1) {
                    showCategoryBottomSheet(context,
                        Provider.of<CategoryProvider>(context, listen: false));
                    return;
                  }
                  if (pageIndex == 2) {
                    showSubcategoryBottomSheet(context,
                        Provider.of<CategoryProvider>(context, listen: false));
                    return;
                  }
                  if (pageIndex == 4) {
                    showAdvertisementBottomSheet(
                        context,
                        Provider.of<AdvertisementProvider>(context,
                            listen: false));
                    return;
                  }
                  if (pageIndex == 6) {
                    showNotificationBottomSheet(
                        context,
                        Provider.of<NotificationProvider>(context,
                            listen: false));
                    return;
                  }
                  if (pageIndex == 7) {
                    showCouponBottomSheet(context,
                        Provider.of<CouponProvider>(context, listen: false));
                    return;
                  }
                  if (pageIndex == 8) {
                    showImageAdvertisementBottomSheet(
                        context,
                        Provider.of<AdvertisementProvider>(context,
                            listen: false));
                    return;
                  }
                  action();
                },
              ),
        openElevation: 0,
        closedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        closedElevation: 0.0,
        openBuilder: (BuildContext c, VoidCallback action) =>
            const NewProductPage(),
        tappable: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 56),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NavigationDrawer(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? null
                    : Colors.white,
                selectedIndex: pageIndex - 1,
                onDestinationSelected: (value) {
                  setState(() {
                    pageIndex = value + 1;
                  });
                },
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      SvgPicture.asset(
                        'assets/images/bheeshma-naturals.svg',
                        height: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ...([
                    {
                      'icon': FeatherIcons.package,
                      'label': 'Categories',
                    },
                    {
                      'icon': FeatherIcons.package,
                      'label': 'Subcatgories',
                    },
                    {
                      'icon': FeatherIcons.package,
                      'label': 'Product',
                    },
                    {
                      'icon': FeatherIcons.trendingUp,
                      'label': 'Advertisements',
                    },
                    {
                      'icon': FeatherIcons.package,
                      'label': 'Orders',
                    },
                    {
                      'icon': FeatherIcons.bell,
                      'label': 'Notifications',
                    },
                    {
                      'icon': FeatherIcons.dollarSign,
                      'label': 'Coupons',
                    },
                    {
                      'icon': FeatherIcons.trendingUp,
                      'label': 'Image Advertisements',
                    },
                  ].map(
                    (e) => NavigationDrawerDestination(
                      icon: Icon(e['icon'] as IconData),
                      label: Text(e['label'].toString()),
                    ),
                  )),
                ]),
            Expanded(
              child: Padding(
                padding: pageIndex == 3
                    ? EdgeInsets.all(24).copyWith(left: 0)
                    : const EdgeInsets.all(24),
                child: pageIndex == 1
                    ? const CategoriesSection()
                    : pageIndex == 2
                        ? const SubcategoriesSection()
                        : pageIndex == 3
                            ? const ProductsSection()
                            : pageIndex == 4
                                ? const AdvertisementSection()
                                : pageIndex == 5
                                    ? const OrderSection()
                                    : pageIndex == 6
                                        ? const NotificationSection()
                                        : pageIndex == 7
                                            ? const CouponSection()
                                            : const ImageAdvertisementSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewProductPage extends StatefulWidget {
  final Product? product;
  const NewProductPage({
    super.key,
    this.product,
  });

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  DiscountType? type;
  Category? category;
  Subcategory? subcategory;
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var pricesAndQuantityControllers = [
    {
      'price': TextEditingController(),
      'quantity': TextEditingController(),
      'stock': TextEditingController(),
      'discount': TextEditingController(),
    }
  ];
  var discountController = TextEditingController();
  var coverUrlController = TextEditingController();
  XFile? image;
  String? imageURL;

  @override
  void initState() {
    super.initState();
    category = widget.product?.category;
    subcategory = widget.product?.subcategory;
    nameController.text = widget.product?.name ?? '';
    descriptionController.text = widget.product?.description ?? '';
    discountController.text = widget.product?.discount.toString() ?? '';
    coverUrlController.text = widget.product?.cover ?? '';
    type = widget.product?.discountType;
    pricesAndQuantityControllers = [];
    widget.product?.price.forEach((element) {
      pricesAndQuantityControllers.add({
        'price': TextEditingController(text: element.price.toString()),
        'quantity': TextEditingController(text: element.quantity.toString()),
        'stock': TextEditingController(text: element.stock.toString()),
        'discount': TextEditingController(text: element.discount.toString()),
      });
    });
    imageURL = widget.product?.image;
    print(widget.product?.docId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
          return Consumer<CategoryProvider>(
              builder: (context, categoryProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (widget.product == null ? 'Add Product' : 'Update Product')
                        .toUpperCase(),
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
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  labelText: 'Name',
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer),
                              controller: nameController,
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
                              height: 24,
                            ),
                            ListView.separated(
                                itemCount: pricesAndQuantityControllers.length,
                                shrinkWrap: true,
                                primary: false,
                                separatorBuilder: (_, __) => const SizedBox(
                                      height: 16,
                                    ),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              pricesAndQuantityControllers
                                                      .elementAt(
                                                          index)['quantity']
                                                  as TextEditingController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            labelText: 'Quantity',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              pricesAndQuantityControllers
                                                      .elementAt(index)['price']
                                                  as TextEditingController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            labelText: 'Price',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              pricesAndQuantityControllers
                                                      .elementAt(index)['stock']
                                                  as TextEditingController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            labelText: 'Stock',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller:
                                              pricesAndQuantityControllers
                                                      .elementAt(
                                                          index)['discount']
                                                  as TextEditingController,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            labelText: 'Discount',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            pricesAndQuantityControllers
                                                .removeAt(index);
                                          });
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  );
                                }),
                            const SizedBox(
                              height: 8,
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    pricesAndQuantityControllers.add({
                                      'price': TextEditingController(),
                                      'quantity': TextEditingController(),
                                      'stock': TextEditingController(),
                                      'discount': TextEditingController(),
                                    });
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Price')),
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            // Row(
                            //   children: [
                            //     Radio(
                            //         value: DiscountType.percentage,
                            //         groupValue: type,
                            //         onChanged: (_) {
                            //           setState(() {
                            //             type = DiscountType.percentage;
                            //           });
                            //         }),
                            //     const Text("Percent"),
                            //     Radio(
                            //         value: DiscountType.fixed,
                            //         groupValue: type,
                            //         onChanged: (_) {
                            //           setState(() {
                            //             type = DiscountType.fixed;
                            //           });
                            //         }),
                            //     const Text("Fixed"),
                            //     const SizedBox(
                            //       width: 12,
                            //     ),
                            //     Expanded(
                            //       child: TextField(
                            //         decoration: InputDecoration(
                            //             border: UnderlineInputBorder(
                            //                 borderRadius:
                            //                     BorderRadius.circular(8),
                            //                 borderSide: BorderSide.none),
                            //             labelText: 'Discount',
                            //             filled: true,
                            //             fillColor: Theme.of(context)
                            //                 .colorScheme
                            //                 .secondaryContainer),
                            //         controller: discountController,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                DropdownMenu<Category>(
                                  label: const Text('Category'),
                                  menuStyle: MenuStyle(
                                      shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )),
                                  initialSelection: category,
                                  dropdownMenuEntries:
                                      categoryProvider.categories
                                          .map((e) => DropdownMenuEntry(
                                                value: e,
                                                label: e.name,
                                              ))
                                          .toList(),
                                  onSelected: (newCategory) {
                                    setState(() {
                                      category = newCategory ?? category;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                DropdownMenu<Subcategory>(
                                  label: const Text('Subcategory'),
                                  width: 200,
                                  menuStyle: MenuStyle(
                                      shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )),
                                  initialSelection: subcategory,
                                  enabled: category != null &&
                                      categoryProvider.subcategories
                                          .where((element) =>
                                              element.category.id ==
                                              category?.id)
                                          .isNotEmpty,
                                  // initialSelection: category,
                                  dropdownMenuEntries: categoryProvider
                                      .subcategories
                                      .where((element) =>
                                          element.category.id == category?.id)
                                      .map((e) => DropdownMenuEntry(
                                            value: e,
                                            label: e.name,
                                          ))
                                      .toList(),
                                  onSelected: (newSubcategory) {
                                    setState(() {
                                      subcategory =
                                          newSubcategory ?? subcategory;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () async {
                                final image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  setState(() {
                                    this.image = image;
                                  });
                                }
                              },
                              child: image != null
                                  ? Image.network(
                                      image!.path,
                                      height: 300,
                                      width: 300,
                                      fit: BoxFit.cover,
                                    )
                                  : imageURL != null && imageURL!.isNotEmpty
                                      ? Image.network(
                                          imageURL!,
                                          height: 300,
                                          width: 300,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withOpacity(0.5),
                                          height: 300,
                                          width: 300,
                                          alignment: Alignment.center,
                                          child: const Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.photo_library),
                                              Text("Add Image"),
                                            ],
                                          ),
                                        ),
                            ),
                          ),
                          ...(image != null
                              ? [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          image = null;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.restart_alt_rounded,
                                        size: 16,
                                      ),
                                      label: const Text('Reset Image')),
                                ]
                              : []),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Cover URL',
                              ),
                              controller: coverUrlController,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Consumer<ProductProvider>(
                          builder: (context, productProvider, _) {
                        return FilledButton(
                          onPressed: () async {
                            var productImage = imageURL;
                            if (nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Name cannot be empty')));
                              return;
                            }
                            if (descriptionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Description cannot be empty')));
                              return;
                            }
                            if (pricesAndQuantityControllers.isEmpty ||
                                pricesAndQuantityControllers.any((element) =>
                                    (element['price'] as TextEditingController)
                                        .text
                                        .isEmpty ||
                                    (element['quantity']
                                            as TextEditingController)
                                        .text
                                        .isEmpty ||
                                    (element['stock'] as TextEditingController)
                                        .text
                                        .isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Price, Quantity and Stock cannot be empty')));
                              return;
                            }

                            if (category == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Category cannot be empty')));
                              return;
                            }

                            if (image != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Uploading Image')));
                              productImage = await productProvider.getImageURL(
                                  image!,
                                  productName: nameController.text);
                            }
                            var product = Product(
                              docId: widget.product?.docId,
                              id: widget.product?.id ??
                                  productProvider.products
                                          .reduce((value, element) =>
                                              value.id > element.id
                                                  ? value
                                                  : element)
                                          .id +
                                      1,
                              name: nameController.text,
                              description: descriptionController.text,
                              price: pricesAndQuantityControllers
                                  .map(
                                    (e) => QuantityInfo(
                                      quantity: (e['quantity']
                                              as TextEditingController)
                                          .text,
                                      price: double.parse(
                                          (e['price'] as TextEditingController)
                                              .text),
                                      stock: int.parse(
                                          (e['stock'] as TextEditingController)
                                              .text),
                                      discount: int.tryParse((e['discount']
                                                  as TextEditingController)
                                              .text) ??
                                          0,
                                    ),
                                  )
                                  .toList(),
                              discount:
                                  int.tryParse(discountController.text) ?? 0,
                              discountType: type ?? DiscountType.fixed,
                              category: category!,
                              subcategory: subcategory,
                              cover: coverUrlController.text.isEmpty
                                  ? 'https://firebasestorage.googleapis.com/v0/b/bheeshma-naturals.appspot.com/o/images%2Fproducts%2Ffeature-graphic.png?alt=media&token=cec39c8b-317b-4401-a748-7acafc9e9f57'
                                  : coverUrlController.text,
                              image: productImage ??
                                  'https://firebasestorage.googleapis.com/v0/b/bheeshma-naturals.appspot.com/o/images%2Fproducts%2FBheeshma-Naturals.png?alt=media&token=342bc183-c558-45d4-a97b-8e6cebb410d5',
                            );
                            if (widget.product != null) {
                              await productProvider.updateProduct(product);
                            } else {
                              await productProvider.addProduct(product);
                            }
                            Navigator.of(context).pop();
                          },
                          child:
                              Text((widget.product == null ? 'Add' : 'Update')),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            );
          });
        }),
      ),
    );
  }
}

class CouponSection extends StatelessWidget {
  const CouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coupons'.toUpperCase(),
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
            Consumer<CouponProvider>(builder: (context, value, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return CouponTile(value.coupons[index]);
                },
                primary: false,
                shrinkWrap: true,
                itemCount: value.coupons.length,
              );
            })
          ],
        ),
      ),
    );
  }
}

class NotificationSection extends StatelessWidget {
  const NotificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications'.toUpperCase(),
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
            Consumer<NotificationProvider>(
                builder: (context, notificationProvider, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return NotificationCard(
                      notificationProvider.notification[index]);
                },
                primary: false,
                shrinkWrap: true,
                itemCount: notificationProvider.notification.length,
              );
            })
          ],
        ),
      ),
    );
  }
}

class OrderSection extends StatefulWidget {
  const OrderSection({super.key});

  @override
  State<OrderSection> createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {
  var selectedChip = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders'.toUpperCase(),
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
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: [
                FilterChip(
                  showCheckmark: false,
                  selected: selectedChip == 0,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.new_label,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Fresh Orders"),
                    ],
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedChip = 0;
                    });
                  },
                ),
                FilterChip(
                  showCheckmark: false,
                  selected: selectedChip == 1,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pending_actions_rounded,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("In Progress"),
                    ],
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedChip = 1;
                    });
                  },
                ),
                FilterChip(
                  showCheckmark: false,
                  selected: selectedChip == 2,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_shipping,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Shipped"),
                    ],
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedChip = 2;
                    });
                  },
                ),
                FilterChip(
                  showCheckmark: false,
                  selected: selectedChip == 3,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.markunread_mailbox_rounded,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Delivered"),
                    ],
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedChip = 3;
                    });
                  },
                ),
                FilterChip(
                  showCheckmark: false,
                  selected: selectedChip == 7,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Cancelled"),
                    ],
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedChip = 7;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Consumer<OrderProvider>(builder: (context, orderProvider, child) {
              final cardDatagrams = orderProvider.orders
                  .where((element) => element.status.contains(selectedChip))
                  .toList();
              return GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: cardDatagrams.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    return OrderCard(cardDatagrams[index]);
                  });
            })
          ],
        ),
      ),
    );
  }
}

class SubcategoriesSection extends StatelessWidget {
  const SubcategoriesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SubCategories'.toUpperCase(),
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
          Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
            return CategoriesPage(categoryProvider.subcategories);
          }),
        ],
      ),
    );
  }
}

class ImageAdvertisementSection extends StatelessWidget {
  const ImageAdvertisementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image Advertisements'.toUpperCase(),
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
          Consumer<AdvertisementProvider>(
              builder: (context, advertisementProvider, _) {
            return GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: advertisementProvider.imageAds.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 2.2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showImageAdvertisementBottomSheet(
                          context, advertisementProvider,
                          advertisement: advertisementProvider.imageAds[index]);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        advertisementProvider.imageAds[index].url,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  );
                });
          }),
        ],
      ),
    );
  }
}

class AdvertisementSection extends StatelessWidget {
  const AdvertisementSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advertisements'.toUpperCase(),
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
          Consumer<AdvertisementProvider>(
              builder: (context, advertisementProvider, _) {
            return GridView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: advertisementProvider.advertisement.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 1.8),
                itemBuilder: (context, index) {
                  return AdvertisementItem(
                      advertisementProvider.advertisement[index]);
                });
          }),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories'.toUpperCase(),
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
          Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
            return CategoriesPage(categoryProvider.categories);
          }),
        ],
      ),
    );
  }
}

class ProductsSection extends StatefulWidget {
  const ProductsSection({
    super.key,
  });

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _subTabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final categoriesProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    _tabController =
        TabController(length: categoriesProvider.categories.length, vsync: this)
          ..addListener(() {
            ;
            _subTabController = TabController(
                length: categoriesProvider.subcategories
                    .where((element) =>
                        categoriesProvider.categories[_tabController.index] ==
                        element.category)
                    .length,
                vsync: this)
              ..addListener(() {
                setState(() {});
              });

            print(categoriesProvider.subcategories.where((element) =>
                categoriesProvider.categories[_tabController.index] ==
                element.category));
            setState(() {});
          });
    _subTabController = TabController(
        length: categoriesProvider.subcategories
            .where((element) =>
                categoriesProvider.categories[_tabController.index] ==
                element.category)
            .length,
        vsync: this)
      ..addListener(() {
        setState(() {});
      });
    searchController.addListener(() {
      setState(() {});
    });
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      final categories = categoryProvider.categories;
      final subcategories = categoryProvider.subcategories;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products'.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    'Everything naturals at one place'.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  isDense: true,
                  filled: true,
                  hintText: 'Search',
                  fillColor: const Color(0x50787F54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none),
                  suffixIcon: const Icon(
                    FeatherIcons.search,
                  ),
                ),
                controller: searchController,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              _tabController.animateTo(
                                categories.indexOf(e),
                                duration: Duration(
                                  seconds: 1,
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: e == categories[_tabController.index]
                                      ? Theme.of(context).colorScheme.secondary
                                      : null,
                                  borderRadius: BorderRadius.circular(36)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12)
                                    .copyWith(
                                        left: e ==
                                                categories[_tabController.index]
                                            ? 24
                                            : null),
                                child: Text(
                                  e.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          fontWeight: e ==
                                                  categories[
                                                      _tabController.index]
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: e ==
                                                  categories[
                                                      _tabController.index]
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary
                                              : null),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        //.copyWith(top: 80),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          searchController.text.isEmpty &&
                                  _subTabController.length > 0
                              ? TabBar(
                                  isScrollable: true,
                                  tabs: subcategories
                                      .where((element) =>
                                          categories[_tabController.index] ==
                                          element.category)
                                      .map((e) => Tab(
                                            text: e.name,
                                          ))
                                      .toList(),
                                  controller: _subTabController,
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 24,
                          ),
                        ]),
                      ),
                      Consumer<ProductProvider>(
                          builder: (context, productProvider, _) {
                        var categoricalProducts = searchController.text.isEmpty
                            ? productProvider.products
                                .where((element) =>
                                    element.category ==
                                    categories[_tabController.index])
                                .toList()
                            : productProvider.products
                                .where((element) =>
                                    searchController.text.isEmpty ||
                                    element.name.toLowerCase().contains(
                                        searchController.text.toLowerCase()))
                                .toList();
                        // print(categoricalProducts.first.name);
                        // print(categoricalProducts.first.subcategory?.name);
                        if (_subTabController.length >= 1) {
                          print(subcategories
                              .where((element) =>
                                  element.category ==
                                  categories[_tabController.index])
                              .toList()[_subTabController.index]
                              .name);
                          categoricalProducts = categoricalProducts
                              .where((element) =>
                                  element.subcategory ==
                                  subcategories
                                      .where((element) =>
                                          element.category ==
                                          categories[_tabController.index])
                                      .toList()[_subTabController.index])
                              .toList();
                          // print(categoricalProducts.first.name);
                        }
                        return GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: categoricalProducts.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 24,
                                    mainAxisSpacing: 24,
                                    childAspectRatio: 0.67),
                            itemBuilder: (context, index) {
                              return OpenContainer(
                                middleColor:
                                    Theme.of(context).colorScheme.background,
                                openColor:
                                    Theme.of(context).colorScheme.background,
                                closedColor:
                                    Theme.of(context).colorScheme.background,
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                closedBuilder:
                                    (BuildContext c, VoidCallback action) =>
                                        ExploreProductCard(
                                  categoricalProducts[index],
                                  onEdit: action,
                                ),
                                openElevation: 0,
                                closedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                closedElevation: 0.0,
                                openBuilder:
                                    (BuildContext c, VoidCallback action) =>
                                        NewProductPage(
                                  product: categoricalProducts[index],
                                ),
                                tappable: false,
                              );
                            });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
