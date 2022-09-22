// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'seller_dashboard_model.freezed.dart';
part 'seller_dashboard_model.g.dart';

@freezed
class SellerDashboard with _$SellerDashboard {
  const factory SellerDashboard({
    String? status,
    String? message,
    DashboardData? data,
  }) = _SellerDashboard;

  factory SellerDashboard.fromJson(Map<String, dynamic> json) =>
      _$SellerDashboardFromJson(json);
}

@freezed
class DashboardData with _$DashboardData {
  const factory DashboardData({
    @JsonKey(name: "total_orders") int? totalOrders,
    @JsonKey(name: "pending_orders") int? pendingOrders,
    @JsonKey(name: "processing_orders") int? processingOrders,
    @JsonKey(name: "completed_orders") int? completedOrders,
    @JsonKey(name: "gross_sales") SalesModel? grossSales,
    @JsonKey(name: "earnings") SalesModel? earnings,
    @JsonKey(name: "withdraw") SalesModel? withdraw,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);
}

@freezed
class SalesModel with _$SalesModel {
  const factory SalesModel({
    @JsonKey(name: "last_month") String? lastMonth,
    String? month,
    String? week,
  }) = _SalesModel;

  factory SalesModel.fromJson(Map<String, dynamic> json) =>
      _$SalesModelFromJson(json);
}
