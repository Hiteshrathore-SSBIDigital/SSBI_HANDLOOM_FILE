import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Model_Screen/LocaleString.dart';
import 'package:nehhdc_app/Setting_Screen/Directory_Screen.dart';
import 'package:nehhdc_app/Welcome_Screen/Login_Screen.dart';
import 'package:quickalert/quickalert.dart';

late File errorlogs;

String version = 'Version 0.0.72';
String appv = "0.0.72";
String name = 'SSBI Digital PVT.LTD.';
String City = 'Ahmedabad';
final int ColorVal = 0xff022a72;
final String mycolor = '#${ColorVal.toRadixString(16)}';

void showMessageDialog(BuildContext context, dynamic message) {
  String displayMessage = "";

  if (message is List<String>) {
    displayMessage = message.join("\n");
  } else if (message is String) {
    displayMessage = message;
  } else {
    displayMessage = "Unknown response";
  }

  Fluttertoast.showToast(
    msg: displayMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 0,
    backgroundColor: Colors.white,
    textColor: Colors.black,
  );

  Timer(Duration(seconds: 2), () {
    Fluttertoast.cancel();
  });
}

// Please Wait Method
void plaesewaitmassage(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.loading,
    title: "Please Wait",
    text: "Loading..",
  );
}

// Please Wait Method
void plaesewaitdevicereport(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.loading,
    title: "Please Wait",
    text: "This process may take a few moments..",
  );
}

void Successmassage(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: "Success",
    text: "Data Upload Successfully!",
  );
}

void plaesewaitDevice(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.loading,
    title: "Please wait",
    text: "Connecting device..",
  );
}

void showRegisteredMessage(BuildContext context, dynamic message) {
  if (message ==
      'Your Profile Is Approved.Your Credentials are sent to your registered Email ID') {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Registered Mail",
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  } else if (message == 'Your Profile Is Under Approval Process.') {
    QuickAlert.show(
        context: context,
        title: "Registered Mail",
        type: QuickAlertType.error,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  } else if (message == 'Your Profile Is Deactivated') {
    QuickAlert.show(
        context: context,
        title: "Registered Mail",
        type: QuickAlertType.error,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  } else if (message == 'All data received completed') {
    QuickAlert.show(
        context: context,
        title: "Registered Mail",
        type: QuickAlertType.confirm,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  } else if (message == 'Data not found') {
    QuickAlert.show(
        context: context,
        title: "Registered Mail",
        type: QuickAlertType.info,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  } else {
    QuickAlert.show(
        context: context,
        title: "Registered Mail",
        type: QuickAlertType.info,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  }
}

void showForgetMessage(BuildContext context, dynamic message) {
  if (message == 'Mail has been sent to your registered Email ID.') {
    QuickAlert.show(
        context: context,
        title: "Registered Mail",
        type: QuickAlertType.success,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          loginscreen(context);
        });
  } else if (message == 'Invalid registered Email ID or UserId.') {
    QuickAlert.show(
        context: context,
        title: "Forget Password?",
        type: QuickAlertType.error,
        text: message,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
        });
  }
}

void LogoutMassge(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.confirm,
    text: 'Sure you want to logout?',
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    confirmBtnColor: Colors.green,
    onConfirmBtnTap: () async {
      try {
        // Clear language preference to default to English
        await LanguageService().saveLanguage('en', 'US');

        // Update credentials to null
        await DatabaseHelper.updateCredentialsToNull();

        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Login_Screen()),
        );
      } catch (e) {
        print('Error during logout: $e');
        // Handle error here, e.g., show a different error message or log it
      }
    },
  );
}

void showInternetConnectivitySnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

// Location
Future<Position?> getCurrentLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    print('Error getting location: $e');
    logError('$e');
    return null;
  }
}

Future<File?> initializeErrorlogs() async {
  try {
    Directory? directory = await getAndroidMediaDirectory();
    if (directory != null) {
      Directory logsDirectory = Directory('${directory.path}/Logs');
      if (!(await logsDirectory.exists())) {
        await logsDirectory.create(recursive: true);
      }

      String filename = 'error_logs.txt';
      File errorlogs = File('${logsDirectory.path}/$filename');

      if (!(await errorlogs.exists())) {
        await errorlogs.create();
      }

      print('Error log initialized successfully: $filename');

      return errorlogs;
    } else {
      throw Exception('Error: External storage directory is null');
    }
  } catch (e, stackTrace) {
    print('Error initializing error log: $e');
    print(stackTrace);
    return null;
  }
}

Future<void> logError(String message) async {
  try {
    File? errorLog = await initializeErrorlogs();
    if (errorLog != null) {
      IOSink sink = errorLog.openWrite(mode: FileMode.append);
      String dataformat =
          DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.now());
      sink.write('$dataformat,Error occurred : $message\n');
      await sink.flush();
      await sink.close();

      print('Error logged: $message');
      //  await sendLogFileViaGmail();
    } else {
      print('Error log initialization failed. Cannot log error: $message');
    }
  } catch (e) {
    print('Error logging error: $e');
  }
}
// GPS Location Enable on off

Future<bool> checkGps(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    // Check location services are enabled (common across all Android versions)
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showGpsDialog(
          context); // Custom dialog to inform user about disabled GPS
      //logError("GPS Location Off");
      return false;
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    //logError("GPS permission: $permission");

    // Handle permission scenarios
    switch (permission) {
      case LocationPermission.denied:
        // Request permission if denied
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDeniedDialog(context);
          // logError("GPS Location Permission Denied");
          return false;
        }
        break;
      case LocationPermission.deniedForever:
        _showPermissionDeniedDialog(context);
        return false;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        // Additional check for Android 9 specifically
        // if (await _isAndroidVersion9()) {
        //   logError(
        //       "Running on Android 9: Additional checks for GPS services");
        if (!await _checkPreciseLocationEnabled()) {
          _showGpsDialog(context);
          // logError("Precise location not enabled on Android 9");
          return false;
        }
        // }
        //logError("GPS Location Success: Permission Granted");
        return true;
      default:
        _showPermissionDeniedDialog(context);
        //logError("GPS Location Permission Status Not Handled: $permission");
        return false;
    }
  } catch (e) {
    print('Error checking GPS: $e');
    logError("GPS Location Error: $e");
    return false;
  }
  return false;
}

void _showGpsDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Row(
        children: [
          Icon(
            Icons.location_off_outlined,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'NEHHDC wants to use your location',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
      content: Text('Please enable GPS Location to continue.'),
      actions: <Widget>[
        TextButton(
          child: Text("Don't Allow"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Allow'),
          onPressed: () {
            Geolocator.openLocationSettings();
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

void _showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Row(
        children: [
          Icon(
            Icons.location_off_outlined,
            color: Colors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Permission Denied',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
      content: Text(
          'Location permission is required to continue. Please allow access.'),
      actions: <Widget>[
        TextButton(
          child: Text("Don't Allow"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Allow'),
          onPressed: () async {
            await Geolocator.requestPermission();
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Future<bool> _checkPreciseLocationEnabled() async {
  LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high, // or LocationAccuracy.best
    distanceFilter: 100, // Optional
  );

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: locationSettings.accuracy,
    );
    return position != "";
  } catch (e) {
    return false;
  }
}

// App Font size manage
class apptextsizemanage {
  static const double handline1 = 15.00;
  static const double handline2 = 13.00;
  static const double handline3 = 14.00;

  static TextStyle Appbartextstyle() {
    return TextStyle(
        fontSize: handline1, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle handltextdefult() {
    return TextStyle(fontSize: handline2, fontWeight: FontWeight.normal);
  }

  static TextStyle handlinetextstylebold() {
    return TextStyle(
        fontSize: handline2,
        fontWeight: FontWeight.normal,
        color: Colors.white);
  }

  static TextStyle handlinetextstyle1() {
    return TextStyle(
        fontSize: handline1, fontWeight: FontWeight.bold, color: Colors.grey);
  }

  static TextStyle handlinetextstyle2() {
    return TextStyle(
      fontSize: handline3,
      fontWeight: FontWeight.bold,
    );
  }
}
