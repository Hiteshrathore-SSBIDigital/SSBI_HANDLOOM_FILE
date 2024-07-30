import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Other_Screen/Notification_View.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';

class Notification_Screen extends StatefulWidget {
  const Notification_Screen({super.key});

  @override
  State<Notification_Screen> createState() => _Notification_ScreenState();
}

class _Notification_ScreenState extends State<Notification_Screen> {
  late Future<Notificationclass> notification;
  final Notificationcheck _notificationcheck = Notificationcheck();
  String? selectedNotificationId;
  final NotificationDisplayService _notificationDisplayService =
      NotificationDisplayService();
  final feedbackService = FeedbackService();
  String feedbackview = '';
  String emoji = '';
  String comments = '';
  String? selectedFeedback;
  String? Notiqrval;
  @override
  void initState() {
    super.initState();
    notification = fetchNotification();
  }

  Future<Notificationclass> fetchNotification() {
    Notificationapis notificationApis = Notificationapis();
    return notificationApis.fetchNotification(context);
  }

  Future<void> _fetchNotification(BuildContext context, String id) async {
    try {
      await _notificationcheck.fetchNotificationcheck(context, id);
      setState(() {
        selectedNotificationId = id;
      });
      await fetchNotificationd(context);
    } catch (e) {
      print('Failed to fetch notifications: $e');
    }
  }

  Future<void> fetchNotificationd(BuildContext context) async {
    final qrval = Notiqrval;
    plaesewaitmassage(context);
    if (qrval == null || qrval.isEmpty) {
      throw Exception('QR value is null or empty');
    }

    try {
      final notificationRecord = await _notificationDisplayService
          .fetchNotificationDisplay(context, qrval);

      // Assuming feedbackService.sendFeedback returns a map with feedback data
      Map<String, String> feedbackData =
          await feedbackService.sendFeedback(context, qrval);
      final feedbackview = feedbackData['feedback'] ?? 'No feedback available';
      final emoji = feedbackData['emoji'] ?? '🤔';
      final comments = feedbackData['comment'] ?? 'No comments available';

      print('Feedback: $feedbackview');
      print('Emoji: $emoji');
      print('Comments: $comments');

      if (notificationRecord != null &&
          notificationRecord.notifications.isNotEmpty) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationView(
              notificationData: notificationRecord.notifications[0],
              feedbackview: feedbackview,
              emoji: emoji,
              comments: comments,
            ),
          ),
        );
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      Navigator.of(context).pop();
      print(e.toString());
    }
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
                  print('Notification date: ${notification.date}');
                  bool isSelected =
                      selectedNotificationId == notification.id.toString();
                  Color backgroundColor = isSelected
                      ? Colors.white
                      : (notification.isread == 0
                          ? Colors.grey[300]!
                          : Colors.white);

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            Notiqrval = notification.qrvalue;
                            print(Notiqrval);
                          });

                          _fetchNotification(
                              context, notification.id.toString());
                        },
                        tileColor: backgroundColor,
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
