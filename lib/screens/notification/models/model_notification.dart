class ModelNotification {
  String? message;
  bool? status;
  Data? data;

  ModelNotification({this.message, this.status, this.data});

  ModelNotification.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? count;
  List<Notifications>? notifications;

  Data({this.count, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? date;
  String? title;
  dynamic order_id;
  String? description;
  String? icon;

  Notifications({this.date, this.title, this.description, this.icon,this.order_id});

  Notifications.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    title = json['title'];
    order_id = json['order_id'];
    description = json['description'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['title'] = title;
    data['order_id'] = order_id;
    data['description'] = description;
    data['icon'] = icon;
    return data;
  }
}
