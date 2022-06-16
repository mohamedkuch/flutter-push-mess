import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'models/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NotificationModel> notifications = <NotificationModel>[];
  bool isPending = false;

  @override
  void initState() {
    super.initState();
    configOneSignel();
    initNotifications();
  }

  Future<void> configOneSignel() async {
    OneSignal.shared.setAppId('d905bc9b-a10e-4139-a301-77a39880d467');
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      // ignore: avoid_print
      print("Accepted permission: $accepted");
    });
  }

  Future<void> saveNotificationFromSharedPrefs() async {
    // Get preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('action', '######## Start');

    await prefs.reload();
    final keys = prefs.getKeys();
    // ignore: prefer_collection_literals
    final prefsMap = Map<String, dynamic>();
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);

      final String? notificationString = prefs.getString(key);

      if (notificationString != null) {
        print(notificationString);

        // final notificationJson = json.decode(notificationString);

        // // Save notifications in backend
        // var save_url = Uri.http("push-notification-admin-panel.herokuapp.com",
        //     "/api/receivedNotification");

        // final response = await http.post(
        //   save_url,
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8',
        //   },
        //   body: jsonEncode(
        //     <String, dynamic>{
        //       'user_id': notificationJson['user_id'],
        //       'title': notificationJson['title'],
        //       'content': notificationJson['content'],
        //       'received_time': notificationJson['received_time'],
        //       'notification_id': notificationJson['notification_id'],
        //       'sent_time': notificationJson['sent_time'],
        //     },
        //   ),
        // );
        // if (response.statusCode == 200) {
        //   await prefs.remove(key);
        // }
      }
    }
    print(prefsMap);
  }

  Future<List<NotificationModel>> getNotifications() async {
    String userId = await getUserId();

    if (userId == "not found") {
      return [];
    }

    var notificationsList = <NotificationModel>[];

    await saveNotificationFromSharedPrefs();

    // Get Notification from server
    var get_url = Uri.https("push-notification-admin-panel.herokuapp.com",
        "/api/receivedNotification", {"user_id": userId});

    final response = await http.get(get_url);

    if (response.statusCode == 200) {
      var results = json.decode(response.body);

      for (var notificationJson in results) {
        notificationsList.add(NotificationModel.fromJson(notificationJson));
      }
    }

    print("##### finished");

    return notificationsList;
  }

  Future<String> getUserId() async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    if (osUserID != null) {
      return osUserID;
    } else {
      return "not found";
    }
  }

  Future<void> initNotifications() async {
    setState(() {
      isPending = true;
    });
    var notificationsList = await getNotifications();

    setState(() {
      notifications = [];
      notifications.addAll(notificationsList);
      isPending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications App'),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(10)),
              const Text(
                'Notifications user_id :',
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.all(5)),
              FutureBuilder(
                future: getUserId(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString(),
                        textAlign: TextAlign.center);
                  } else {
                    return const Text(
                      'not found',
                      textAlign: TextAlign.center,
                    );
                  }
                },
              ),
              const Padding(padding: EdgeInsets.all(5)),
              ElevatedButton.icon(
                onPressed: () {
                  initNotifications();
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 24.0,
                ),
                label: const Text('Refresh & update'), // <-- Text
              ),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Colors.black,
              ),
              isPending
                  ? Container(
                      alignment: Alignment.topCenter,
                      margin: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator(
                        value: 0.8,
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: initNotifications,
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        notifications[index].title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        notifications[index].content,
                                      ),
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 5,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "sent time :" +
                                            notifications[index]
                                                .sentTime
                                                .toString(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "received time :" +
                                            notifications[index]
                                                .receivedTime
                                                .toString(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

              // FutureBuilder(
              //   future: getNotifications(),
              //   builder: (context, AsyncSnapshot snapshot) {
              //     if (snapshot.hasData) {
              //       var finalData = snapshot.data.toList();
              //       return Expanded(
              //         child: RefreshIndicator(
              //           onRefresh: getNotifications,
              //           child: ListView.builder(
              //             itemCount: finalData.length,
              //             itemBuilder: (context, index) {
              //               final item = finalData[index];
              //               return Padding(
              //                 padding: const EdgeInsets.all(10.0),
              //                 child: Container(
              //                   padding: const EdgeInsets.all(10.0),
              //                   decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(10),
              //                     color: Colors.white,
              //                   ),
              //                   child: Column(
              //                     children: <Widget>[
              //                       Container(
              //                         alignment: Alignment.centerLeft,
              //                         padding:
              //                             const EdgeInsets.only(bottom: 10.0),
              //                         child: Text(
              //                           item['title'],
              //                           style: const TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                           ),
              //                         ),
              //                       ),
              //                       Container(
              //                         alignment: Alignment.centerLeft,
              //                         child: Text(
              //                           item['content'],
              //                         ),
              //                         padding:
              //                             const EdgeInsets.only(bottom: 10.0),
              //                       ),
              //                       const Divider(
              //                         height: 1,
              //                         thickness: 1,
              //                         color: Colors.grey,
              //                       ),
              //                       Container(
              //                         padding: const EdgeInsets.only(
              //                           top: 10.0,
              //                           bottom: 5,
              //                         ),
              //                         alignment: Alignment.center,
              //                         child: Text(
              //                           "sent time :" + item['sent_time'],
              //                           style: const TextStyle(
              //                             fontSize: 10,
              //                           ),
              //                         ),
              //                       ),
              //                       Container(
              //                         alignment: Alignment.center,
              //                         child: Text(
              //                           "received time :" +
              //                               item['received_time'],
              //                           style: const TextStyle(
              //                             fontSize: 10,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       );
              //     } else {
              //       return const Text(
              //         'No notifications found',
              //         textAlign: TextAlign.center,
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
