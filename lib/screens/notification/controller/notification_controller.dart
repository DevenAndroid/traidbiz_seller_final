import 'package:get/get.dart';

import '../models/model_notification.dart';
import '../repositories/notification_repository.dart';

class NotificationController extends GetxController{

  Rx<ModelNotification> model = ModelNotification().obs;
  RxBool notificationLoading = false.obs;
  var notifications;
  var isLoading;


  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData(){
        print("Notification Response ::>>>>>>>");
    notificationData().then((value) {
      notificationLoading.value = true;
      if(value.status!){
        print("Notification Response ::$value");
        model.value = value;
        notifications = model.value.data!.notifications;
      }
    });
  }

}