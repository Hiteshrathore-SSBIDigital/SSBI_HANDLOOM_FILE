import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';

class NotificationView extends StatefulWidget {
  final NotificationDisplayRecord notificationData;

  const NotificationView({Key? key, required this.notificationData})
      : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification View",
          style: apptextsizemanage.Appbartextstyle(),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color(ColorVal),
      ),
      // body: IndexList(notificationData: widget.notificationData),
      backgroundColor: Colors.white,
    );
  }
}

class IndexList extends StatelessWidget {
  final NotificationDisplay notificationData;
  const IndexList({Key? key, required this.notificationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildInfoTitle(
            context,
            "State: ${notificationData.state}",
            "District: ${notificationData.district}",
            "Type: ${notificationData.type}",
            "Department: ${notificationData.department}",
            "Image: ${notificationData.image}",
            "Video: ${notificationData.video}",
            "Wrape: ${'notificationData.wrape'}",
            "count: ${'notificationData.wrapeCount'}",
            "Weft: ${"notificationData.weft"}",
            "Count: ${'notificationData.weftCount'}",
            "Extra Weft: ${"notificationData.extraWeft"}",
            "Count: ${"notificationData.extraWeftCount"}",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTitle(
    BuildContext context,
    String state,
    String district,
    String type,
    String department,
    String image,
    String video,
    String wrape,
    String wrapeCount,
    String weft,
    String weftCount,
    String extraWeft,
    String extraWeftCount,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 8),
            Text(district, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(type, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(department, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(image, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(video, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(wrape, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(weft, style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text(extraWeft, style: apptextsizemanage.handlinetextstyle()),
          ],
        ),
      ),
    );
  }
}
