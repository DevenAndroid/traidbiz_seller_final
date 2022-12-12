import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:traidbiz_seller/services/notification_service.dart';
import 'constraints/strings.dart';
import 'constraints/themes.dart';
import 'firebase_options.dart';
import 'globals/globals.dart';
import 'screens/splash.dart';

// android api level 23+ is required notification channel
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   description: 'This channel is used for important notifications.',
//   // description
//   importance: Importance.max,
//   enableLights: true,
//   showBadge: true,
// );
// trigger notification when app is not running in foreground
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint(
    "[Main][FirebaseMessaging] Handling a background message: ${message.messageId}",
  );
}

// trigger notification when app is running in foreground
void _firebaseMessagingForegroundHandler() {
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) async {
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      // NotificationService().showLocalNotification(message);
    },
    onDone: () => debugPrint(
      "[Main][RemoteMessage] onDone: Notification Received!",
    ),
    cancelOnError: true,
    onError: (error) => debugPrint(
      "[Main][RemoteMessage] Error on receive notification:",
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init(dbName);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // initialize background message notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await NotificationService().init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await NotificationService.initialize();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) {
    print('fcmToken$fcmToken');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _firebaseMessagingForegroundHandler();
    return OverlaySupport.global(
      child: GetMaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        initialBinding: GlobalBindings(),
        home: const Splash(),
        theme: theme(),
        // darkTheme: darkTheme(),
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget!),
          maxWidth: 1200,
          minWidth: 450,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.resize(
              300,
              name: MOBILE,
              scaleFactor: .90,
            ),
            ResponsiveBreakpoint.resize(
              450,
              name: MOBILE,
            ),
            ResponsiveBreakpoint.autoScale(
              800,
              name: TABLET,
              scaleFactor: 1.10,
            ),
            ResponsiveBreakpoint.autoScale(
              1000,
              name: TABLET,
              scaleFactor: 1.25,
            ),
            ResponsiveBreakpoint.resize(
              1200,
              name: DESKTOP,
              scaleFactor: 1.40,
            ),
          ],
        ),
      ),
    );
  }
}
