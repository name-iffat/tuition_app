
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted a permission");
    }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print("User granted provisional permission");
    }
    else{
      openAppSettings();
      print("User declined or has not accepted permission");
    }
  }

  Future<String> getDeviceToken() async{
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async
  {
    messaging.onTokenRefresh.listen((event){
      event.toString();
      print("refresh");
    });
  }
}