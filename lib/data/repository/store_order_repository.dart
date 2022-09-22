import 'package:traidbiz_seller/data/models/order/order.dart';
import 'package:traidbiz_seller/data/local/auth_db.dart';
import 'package:traidbiz_seller/data/remote/api_service.dart';

import '../../constraints/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;

import '../models/order/order_details.dart';

class StoreOrderRepository {
  final _dio = dio.Dio();

  Future<List<StoreOrder>> getStoreOrders(
    int pageNo,
    int perPage, {
    String? filterBy,
  }) async {
    final _response = await ApiService.post(storeOrderListApi, _dio, body: {
      "cookie": AuthDb.getAuthCookie()?.cookie,
      "per_page": perPage,
      "page_no": pageNo,
      "order_status": filterBy,
    });

    List<dynamic> _products = _response["orders"] ?? [];

    // debugPrint(_result.toString());
    return _products.map((data) => StoreOrder.fromJson(data)).toList();
  }

  Future<StoreOrderDetail> getOrderDetailsById(int? id) async {
    final _response = await ApiService.post(storeOrderDetailsApi, _dio, body: {
      "cookie": AuthDb.getAuthCookie()?.cookie,
      "order_id": "$id",
    });

    try {
      dynamic _result = _response['response'];
      return StoreOrderDetail.fromJson(_result);
    } catch (e) {
      return Future.error("$e");
    }
  }

  Future<dynamic> getOrderStateTypes() async {
    final _response = await ApiService.post(orderStatusTypeApi, _dio, body: {
      "cookie": AuthDb.getAuthCookie()?.cookie,
    });

// {
//     "status": "success",
//     "message": "All Order Status",
//     "response": {
//         "wc-pending": "Pending payment",
//         "wc-processing": "Processing",
//         "wc-exchange": "Exchange",
//         "wc-on-hold": "On hold",
//         "wc-completed": "Completed",
//         "wc-cancelled": "Cancelled",
//         "wc-refunded": "Refunded",
//         "wc-failed": "Failed"
//     }
// }
    return _response;
  }

  Future<dynamic> updateOrderStateById(int? id, String? status) async {
    final _response = await ApiService.post(
      storeOrderStateUpdateApi,
      _dio,
      body: {
        "cookie": AuthDb.getAuthCookie()?.cookie,
        "order_id": "$id",
        "order_status": status
      },
    );

    try {
      bool _result = _response['status'] == "success";
      return _result == true
          ? Future.value(_response['message'])
          : Future.error("${_response['message']}");
    } catch (e) {
      return Future.error("$e");
    }
  }
}
