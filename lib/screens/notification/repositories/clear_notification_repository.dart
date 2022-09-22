import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:traidbiz_seller/helper/Helpers.dart';

import '../../../../data/local/auth_db.dart';
import '../../../../data/models/user/user.dart';
import '../../../model/model_common_respone.dart';

Future<ModelCommonResponse> clearNotificationData(context) async {

  OverlayEntry loader = Helpers.overlayLoader(context);
  Overlay.of(context)!.insert(loader);

  debugPrint(">>>>>>>>>>>>>>>>>Api Called");
  late AuthCookie? authCookie;
  var map = <String, dynamic>{};
  authCookie = AuthDb.getAuthCookie();
  map['cookie'] = authCookie?.cookie;

  http.Response response = await http.post(
      Uri.parse("https://traidbiz.com/wp-json/wc/v3/wepos/clear_notifications"),
      body: json.encode(map),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      });

  if (response.statusCode == 200) {
    Helpers.hideLoader(loader);
    debugPrint( "Response >>>>>>>>>>${json.decode(response.body)}");
    return ModelCommonResponse.fromJson(json.decode(response.body));
  } else {
    Helpers.hideLoader(loader);
    throw Exception(response.body);
  }
}
