import 'dart:developer';

import 'package:traidbiz_seller/data/local/auth_db.dart';
import 'package:traidbiz_seller/data/models/seller_dashboard/seller_dashboard_model.dart';
import 'package:traidbiz_seller/data/remote/api_service.dart';

import '../../constraints/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;

class HomeRepository {
  final _dio = dio.Dio();

  Future<SellerDashboard> getSellerDashboard() async {
    final _response = await ApiService.post(sellerDashboard, _dio, body: {
      "cookie": AuthDb.getAuthCookie()?.cookie,
    });
    try {
      final _result = SellerDashboard.fromJson(_response);
      return _result;
    } catch(e){
      log(e.toString());
    } finally{
      final _result = SellerDashboard.fromJson(_response);
      return _result;
    }
  }

}
