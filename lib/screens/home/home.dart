import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/screens/drawer/drawer.dart';
import '/controller/home_controller.dart';
import 'package:intl/intl.dart';
import '../profile/profile.dart';
import 'widgets/latest_sales_widget.dart';
import 'widgets/report_grid_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    double crossAxisSpacing = 8, mainAxisSpacing = 12, aspectRatio = 1.2;
    int crossAxisCount = 2;
    final formatter = DateFormat('dd MMM, yyy');

    return controller.obx(
      (state) => Scaffold(
        /*appBar: AppBar(
          // leading: Builder(
          //   builder: (context) => IconButton(
          //     icon: const Icon(
          //       PhosphorIcons.list_bold,
          //       color: Colors.black,
          //     ),
          //     onPressed: () => Scaffold.of(context).openDrawer(),
          //   ),
          // ),
          // leadingWidth: 44,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi! ${controller.authCookie?.user?.displayName}'),
              Text(formatter.format(DateTime.now()),
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: (() => Get.to(() => const ProfileScreen())),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    '${controller.authCookie?.user?.profileImage}',
                  ),
                ),
              ),
            )
          ],
        ),*/
        // drawer: const CommonDrawer(),
        body: RefreshIndicator(
          onRefresh: () => controller.refreshHomepage(),
          child: SingleChildScrollView(
            controller: controller.scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8)
                      .copyWith(top: 20),
                  child: Text(
                    'This Month',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Obx(
                    () => controller.monthlyReportList.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            itemCount: controller.monthlyReportList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            itemBuilder: (context, index) => ReportGridWidget(
                              report: controller.monthlyReportList[index],
                              index: index,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: crossAxisSpacing,
                              mainAxisSpacing: mainAxisSpacing,
                              childAspectRatio: aspectRatio,
                            ),
                          ),
                  ),
                ),
                /// Graph Code
                // const SizedBox(height: 20),
                // Card(
                //   margin: const EdgeInsets.all(0),
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 18.0)
                //             .copyWith(top: 20),
                //         child: Row(
                //           children: [
                //             Text(
                //               'Sales by Week',
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .headline6
                //                   ?.copyWith(
                //                     fontWeight: FontWeight.bold,
                //                   ),
                //             ),
                //             const Spacer(),
                //             Row(
                //               children: [
                //                 Row(
                //                   children: [
                //                     Container(
                //                       padding: const EdgeInsets.all(4),
                //                       decoration: const BoxDecoration(
                //                         color: colorEarningsLine,
                //                         shape: BoxShape.circle,
                //                       ),
                //                     ),
                //                     const SizedBox(width: 4),
                //                     const Text(
                //                       'Earnings',
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         color: Colors.black38,
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 const SizedBox(width: 8),
                //                 Row(
                //                   children: [
                //                     Container(
                //                       padding: const EdgeInsets.all(4),
                //                       decoration: const BoxDecoration(
                //                         color: colorGrossSalesLine,
                //                         shape: BoxShape.circle,
                //                       ),
                //                     ),
                //                     const SizedBox(width: 4),
                //                     const Text(
                //                       'Gross Sales',
                //                       style: TextStyle(
                //                         fontWeight: FontWeight.bold,
                //                         color: Colors.black38,
                //                       ),
                //                     ),
                //                   ],
                //                 )
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //       const SizedBox(height: 12),
                //       const StackedColumnChart(),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                Card(
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Latest Sales',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        controller.obx(
                          (state) => LatestSales(state: state),
                          onLoading:
                              const Center(child: CircularProgressIndicator()),
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
                                  onPressed: () => controller.refreshHomepage(),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
