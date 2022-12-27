import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../model/model_calculated_price.dart';

Future<ModelSingleProduct> singleProductRepo({
  required productId
}) async {
  Map map = <String, dynamic>{};

  map["product_id"]  = productId.toString();

  log("Create Variation >>>>>>>>>>$map");

  http.Response response = await http.post(
      Uri.parse(
          "https://traidbiz.com/wp-json/wc/v3/wepos/product_single_page"),
      body: jsonEncode(map),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    return ModelSingleProduct.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}


Future<ModelCalculatedPrice> calculatePrice({
  required productId,
  required weight,
  required length,
  required width,
  required height,
  required regularPrice,
}) async {
  Map map = <String, dynamic>{};

  map["product_id"]  = productId.toString();
  map["weight"]  = weight.toString();
  map["length"]  = length.toString();
  map["width"]  = width.toString();
  map["height"]  = height.toString();
  map["regular_price"]  = regularPrice.toString();

  log("Create Variation >>>>>>>>>>$map");

  http.Response response = await http.post(
      Uri.parse(
          "https://traidbiz.com/wp-json/wc/v3/wepos/calculate_free_shipping_price"),
      body: jsonEncode(map),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
  if (response.statusCode == 200) {
    return ModelCalculatedPrice.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}







class ModelSingleProduct {
  String? status;
  String? message;
  ProductData? productData;

  ModelSingleProduct({this.status, this.message, this.productData});

  ModelSingleProduct.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    productData = json['product_data'] != null
        ? new ProductData.fromJson(json['product_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.productData != null) {
      data['product_data'] = this.productData!.toJson();
    }
    return data;
  }
}

class ProductData {
  dynamic id;
  dynamic name;
  dynamic slug;
  dynamic sku;
  dynamic price;
  dynamic regularPrice;
  dynamic salePrice;
  dynamic dateOnSaleFrom;
  dynamic dateOnSaleTo;
  dynamic totalSales;
  dynamic taxStatus;
  dynamic taxClass;
  dynamic manageStock;
  dynamic stockQuantity;
  dynamic stockStatus;
  dynamic backorders;
  dynamic lowStockAmount;
  dynamic soldIndividually;
  dynamic weight;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic averageRating;
  dynamic reviewCount;

  ProductData(
      {this.id,
        this.name,
        this.slug,
        this.sku,
        this.price,
        this.regularPrice,
        this.salePrice,
        this.dateOnSaleFrom,
        this.dateOnSaleTo,
        this.totalSales,
        this.taxStatus,
        this.taxClass,
        this.manageStock,
        this.stockQuantity,
        this.stockStatus,
        this.backorders,
        this.lowStockAmount,
        this.soldIndividually,
        this.weight,
        this.length,
        this.width,
        this.height,
        this.averageRating,
        this.reviewCount});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    dateOnSaleFrom = json['date_on_sale_from'];
    dateOnSaleTo = json['date_on_sale_to'];
    totalSales = json['total_sales'];
    taxStatus = json['tax_status'];
    taxClass = json['tax_class'];
    manageStock = json['manage_stock'];
    stockQuantity = json['stock_quantity'];
    stockStatus = json['stock_status'];
    backorders = json['backorders'];
    lowStockAmount = json['low_stock_amount'];
    soldIndividually = json['sold_individually'];
    weight = json['weight'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    averageRating = json['average_rating'];
    reviewCount = json['review_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['sku'] = this.sku;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['date_on_sale_from'] = this.dateOnSaleFrom;
    data['date_on_sale_to'] = this.dateOnSaleTo;
    data['total_sales'] = this.totalSales;
    data['tax_status'] = this.taxStatus;
    data['tax_class'] = this.taxClass;
    data['manage_stock'] = this.manageStock;
    data['stock_quantity'] = this.stockQuantity;
    data['stock_status'] = this.stockStatus;
    data['backorders'] = this.backorders;
    data['low_stock_amount'] = this.lowStockAmount;
    data['sold_individually'] = this.soldIndividually;
    data['weight'] = this.weight;
    data['length'] = this.length;
    data['width'] = this.width;
    data['height'] = this.height;
    data['average_rating'] = this.averageRating;
    data['review_count'] = this.reviewCount;
    return data;
  }
}
