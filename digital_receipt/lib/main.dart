//import 'package:digital_receipt/screens/create_receipt_page.dart';
import 'dart:io';

import 'package:digital_receipt/screens/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

import './screens/onboarding.dart';

import 'package:flutter/material.dart';

import 'models/notification.dart';
import 'services/sql_database_client.dart';
import 'services/shared_preference_service.dart';
import 'services/sql_database_repository.dart';

//BACKGROUND MESSAGE HANDLER
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    SqlDbClient sqlDbClient = SqlDbClient();
    SqlDbRepository _sqlDbRepository =
        SqlDbRepository(sqlDbClient: sqlDbClient);
    print(message['data']["click_action"]);
    //INSERTING NOTIFICATION TO SQFLITE DB
    NotificationModel notification = NotificationModel(
      id: message["data"]["id"],
      title: message['data']['title'],
      body: message['data']['body'],
      date: message["data"]["date"],
      isRead: message["data"]["isRead"],
    );
    await _sqlDbRepository.insertNotification(notification);
    //INSERTING NOTIFICATION TO SQFLITE DB
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    // final dynamic notification = message['notification'];
    // print(notification);

  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Reepcy',
        theme: ThemeData(
          primaryColor: Color(0xFF0B57A7),
          scaffoldBackgroundColor: Color(0xFFF2F8FF),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontFamily: 'Montserrat',
            ),
            bodyText2: TextStyle(
              fontFamily: 'Montserrat',
            ),
            button: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: ScreenController(),
      ),
    );
  }
}

class ScreenController extends StatefulWidget {
  @override
  _ScreenControllerState createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();
  static SqlDbClient sqlDbClient = SqlDbClient();
  SqlDbRepository _sqlDbRepository = SqlDbRepository(sqlDbClient: sqlDbClient);

  //Initializing SQL Database.
  initSharedPreferenceDb() async {
    await _sqlDbRepository.createDatabase();
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferenceDb();

    final FirebaseMessaging _fcm = FirebaseMessaging();

    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print("Twooo");
        showOverlayNotification((context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(
                        child: Container(
                      color: Colors.black,
                    ))),
                title: Text('${message['notification']['title']}'),
                subtitle: Text('${message['notification']['body']}'),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ),
            ),
          );
        }, duration: Duration(hours: 1));

        //INSERTING NOTIFICATION TO SQFLITE DB
        NotificationModel notification = NotificationModel(
          id: message["data"]["id"],
          title: message['notification']['title'],
          body: message['notification']['body'],
          date: message["data"]["date"],
          isRead: message["data"]["isRead"],
        );
        await _sqlDbRepository.insertNotification(notification);
        //INSERTING NOTIFICATION TO SQFLITE DB
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        //INSERTING NOTIFICATION TO SQFLITE DB
        NotificationModel notification = NotificationModel(
          id: message["data"]["id"],
          title: message['notification']['title'],
          body: message['notification']['body'],
          date: message["data"]["date"],
          isRead: message["data"]["isRead"],
        );
        await _sqlDbRepository.insertNotification(notification);
        //INSERTING NOTIFICATION TO SQFLITE DB
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        //INSERTING NOTIFICATION TO SQFLITE DB
        NotificationModel notification = NotificationModel(
          id: message["data"]["id"],
          title: message['notification']['title'],
          body: message['notification']['body'],
          date: message["data"]["date"],
          isRead: message["data"]["isRead"],
        );
        await _sqlDbRepository.insertNotification(notification);
        //INSERTING NOTIFICATION TO SQFLITE DB
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _sharedPreferenceService.getStringValuesSF("AUTH_TOKEN"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // await _pushNotificationService.initialise();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return OnboardingPage();
          }
        });
  }
}
