import 'package:bheeshma_naturals_admin/data/entitites/order.dart';
import 'package:bheeshma_naturals_admin/data/providers/order_provider.dart';
import 'package:bheeshma_naturals_admin/presentation/invoice_page.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  const OrderCard(this.order, {super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  List<int> selectedItems = [];
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
                    "#${widget.order.id + 1}",
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
                  DateFormat('dd.MM.yy').format(widget.order.date),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  widget.order.razorpayPaymentId ?? "",
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
                        "${widget.order.shippingAddress.name}\n${widget.order.billingAddress.doorNumber}, ${widget.order.billingAddress.building}, ${widget.order.billingAddress.street}, ${widget.order.billingAddress.city}, ${widget.order.billingAddress.state}, ${widget.order.billingAddress.pincode}\n${widget.order.shippingAddress.phoneNumber}",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                                text:
                                    "${widget.order.shippingAddress.name}\n${widget.order.shippingAddress.phoneNumber}\n${widget.order.billingAddress.doorNumber}, ${widget.order.billingAddress.building}, ${widget.order.billingAddress.street}, ${widget.order.billingAddress.city}, ${widget.order.billingAddress.state}, ${widget.order.billingAddress.pincode}"),
                          );
                        },
                        icon: const Icon(FeatherIcons.copy)),
                  ],
                ),
              ),
              widget.order.status.where((e) => e != 0).isEmpty
                  ? const SizedBox(
                      height: 16,
                    )
                  : const SizedBox(),
              widget.order.status.where((e) => e != 0).isEmpty
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
                                widget.order.id, widget.order.uid ?? "");
                          },
                          child: const Text("Reject"),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        FilledButton(
                          onPressed: () {
                            orderProvider.acceptOrder(
                                widget.order.id, widget.order.uid ?? "");
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
                    crossAxisAlignment:
                        widget.order.deliveryStatus[index]['partner'] == null ||
                                widget.order.deliveryStatus[index]['partner']
                                    .toString()
                                    .isEmpty
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                    children: [
                      widget.order.status[index] == 7
                          ? Checkbox(
                              value: null,
                              onChanged: null,
                              fillColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.error),
                              tristate: true,
                            )
                          : Checkbox(
                              tristate: true,
                              value: selectedItems.contains(index)
                                  ? true
                                  : widget.order.status[index] == 2
                                      ? null
                                      : widget.order.status[index] > 1,
                              onChanged: widget.order.status[index] == 3
                                  ? null
                                  : selectedItems.isNotEmpty &&
                                          widget.order.status[index] !=
                                              widget.order
                                                  .status[selectedItems.first]
                                      ? null
                                      : (_) {
                                          if (selectedItems.contains(index)) {
                                            selectedItems.remove(index);
                                          } else {
                                            selectedItems.add(index);
                                          }
                                          setState(() {});
                                        },
                            ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.order.products[index].productName} x ${widget.order.products[index].quantity}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      decoration: widget.order.status[index] > 2
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationThickness: 2),
                            ),
                            widget.order.deliveryStatus[index]['partner'] ==
                                        null ||
                                    widget
                                        .order.deliveryStatus[index]['partner']
                                        .toString()
                                        .isEmpty
                                ? SizedBox()
                                : Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                      "${widget.order.deliveryStatus[index]['partner']}, ${widget.order.deliveryStatus[index]['text']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              decoration:
                                                  widget.order.status[index] > 2
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : null,
                                              decorationThickness: 2),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                itemCount: widget.order.products.length,
                primary: false,
                shrinkWrap: true,
              ),
              widget.order.status.where((e) => e != 7).isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          ...(selectedItems.isEmpty
                              ? []
                              : [
                                  FilledButton(
                                    onPressed: () {
                                      var trackingIDController =
                                          TextEditingController();
                                      var trackingPartnerController =
                                          TextEditingController();
                                      showDeliveryStatusChangeBottomSheet(
                                          context,
                                          selectedItems,
                                          trackingPartnerController,
                                          trackingIDController,
                                          orderProvider);
                                    },
                                    child: Text(widget.order.status[
                                                    selectedItems.first] ==
                                                1 ||
                                            widget.order.status[
                                                    selectedItems.first] ==
                                                0
                                        ? "Ship"
                                        : "Deliver"),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                ]),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => InvoicePage(
                                        widget.order,
                                      )));
                            },
                            child: Text("View Invoice"),
                          ),
                        ],
                      ),
                    ),
            ]),
          ),
        );
      }),
    );
  }

  Future<dynamic> showDeliveryStatusChangeBottomSheet(
      BuildContext context,
      List<int> index,
      TextEditingController trackingPartnerController,
      TextEditingController trackingIDController,
      OrderProvider orderProvider) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  'Update Order Item'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  'Everything naturals at one place'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ...(widget.order.status[selectedItems.first] < 2
                    ? [
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
                                    labelText: 'Shipping Partner',
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer),
                                controller: trackingPartnerController,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide.none),
                                    labelText: 'Tracking ID',
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer),
                                controller: trackingIDController,
                              ),
                            ),
                          ],
                        ),
                      ]
                    : []),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Spacer(),
                    widget.order.status[selectedItems.first] < 2
                        ? FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () async {
                              for (var element in selectedItems) {
                                await orderProvider.rejectOrderItem(
                                    widget.order.id,
                                    element,
                                    widget.order.uid ?? "");
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text("Reject"),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      width: 12,
                    ),
                    FilledButton(
                      onPressed: () {
                        if (widget.order.status[selectedItems.first] < 2 &&
                            trackingIDController.text.isEmpty &&
                            trackingPartnerController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Tracking ID cannot be empty")));
                          return;
                        }
                        for (var element in selectedItems) {
                          orderProvider.updateOrderItem(
                              widget.order.id,
                              element,
                              trackingPartnerController.text,
                              trackingIDController.text,
                              widget.order.uid ?? "");
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text(
                          widget.order.status[selectedItems.first] == 1 ||
                                  widget.order.status[selectedItems.first] == 0
                              ? "Ship"
                              : "Deliver"),
                    ),
                  ],
                )
              ]),
            );
          });
        });
  }
}
