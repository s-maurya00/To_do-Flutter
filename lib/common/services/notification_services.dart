import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:get/get.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../models/task.dart';

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    // tz.initializeTimeZones();
    _configureLocalTimeZone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("drawable/appicon");

    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: selectNotification,
    );
  }

  // Future onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     //context: Get.context!,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title!),
  //       content: Text(body!),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => SecondScreen(payload),
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );

  //   Get.dialog(Text("Welcome to flutter"));
  // }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => Container());
  }

  displayNotification({required String title, required String body}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'It_could_be_anything_you_pass',
    );
  }

  scheduledNotification(Task task, int hour, int minutes) async {
    AndroidScheduleMode androidScheduleMode =
        AndroidScheduleMode.exactAllowWhileIdle;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _convertTimeToTimeZone(hour, minutes),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        ),
      ),
      androidScheduleMode: androidScheduleMode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: task.repeat == "None"
          ? null
          : (task.repeat == "Daily"
              ? DateTimeComponents.time
              : (task.repeat == "Weekly"
                  ? DateTimeComponents.dayOfWeekAndTime
                  : DateTimeComponents.dayOfMonthAndTime)),
    );
  }

  tz.TZDateTime _convertTimeToTimeZone(int hours, int minute) {
    // what it does is it takes the current time of the device and converts it to the local time zone which means if the user is in India it will convert the time to Indian time zone.
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    print("--------------------INSIDE ConvertTimeToTimeZone function tz.local: ${tz.local}, now.year: ${now.year}, now.month: ${now.month}, now.day: ${now.day}");

    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hours,
      minute,
    );

    print("scheduledDate: $scheduledDate");

    // we did this because if the user selects the time less than the current time then it will not schedule the notification so we are adding one day to the scheduled date. Here, we are assuming that the user will not select the time less than the current time. Also, we use .add on the scheduledDate as adding one day to the now will change the current time of the device which we don’t want. as a whole, we want to add one day to the scheduledDate and not to the now.
    if (scheduledDate.isBefore(now)) {
      print("scheduledDate is before now");
      scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print("tz.setLocalLocation ran successfully");
    } catch (e) {
      print(e);
      print("using default timezone of Asia/Kolkata");
      tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));
    }
  }

  // Future<void> cancelNotification() async {
  //   await flutterLocalNotificationsPlugin.cancel(0);
  // }
}
