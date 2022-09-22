import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/controller/store_order_controller.dart';
import 'package:traidbiz_seller/data/models/store_settings/store_settings.dart';
import '../data/repository/store_repository.dart';
import '/data/local/auth_db.dart';
import '/data/models/user/user.dart';
import '/data/repository/home_repository.dart';

import '../constraints/colors.dart';
import '../data/models/order/order.dart';
import '../data/models/report/monthly_report.dart';
import '../data/repository/store_order_repository.dart';

class HomeController extends GetxController
    with StateMixin<List<StoreOrder>>, ScrollMixin {
  final HomeRepository _repository = HomeRepository();
  final StoreOrderRepository _orderRepository;

  HomeController(this._orderRepository);

  AuthCookie? authCookie;

  final RxList<MonthlyReport> _monthlyReportList = <MonthlyReport>[].obs;
  List<MonthlyReport> get monthlyReportList => _monthlyReportList;
  List<StoreOrder> _storeOrders = [];

  final int repositoriesPerPage = 20;
  int page = 1;
  bool getFirstData = false;
  bool lastPage = false;

  @override
  void onInit() {
    super.onInit();
    authCookie = AuthDb.getAuthCookie();
    getSellerDashboard();
    _getStoreOrders();
  }


  final storeOrderController = Get.find<StoreOrderController>();

  Future<void> refreshHomepage() async {
    page = 1;
    getFirstData = false;
    lastPage = false;
    getSellerDashboard();
    await refreshHomepageStoreOrders();

    // await storeOrderController.refreshEarnings();
    // await storeOrderController.refreshStoreOrders();
    final StoreRepository storeRepository = StoreRepository();
    final storeSettings = await storeRepository.getStoreProfileInfo();
    updateUserProfileFromStoreSettings(storeSettings);
    await _getStoreOrders();
  }

  void updateUserProfileFromStoreSettings(StoreProfileInfo profile) {
    authCookie = authCookie?.copyWith(
      user: authCookie?.user?.copyWith(
        displayName: profile.storeProfile?.storeName,
        profileImage: profile.storeProfile?.logoUrl,
      ),
    );

    if (authCookie != null) {
      AuthDb.setAuthCookie(authCookie!);
    }
    update();
  }

  Future<void> refreshHomepageStoreOrders() async {
    page = 1;
    getFirstData = false;
    lastPage = false;
    change(null, status: RxStatus.loading());
    _storeOrders = [];
    await _getStoreOrders();
  }

  void getSellerDashboard() {
    _repository.getSellerDashboard().then((value) {
      List<MonthlyReport> reports = [];

      reports.add(
        MonthlyReport(
          color: colorPrimary,
          title: 'Gross Sales',
          value: value.data?.grossSales?.month!,
          percentage: 10,
        ),
      );

      reports.add(
        MonthlyReport(
          color: colorSecondary,
          title: 'Earning',
          value: value.data?.earnings?.month!,
          percentage: 10,
        ),
      );

      reports.add(
        MonthlyReport(
          color: colorSuccess,
          title: 'Completed Order',
          value: value.data?.completedOrders,
          percentage: 10,
        ),
      );

      reports.add(
        MonthlyReport(
          color: colorGrossSalesLine,
          title: 'Order Received',
          value: value.data?.totalOrders,
          percentage: 10,
        ),
      );

      _monthlyReportList.value = reports;
      update();
    },
        onError: (error) {
      print(error);
    });
  }

  Future<void> _getStoreOrders() async {
    await _orderRepository.getStoreOrders(page, repositoriesPerPage).then(
        (result) {
      final bool emptyRepositories = result.isEmpty;
        if (getFirstData && emptyRepositories) {
        lastPage = true;
      } else {
        getFirstData = true;
        _storeOrders = [..._storeOrders, ...result];
        change(_storeOrders, status: RxStatus.success());
      }
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  @override
  Future<void> onEndScroll() async {
    debugPrint('onEndScroll');
    if (!lastPage) {
      page += 1;
      Get.dialog(const Center(child: CircularProgressIndicator()));

      await _getStoreOrders();
      Get.back();
    } else {
      Get.snackbar('Alert', 'All Orders Loaded!');
    }
  }

  @override
  Future<void> onTopScroll() async {
    debugPrint('onTopScroll');
  }
}
