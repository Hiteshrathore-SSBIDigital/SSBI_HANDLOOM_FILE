import 'package:flutter/material.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

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
      body: const IndexList(),
      backgroundColor: Colors.white,
    );
  }
}

class IndexList extends StatelessWidget {
  const IndexList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildInfoTitle(
            context,
            "State: ",
            "District: ",
            "Type: ",
            "Department: ",
            "Image: ",
            "Video: ",
            "Wrape: ",
            "count: ",
            "Weft: ",
            "Count: ",
            "Extra Weft: ",
            "Count: ",
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
            Text("State : ${staticverible.state}",
                style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 8),
            Text("District : ${staticverible.distric}",
                style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("Type : ${staticverible.type}",
                style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("Department : ${staticverible.department}",
                style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("$image $image", style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("$video $video", style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("$wrape $wrapeCount",
                style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("$weft $weftCount",
                style: apptextsizemanage.handlinetextstyle()),
            const SizedBox(height: 4),
            Text("$extraWeft $extraWeftCount",
                style: apptextsizemanage.handlinetextstyle()),
          ],
        ),
      ),
    );
  }
}
