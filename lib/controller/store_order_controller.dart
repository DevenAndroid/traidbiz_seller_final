import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/data/models/order/order.dart';
import '/data/repository/store_order_repository.dart';
import '/utils/snackbar.dart';

import '../data/models/earning/earnings.dart';
import '../data/models/order/order_details.dart';
import '../data/repository/earnings_repository.dart';

class StoreOrderController extends GetxController
    with StateMixin<List<StoreOrder>>, ScrollMixin {
  final StoreOrderRepository _repository;
  StoreOrderController(this._repository);

  final _isStateUpdating = false.obs;
  bool get isStateUpdating => _isStateUpdating.value;

  List<StoreOrder> _storeOrders = [];

  final EarningsRepository _earningsRepository = EarningsRepository();
  final Rx<EarningModel> _earnings = Rx<EarningModel>(const EarningModel());
  EarningModel get earnings => _earnings.value;

  final int repositoriesPerPage = 20;
  int page = 1;
  bool getFirstData = false;
  bool lastPage = false;

  String? _filterBy;

  @override
  void onInit() {
    super.onInit();
    getStoreOrders();
    getStoreEarnings();
  }

  void getStoreEarnings() {
    _earningsRepository.getStoreEarnings().then((earning) {
      print(earning);
      _earnings.value = earning;
      update();
    });
  }

  Future<void> refreshEarnings() async => getStoreEarnings();

  Future<void> refreshStoreOrders({String? filterBy}) async {
    _filterBy = filterBy;
    page = 1;
    getFirstData = false;
    lastPage = false;

    _storeOrders = [];
    change(_storeOrders, status: RxStatus.loading());
    return await getStoreOrders(filterBy: filterBy);
  }

  Future<void> getStoreOrders({String? filterBy}) async {
    await _repository.getStoreOrders(
      page,
      repositoriesPerPage,
      filterBy: filterBy,
    ).then((result) {
      print(result);
      final bool emptyRepositories = result.isEmpty;

      if (!getFirstData && emptyRepositories) {
        change(null, status: RxStatus.empty());
      } else if (getFirstData && emptyRepositories) {
        lastPage = true;
      } else {
        getFirstData = true;
        if (!_storeOrders.contains(result[0])){
        _storeOrders = [..._storeOrders, ...result];
        }
        change(_storeOrders, status: RxStatus.success());
      }
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  Future<StoreOrderDetail> getOrderDetailsById(int? id) async =>
      await _repository.getOrderDetailsById(id);

  Future<dynamic> getOrderStateTypes() async {
    return await _repository.getOrderStateTypes();
  }

  Future<dynamic> updateOrderStateById(int orderId, String status) async {
    try {
      _isStateUpdating.value = true;
      update();
      refreshStoreOrders(filterBy: _filterBy);
      return await _repository.updateOrderStateById(orderId, status);
    } catch (e) {
      return e;
    } finally {
      _isStateUpdating.value = false;
      update();
    }
  }

  @override
  Future<void> onEndScroll() async {
    debugPrint('onEndScroll');
    if (!lastPage) {
      page += 1;
      Get.dialog(const Center(child: CircularProgressIndicator()));
      await getStoreOrders(filterBy: _filterBy).then((value) {
        Get.back();
      });
    } else {
      Get.snackbar('Alert', 'All Orders Loaded!');
    }
  }

  @override
  Future<void> onTopScroll() async {
    debugPrint('onTopScroll');
  }
}
