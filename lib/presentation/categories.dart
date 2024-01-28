import 'package:bheeshma_naturals_admin/data/entitites/category.dart';
import 'package:bheeshma_naturals_admin/presentation/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesPage<T> extends StatelessWidget {
  final List<T> items;
  const CategoriesPage(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return items is List<Category>
            ? CategoryItem(items[index] as Category)
            : items is List<Subcategory>
                ? SubcategoryItem(items[index] as Subcategory)
                : Text(items[index].toString());
      },
      separatorBuilder: (context, _) => SizedBox(
        height: 12,
      ),
      itemCount: items.length,
      primary: false,
      shrinkWrap: true,
    );
  }
}
