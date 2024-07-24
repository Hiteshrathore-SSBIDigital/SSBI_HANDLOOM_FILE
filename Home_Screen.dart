import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nehhdc_app/IOT_Screen/DeviceLIst.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';

import 'package:nehhdc_app/Model_Screen/LocaleString.dart';
import 'package:nehhdc_app/Other_Screen/Contact_Screen.dart';
import 'package:nehhdc_app/Other_Screen/Help_Screen.dart';
import 'package:nehhdc_app/Other_Screen/Manage_Password.dart';
import 'package:nehhdc_app/Other_Screen/Notification.dart';

import 'package:nehhdc_app/Report/Product_Report.dart';

import 'package:nehhdc_app/Screen/Bottom_Screen.dart';
import 'package:nehhdc_app/Screen/Product_List.dart';

import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  int _notificationCount = 0; // Default to 0 notifications
  final List<Map<String, dynamic>> locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'हिंदी', 'locale': Locale('hi', 'IN')},
    {'name': 'অসমীয়া', 'locale': Locale('as', 'IN')},
  ];
  updateLanguage(Locale locale) async {
    Get.back();

    LanguageService languageService = LanguageService();
    await languageService.saveLanguage(
        locale.languageCode, locale.countryCode ?? '');
    Get.updateLocale(locale);
    print("Updated Locale: $locale");
  }

  buildLanguageDialog(BuildContext context) async {
    LanguageService languageService = LanguageService();
    Locale savedLocale = await languageService.getSavedLocale();

    showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text(
            'Choose Your Language',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool isSelected = savedLocale.languageCode ==
                    locale[index]['locale']
                        .languageCode; // Check if current locale is selected
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: Text(
                      locale[index]['name'],
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    onTap: () {
                      updateLanguage(locale[index]['locale']);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.blue,
                );
              },
              itemCount: locale.length,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final notificationApis = Notificationapis();
      final notificationData =
          await notificationApis.fetchNotification(context);
      setState(() {
        _notificationCount = notificationData.notifications.length;
        print('Number of notification $_notificationCount ');
      });
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          width: 250,
          elevation: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 60,
                            child: Image.asset('assets/Images/NEHHD.png'))
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User Name :- ${staticverible.username}',
                            style: TextStyle(fontSize: 13)),
                        Text('Role :- ${staticverible.rolename}',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Divider(),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Color(ColorVal),
                      ),
                      title: Text(
                        "Home".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_outlined),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Bottom_Screen(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Color(ColorVal),
                        ),
                      ),
                      // Add Product
                      title: Text(
                        "Product".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Productlist_Screen(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    // blutooth
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.bluetooth,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text(
                        "Device".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => DeviceList(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.language,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text(
                        "Language".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        buildLanguageDialog(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.contact_support_sharp,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text(
                        "Contact Us".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ContactScreen()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.lock,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text(
                        "Manage Password".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Manage_Password()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.help,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text(
                        "Help".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Help_Screen()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Container(
                        child: Icon(
                          Icons.login,
                          color: Color(ColorVal),
                        ),
                      ),
                      title: Text(
                        "Log out".tr,
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Color(ColorVal),
                      ),
                      onTap: () {
                        LogoutMassge(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(),
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        version,
                        style: TextStyle(fontSize: 13),
                      ),
                    )),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Current Server',
                        style: TextStyle(fontSize: 13),
                      ),
                    )),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        staticverible.tempip,
                        style: TextStyle(fontSize: 12),
                        softWrap: true,
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
      ),
      appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color(ColorVal),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.language),
              color: Colors.white,
              onPressed: () {
                buildLanguageDialog(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 30,
                    ),
                    if (_notificationCount > 0)
                      Positioned(
                        right: -5,
                        top: -2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              _notificationCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext content) =>
                              Notification_Screen()));
                },
              ),
            )
          ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(ColorVal)),
                ),
                InkWell(
                  child: Text(
                    "View All",
                    style: TextStyle(
                        color: Color(ColorVal), fontWeight: FontWeight.bold),
                  ),
                  onTap: () {},
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.production_quantity_limits,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Productlist_Screen()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Product".tr),
                    ],
                  ),
                  // SizedBox(width: 20),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Product_Report()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("View Product".tr),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Color(ColorVal),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.bluetooth,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DeviceList()));
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Device".tr),
                    ],
                  ),
                ]),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
