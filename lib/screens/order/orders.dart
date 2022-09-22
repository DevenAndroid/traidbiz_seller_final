import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:traidbiz_seller/controller/store_order_controller.dart';
import '../../constraints/strings.dart';
import '../../utils/number_formatter.dart';
import '/constraints/colors.dart';
import '/constraints/styles.dart';
import '/screens/home/widgets/latest_sales_widget.dart';
import 'widgets/custom_circle_path.dart';

class OrderScreen extends GetView<StoreOrderController> {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          controller.refreshEarnings();
          controller.refreshStoreOrders();
        },
        child: SingleChildScrollView(
          controller: controller.scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          'Your Orders',
                          style:
                              Theme.of(context).textTheme.headline5?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Obx(
                            () => Text(
                              numberFormatTwoDecimal
                                  .format(controller.earnings.earnings ?? 0),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Your Overall Earnings',
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Positioned(
                      right: -20,
                      top: -20,
                      child: ClipPath(
                        clipper: CustomCirclePainter(),
                        child: Container(
                          height: 180,
                          width: 200,
                          color: colorBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: DropdownButtonFormField<String>(
                  items: List.generate(
                    productFilters.length,
                    (index) => DropdownMenuItem(
                      value: productFilters[index].toLowerCase(),
                      child: Text(productFilters[index]),
                    ),
                  ),
                  decoration: inputDecorationFilled2.copyWith(
                    labelText: 'Filter',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    controller.refreshStoreOrders(filterBy: value);
                  },
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Latest Sales',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      controller.obx(
                        (state) => LatestSales(
                            state: state
                        ),
                        onLoading: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        onEmpty: const Center(
                          child: Text(
                            'Orders not found',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onError: (error) => Column(
                          children: [
                            const Center(
                              child: Text(
                                'Error: Cannot get orders..',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            MaterialButton(
                                child: const Text("Retry"),
                                onPressed: () async {
                                  controller.refreshEarnings();
                                  controller.refreshStoreOrders();
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
