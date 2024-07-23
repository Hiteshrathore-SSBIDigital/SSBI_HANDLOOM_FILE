import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:intl/intl.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';

class Product_Report extends StatefulWidget {
  const Product_Report({super.key});

  @override
  State<Product_Report> createState() => _Product_ReportState();
}

class _Product_ReportState extends State<Product_Report> {
  TextEditingController searchController = TextEditingController();
  TextEditingController _endDtController = TextEditingController();
  TextEditingController _startDtController = TextEditingController();

  List<String> _weaverNames = [];
  String _selectedWeaver = '';
  DateTime selectedDate = DateTime.now();
  late DateTime FromDate;
  late DateTime ToDate;
  List<ProductView> productViewList = [];
  bool isLoading = false;
  bool weaverenable = true;
  bool searchPerformed = false;
  final FeedbackService feedback = FeedbackService();
  String feedbackview = '';
  String emoji = '';
  String comments = '';
  String? selectedFeedback;
  @override
  void initState() {
    initializeFromDate();
    super.initState();
    fetchWeavers().then((_) {
      if (_weaverNames.length == 2 && staticverible.type == 'Own') {
        setState(() {
          _selectedWeaver = _weaverNames[1];
          weaverenable = false;
        });
      }
    });
  }

  Future<void> fetchWeavers() async {
    try {
      TempWearverAPIs tempWeaverAPIs = TempWearverAPIs();
      List<String>? weaverNames = await tempWeaverAPIs.Fetchwearver(context);
      if (weaverNames != '' && weaverNames.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          _weaverNames = ['Select Weaver', ...weaverNames];
          _selectedWeaver = _weaverNames[0];
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching weaver names: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void initializeFromDate() {
    if (_startDtController.text.isEmpty) {
      _startDtController.text = DateTime.now().toIso8601String();
    }
    if (_endDtController.text.isEmpty) {
      _endDtController.text = DateTime.now().toIso8601String();
    }

    FromDate = DateTime.parse(_startDtController.text);
    ToDate = DateTime.parse(_endDtController.text);
  }

  void fetchData() async {
    try {
      plaesewaitmassage(context);
      List<ProductView> itemdata =
          await GetProductwiseData(context, FromDate, ToDate, _selectedWeaver);

      setState(() {
        productViewList = itemdata;
        searchPerformed = true;
        Navigator.of(context).pop();
      });
    } catch (e) {
      print("Error fetching product data: $e");
      setState(() {
        searchPerformed = true;
      });
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectStartDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _startDtController.text = picked.toLocal().toString().split(' ')[0];
        FromDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(
      BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _endDtController.text = picked.toLocal().toString().split(' ')[0];
        ToDate = picked;
      });
    }
  }

  void showProductDetails(BuildContext context, ProductView product) async {
    // Determine the feedback value based on the feedback response
    String feedbackValue = '';
    switch (feedbackview) {
      case 'Good':
        feedbackValue = '1';
        break;
      case 'Poor':
        feedbackValue = '2';
        break;
      case 'Very Poor':
        feedbackValue = '3';
        break;
      case 'Okay':
        feedbackValue = '4';
        break;
      case 'Excellent':
        feedbackValue = '5';
        break;
      default:
        feedbackValue = '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String weavetype =
            product.weavetype == 'ALL' ? "N/A" : product.weavetype;
        String dyestatus =
            product.dyestatus == 'ALL' ? 'N/A' : product.dyestatus;
        String nature_dye =
            product.nature_dye == 'ALL' ? 'N/A' : product.nature_dye;
        String yarntype = product.yarntype == 'ALL' ? 'N/A' : product.yarntype;
        String loomtype = product.loomtype == 'ALL' ? 'N/A' : product.loomtype;
        String dimension =
            product.dimension == 'ALL' ? 'N/A' : product.dimension;

        String wrapname = product.Yarncount.wrape == 'Wrape - ALL'
            ? 'N/A'
            : product.Yarncount.wrape;

        String wrapecount = product.Yarncount.wrapecount == 'Wrape count - ALL'
            ? 'N/A'
            : product.Yarncount.wrapecount;
        String weftname = product.Yarncount.weft == 'Weft - ALL'
            ? 'N/A'
            : product.Yarncount.weft;
        String weftcount = product.Yarncount.weftcount == 'Weft count - ALL'
            ? 'N/A'
            : product.Yarncount.weftcount;
        String extraweft = product.Yarncount.extraweft == 'Extra weft - ALL'
            ? 'N/A'
            : product.Yarncount.extraweft;
        String extraweftcount =
            product.Yarncount.extraweftcount == 'Extra weft count - ALL'
                ? 'N/A'
                : product.Yarncount.extraweftcount;
        if (wrapname == 'N/A') {
          wrapname = 'Wrape - N/A';
        }
        if (wrapecount == 'N/A') {
          wrapecount = 'Wrape count - N/A';
        }
        if (weftname == 'N/A') {
          weftname = 'Weft - N/A';
        }
        if (weftcount == 'N/A') {
          weftcount = 'Weft count - N/A';
        }
        if (extraweft == 'N/A') {
          extraweft = 'Extra weft - N/A';
        }
        if (extraweftcount == 'N/A') {
          extraweftcount = 'Extra weft count - N/A';
        }
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Center(
            child: Column(
              children: [
                Text(
                  "Product Details",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width / 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("State : ${product.state}"),
                  SizedBox(height: 2),
                  Text("District : ${product.district}"),
                  SizedBox(height: 2),
                  Text("Department : ${product.department}"),
                  SizedBox(height: 2),
                  Text("Type : ${product.type}"),
                  SizedBox(height: 2),
                  Text("Organization : ${product.organazation}"),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text("Image: "),
                      if (product.image != '' && product.image.isNotEmpty)
                        InkWell(
                          child: Text(
                            "View Image",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            launchImageURL(product.image);
                          },
                        )
                      else
                        Text("N/A")
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text("Video : "),
                      if (product.video != '' && product.video.isNotEmpty)
                        InkWell(
                          child: Text(
                            "View Video",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            launchvideosURL(product.video);
                          },
                        )
                      else
                        Text("N/A")
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  Center(
                    child: Text(
                      "Product Specification",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Divider(),
                  Text("WeaveType : $weavetype"),
                  SizedBox(height: 2),
                  SizedBox(height: 2),
                  Text("Dyestatus : $dyestatus"),
                  SizedBox(height: 2),
                  Text("Nature Dye : $nature_dye"),
                  SizedBox(height: 2),
                  Text("Yarntype : $yarntype"),
                  SizedBox(height: 2),
                  Text("Loomtype : $loomtype"),
                  SizedBox(height: 2),
                  Text("Dimension : $dimension"),
                  SizedBox(height: 2),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                        "Yarncount",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      )),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$wrapname"),
                            Text("$wrapecount"),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$weftname"),
                          Text("$weftcount"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$extraweft"),
                          Text("$extraweftcount"),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  if (feedbackValue.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Feedback",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FeedbackEmoji(
                                    emoji: '😃',
                                    label: 'Good',
                                    isSelected: feedbackValue == '1',
                                    onTap: (value) => updateFeedback(value),
                                    feedbackValue: '1',
                                  ),
                                  FeedbackEmoji(
                                    emoji: '😞',
                                    label: 'Poor',
                                    isSelected: feedbackValue == '2',
                                    onTap: (value) => updateFeedback(value),
                                    feedbackValue: '2',
                                  ),
                                  FeedbackEmoji(
                                    emoji: '😣',
                                    label: 'Very Poor',
                                    isSelected: feedbackValue == '3',
                                    onTap: (value) => updateFeedback(value),
                                    feedbackValue: '3',
                                  ),
                                  FeedbackEmoji(
                                    emoji: '😐',
                                    label: 'Okay',
                                    isSelected: feedbackValue == '4',
                                    onTap: (value) => updateFeedback(value),
                                    feedbackValue: '4',
                                  ),
                                  FeedbackEmoji(
                                    emoji: '😍',
                                    label: 'Excellent',
                                    isSelected: feedbackValue == '5',
                                    onTap: (value) => updateFeedback(value),
                                    feedbackValue: '5',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Center(child: Text("Comments")),
                        Center(
                          child: Text(
                            comments.isEmpty
                                ? 'No comments available'
                                : comments,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  InkWell(
                    child: Center(
                      child: Container(
                        height: 40,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color(ColorVal),
                        ),
                        child: Center(
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void updateFeedback(String value) {
    setState(() {
      selectedFeedback = value;
    });
    print("Selected feedback: $selectedFeedback");
  }

  String formatproductName(String name) {
    if (name.length > 20) {
      return name.substring(0, 20) + '\n' + name.substring(20);
    } else {
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product List",
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
      body: Column(
        children: [
          Container(
            height: 150,
            color: Color(ColorVal),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text(
                              "Start Date: ${FromDate != '' ? DateFormat('dd MMM yyyy').format(FromDate) : ''}",
                              style: TextStyle(color: Color(ColorVal)),
                            ),
                          ),
                        ),
                        onTap: () {
                          _selectStartDate(context, setState);
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "End Date: ${ToDate != '' ? DateFormat('dd MMM yyyy').format(ToDate) : ''}",
                              style: TextStyle(color: Color(ColorVal)),
                            ),
                          ),
                        ),
                        onTap: () {
                          _selectEndDate(context, setState);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading)
                        Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(ColorVal)),
                          ),
                        )
                      else if (staticverible.type == 'Own')
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(width: 0, color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: SizedBox(),
                              value: _selectedWeaver,
                              items: _weaverNames.map((String weaverName) {
                                return DropdownMenuItem<String>(
                                  value: weaverName,
                                  child: Text(
                                    weaverName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: staticverible.type == 'Own'
                                          ? Colors.black
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: weaverenable
                                  ? (String? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          _selectedWeaver = newValue;
                                        });
                                      }
                                    }
                                  : null,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(width: 0, color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: SizedBox(),
                              value: _selectedWeaver,
                              items: _weaverNames.map((String weaverName) {
                                return DropdownMenuItem<String>(
                                  value: weaverName,
                                  child: Text(
                                    weaverName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedWeaver = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(255, 175, 170, 243)),
                      child: Center(child: Text("Search")),
                    ),
                    onTap: () {
                      if (_selectedWeaver == _weaverNames.first &&
                          _selectedWeaver.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Please select weaver name',
                            ),
                          ),
                        );
                        return;
                      }
                      setState(() {
                        searchPerformed = true;
                      });
                      fetchData();
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: productViewList.isEmpty
                ? Center(
                    child: searchPerformed
                        ? Column(
                            children: [
                              Image.asset(
                                  'assets/Images/Data_Not_Available.jpg'),
                              Text("No Data Found"),
                            ],
                          )
                        : Image.asset('assets/Images/Nodata.jpg'),
                  )
                : ListView.separated(
                    itemCount: productViewList.length,
                    itemBuilder: (context, index) {
                      final product = productViewList[index];
                      final hasData = product.qrtextfinal.isNotEmpty &&
                          product.productname.isNotEmpty &&
                          product.wearverName.isNotEmpty;
                      return ListTile(
                        title: product.qrtextfinal.isNotEmpty
                            ? Row(
                                children: [
                                  Text('QR Label: '),
                                  Text(product.qrtextfinal),
                                ],
                              )
                            : null,
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.productname.isNotEmpty)
                              Row(
                                children: [
                                  Text('Product Name: '),
                                  Text(
                                      '${formatproductName(product.productname)}'),
                                ],
                              ),
                            if (product.wearverName.isNotEmpty)
                              Row(
                                children: [
                                  Text('Weaver Name: '),
                                  Text(product.wearverName),
                                ],
                              ),
                          ],
                        ),
                        trailing: hasData
                            ? IconButton(
                                onPressed: () async {
                                  final feedbackService = FeedbackService();

                                  try {
                                    Map<String, String> feedbackData =
                                        await feedbackService.sendFeedback(
                                            context, product.qrtextfinal);

                                    feedbackview = feedbackData['feedback'] ??
                                        'No feedback available';
                                    emoji = feedbackData['emoji'] ?? '🤔';
                                    comments = feedbackData['comment'] ??
                                        'No feedback available';

                                    print('Feedback: $feedbackview');
                                    print('Emoji: $emoji');
                                    print('comments: $comments');

                                    showProductDetails(context, product);
                                  } catch (e) {
                                    print('Error: $e');

                                    print('Failed to load feedback');
                                  }
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Color(ColorVal),
                                ),
                              )
                            : null,
                      );
                    },
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

class FeedbackEmoji extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final ValueChanged<String> onTap;
  final String feedbackValue;

  FeedbackEmoji({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.feedbackValue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(feedbackValue), // Pass feedbackValue to onTap
      child: Column(
        children: <Widget>[
          Text(
            emoji,
            style: TextStyle(
              fontSize: 30,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          Radio<String>(
            value: feedbackValue,
            groupValue: isSelected ? feedbackValue : null,
            onChanged: (value) {},
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
