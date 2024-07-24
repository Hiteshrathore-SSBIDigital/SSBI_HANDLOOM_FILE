import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  late Future<Notificationclass> notification;

  @override
  void initState() {
    super.initState();
    notification = fetchNotification();
  }

  Future<Notificationclass> fetchNotification() {
    Notificationapis notificationApis = Notificationapis();
    return notificationApis.fetchNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(ColorVal),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<Notificationclass>(
        future: notification,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final notificationData = snapshot.data!;
            print(
                'Notifications fetched: ${notificationData.notifications.length}'); // Debug print
            return ListView.builder(
              itemCount: notificationData.notifications.length + 1,
              itemBuilder: (context, index) {
                if (index == notificationData.notifications.length) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Divider(height: 1, color: Colors.grey[300]),
                  );
                } else {
                  final notification = notificationData.notifications[index];
                  print(
                      'Notification date: ${notification.date}'); // Debug print
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child:
                                Icon(Icons.feedback, color: Color(ColorVal))),
                        title: Text(notification.message,
                            style: TextStyle(fontSize: 13)),
                        subtitle: Text(notification.getRelativeTime(),
                            style: TextStyle(fontSize: 13)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Divider(height: 1, color: Colors.grey[300]),
                      ),
                    ],
                  );
                }
              },
            );
          } else {


            return Center(child: Text('No notifications found.'));
          }
        },
      ),
    );
  }
}
