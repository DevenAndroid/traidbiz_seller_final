class ModelCalculatedPrice {
  String? status;
  String? message;
  Data? data;

  ModelCalculatedPrice({this.status, this.message, this.data});

  ModelCalculatedPrice.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? price;
  String? shippingCost;
  String? priceWithShipping;
  String? salePriceWithShipping;

  Data(
      {this.price,
        this.shippingCost,
        this.priceWithShipping,
        this.salePriceWithShipping});

  Data.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    shippingCost = json['shipping_cost'];
    priceWithShipping = json['price_with_shipping'];
    salePriceWithShipping = json['sale_price_with_shipping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['shipping_cost'] = this.shippingCost;
    data['price_with_shipping'] = this.priceWithShipping;
    data['sale_price_with_shipping'] = this.salePriceWithShipping;
    return data;
  }
}
