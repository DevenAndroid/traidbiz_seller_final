import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/constraints/colors.dart';
import 'package:traidbiz_seller/controller/store_order_controller.dart';
import 'package:traidbiz_seller/data/models/order/order_details.dart';
import 'package:traidbiz_seller/utils/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/home_controller.dart';
import '../../utils/date_formatter.dart';
import '../../utils/number_formatter.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int? orderId;
  const OrderDetailsScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final StoreOrderController _storeOrderController =
      Get.find<StoreOrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _storeOrderController.getOrderDetailsById(widget.orderId),
          builder: (context, AsyncSnapshot<StoreOrderDetail> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              StoreOrderDetail? order = snapshot.data;

              return Scaffold(
                appBar: AppBar(title: const Text('Order Details')),
                bottomNavigationBar:
                    _statusMap(order?.id, "${order?.status}")['button'] != null
                        ? Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Obx(
                              () => SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: _storeOrderController.isStateUpdating
                                    ? const LinearProgressIndicator()
                                    : ElevatedButton(
                                        onPressed: _statusMap(order?.id,
                                                "${order?.status}")['button']
                                            ['onPressed'],
                                        style: ElevatedButton.styleFrom(
                                          // backgroundColor: _statusMap(order?.id, "${order?.status}")['button']['color'],
                                        ),
                                        child: Text(
                                          _statusMap(order?.id,
                                                  "${order?.status}")['button']
                                              ['label'],
                                        ),
                                      ),
                              ),
                            ),
                          )
                        : null,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0)
                            .copyWith(
                          top: 20,
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Assigned',
                              style: TextStyle(
                                color: colorSuccess,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              orderDetailsDateFormat.format(
                                  DateTime.parse('${order?.createDate}')),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: const Icon(
                                Icons.list_alt,
                                color: colorPrimary,
                              ),
                              title: Text(
                                'Order #${order?.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorPrimary,
                                ),
                              ),
                              subtitle: Text(
                                orderDetailsDateFormat.format(
                                    DateTime.parse('${order?.createDate}')),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: _statusMap(
                                      order?.id, "${order?.status}")['color'],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                child: Text(
                                  _statusMap(
                                      order?.id, "${order?.status}")['status'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            OrderLineItems(order: order),
                          ],
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                        child: Text(
                          'Customer Detail',
                          style: TextStyle(
                            color: colorPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text(
                                'Customer Name',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              subtitle: Text(
                                '${order?.billing?.firstName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: const CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  PhosphorIcons.storefront,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Divider(height: 0),
                            ListTile(
                              title: const Text(
                                'Customer Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              subtitle: Text(
                                '${order?.billing?.phone}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: CircleAvatar(
                                // child: Icon(
                                //   PhosphorIcons.phone,
                                //   color: Colors.white,
                                // ),
                                backgroundColor: colorSuccess,
                                // child: Icon(
                                //   PhosphorIcons.phone,
                                //   color: Colors.white,
                                // ),
                                child: IconButton(
                                    onPressed: () {
                                      _clickToCall(order?.billing?.phone);
                                    },
                                    icon: const Icon(
                                      PhosphorIcons.phone,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            const Divider(height: 0),
                            ListTile(
                              title: const Text(
                                'Customer Address',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              isThreeLine: true,
                              subtitle: Text(
                                '${order?.billing?.address1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: const CircleAvatar(
                                child: Icon(PhosphorIcons.map_pin),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Delivery Fee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${order?.currencySymbol} 0',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    'Tax(VAT)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${order?.currencySymbol} ${order?.totalTax}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Total Payment',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${order?.currencySymbol} ${order?.orderTotal}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorSuccess,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Map<String, dynamic> _statusMap(orderId, String status) {
    switch (status) {
      case 'pending':
        return {
          'status': 'Pending',
          'color': colorAlert,
          'button': {
            'label': 'Mark Processing',
            'color': colorSecondary,
            'onPressed': () => _changeOrderState(orderId, 'wc-processing'),
          },
        };
      case 'processing':
        return {
          'status': 'Processing',
          'color': colorSecondary,
          'button': {
            'label': 'Mark Delivered',
            'color': colorSuccess,
            'onPressed': () => _changeOrderState(orderId, 'wc-completed'),
          },
        };
      case 'on-hold':
        return {
          'status': 'On Hold',
          'color': colorWarning,
          'button': {
            'label': 'Mark Delivered',
            'color': colorSuccess,
            'onPressed': () => _changeOrderState(orderId, 'wc-completed'),
          },
        };
      case 'completed':
        return {
          'status': 'Completed',
          'color': colorSuccess,
          'button': null,
        };
      case 'cancelled':
        return {
          'status': 'Cancelled',
          'color': colorDanger,
          'button': null,
        };
      default:
        return {
          'status': 'Pending',
          'color': colorAlert,
          'button': {
            'label': 'Mark Processing',
            'color': colorSecondary,
            'onPressed': () => _changeOrderState(orderId, 'wc-processing'),
          },
        };
    }
  }

  void _changeOrderState(orderId, String nextState) async {
    _storeOrderController
        .updateOrderStateById(
      orderId,
      nextState,
    )
        .then((value) {
      snack('Success', value.toString(), Icons.done);
      _storeOrderController.refreshStoreOrders();
      final homeController = Get.find<HomeController>();
      homeController.refreshHomepageStoreOrders();

      setState(() {});
    }, onError: (error) => snack('Error', error.toString(), Icons.error));
  }
}

class OrderLineItems extends StatelessWidget {
  const OrderLineItems({
    Key? key,
    required StoreOrderDetail? order,
  })  : _order = order,
        super(key: key);

  final StoreOrderDetail? _order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        _order?.lineItems?.length ?? 0,
        (index) => ListTile(
          horizontalTitleGap: 0,
          leading: const SizedBox(),
          title: RichText(
            text: TextSpan(
              text: '${_order?.lineItems?[index].quantity}x',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                const TextSpan(
                  text: '  ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: '${_order?.lineItems?[index].name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text('${_order?.paymentMethodTitle}'),
          trailing: Text(
            '${_order?.currencySymbol} ${numberFormatTwoDecimal.format(_order?.lineItems?[index].price)}',
            style: const TextStyle(
                color: colorSuccess, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

Future _clickToCall(tel) async {
  var url = 'tel:$tel';
  await launch(url);
}
