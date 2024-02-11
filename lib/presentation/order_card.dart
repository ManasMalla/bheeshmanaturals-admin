import 'package:bheeshma_naturals_admin/data/entitites/order.dart';
import 'package:bheeshma_naturals_admin/data/providers/order_provider.dart';
import 'package:bheeshma_naturals_admin/presentation/invoice_page.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<OrderProvider>(builder: (context, orderProvider, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text(
                    "ORDER",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.surfaceTint,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    "#${order.id + 1}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceTint
                            .withOpacity(0.3),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  DateFormat('dd.MM.yy').format(order.date),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceTint
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(FeatherIcons.mapPin),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Text(
                        "${order.shippingAddress.name}\n${order.shippingAddress.phoneNumber}\n${order.billingAddress.doorNumber}, ${order.billingAddress.building}, ${order.billingAddress.street}, ${order.billingAddress.city}, ${order.billingAddress.state}, ${order.billingAddress.pincode}",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              order.status.where((e) => e != 0).isEmpty
                  ? const SizedBox(
                      height: 16,
                    )
                  : const SizedBox(),
              order.status.where((e) => e != 0).isEmpty
                  ? Row(
                      children: [
                        const Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () {
                            orderProvider.rejectOrder(
                                order.id, order.uid ?? "");
                          },
                          child: const Text("Reject"),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        FilledButton(
                          onPressed: () {
                            orderProvider.acceptOrder(
                                order.id, order.uid ?? "");
                          },
                          child: const Text("Accept"),
                        ),
                        const Spacer(),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 24,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      order.status[index] == 7
                          ? Checkbox(
                              value: null,
                              onChanged: null,
                              fillColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.error),
                              tristate: true,
                            )
                          : Checkbox(
                              tristate: true,
                              value: order.status[index] == 2
                                  ? null
                                  : order.status[index] > 1,
                              onChanged: order.status[index] == 3
                                  ? null
                                  : (_) {
                                      var trackingIDController =
                                          TextEditingController();
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (context, setSheetState) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(48.0),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Update Order Item'
                                                            .toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineMedium
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                      Text(
                                                        'Everything naturals at one place'
                                                            .toUpperCase(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      ...(order.status[index] <
                                                              2
                                                          ? [
                                                              const SizedBox(
                                                                height: 24,
                                                              ),
                                                              TextField(
                                                                decoration: InputDecoration(
                                                                    border: const UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide
                                                                                .none),
                                                                    labelText:
                                                                        'Tracking ID',
                                                                    filled:
                                                                        true,
                                                                    fillColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondaryContainer),
                                                                controller:
                                                                    trackingIDController,
                                                              ),
                                                            ]
                                                          : []),
                                                      const SizedBox(
                                                        height: 24,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          order.status[index] <
                                                                  2
                                                              ? FilledButton(
                                                                  style: FilledButton
                                                                      .styleFrom(
                                                                    backgroundColor: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    orderProvider.rejectOrderItem(
                                                                        order
                                                                            .id,
                                                                        index,
                                                                        order.uid ??
                                                                            "");
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      "Reject"),
                                                                )
                                                              : const SizedBox(),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          FilledButton(
                                                            onPressed: () {
                                                              if (order.status[
                                                                          index] <
                                                                      2 &&
                                                                  trackingIDController
                                                                      .text
                                                                      .isEmpty) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(const SnackBar(
                                                                        content:
                                                                            Text("Tracking ID cannot be empty")));
                                                                return;
                                                              }
                                                              orderProvider
                                                                  .updateOrderItem(
                                                                      order.id,
                                                                      index,
                                                                      trackingIDController
                                                                          .text,
                                                                      order.uid ??
                                                                          "");

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(order.status[
                                                                            index] ==
                                                                        1 ||
                                                                    order.status[
                                                                            index] ==
                                                                        0
                                                                ? "Ship"
                                                                : "Deliver"),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                              );
                                            });
                                          });
                                    },
                            ),
                      Expanded(
                        child: Text(
                          "${order.products[index].productName} x ${order.products[index].quantity}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  decoration: order.status[index] > 1
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationThickness: 2),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: order.products.length,
                primary: false,
                shrinkWrap: true,
              ),
              order.status.where((e) => e != 7).isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InvoicePage(
                                    order,
                                  )));
                        },
                        child: Text("View Invoice"),
                      ),
                    ),
            ]),
          ),
        );
      }),
    );
  }
}
