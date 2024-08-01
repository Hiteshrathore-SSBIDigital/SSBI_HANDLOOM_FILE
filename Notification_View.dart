import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';
import 'package:video_player/video_player.dart'; // Add this import for video handling
import 'package:url_launcher/url_launcher.dart'; // Ensure you have this import for URL launching

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
        padding: EdgeInsets.all(10),
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
                0: FixedColumnWidth(130),
                1: FixedColumnWidth(30),
              },
              children: [
                _buildTableRow("State", state),
                _buildTableRow("District", district),
                _buildTableRow("City", city),
                _buildTableRow("Department", department),
                _buildTableRow("Type", type),
                _buildTableRow("Image", image.isNotEmpty ? "View Image" : "N/A",
                    onTap: () => _viewMedia(context, image, isImage: true)),
                _buildTableRow("Video", video.isNotEmpty ? "Play Video" : "N/A",
                    onTap: () => _viewMedia(context, video, isImage: false)),
              ],
            ),
            SizedBox(height: 10),
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
                "Product Details or Specification",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Table(
              columnWidths: {
                0: FixedColumnWidth(130),
                1: FixedColumnWidth(30),
              },
              children: [
                _buildTableRow("Product Name ",
                    productname == "ALL" ? "N/A" : productname),
                _buildTableRow(
                    "Weaver Name", wearverName == "ALL" ? "N/A" : wearverName),
                _buildTableRow(
                    "Dimension", dimision == "ALL" ? "N/A" : dimision),
                _buildTableRow(
                    "Dyeing Status", dyeStatus == "ALL" ? "N/A" : dyeStatus),
                _buildTableRow(
                    "Nature Dye", nature_dye == "ALL" ? "N/A" : nature_dye),
                _buildTableRow(
                    "Type of Weave", WeaveType == "ALL" ? "N/A" : WeaveType),
                _buildTableRow(
                    "Type of Yarn", yarntype == "ALL" ? "N/A" : yarntype),
                _buildTableRow(
                    "Type of loom", loomtype == "ALL" ? "N/A" : loomtype),
                _buildTableRow("Yarn Count", ''),
                _buildTableRow("Wrape", wrape == "ALL" ? "N/A" : wrape),
                _buildTableRow(
                    "Wrape Count", wrapeCount == "ALL" ? "N/A" : wrapeCount),
                _buildTableRow("Weft", weft == "ALL" ? "N/A" : weft),
                _buildTableRow(
                    "Weft Count", weftCount == "ALL" ? "N/A" : weftCount),
                _buildTableRow(
                    "Extra Weft", extraWeft == "ALL" ? "N/A" : extraWeft),
                _buildTableRow("Extra Weft Count",
                    extraWeftCount == "ALL" ? "N/A" : extraWeftCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _viewMedia(BuildContext context, String url,
      {required bool isImage}) async {
    final String updateurl = staticverible.temqr + url;

    print('Attempting to launch URL: $updateurl'); // Debug print

    try {
      if (await canLaunch(updateurl)) {
        await launch(updateurl);
      } else {
        print('Could not launch URL: $updateurl'); // Debug print
      }
    } catch (e) {
      print('Exception: $e'); // Debug print
    }
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
                ),
                Divider()
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
                _buildTablecomments(context, "Comments", comments),
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

  TableRow _buildTableRow(String label, String value,
      {void Function()? onTap}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '$label',
            style: apptextsizemanage.handlinetextstyle2(),
          ),
        ),
        Text(
          ':',
          style: apptextsizemanage.handlinetextstyle2(),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                value,
                style: apptextsizemanage.handlinetextstyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTablecomments(
      BuildContext context, String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: apptextsizemanage.handlinetextstyle2(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      width: 0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      value,
                      style: apptextsizemanage.handlinetextstyle(),
                    ),
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

class ImageViewer extends StatelessWidget {
  final String url;

  const ImageViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                url,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoViewer extends StatefulWidget {
  final String url;

  const VideoViewer({Key? key, required this.url}) : super(key: key);

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Viewer'),
        backgroundColor: Color(ColorVal),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';
import 'package:video_player/video_player.dart'; // Add this import for video handling
import 'package:url_launcher/url_launcher.dart'; // Ensure you have this import for URL launching

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
        padding: EdgeInsets.all(10),
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
                0: FixedColumnWidth(130),
                1: FixedColumnWidth(30),
              },
              children: [
                _buildTableRow("State", state),
                _buildTableRow("District", district),
                _buildTableRow("City", city),
                _buildTableRow("Department", department),
                _buildTableRow("Type", type),
                _buildTableRow("Image", image.isNotEmpty ? "View Image" : "N/A",
                    onTap: () => _viewMedia(context, image, isImage: true)),
                _buildTableRow("Video", video.isNotEmpty ? "Play Video" : "N/A",
                    onTap: () => _viewMedia(context, video, isImage: false)),
              ],
            ),
            SizedBox(height: 10),
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
                "Product Details or Specification",
                style: apptextsizemanage.handlinetextstyle1(),
              ),
            ),
            Divider(),
            Table(
              columnWidths: {
                0: FixedColumnWidth(130),
                1: FixedColumnWidth(30),
              },
              children: [
                _buildTableRow("Product Name ",
                    productname == "ALL" ? "N/A" : productname),
                _buildTableRow(
                    "Weaver Name", wearverName == "ALL" ? "N/A" : wearverName),
                _buildTableRow(
                    "Dimension", dimision == "ALL" ? "N/A" : dimision),
                _buildTableRow(
                    "Dyeing Status", dyeStatus == "ALL" ? "N/A" : dyeStatus),
                _buildTableRow(
                    "Nature Dye", nature_dye == "ALL" ? "N/A" : nature_dye),
                _buildTableRow(
                    "Type of Weave", WeaveType == "ALL" ? "N/A" : WeaveType),
                _buildTableRow(
                    "Type of Yarn", yarntype == "ALL" ? "N/A" : yarntype),
                _buildTableRow(
                    "Type of loom", loomtype == "ALL" ? "N/A" : loomtype),
                _buildTableRow("Yarn Count", ''),
                _buildTableRow("Wrape", wrape == "ALL" ? "N/A" : wrape),
                _buildTableRow(
                    "Wrape Count", wrapeCount == "ALL" ? "N/A" : wrapeCount),
                _buildTableRow("Weft", weft == "ALL" ? "N/A" : weft),
                _buildTableRow(
                    "Weft Count", weftCount == "ALL" ? "N/A" : weftCount),
                _buildTableRow(
                    "Extra Weft", extraWeft == "ALL" ? "N/A" : extraWeft),
                _buildTableRow("Extra Weft Count",
                    extraWeftCount == "ALL" ? "N/A" : extraWeftCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _viewMedia(BuildContext context, String url,
      {required bool isImage}) async {
    final String updateurl = staticverible.temqr + url;

    print('Attempting to launch URL: $updateurl'); // Debug print

    try {
      if (await canLaunch(updateurl)) {
        await launch(updateurl);
      } else {
        print('Could not launch URL: $updateurl'); // Debug print
      }
    } catch (e) {
      print('Exception: $e'); // Debug print
    }
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
                ),
                Divider()
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
                _buildTablecomments(context, "Comments", comments),
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

  TableRow _buildTableRow(String label, String value,
      {void Function()? onTap}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            '$label',
            style: apptextsizemanage.handlinetextstyle2(),
          ),
        ),
        Text(
          ':',
          style: apptextsizemanage.handlinetextstyle2(),
        ),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                value,
                style: apptextsizemanage.handlinetextstyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildTablecomments(
      BuildContext context, String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: apptextsizemanage.handlinetextstyle2(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      width: 0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      value,
                      style: apptextsizemanage.handlinetextstyle(),
                    ),
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

class ImageViewer extends StatelessWidget {
  final String url;

  const ImageViewer({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                url,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoViewer extends StatefulWidget {
  final String url;

  const VideoViewer({Key? key, required this.url}) : super(key: key);

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Viewer'),
        backgroundColor: Color(ColorVal),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
