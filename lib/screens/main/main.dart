import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/controller/home_controller.dart';
import 'package:traidbiz_seller/screens/drawer/drawer.dart';
import 'package:traidbiz_seller/screens/product/products.dart';
import 'package:intl/intl.dart';
import 'package:traidbiz_seller/screens/profile/profile.dart';
import '../home/home.dart';
import '../notification/controller/notification_controller.dart';
import '../notification/notification.dart';
import '../order/orders.dart';
import '../settings/settings.dart';
import 'widgets/drawer.dart';
import 'widgets/nav_button_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = Get.find<HomeController>();
  final notificationController = Get.put(NotificationController());
  int _index = 2;
  final List<Widget> _screens = [
    ProductsScreen(),
    NotificationScreen(),
    HomeScreen(),
    OrderScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM, yyy');
    return _index==2
        ? controller.obx(
          (state) => Scaffold(
      appBar: AppBar(
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
      ),
      drawer: CommonDrawer('${controller.authCookie!.cookie}','${controller.authCookie?.user?.displayName}','${controller.authCookie?.user?.email}','${controller.authCookie?.user?.profileImage}'),
      body: IndexedStack(
        index: _index,
        children: List.generate(_screens.length, (index) => _screens[index]),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(bottom: 10),
        height: kBottomNavigationBarHeight + 30,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  _index = 0;
                });
              },
              icon: PhosphorIcons.package,
              text: 'Product',
              isSelected: _index == 0,
            ),
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  notificationController.getData();
                  _index = 1;
                });
              },
              icon: Icons.notifications,
              text: 'Notification',
              isSelected: _index == 1,
            ),
            BottomNavCenterButtonWidget(
              onTap: () {
                setState(() {
                  _index = 2;
                });
              },
              icon: CustomPaint(
                painter: SelectedNavShape(),
                child: const SizedBox(
                  height: 45,
                  width: 40,
                  child: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  _index = 3;
                });
              },
              icon: Icons.list_alt,
              text: 'Orders',
              isSelected: _index == 3,
            ),
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  _index = 4;
                });
              },
              icon: Icons.settings,
              text: 'Settings',
              isSelected: _index == 4,
            ),
          ],
        ),
      ),
    ))
        : Scaffold(
      body: IndexedStack(
        index: _index,
        children: List.generate(_screens.length, (index) => _screens[index]),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(bottom: 10),
        height: kBottomNavigationBarHeight + 30,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  _index = 0;
                });
              },
              icon: PhosphorIcons.package,
              text: 'Product',
              isSelected: _index == 0,
            ),
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  notificationController.getData();
                  _index = 1;
                });
              },
              icon: Icons.notifications,
              text: 'Notification',
              isSelected: _index == 1,
            ),
            BottomNavCenterButtonWidget(
              onTap: () {
                setState(() {
                  _index = 2;
                });
              },
              icon: CustomPaint(
                painter: SelectedNavShape(),
                child: const SizedBox(
                  height: 45,
                  width: 40,
                  child: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  _index = 3;
                });
              },
              icon: Icons.list_alt,
              text: 'Orders',
              isSelected: _index == 3,
            ),
            BottomNavButtonWidget(
              onTap: () {
                setState(() {
                  _index = 4;
                });
              },
              icon: Icons.settings,
              text: 'Settings',
              isSelected: _index == 4,
            ),
          ],
        ),
      ),
    );
  }
}
