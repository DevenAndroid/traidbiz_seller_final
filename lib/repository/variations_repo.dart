
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/model_get_attribute_list.dart';

Future<ModelGetAttributeList> getAttributeVariationLists(
    productID,
    ) async {

  Map map = <String , dynamic>{};

  map["product_id"] = productID;

  log("variation>>>>>>>>>>${jsonEncode(map)}");

  http.Response response = await http.post(Uri.parse("https://traidbiz.com/wp-json/wc/v3/wepos/get_product_available_variations"),
      body: jsonEncode(map),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      }
      );
  if(response.statusCode == 200){
    print("response123"+jsonDecode(response.body).toString());
    return ModelGetAttributeList.fromJson(jsonDecode(response.body));
  } else{
    throw Exception(response.body);
  }

}