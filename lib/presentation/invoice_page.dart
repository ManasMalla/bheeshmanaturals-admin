import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:bheeshma_naturals_admin/data/entitites/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

getThemedColor(BuildContext context, Color lightColor, Color darkColor) {
  return Theme.of(context).brightness == Brightness.dark
      ? darkColor
      : lightColor;
}

class OrderItemCard extends StatelessWidget {
  final String productName;
  final String quantityChoice;
  final double price;
  final int quantity;
  final bool isReview;
  final bool isOrderHistory;
  final Function(int) modifyItemCount;
  final bool isCancelled;
  const OrderItemCard({
    super.key,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.quantityChoice,
    this.isReview = false,
    this.isOrderHistory = false,
    required this.modifyItemCount,
    this.isCancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  Opacity(
                    opacity: 0.54,
                    child: Text('$quantityChoice Pack',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
            quantity == 0
                ? const SizedBox()
                : Container(
                    decoration: BoxDecoration(
                        color: isOrderHistory ? null : const Color(0xFF487D60),
                        borderRadius: BorderRadius.circular(32),
                        border: isOrderHistory
                            ? Border.all(
                                color: getThemedColor(
                                    context, Colors.black, Colors.white))
                            : null),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: isReview ? 8 : 0,
                        ),
                        !isReview
                            ? InkWell(
                                onTap: () {
                                  modifyItemCount(-1);
                                },
                                child: const Icon(
                                  FeatherIcons.minusCircle,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                Icons.close,
                                size: 12,
                                color: isOrderHistory ? null : Colors.white,
                              ),
                        SizedBox(
                          width: isReview ? 5 : 12,
                        ),
                        Text(
                          quantity.toString(),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: isOrderHistory ? null : Colors.white,
                                  ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        !isReview
                            ? InkWell(
                                onTap: () {
                                  modifyItemCount(1);
                                },
                                child: const Icon(
                                  FeatherIcons.plusCircle,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
            quantity == 0
                ? const SizedBox()
                : const SizedBox(
                    width: 12,
                  ),
            isOrderHistory
                ? const SizedBox()
                : Container(
                    decoration: BoxDecoration(
                      color: getThemedColor(
                          context, const Color(0xFF699E81), Colors.white),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 24,
                    ),
                    child: Text(
                      "₹${price * (quantity == 0 ? 1 : quantity)}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: getThemedColor(
                              context,
                              Colors.white,
                              const Color(0xFF487D60),
                            ),
                          ),
                    ),
                  ),
            quantity == 0
                ? const SizedBox(
                    width: 12,
                  )
                : const SizedBox(),
            quantity == 0
                ? FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF487D60),
                    ),
                    onPressed: () {
                      modifyItemCount(1);
                    },
                    child: Text(
                      'ADD',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  )
                : const SizedBox()
          ],
        ),
        isCancelled
            ? Image.network(
                "https://static.vecteezy.com/system/resources/previews/021/433/002/original/cancelled-rubber-stamp-free-png.png",
                height: 50,
              )
            : SizedBox(),
      ],
    );
  }
}

class InvoicePage extends StatelessWidget {
  final Order order;
  const InvoicePage(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
          const SizedBox(
            height: 48,
          ),
          SvgPicture.asset(
            'assets/images/bheeshma-naturals.svg',
            height: 100,
            colorFilter: Theme.of(context).brightness == Brightness.dark
                ? const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  )
                : null,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'INVOICE',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text('Time'),
              const Spacer(),
              Text(DateFormat('hh:mm a').format(order.date)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text('Date'),
              const Spacer(),
              Text(DateFormat('dd-MM-yyyy').format(order.date)),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),
          ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(
                    height: 16,
                  ),
              itemCount: order.products.length,
              itemBuilder: (context, productOrderIndex) {
                final orderItem = order.products[productOrderIndex];
                return OrderItemCard(
                  productName: orderItem.productName,
                  price: orderItem.price,
                  quantity: orderItem.quantity,
                  quantityChoice: orderItem.size,
                  modifyItemCount: (_) {},
                  isReview: true,
                  isCancelled: order.status[productOrderIndex] == 7,
                );
              }),
          const SizedBox(
            height: 16,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Rs. ${order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                      (value, element) => value + element,
                    )}',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 8,
          ),
          Builder(builder: (context) {
            final coupon = order.coupon;
            return coupon == null
                ? const SizedBox()
                : Row(
                    children: [
                      Text(
                        'Discount ',
                      ),
                      Text(
                        '(${coupon.code} applied)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.4),
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '- Rs. ${coupon.type == DiscountType.percentage ? (coupon.discount * 0.01 * order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                              (value, element) => value + element,
                            )).toStringAsFixed(2) : coupon.discount.toStringAsFixed(2)}',
                      ),
                    ],
                  );
          }),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5),
              ),
              Text(
                'Rs. ${order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                      (value, element) => value + element,
                    ) - (order.coupon == null ? 0 : order.coupon!.type == DiscountType.percentage ? (order.coupon!.discount * 0.01 * order.products.map((e) => (e.price) * ((e.quantity))).reduce(
                      (value, element) => value + element,
                    )) : order.coupon!.discount)}',
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
        ]),
      ),
    );
  }
}
