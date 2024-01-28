import 'package:bheeshma_naturals_admin/data/entitites/coupon.dart';
import 'package:bheeshma_naturals_admin/data/entitites/discount_type.dart';
import 'package:bheeshma_naturals_admin/data/providers/coupon_provider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CouponTile extends StatelessWidget {
  final Coupon coupon;
  const CouponTile(
    this.coupon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CouponProvider>(builder: (context, couponProvider, _) {
      return ListTile(
        onTap: () {
          showCouponBottomSheet(context, couponProvider, coupon: coupon);
        },
        title: Text(
          coupon.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(coupon.description),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                      'Valid from ${coupon.validFrom.day}/${coupon.validFrom.month}/${coupon.validFrom.year.toString().substring(2, 4)} - ${coupon.validTill.day}/${coupon.validTill.month}/${coupon.validTill.year.toString().substring(2, 4)}'),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.payment,
                  size: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text('Min: Rs. ${coupon.minimumOrderAmount}'),
                ),
                const SizedBox(
                  width: 16,
                ),
                const Icon(
                  Icons.discount_rounded,
                  size: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                Opacity(
                  opacity: 0.5,
                  child: Text('Rs. ${coupon.maximumDiscountAmount}'),
                ),
              ],
            )
          ],
        ),
        leading: SizedBox(
          width: 100,
          child: Center(
            child: Text(
              coupon.code,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        trailing: Text(
          (coupon.type == DiscountType.fixed ? "₹" : "") +
              coupon.discount.toString() +
              (coupon.type == DiscountType.fixed ? "" : "%"),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
        ),
      );
    });
  }
}

Future<dynamic> showCouponBottomSheet(
    BuildContext context, CouponProvider couponProvider,
    {Coupon? coupon}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        var nameController = TextEditingController(text: coupon?.name);
        var descriptionController =
            TextEditingController(text: coupon?.description);
        var codeController = TextEditingController(text: coupon?.code);
        var validFromController = TextEditingController(
            text: DateFormat('dd MMM yyyy')
                .format(coupon?.validFrom ?? DateTime.now()));
        var validTillController = TextEditingController(
            text: DateFormat('dd MMM yyyy')
                .format(coupon?.validTill ?? DateTime.now()));
        var minimumOrderAmountController =
            TextEditingController(text: coupon?.minimumOrderAmount.toString());
        var maximumDiscountAmountController = TextEditingController(
            text: coupon?.maximumDiscountAmount.toString());
        var discountController =
            TextEditingController(text: coupon?.discount.toString());
        var type = coupon?.type;
        return StatefulBuilder(builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  coupon == null
                      ? 'Add coupon'.toUpperCase()
                      : 'Update coupon'.toUpperCase(),
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
                            labelText: 'Name',
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
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Code',
                        ),
                        controller: codeController,
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
                          labelText: 'Valid From',
                          suffixIcon: IconButton(
                            icon: const Icon(FeatherIcons.calendar),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate:
                                    coupon?.validFrom ?? DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                            },
                          ),
                        ),
                        readOnly: true,
                        controller: validFromController,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Valid To',
                          suffixIcon: IconButton(
                            icon: const Icon(FeatherIcons.calendar),
                            onPressed: () async {
                              final dateTime = await showDatePicker(
                                context: context,
                                initialDate:
                                    coupon?.validTill ?? DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              setSheetState(() {
                                validTillController.text =
                                    DateFormat('dd MMM yyyy')
                                        .format(dateTime ?? DateTime.now());
                              });
                            },
                          ),
                        ),
                        controller: validTillController,
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Radio(
                        value: DiscountType.percentage,
                        groupValue: type,
                        onChanged: (_) {
                          setSheetState(() {
                            type = DiscountType.percentage;
                          });
                        }),
                    const Text("Percent"),
                    Radio(
                        value: DiscountType.fixed,
                        groupValue: type,
                        onChanged: (_) {
                          setSheetState(() {
                            type = DiscountType.fixed;
                          });
                        }),
                    const Text("Fixed"),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            labelText: 'Discount',
                            filled: true,
                            fillColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        controller: discountController,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Min. Order Amount',
                        ),
                        controller: minimumOrderAmountController,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Max. Discount',
                        ),
                        controller: maximumDiscountAmountController,
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
                  coupon == null
                      ? const SizedBox()
                      : TextButton.icon(
                          onPressed: () async {
                            await couponProvider.deleteCoupon(coupon.id);
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade800),
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  FilledButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a name')));
                        return;
                      }
                      if (codeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a code')));
                        return;
                      }
                      if (descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a description')));
                        return;
                      }
                      if (validFromController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a valid from')));
                        return;
                      }
                      if (validTillController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a valid till')));
                        return;
                      }
                      if (discountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a discount')));
                        return;
                      }
                      if (minimumOrderAmountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a minimum order')));
                        return;
                      }
                      if (maximumDiscountAmountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter a maximum discount')));
                        return;
                      }
                      if (type == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please select a discount type')));
                        return;
                      }

                      if (coupon != null) {
                        await couponProvider.editCoupon(
                          Coupon(
                            id: coupon.id,
                            name: nameController.text,
                            code: codeController.text,
                            description: descriptionController.text,
                            validFrom: validFromController.text.isEmpty
                                ? DateTime.now()
                                : DateFormat('dd MMM yyyy')
                                    .parse(validFromController.text),
                            validTill: validTillController.text.isEmpty
                                ? DateTime.now()
                                : DateFormat('dd MMM yyyy')
                                    .parse(validTillController.text),
                            type: type ?? coupon.type,
                            discount: int.parse(discountController.text),
                            minimumOrderAmount:
                                int.parse(minimumOrderAmountController.text),
                            maximumDiscountAmount: double.parse(
                                maximumDiscountAmountController.text),
                            isActive: DateTime.now().isAfter(
                                DateFormat('dd MMM yyyy')
                                    .parse(validFromController.text)),
                          ),
                        );
                      } else {
                        await couponProvider.addCoupon(
                          Coupon(
                            id: nameController.text.substring(0, 4) +
                                couponProvider.coupons.length.toString(),
                            name: nameController.text,
                            code: codeController.text,
                            description: descriptionController.text,
                            validFrom: validFromController.text.isEmpty
                                ? DateTime.now()
                                : DateFormat('dd MMM yyyy')
                                    .parse(validFromController.text),
                            validTill: validTillController.text.isEmpty
                                ? DateTime.now()
                                : DateFormat('dd MMM yyyy')
                                    .parse(validTillController.text),
                            type: type ?? DiscountType.percentage,
                            discount: int.parse(discountController.text),
                            minimumOrderAmount:
                                int.parse(minimumOrderAmountController.text),
                            maximumDiscountAmount: double.parse(
                                maximumDiscountAmountController.text),
                            isActive: DateTime.now().isAfter(
                                DateFormat('dd MMM yyyy')
                                    .parse(validFromController.text)),
                          ),
                        );
                      }

                      Navigator.pop(context);
                    },
                    child: Text(coupon == null ? 'Add' : 'Update'),
                  ),
                ]),
              ],
            ),
          );
        });
      });
}
