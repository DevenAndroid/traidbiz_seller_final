import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traidbiz_seller/screens/notification/repositories/clear_notification_repository.dart';
import '../common_widget/no_data_message.dart';
import '../order/order_details.dart';
import 'controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Obx(() {
        return !controller.notificationLoading.value
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              controller.model.value.data!.notifications!.isEmpty ?
              const SizedBox() :
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: (){
                        clearNotificationData(context).then((value) {
                          if (value.status) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(value.message)));
                            setState(() {
                              controller.getData();
                            });
                          }
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 16, 0),
                        child: Text("Clear All",style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.bold),),
                      ))
                ],
              ),
              controller.model.value.data!.notifications!.isEmpty
                  ? NoDataMessage(
                messageText: "You don't have any notification",
                messageTextSize: 16,
                elevationCard: 4,
                imageHeight: 160,
                imageWidth: MediaQuery.of(context).size.width - 30,
              )
                  :
              ListView.separated(
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.notifications.length,
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemBuilder: (context, index) => InkWell(
                  onTap: (){
                    if (kDebugMode) {
                      print(controller.model.value.data!.notifications![0].order_id.toString());
                    }
                    Get.to(() => OrderDetailsScreen(
                      orderId: int.parse(
                          controller.model.value.data!.notifications![index]
                              .order_id.toString()
                      ),
                    ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                                backgroundColor: Color(0xFFed1c24),
                                child: Icon(
                                  Icons.notification_important,
                                  color: Colors.white,
                                  size: 28,
                                )),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    controller
                                        .notifications[index].title
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.notifications[index]
                                        .description
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.notifications[index].date
                                        .toString(),
                                    style:
                                    const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
