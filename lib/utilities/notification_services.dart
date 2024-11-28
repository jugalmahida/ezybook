import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;

// show notitcaiton when app is killed

class NotificationService {
  void listenForBookingsStatus(String uId) {
    final Query bookingRef = FirebaseDatabase.instance
        .ref()
        .child('Booking')
        .orderByChild("userId")
        .equalTo(uId);
    bookingRef.onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        // Extract booking details
        Map bookingData = event.snapshot.value as Map;
        // print("Booking - $bookingData");
        // String bookingId = event.snapshot.key!;
        String shopName = bookingData['shopName'] ?? "";
        String category = bookingData['shopCategory'] ?? "";
        String status = bookingData['status'] ?? "";
        String customerName = bookingData['customerName'] ?? "";
        if (status == "Accepted") {
          String seatOrTable = "";
          if (category == "Salon") {
            seatOrTable = "Seat";
          } else {
            seatOrTable = "Table";
          }
          int numberOfSeatorTable = bookingData['numberOfSeatorTable'] ?? 0;

          // Trigger local notification booking is Accepted
          showNotification(
            title: "Congratulation $customerName !!!, Request Accepted",
            body:
                "$shopName accepted your request, Your $seatOrTable Number is $numberOfSeatorTable.",
          );
        } else if (status == "Cancel") {
          String cancelReason = bookingData['cancelReason'] ?? "";
          // Trigger local notification when booking is canceled
          showNotification(
            title: "Oops! Request Canceled",
            body: "$shopName cancel your request, because $cancelReason",
          );
        } else {}
      }
    });
  }

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsiOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsiOS);

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle notification response here if needed
      },
    );

    // Request notification permission for Android 13+
    if (Platform.isAndroid) {
      await _requestAndroidNotificationPermission();
    }
  }

  Future<void> _requestAndroidNotificationPermission() async {
    if (Platform.isAndroid &&
        await notificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission() ==
            false) {
      // Handle permission denial if needed
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "001",
        "EzyBook Request Booking",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await notificationsPlugin.show(id, title, body, notificationDetails());
  }
}
