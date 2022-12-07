import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../controller/store_settings_controller.dart';
import '/data/local/auth_db.dart';
import '/data/models/store_settings/store_settings.dart';
import '/data/remote/api_service.dart';

import '../../constraints/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;

class StoreRepository {
  final _dio = dio.Dio();

  Future<StoreProfileInfo> getStoreProfileInfo() async {
    final _response = await ApiService.post(
      vendorAccountSettingsApi,
      _dio,
      body: {
        "cookie": AuthDb.getAuthCookie()?.cookie,
      },
    );
    final _result = StoreProfileInfo.fromJson(_response);
    debugPrint(_response.toString());
    return _result;
  }
  Future<ModelStoreSettings> getStoreProfileInfo1() async {
    final response = await http.post(Uri.parse("https://traidbiz.com/wp-json/wc/v3/wepos/vendor_account_settings"),
    body:{
      "cookie": AuthDb.getAuthCookie()?.cookie,
    },
    headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        });
    if(response.statusCode == 200){
    return ModelStoreSettings.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
}
