import 'package:bheeshma_naturals_admin/data/entitites/category.dart';
import 'package:bheeshma_naturals_admin/data/providers/category_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final Category category;
  const CategoryItem(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      return Row(
        children: [
          Text(
            "#${category.id}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade500, fontWeight: FontWeight.w200),
          ),
          const SizedBox(
            width: 24,
          ),
          Text(
            category.name.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              showCategoryBottomSheet(context, categoryProvider,
                  category: category);
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Consumer<ProductProvider>(builder: (context, productProvider, _) {
            return IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await categoryProvider.deleteCategory(
                                        category.id, productProvider);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No')),
                            ],
                            title: const Text('Are you sure?'),
                            content: const Text(
                                'Do you want to delete this category?\nThis will delete all the subcategories and products under this category.')));
              },
              icon: const Icon(
                Icons.delete,
              ),
              color: Colors.red.shade200,
            );
          }),
        ],
      );
    });
  }
}

class SubcategoryItem extends StatelessWidget {
  final Subcategory subcategory;
  const SubcategoryItem(this.subcategory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      return Row(
        children: [
          Text(
            "#${subcategory.id}",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade500, fontWeight: FontWeight.w200),
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subcategory.category.name.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                subcategory.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              showSubcategoryBottomSheet(context, categoryProvider,
                  subcategory: subcategory);
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () async {
              await categoryProvider.deleteSubcategory(subcategory.id);
            },
            icon: const Icon(
              Icons.delete,
            ),
            color: Colors.red.shade200,
          ),
        ],
      );
    });
  }
}

Future<dynamic> showSubcategoryBottomSheet(
    BuildContext context, CategoryProvider categoryProvider,
    {Subcategory? subcategory}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        var nameController = TextEditingController(text: subcategory?.name);
        var category = subcategory?.category;
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                Text(
                  subcategory == null
                      ? 'Add Subcategory'.toUpperCase()
                      : 'Update Subcategory'.toUpperCase(),
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
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer),
                  controller: nameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                DropdownMenu<Category>(
                  width: 540,
                  initialSelection: category,
                  dropdownMenuEntries: categoryProvider.categories
                      .map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.name,
                          ))
                      .toList(),
                  onSelected: (newCategory) {
                    setSheetState(() {
                      category = newCategory ?? category;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a name')));
                        return;
                      }
                      if (category == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select a category')));
                        return;
                      }
                      if (subcategory != null) {
                        await categoryProvider.editSubcategory(Subcategory(
                            id: subcategory.id,
                            name: nameController.text,
                            category: category!));
                      } else {
                        await categoryProvider.addSubcategory(Subcategory(
                            id: categoryProvider.subcategories.length,
                            name: nameController.text,
                            category: category!));
                      }

                      Navigator.pop(context);
                    },
                    child: Text(subcategory == null ? 'Add' : 'Update'),
                  ),
                ]),
              ],
            ),
          );
        });
      });
}

Future<dynamic> showCategoryBottomSheet(
    BuildContext context, CategoryProvider categoryProvider,
    {Category? category}) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        var nameController = TextEditingController(text: category?.name);
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              children: [
                Text(
                  category == null
                      ? 'Add category'.toUpperCase()
                      : 'Update category'.toUpperCase(),
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
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer),
                  controller: nameController,
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a name')));
                        return;
                      }
                      if (category != null) {
                        await categoryProvider.editCategory(
                          Category(
                            id: category.id,
                            name: nameController.text,
                          ),
                        );
                      } else {
                        await categoryProvider.addCategory(
                            Category(
                              id: categoryProvider.categories.length,
                              name: nameController.text,
                            ), (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                            ),
                          );
                        });
                      }

                      Navigator.pop(context);
                    },
                    child: Text(category == null ? 'Add' : 'Update'),
                  ),
                ]),
              ],
            ),
          );
        });
      });
}
