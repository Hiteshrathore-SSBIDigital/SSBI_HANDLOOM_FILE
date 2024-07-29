import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';

class NotificationView extends StatefulWidget {
  final NotificationDisplay notificationData;
  final String feedbackview;
  final String emoji;
  final String comments;

  const NotificationView({
    Key? key,
    required this.notificationData,
    required this.feedbackview,
    required this.emoji,
    required this.comments,
  }) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  String selectedFeedback = '';

  @override
  void initState() {
    super.initState();
    selectedFeedback = widget.feedbackview;
  }

  void _updateFeedback(String feedback) {
    setState(() {
      selectedFeedback = feedback;
    });
  }

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
      body: IndexList(
        notificationData: widget.notificationData,
        feedbackview: selectedFeedback,
        emoji: widget.emoji,
        comments: widget.comments,
        onFeedbackChanged: _updateFeedback,
      ),
      backgroundColor: Colors.white,
    );
  }
}

class IndexList extends StatelessWidget {
  final NotificationDisplay notificationData;
  final String feedbackview;
  final String emoji;
  final String comments;
  final Function(String) onFeedbackChanged;

  const IndexList({
    Key? key,
    required this.notificationData,
    required this.feedbackview,
    required this.emoji,
    required this.comments,
    required this.onFeedbackChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildInfoTable(
              context,
              state: notificationData.state,
              district: notificationData.district,
              department: notificationData.department,
              type: notificationData.type,
              image: notificationData.image,
              video: notificationData.video,
              city: notificationData.city,
            ),
            SizedBox(height: 10),
            _buildInfoTable1(
              context,
              wearverName: notificationData.weavername,
              productname: notificationData.productname,
              loomtype: notificationData.loomtype,
              wrape: notificationData.wrape,
              wrapeCount: notificationData.wrapeCount,
              weft: notificationData.weft,
              weftCount: notificationData.weftCount,
              extraWeft: notificationData.extraWeft,
              extraWeftCount: notificationData.extraWeftCount,
              dimision: notificationData.dimision,
              WeaveType: notificationData.WeaveType,
              dyeStatus: notificationData.dyeStatus,
              nature_dye: notificationData.nature_dye,
              yarntype: notificationData.yarntype,
            ),
            SizedBox(height: 10),
            _buildInfofeedback(
              context,
              emoji: emoji,
              feedback: feedbackview,
              comments: comments,
              onFeedbackChanged: onFeedbackChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(
    BuildContext context, {
    required String state,
    required String district,
    required String type,
    required String department,
    required String image,
    required String video,
    required String city,
  }) {
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
            Center(
              child: Text(
                "Product Details",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow("State", state),
                _buildTableRow("District", district),
                _buildTableRow("City", city),
                _buildTableRow("Department", department),
                _buildTableRow("Type", type),
                _buildTableRow("Image", image),
                _buildTableRow("Video", video),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable1(
    BuildContext context, {
    required String productname,
    required String wearverName,
    required String dimision,
    required String dyeStatus,
    required String nature_dye,
    required String WeaveType,
    required String yarntype,
    required String loomtype,
    required String wrape,
    required String wrapeCount,
    required String weft,
    required String weftCount,
    required String extraWeft,
    required String extraWeftCount,
  }) {
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
            Center(
              child: Text(
                "Product Details",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow("Product Name", productname),
                _buildTableRow("Weaver Name", wearverName),
                _buildTableRow("Dimension", dimision),
                _buildTableRow("Dyeing Status", dyeStatus),
                _buildTableRow("Nature Dye", nature_dye),
                _buildTableRow("Type of Weave", WeaveType),
                _buildTableRow("Type of Yarn", yarntype),
                _buildTableRow("Wrape", wrape),
                _buildTableRow("Wrape Count", wrapeCount),
                _buildTableRow("Weft", weft),
                _buildTableRow("Weft Count", weftCount),
                _buildTableRow("Extra Weft", extraWeft),
                _buildTableRow("Extra Weft Count", extraWeftCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfofeedback(
    BuildContext context, {
    required String emoji,
    required String feedback,
    required String comments,
    required Function(String) onFeedbackChanged,
  }) {
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
            Center(
              child: Text(
                "Feed Back",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFeedbackRadio(
                        "Good", feedbackview, onFeedbackChanged),
                    _buildFeedbackRadio(
                        "Poor", feedbackview, onFeedbackChanged),
                    _buildFeedbackRadio(
                        "Very Poor", feedbackview, onFeedbackChanged),
                    _buildFeedbackRadio(
                        "Okay", feedbackview, onFeedbackChanged),
                    _buildFeedbackRadio(
                        "Excellent", feedbackview, onFeedbackChanged),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                // _buildTablefeedback("Emoji", emoji),
                // _buildTablefeedback("Feedback", feedback),
                _buildTablefeedback("Comments", comments),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackRadio(
      String value, String groupValue, Function(String) onChanged) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          _getFeedbackEmoji(value),
        ),
        Text(
          value,
        ),
        SizedBox(width: 8),
        Radio<String>(
          groupValue: groupValue,
          value: value,
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          fillColor: MaterialStateProperty.all(_getFeedbackColor(value)),
        ),
      ],
    );
  }

  String _getFeedbackEmoji(String feedback) {
    switch (feedback) {
      case "Good":
        return "😊";
      case "Poor":
        return "😞";
      case "Very Poor":
        return "😣";
      case "Okay":
        return "😐";
      case "Excellent":
        return "😍";
      default:
        return "🤔";
    }
  }

  Color _getFeedbackColor(String feedback) {
    switch (feedback) {
      case "Good":
        return Color(ColorVal);
      case "Poor":
        return Color(ColorVal);
      case "Very Poor":
        return Color(ColorVal);
      case "Okay":
        return Color(ColorVal);
      case "Excellent":
        return Color(ColorVal);
      default:
        return Color(ColorVal);
    }
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: apptextsizemanage.handlinetextstyle(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            value,
            style: apptextsizemanage.handlinetextstyle(),
          ),
        ),
      ],
    );
  }

  TableRow _buildTablefeedback(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            label,
            style: apptextsizemanage.handlinetextstyle(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            value,
            style: apptextsizemanage.handlinetextstyle(),
          ),
        ),
      ],
    );
  }
}
