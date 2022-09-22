import 'package:traidbiz_seller/data/local/auth_db.dart';
import 'package:traidbiz_seller/data/models/earning/earnings.dart';
import 'package:traidbiz_seller/data/models/seller_dashboard/seller_dashboard_model.dart';
import 'package:traidbiz_seller/data/remote/api_service.dart';

import '../../constraints/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;

class EarningsRepository {
  final _dio = dio.Dio();

  Future<EarningModel> getStoreEarnings() async {
    final _response = await ApiService.post(storeEarningsApi, _dio, body: {
      "cookie": AuthDb.getAuthCookie()?.cookie,
    });
    final _result = EarningModel.fromJson(_response);
    // debugPrint(_result.toString());
    return _result;
  }
}
