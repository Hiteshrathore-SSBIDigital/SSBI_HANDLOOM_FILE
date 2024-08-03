import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';
import 'package:url_launcher/url_launcher.dart';

class Product_Report_View extends StatefulWidget {
  final NotificationDisplay notificationData;
  final String feedbackview;
  final String emoji;
  final String comments;

  const Product_Report_View({
    Key? key,
    required this.notificationData,
    required this.feedbackview,
    required this.emoji,
    required this.comments,
  }) : super(key: key);

  @override
  State<Product_Report_View> createState() => _Product_Report_ViewState();
}

class _Product_Report_ViewState extends State<Product_Report_View> {
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
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
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildInfoTablestate(
              context,
              data: {
                "State": notificationData.state == "ALL"
                    ? "N/A"
                    : notificationData.state,
                "District": notificationData.district,
                "City": notificationData.city,
                "Department": notificationData.department,
                "Type": notificationData.type,
                "Image": notificationData.image,
                "Video": notificationData.video,
              },
            ),
            SizedBox(height: 10),
            _buildInfoTable(
              context,
              data: {
                "Product Name": notificationData.productname,
                "Weaver Name": notificationData.weavername,
                "Dimension": notificationData.dimision == "ALL"
                    ? "N/A"
                    : notificationData.dimision,
                "Dyeing Status": notificationData.dyeStatus == "ALL"
                    ? "N/A"
                    : notificationData.dyeStatus,
                "Nature Dye": notificationData.nature_dye == "ALL"
                    ? "N/A"
                    : notificationData.nature_dye,
                "Type of Weave": notificationData.WeaveType == "ALL"
                    ? "N/A"
                    : notificationData.WeaveType,
                "Type of Yarn": notificationData.yarntype == "ALL"
                    ? "N/A"
                    : notificationData.yarntype,
                "Type of Loom": notificationData.loomtype == "ALL"
                    ? "N/A"
                    : notificationData.loomtype,
                "Yarn Count": "",
                "Wrape": notificationData.wrape == "ALL"
                    ? "N/A"
                    : notificationData.wrape,
                "Wrape Count": notificationData.wrapeCount == "ALL"
                    ? "N/A"
                    : notificationData.wrapeCount,
                "Weft": notificationData.weft == "ALL"
                    ? "N/A"
                    : notificationData.weft,
                "Weft Count": notificationData.weftCount == "ALL"
                    ? "N/A"
                    : notificationData.weftCount,
                "Extra Weft": notificationData.extraWeft == "ALL"
                    ? "N/A"
                    : notificationData.extraWeft,
                "Extra Weft Count": notificationData.extraWeftCount == "ALL"
                    ? "N/A"
                    : notificationData.extraWeftCount,
              },
            ),
            SizedBox(height: 10),
            _buildFeedbackSection(
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

  Widget _buildInfoTablestate(BuildContext context,
      {required Map<String, String> data}) {
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
                0: FixedColumnWidth(130),
                1: FixedColumnWidth(30),
              },
              children: data.entries.map((entry) {
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          entry.key,
                          style: apptextsizemanage.handlinetextstyle2(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(":"),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: entry.key == "Image" || entry.key == "Video"
                            ? InkWell(
                                onTap: () {
                                  if (entry.key == "Image") {
                                    launchImageURL(entry.value);
                                  } else if (entry.key == "Video") {
                                    launchvideosURL(entry.value);
                                  }
                                },
                                child: Text(
                                  entry.value.isNotEmpty
                                      ? 'View ${entry.key}'
                                      : 'No ${entry.key}',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            : Text(entry.value),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTable(BuildContext context,
      {required Map<String, String> data}) {
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
                "Product Specification",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Table(
              columnWidths: {
                0: FixedColumnWidth(130),
                1: FixedColumnWidth(30),
              },
              children: data.entries.map((entry) {
                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          entry.key,
                          style: apptextsizemanage.handlinetextstyle2(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(":"),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: entry.key == "Image" || entry.key == "Video"
                            ? InkWell(
                                onTap: () {
                                  if (entry.key == "Image") {
                                    launchImageURL(entry.value);
                                  } else if (entry.key == "Video") {
                                    launchvideosURL(entry.value);
                                  }
                                },
                                child: Text(
                                  entry.value.isNotEmpty
                                      ? 'View ${entry.key}'
                                      : 'No ${entry.key}',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              )
                            : Text(entry.value),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void launchImageURL(String imageUrl) async {
    String url = staticverible.temqr + '/' + imageUrl;

    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url: $e';
    }
  }

  void launchvideosURL(String videosUrl) async {
    String url = staticverible.temqr + '/' + videosUrl;
    try {
      await launch(url);
    } catch (e) {
      throw 'Could not launch $url: $e';
    }
  }

  Widget _buildFeedbackSection(
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
                "Feedback",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...["Good", "Poor", "Very Poor", "Okay", "Excellent"].map(
                  (value) => _buildFeedbackRadio(
                      context, value, feedback, onFeedbackChanged),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                //     _buildTableRow("Comments", comments),
                _buildTablecomments(context, "Comments :"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackRadio(
    BuildContext context,
    String value,
    String groupValue,
    Function(String) onChanged,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(_getFeedbackEmoji(value)),
        Text(value),
        SizedBox(width: 8),
        Radio<String>(
          groupValue: groupValue,
          value: value,
          onChanged: (newValue) {},
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
    return Color(ColorVal); // Customize colors as needed
  }

  TableRow _buildTablecomments(BuildContext context, String label) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: apptextsizemanage.handlinetextstyle2(),
              ),
              SizedBox(height: 8),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    comments,
                    style: apptextsizemanage.handlinetextstyle(),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
