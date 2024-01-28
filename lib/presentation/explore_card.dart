import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:bheeshma_naturals_admin/data/entitites/product.dart';
import 'package:bheeshma_naturals_admin/data/providers/product_provider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreProductCard extends StatelessWidget {
  final Product product;
  final Function() onEdit;
  const ExploreProductCard(
    this.product, {
    super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              product.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Text(
              '₹${product.price.first.price.toInt()}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration:
                      product.discount > 0 ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF699E81).withOpacity(0.6),
                  decorationColor: const Color(0xFF699E81).withOpacity(0.7)),
            ),
            SizedBox(
              width: product.discount > 0 ? 6 : 0,
            ),
            product.discount > 0
                ? Text(
                    '₹${product.discountedPrices.first.price.toInt()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF699E81),
                        ),
                  )
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
        product.discount > 0
            ? Text(
                '(${product.discount}${product.discountType == DiscountType.percentage ? '%' : '₹'} off)',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              )
            : const SizedBox(
                height: 16,
              ),
        Text(
          product.description,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.normal,
              ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            MaterialButton(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              onPressed: onEdit,
              child: Text(
                'Edit Product'.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              width: 40,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.black,
                    width: 1.3,
                  ),
                ),
                onPressed: () {
                  Provider.of<ProductProvider>(context, listen: false)
                      .deleteProduct(product.docId);
                },
                child: Icon(
                  FeatherIcons.trash,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
