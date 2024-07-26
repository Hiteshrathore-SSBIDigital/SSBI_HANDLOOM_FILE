import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nehhdc_app/Screen/Add_Product.dart';
import 'package:nehhdc_app/Screen/Bottom_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Directory_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';
import 'package:nehhdc_app/Welcome_Screen/Login_Screen.dart';
import 'package:path/path.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart' as xml;

class Temp {
  final String tempurl;
  int status;

  Temp({required this.tempurl, required this.status});
}

String getQrValue(String url) {
  Uri uri = Uri.parse(url);

  staticverible.qrval = uri.queryParameters['ID'].toString();

  return staticverible.qrval;
}

class TempAPIs {
  final String apiUrl = staticverible.temqr + "/QRcheck.aspx/GetData";

  Future<List<Temp>> fetchTemp(
      BuildContext context, String url, VoidCallback onDismiss) async {
    String qrval1 = getQrValue(url);

    try {
      plaesewaitmassage(context);
      final Map<String, dynamic> requestBody = {"qrvalue": qrval1};
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);
          if (dataMap['statuscode'] == "1") {
            String message = dataMap['message'];
            int statusCode = int.parse(dataMap['statuscode']);
            staticverible.statuscode = statusCode;
            Temp temp = Temp(tempurl: message, status: statusCode);
            Navigator.of(context).pop();
            return [temp];
          } else if (dataMap['statuscode'] == "2") {
            String errorMessage = dataMap['message'];
            Navigator.of(context).pop();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              title: '',
              text: errorMessage,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                onDismiss();
              },
            );
          }
        } else {
          throw Exception('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        Navigator.of(context).pop();
        throw Exception('Failed to load QR Scan');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      Navigator.of(context).pop();
      throw Exception('Failed to load QR Scan: $e');
    }

    return [];
  }
}

class Login {
  final String username;
  final String password;
  final String tempmass;
  int status;

  Login({
    required this.username,
    required this.password,
    required this.tempmass,
    required this.status,
  });
}

// Registered Mail
class Tempmail {
  final String tempurl;

  Tempmail({required this.tempurl});
}

class RegisteredAPIs {
  final String regiApis =
      staticverible.temqr + '/profilestatus.aspx/checkuserstatus';

  Future<Tempmail> fetchRegisteredMail(String registeredMail) async {
    try {
      final Map<String, dynamic> requestBody = {"emailid": registeredMail};
      final response = await http.post(
        Uri.parse(regiApis),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);

          String message = dataMap['message'];
          return Tempmail(tempurl: message);
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load Registered Mail. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('Failed to load Registered Mail: $e');
    }
  }
}

// Forget Password
class Tempforget {
  final String tempmass;

  Tempforget({required this.tempmass});
}

class Forgetapis {
  final String forgetApis =
      staticverible.temqr + '/forgetpassword.aspx/forgotpassword';

  Future<Tempforget> Fetchforget(String userid, String email) async {
    try {
      final Map<String, dynamic> requestBody = {
        "userid": userid,
        'emailid': email
      };
      final response = await http.post(
        Uri.parse(forgetApis),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);

          String message = dataMap['message'];
          return Tempforget(tempmass: message);
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load Forget Password HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('Failed to load Forget Password: $e');
    }
  }
}

String getQrValue1(String url) {
  Uri uri = Uri.parse(url);

  String? qrValue = uri.queryParameters['ID'];

  return qrValue ?? '';
}

Future<String> UploadFilesData(
  BuildContext context,
  String qrcodevalue,
  String productname,
  String weavername,
  String? imagePath,
  String? compressedVideoPath,
  String deviceid,
  String dimision,
  String dyestatus,
  String naturedays,
  String weavertype,
  String yerntype,
  String yarncount,
  String loomtype,
) async {
  String responseMessage = "";

  dimision = dimision.trim().isEmpty || dimision.trim() == ''
      ? 'ALL'
      : dimision.trim();
  dyestatus = dyestatus.trim().isEmpty || dyestatus.trim() == ''
      ? 'ALL'
      : dyestatus.trim();
  naturedays = naturedays.trim().isEmpty || naturedays.trim() == ''
      ? 'ALL'
      : naturedays.trim();
  weavertype = weavertype.trim().isEmpty || weavertype.trim() == ''
      ? 'ALL'
      : weavertype.trim();
  yerntype = yerntype.trim().isEmpty || yerntype.trim() == ''
      ? 'ALL'
      : yerntype.trim();
  yarncount = yarncount.trim().isEmpty || yarncount.trim() == ''
      ? 'ALL'
      : yarncount.trim();
  loomtype = loomtype.trim().isEmpty || loomtype.trim() == ''
      ? 'ALL'
      : loomtype.trim();

  try {
    final String apiurl =
        staticverible.temqr + "/UploadService.asmx/UploadFiles";
    var request = http.MultipartRequest('POST', Uri.parse(apiurl));

    request.fields['product'] = productname;
    request.fields['weaver'] = weavername;
    request.fields['devicecode'] = deviceid;
    request.fields['qrcodevalue'] = staticverible.qrval;
    request.fields['dimension'] = dimision;
    request.fields['dyeStatus'] = dyestatus;
    request.fields['nature_dye'] = naturedays;
    request.fields['weavetype'] = weavertype;
    request.fields['yarncount'] = yarncount;
    request.fields['yarntype'] = yerntype;
    request.fields['loomtype'] = loomtype;

    print(request.toString());
    if (compressedVideoPath != null) {
      var videoFile =
          await http.MultipartFile.fromPath('video', compressedVideoPath);
      request.files.add(videoFile);
    }

    if (imagePath != null) {
      var imageFile = await http.MultipartFile.fromPath('image', imagePath);
      request.files.add(imageFile);
    }

    var streamedResponse = await request.send();
    print(request.toString());
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final document = xml.XmlDocument.parse(responseBody);
      final root = document.rootElement;

      if (root.name.local == 'string') {
        String message = root.text.trim();
        Map<String, dynamic> jsonResponse = json.decode(message);
        if (jsonResponse.containsKey("message")) {
          responseMessage = jsonResponse["message"];
          if (responseMessage == "Data Added Successfully") {
            showMessageDialog(context, responseMessage);
            if (imagePath != null) {
              deleteFile(imagePath);
            }
            if (compressedVideoPath != null) {
              deleteFileOrDirectory(compressedVideoPath, compressedVideoPath);
            }
          }
        }
      } else {
        throw FormatException('Unexpected format for response');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
      Navigator.of(context).pop();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Bottom_Screen()));
      throw http.ClientException(
          'Failed to load UploadFiles HTTP Status Code: ${response.statusCode}');
    }
  } catch (e) {
    List<String?> nullFieldNames = [];
    if (imagePath == null) {
      nullFieldNames.add('imagePath');
    }
    if (compressedVideoPath == null) {
      nullFieldNames.add('compressedVideoPath');
    }
    await UploadFilelogs(nullFieldNames, '$e');
    Navigator.of(context).pop();
  }
  return responseMessage;
}

Future<void> UploadFilelogs(
    List<String?>? nullFieldNames, String? message) async {
  try {
    File? errorLog = await initializeErrorlogs();
    if (errorLog != null) {
      IOSink sink = errorLog.openWrite(mode: FileMode.append);

      if (message != null) {
        if (nullFieldNames != null && nullFieldNames.isNotEmpty) {
          sink.write('Null fields: ${nullFieldNames.join(', ')}\n');
          sink.write('Message: $message\n');
          print(
              'Error logged: Null fields: ${nullFieldNames.join(', ')} - Message: $message');
        } else {
          sink.write('Null fields: None\n');
          sink.write('Message: $message\n');
          print('Error logged: Null fields: None - Message: $message');
        }
      } else {
        if (nullFieldNames != null && nullFieldNames.isNotEmpty) {
          sink.write('Null fields: ${nullFieldNames.join(', ')}\n');
          sink.write('Message: Message is null\n');
          print(
              'Error logged: Null fields: ${nullFieldNames.join(', ')} - Message: Message is null');
        } else {
          sink.write('Null fields: None\n');
          sink.write('Message: Message is null\n');
          print('Error logged: Null fields: None - Message: Message is null');
        }
      }

      // Close the file
      await sink.flush();
      await sink.close();
    } else {
      print('Error log initialization failed. Cannot log error: $message');
    }
  } catch (e) {
    print('Error logging error: $e');
  }
}

void deleteFile(String? filePath) {
  if (filePath != null) {
    try {
      File file = File(filePath);
      if (file.existsSync()) {
        file.deleteSync();
        print('Deleted file: $filePath');
      }
    } catch (e) {
      print('Failed to delete file: $filePath, Error: $e');
    }
  }
}

void deleteFileOrDirectory(String? specificPath, String defaultPath) {
  String pathToDelete = specificPath ?? defaultPath;

  try {
    if (FileSystemEntity.typeSync(pathToDelete) ==
        FileSystemEntityType.directory) {
      Directory directory = Directory(pathToDelete);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
        print('Deleted directory and its contents: $pathToDelete');
      } else {
        print('Directory does not exist: $pathToDelete');
      }
    } else if (FileSystemEntity.typeSync(pathToDelete) ==
        FileSystemEntityType.file) {
      File file = File(pathToDelete);
      if (file.existsSync()) {
        file.deleteSync();
        print('Deleted file: $pathToDelete');
      } else {
        print('File does not exist: $pathToDelete');
      }
    } else {
      print('Path does not exist: $pathToDelete');
    }
  } catch (e) {
    print('Failed to delete: $pathToDelete, Error: $e');
  }
}

Future<void> insertData(
  BuildContext context,
  String selectedState,
  String selectedDistrict,
  String selectedDepartment,
  String selecttype,
  String selectrole,
  TextEditingController firstcontroller,
  TextEditingController lastcontroller,
  String selectedGender,
  TextEditingController datecontroller,
  TextEditingController emailcontroller,
  TextEditingController mobilecontroller,
  TextEditingController orgnazationcontroller,
  String selectdoc,
  String selectedVillage,
  String? imageFile,
  TextEditingController weaverid,
) async {
  try {
    final String apiurl = staticverible.temqr + "/register.asmx/RegisterUser";
    var request = http.MultipartRequest('POST', Uri.parse(apiurl));

    request.fields['state'] = selectedState;
    request.fields['district'] = selectedDistrict;
    request.fields['department'] = selectedDepartment;
    request.fields['type'] = selecttype;
    request.fields['role'] = selectrole;
    request.fields['firstname'] = firstcontroller.text;
    request.fields['lastname'] = lastcontroller.text;
    request.fields['gender'] = selectedGender;
    request.fields['dob'] = datecontroller.text;
    request.fields['email'] = emailcontroller.text;
    request.fields['mobileno'] = mobilecontroller.text;
    request.fields['organization'] = orgnazationcontroller.text;
    request.fields['documentname'] = selectdoc;
    request.fields['documentno'] = imageFile ?? '';
    request.fields['city'] = selectedVillage;
    request.fields['weaverid'] = weaverid.text;
    print('Request Payload: ${request.fields}');
    final response = await request.send();
    if (response.statusCode == 200) {
      final dynamic responseData = await response.stream.bytesToString();
      print('Response Body: $responseData');

      final document = xml.XmlDocument.parse(responseData);
      var stringNode = document.findAllElements('string').first;
      var jsonString = stringNode.text;

      // Parse JSON
      Map<String, dynamic> dataMap = json.decode(jsonString);
      String message = dataMap['message'];
      if (message ==
          "User Added SuccessFully. Link to check User Status is sent to Your Registered Email ID") {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Registered Mail",
          text: message,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            orgnazationcontroller.clear();
            lastcontroller.clear();
            firstcontroller.clear();
            datecontroller.clear();
            emailcontroller.clear();
            mobilecontroller.clear();
            weaverid.clear();
          },
        );
      } else {
        showMessageDialog(context, message);
        Navigator.of(context).pop();
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      throw http.ClientException('Failed to load: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    logError('$e');
    Navigator.of(context).pop();
  }
}

class Temporg {
  final List<String> orgNames;

  Temporg({required this.orgNames});
}

class TempOrgAPIs {
  final String OrgApis =
      staticverible.temqr + "/organizationmaster.aspx/GetorgData";

  Future<List<String>> organizationapi(
      String state1, String district, String department, String type) async {
    try {
      final Map<String, dynamic> requestBody = {
        "state": state1,
        'district': district,
        'department': department,
        'type': type
      };

      final response = await http.post(
        Uri.parse(OrgApis),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);
          final List<dynamic> orgArray = dataMap['orgArray'];
          final List<String> orgNames =
              orgArray.map((org) => org as String).toList();

          return orgNames;
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load Organization HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('Failed to load Organization: $e');
    }
  }
}

class TempWearver {
  final List<String> wearverNames;

  TempWearver({required this.wearverNames});
}

class TempWearverAPIs {
  final String WearverApis =
      staticverible.temqr + "/weavermaster.aspx/GetweaverData";

  Future<List<String>> Fetchwearver(BuildContext context) async {
    try {
      final Map<String, dynamic> requestBody = {
        "state": staticverible.state,
        'district': staticverible.distric,
        'department': staticverible.department,
        'type': staticverible.type,
        'organization': staticverible.organization,
        'city': staticverible.city,
        'weaverid': staticverible.weaverid
      };

      final response = await http.post(
        Uri.parse(WearverApis),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);
          print('Data Map: $dataMap'); // Debugging line

          final dynamic weaverArray = dataMap['weaverArray'];
          print('Weaver Array: $weaverArray'); // Debugging line

          if (weaverArray == null) {
            print('The "weaverArray" field is null'); // Debugging line
            return []; // Return an empty list if "weaverArray" is null
          } else if (weaverArray is List<dynamic>) {
            final List<String> weaverNames =
                weaverArray.map((weaver) => weaver.toString()).toList();

            return weaverNames;
          } else {
            throw FormatException(
                'Expected a List<dynamic> for "weaverArray", but got ${weaverArray.runtimeType}');
          }
        } else {
          throw FormatException(
              'Expected "d" to be a String, but got ${responseData['d'].runtimeType}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load Weaver HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e'); // Ensure logError method is defined
      throw Exception('Failed to load Weaver: $e');
    }
  }
}

// // get organazation
class Tempgetorg {
  final List<String> orgNames;

  Tempgetorg({required this.orgNames});
}

class TempgetOrgAPIs {
  final String getOrgApis =
      staticverible.temqr + "/organizationmaster.aspx/GetorgData";

  Future<List<String>> getorganizationapi() async {
    try {
      final Map<String, dynamic> requestBody = {
        "state": staticverible.state,
        "district": staticverible.distric,
        "department": staticverible.department,
        "type": staticverible.type,
        "city": staticverible.city
      };

      final response = await http.post(
        Uri.parse(getOrgApis),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData != null && responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);
          final List<dynamic> orgArray = dataMap['orgArray'];
          final List<String> orgNames =
              orgArray.map((org) => org as String).toList();

          return orgNames;
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load Organization. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('Failed to load Organization: $e');
    }
  }
}

// Login
class login {
  final String tempurl;
  int status;

  login({required this.tempurl, required this.status});
}

class LoginAPIs {
  final String logUrl = "${staticverible.tempip}" + '/login.aspx/CheckLoginApp';

  LoginAPIs() {
    print(staticverible.tempip);
    print(logUrl);
  }
  Future<Login> fetchLogin(
      BuildContext context, String username, String password) async {
    try {
      final Map<String, dynamic> requestBody = {
        "username": username,
        "password": password,
        "version": appv
      };

      final response = await http.post(
        Uri.parse(logUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        final dynamic responseDataD = responseData['d'];

        if (responseDataD != null && responseDataD is String) {
          final Map<String, dynamic> dataMap = json.decode(responseDataD);

          if (dataMap['statuscode'] == "1") {
            String message = dataMap['message'].toString();
            int statusCode = int.parse(dataMap['statuscode']);
            staticverible.username = dataMap['userid'].toString();
            staticverible.firstlogin = dataMap['first_login'].toString();
            staticverible.weaverid = dataMap['weaverid'].toString();
            staticverible.state = dataMap['state'].toString();
            staticverible.distric = dataMap['district'].toString();
            staticverible.department = dataMap['department'].toString();
            staticverible.type = dataMap['type'].toString();
            staticverible.city = dataMap['city'].toString();
            staticverible.rolename = dataMap['role'].toString();
            staticverible.organization = dataMap['organization'].toString();
            staticverible.fistname = dataMap['firstname'].toString();
            staticverible.lastname = dataMap['lastname'].toString();
            staticverible.gender = dataMap['gender'].toString();
            staticverible.dateofbirth = dataMap['dob'].toString();
            staticverible.email = dataMap['email'].toString();
            staticverible.mobileno = dataMap['contactno'].toString();

            return Login(
              username: username,
              password: password,
              tempmass: message,
              status: statusCode,
            );
          } else if (dataMap['statuscode'] == '3') {
            String message = dataMap['message'].toString();

            return Login(
              username: username,
              password: password,
              tempmass: message,
              status: 3,
            );
          } else if (dataMap['statuscode'] == "0") {
            String message = dataMap['message'].toString();
            int statusCode = 0;

            // Assigning static variables
            staticverible.username = dataMap['userid'].toString();
            staticverible.state = dataMap['state'].toString();
            staticverible.distric = dataMap['district'].toString();
            staticverible.department = dataMap['department'].toString();
            staticverible.type = dataMap['type'].toString();
            staticverible.rolename = dataMap['role'].toString();
            staticverible.organization = dataMap['organization'].toString();
            staticverible.fistname = dataMap['firstname'].toString();
            staticverible.lastname = dataMap['lastname'].toString();
            staticverible.email = dataMap['email'].toString();
            staticverible.city = dataMap['city'].toString();
            staticverible.firstlogin = dataMap['first_login'].toString();

            return Login(
              username: username,
              password: password,
              tempmass: message,
              status: statusCode,
            );
          } else {
            String errorMessage = dataMap['message'].toString();
            if (errorMessage == 'Invalid UserId or Password.') {
              showMessageDialog(context, errorMessage);
            }
            print(errorMessage);
            throw Exception(errorMessage);
          }
        } else {
          throw Exception('Unexpected data format for "d"');
        }
      } else {
        print('${response.statusCode}');
        print('${response.body}');
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('$e');
    }
  }
}

// Reset Password
class ResetPassAPIs {
  final String resetUrl = "${staticverible.tempip}/firstlogin.aspx/Setpassword";

  Future<void> updatePassword(
      BuildContext context, String username, String newPassword) async {
    try {
      final Map<String, dynamic> requestBody = {
        "userid": username,
        "password": newPassword
      };

      final response = await http.post(
        Uri.parse(resetUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        final dynamic responseDataD = responseData['d'];

        if (responseDataD != null && responseDataD is String) {
          final Map<String, dynamic> dataMap = json.decode(responseDataD);
          String message = dataMap['message'] ?? 'Unknown error occurred';

          if (message ==
              "Password successfully changed. You can now access your account.") {
            Navigator.of(context).pop();
            QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: "Password successfully updated",
                text: message,
                onConfirmBtnTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login_Screen(),
                    ),
                  );
                });
          } else {
            print('Error: $message');
            throw Exception(message);
          }
        } else {
          throw Exception('Invalid response format.');
        }
      } else {
        print('Failed to reset password: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to reset password: ${response.statusCode}');
      }
    } catch (e) {
      print('Error resetting password: $e');
      logError('Error resetting password: $e');
      throw Exception('Error resetting password: $e');
    }
  }
}

// get product
class tempProduct {
  final List<String> productName;

  tempProduct({required this.productName});
}

class Tempgetproduct {
  final String getproductApis =
      staticverible.temqr + "/productmaster.aspx/getproductdata";

  Future<List<String>> getproductapi(BuildContext context) async {
    try {
      final Map<String, dynamic> requestBody = {
        "state": staticverible.state,
        "productname": "",
      };

      final response = await http.post(
        Uri.parse(getproductApis),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData != null && responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);
          final List<dynamic> productArray = dataMap['prdArray'];
          final List<String> productnames =
              productArray.map((product) => product as String).toList();

          return productnames;
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load product. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('Failed to load product: $e');
    }
  }
}

// Upload service start
Future<void> uploadservicedata({
  required BuildContext context,
  required String qrcodevalue,
  required DateTime startdate,
  required double latitude,
  required double longitude,
}) async {
  try {
    final String devicesohApis =
        staticverible.temqr + '/UploadService.asmx/ADDData';

    var request = http.MultipartRequest('POST', Uri.parse(devicesohApis));

    request.fields['qrcodevalue'] = staticverible.qrval;
    request.fields['startdate'] = startdate.toString();
    request.fields['state'] = staticverible.state;
    request.fields['district'] = staticverible.distric;
    request.fields['department'] = staticverible.department;
    request.fields['city'] = staticverible.city;
    request.fields['type'] = staticverible.type;
    request.fields['organization'] = staticverible.organization;
    request.fields['createdby'] = staticverible.username;
    request.fields['longitude'] = longitude.toString();
    request.fields['latitude'] = latitude.toString();

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final document = xml.XmlDocument.parse(responseBody);
      final root = document.rootElement;

      if (root.name.local == 'string') {
        String message = root.text.trim();
        Map<String, dynamic> jsonResponse = json.decode(message);
        if (jsonResponse.containsKey("message")) {
          String responseMessage = jsonResponse["message"];
          if (responseMessage == "Data Added Successfully") {
            showMessageDialog(context, responseMessage);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddProduct_Screen(
                          qrVal: staticverible.qrval,
                          startDate: startdate,
                          qrtext: staticverible.qrval,
                        )));
          } else {
            showRegisteredMessage(context, responseMessage);
            Navigator.of(context).pop();
          }
        }
      } else {
        throw FormatException('Unexpected format for response');
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw http.ClientException(
          'Failed to load Upload data Start File HTTP Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    logError('$e');
  }
}

class Getprodata {
  final List<String> dymesion;

  Getprodata({required this.dymesion});
}

class DymesionApis {
  final String dymesionaurl =
      staticverible.temqr + "/productspecificationmaster.aspx/GetprdData";

  Future<List<Map<String, String>>> dymesionproduct(
      String productname, BuildContext context) async {
    try {
      final Map<String, dynamic> requestBody = {
        "state": staticverible.state,
        'productname': productname,
      };
      final response = await http.post(
        Uri.parse(dymesionaurl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData['d'] is String) {
          final List<dynamic> decodedList = json.decode(responseData['d']);
          final List<Map<String, String>> innerDataList =
              decodedList.map((item) {
            if (item is Map<String, dynamic>) {
              return {
                'type': item['type'] as String,
                'value': item['value'] as String,
              };
            } else {
              throw FormatException(
                  'Unexpected data format for item in response');
            }
          }).toList();

          return innerDataList;
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');

        throw http.ClientException(
            'Failed to load Weaver HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      logError('$e');
      throw Exception('Failed to load get product data: $e');
    }
  }
}

class yarncount {
  String wrape;
  String wrapecount;
  String weft;
  String weftcount;
  String extraweft;
  String extraweftcount;
  yarncount(
      {required this.wrape,
      required this.wrapecount,
      required this.weft,
      required this.weftcount,
      required this.extraweft,
      required this.extraweftcount});
}

class ProductView {
  String status;
  String state;
  String district;
  String department;
  String type;
  String organazation;
  String city;
  String createdBy;
  String qrcodeval;
  String image;
  String video;
  String wearverName;
  String deviceid;
  String qrtextfinal;
  String qrimage;
  String productname;
  String weavetype;
  final yarncount Yarncount;
  String dyestatus;
  String nature_dye;
  String yarntype;
  String loomtype;
  String dimension;

  ProductView({
    required this.status,
    required this.state,
    required this.district,
    required this.department,
    required this.type,
    required this.organazation,
    required this.city,
    required this.createdBy,
    required this.qrcodeval,
    required this.image,
    required this.video,
    required this.wearverName,
    required this.deviceid,
    required this.qrtextfinal,
    required this.qrimage,
    required this.productname,
    required this.weavetype,
    required this.dimension,
    required this.dyestatus,
    required this.loomtype,
    required this.nature_dye,
    required this.Yarncount,
    required this.yarntype,
  });
}

List<ProductView> parseXmlResponse(xml.XmlDocument responseData) {
  List<ProductView> productviewStatus = [];
  final jsonString = responseData.rootElement.text;

  dynamic jsonData = json.decode(jsonString);

  yarncount parseYarnCount(String yarnCountString) {
    final values = yarnCountString.split(',');
    return yarncount(
      wrape: values.length > 0 ? values[0] : "",
      wrapecount: values.length > 1 ? values[1] : "",
      weft: values.length > 2 ? values[2] : "",
      weftcount: values.length > 3 ? values[3] : "",
      extraweft: values.length > 4 ? values[4] : "",
      extraweftcount: values.length > 5 ? values[5] : "",
    );
  }

  ProductView parseProductView(dynamic item) {
    String yarnCountString = item['yarncount'] ?? "";
    return ProductView(
      status: item['status'] ?? "",
      state: item['state'] ?? "",
      district: item['district'] ?? "",
      department: item['department'] ?? "",
      type: item['type'] ?? "",
      organazation: item['organization'] ?? "",
      city: item['city'] ?? "",
      createdBy: item['createdby'] ?? "",
      qrcodeval: item['qrcodevalue'] ?? "",
      image: item['image'] ?? "",
      video: item['video'] ?? "",
      wearverName: item['weavername'] ?? "",
      deviceid: item['devicecode'] ?? "",
      qrtextfinal: item['qrtextfinal'] ?? "",
      qrimage: item['qrimage'] ?? "",
      productname: item['productname'] ?? "",
      weavetype: item['weavetype'] ?? "",
      Yarncount: parseYarnCount(yarnCountString),
      dyestatus: item['dyestatus'] ?? "",
      nature_dye: item['nature_dye'] ?? "",
      yarntype: item['yarntype'] ?? "",
      loomtype: item['loomtype'] ?? "",
      dimension: item['dimension'] ?? "",
    );
  }

  if (jsonData is List) {
    for (final item in jsonData) {
      final productview = parseProductView(item);
      productviewStatus.add(productview);
    }
  } else if (jsonData is Map) {
    final productview = parseProductView(jsonData);
    productviewStatus.add(productview);
  } else {
    print("Unknown data format");
  }

  return productviewStatus;
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

Future<List<ProductView>> GetProductwiseData(BuildContext context,
    DateTime fromDt, DateTime toDt, String wearverName) async {
  final String apiUrl =
      staticverible.temqr + "/UploadService.asmx/GetprdDatauserwise";

  if (fromDt.isBefore(DateTime(1753, 1, 1)) ||
      toDt.isAfter(DateTime(9999, 12, 31))) {
    throw Exception('Date range is out of valid SQL DateTime range.');
  }

  // Format the dates
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  String formattedFromDate = dateFormat.format(fromDt);
  String formattedToDate = dateFormat.format(toDt);

  String createdby;
  if (staticverible.rolename == 'Super Admin' ||
      staticverible.rolename == 'Super User' ||
      staticverible.rolename == 'Manager' ||
      staticverible.rolename == 'Admin') {
    createdby = "ALL";
  } else {
    createdby = staticverible.username;
  }

  final Map<String, String> queryParams = {
    'state': staticverible.state,
    'district': staticverible.distric,
    'department': staticverible.department,
    'city': staticverible.city,
    'type': staticverible.type,
    'organization': staticverible.organization,
    'createdby': createdby,
    'fromdate': formattedFromDate,
    'todate': formattedToDate,
    'weavername': wearverName,
  };

  final Uri uri = Uri.parse(apiUrl);

  try {
    http.Response response = await http.post(uri, body: queryParams);

    if (response.statusCode == 200) {
      xml.XmlDocument responseData = xml.XmlDocument.parse(response.body);

      // Check if response contains "No Data Found"
      if (responseData.rootElement.text == '{"message":"No Data Found"}') {
        return []; // Return empty list indicating no data found
      } else {
        List<ProductView> parsedData = parseXmlResponse(responseData);
        return parsedData;
      }
    } else {
      print("Request failed with status: ${response.statusCode}");
      print("Request failed with status: ${response.body}");
      logError('${response.statusCode}' + '' + '${response.body}');
      return []; // Return empty list on request failure
    }
  } catch (e) {
    print('Error occurred: $e');
    logError('$e');
    return []; // Return empty list on error
  }
}

// contact us apis
Future<void> contactus(
    BuildContext context,
    TextEditingController name,
    TextEditingController email,
    TextEditingController mobileno,
    String suggestiontype,
    TextEditingController message,
    String? docfile,
    TextEditingController doccontroller) async {
  try {
    final String apiurl =
        staticverible.temqr + "/contactus.asmx/AddContactUsDetails";
    var request = http.MultipartRequest('POST', Uri.parse(apiurl));

    request.fields['Name'] = name.text;
    request.fields['Email'] = email.text;
    request.fields['MobileNo'] = mobileno.text;
    request.fields['Suggestion'] = suggestiontype;
    request.fields['Message'] = message.text;

    if (docfile != null && docfile.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('File', docfile));
    }
    print('Request Payload: ${request.fields}');
    final response = await request.send();
    if (response.statusCode == 200) {
      final dynamic responseData = await response.stream.bytesToString();
      print('Response Body: $responseData');

      final document = xml.XmlDocument.parse(responseData);
      var stringNode = document.findAllElements('string').first;
      var jsonString = stringNode.text;

      Map<String, dynamic> dataMap = json.decode(jsonString);
      int statuscode = dataMap['status'];
      String responsemassage = dataMap['message'];
      if (statuscode == 1) {
        Navigator.of(context).pop();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Congratulations",
          text: responsemassage,
          onConfirmBtnTap: () {
            Navigator.of(context).pop();
            name.clear();
            email.clear();
            mobileno.clear();
            message.clear();
            doccontroller.clear();
          },
        );
      } else {
        showMessageDialog(context, message);
        Navigator.of(context).pop();
      }
    } else {
      print('HTTP Error: ${response.statusCode}');
      throw http.ClientException('Failed to load: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    logError('$e');
    Navigator.of(context).pop();
  }
}

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'MST_URL';
  static const String dbCheckKey = 'db_check_done';

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  static Future<Database> initializeDatabase() async {
    Directory? externalDirectory = await getAndroidMediaDirectory();
    if (externalDirectory == null) {
      throw Exception('External storage directory not found');
    }

    final String folderPath = join(externalDirectory.path, 'Database');
    final Directory folder = Directory(folderPath);
    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    final String oldDbPath = join(folder.path, 'ssbi.db');
    final String newDbPath = join(folder.path, 'ssbi_v2.db');

    // Check if the database check has been done before
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool dbCheckDone = prefs.getBool(dbCheckKey) ?? false;

    if (!dbCheckDone) {
      // Perform the check and rename operation only once
      if (File(oldDbPath).existsSync()) {
        // Old database exists, do not rename it, just mark the check done
        await prefs.setBool(dbCheckKey, true);
      }
    }

    // Always use newDbPath for the app
    return await openDatabase(
      newDbPath,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _upgradeDb,
    );
  }

  static void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        name TEXT,
        url TEXT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  static Future<void> _upgradeDb(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Check if the columns already exist
      var tableInfo = await db.rawQuery('PRAGMA table_info($tableName);');
      bool hasUsernameColumn =
          tableInfo.any((column) => column['name'] == 'username');
      bool hasPasswordColumn =
          tableInfo.any((column) => column['name'] == 'password');

      // Add the columns only if they do not exist
      if (!hasUsernameColumn) {
        await db.execute('''
        ALTER TABLE $tableName ADD COLUMN username TEXT;
      ''');
      }
      if (!hasPasswordColumn) {
        await db.execute('''
        ALTER TABLE $tableName ADD COLUMN password TEXT;
      ''');
      }
    }
  }

  static Future<int> insertUrl({
    required String url,
    required String username,
    required String password,
  }) async {
    final Database db = await database;

    return await db.insert(tableName, {
      'url': url,
      'username': username,
      'password': password,
    });
  }

  static Future<int> updateUrl({
    required int id,
    required String url,
    required String username,
    required String password,
  }) async {
    final Database db = await database;

    return await db.update(
      tableName,
      {
        'url': url,
        'username': username,
        'password': password,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAll() async {
    final Database db = await database;
    await db.delete(tableName);
  }

  static Future<void> updateCredentialsToNull() async {
    final Database db = await database;
    await db.update(
      tableName,
      {
        'username': null,
        'password': null,
      },
      where: '1=1',
    );
  }

  static Future<List<Map<String, dynamic>>?> getUrls() async {
    final Database db = await database;
    List<Map<String, dynamic>>? urls;

    try {
      urls = await db.query(tableName);
    } catch (e) {
      print('Error retrieving data: $e');
      logError('$e');
    }

    return urls;
  }

  static Future<void> clearDatabase() async {
    Directory? externalDirectory = await getAndroidMediaDirectory();
    if (externalDirectory != null) {
      final String folderPath = join(externalDirectory.path, 'Database');
      final Directory folder = Directory(folderPath);
      if (folder.existsSync()) {
        folder.deleteSync(recursive: true);
      }
    }
  }
}

class ManagePassword {
  final String manageUrl =
      staticverible.temqr + "/managepassword.aspx/ChangePassword";

  Future<void> managePasswordApi(BuildContext context, String currentPass,
      String newPass, String confirmPass) async {
    try {
      final Map<String, dynamic> requestBody = {
        "userid": staticverible.username,
        "currentpassword": currentPass,
        "newpassowrd": newPass,
        "confirmpassword": confirmPass
      };

      final response = await http.post(
        Uri.parse(manageUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData['d'] is String) {
          final Map<String, dynamic> dataMap = json.decode(responseData['d']);
          String message = dataMap['message'];
          if (message == 'Password changed successfully.') {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: message,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                DatabaseHelper.updateCredentialsToNull();
                Navigator.of(context).pop();
                loginscreen(context);
              },
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: message,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
              },
            );
          }
        } else {
          throw FormatException('Unexpected data format for "d"');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw http.ClientException(
            'Failed to load Manage Password. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      logError("Manage Password error $e");
    }
  }
}

void loginscreen(BuildContext context) {
  try {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login_Screen()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    print('Error navigating to login screen: $e');
  }
}

class FeedbackService {
  final String feedbackUrl =
      "${staticverible.tempip}/productdetailslist.aspx/GetFeedback";

  Future<Map<String, String>> sendFeedback(
      BuildContext context, String qrTextVal) async {
    try {
      final Map<String, dynamic> requestBody = {'QRValue': qrTextVal};
      final response = await http.post(
        Uri.parse(feedbackUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Debug log to ensure response is received
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract the 'd' field from the response data
        final dynamic dField = responseData['d'];

        List<dynamic> data = [];
        String message = '';

        if (dField is String) {
          try {
            final decoded = json.decode(dField);
            if (decoded is List) {
              data = decoded;
            } else if (decoded is Map<String, dynamic>) {
              message = decoded['message'] as String? ?? 'No message available';
            } else {
              print('Unexpected format in dField string');
              return {
                'feedback': 'Unexpected format in dField string',
                'emoji': '🤔',
                'comment': '',
                'message': ''
              };
            }
          } catch (e) {
            print('Error decoding dField string: $e');
            return {
              'feedback': 'Error decoding data',
              'emoji': '🤔',
              'comment': '',
              'message': ''
            };
          }
        } else if (dField is List) {
          data = dField;
        } else if (dField is Map<String, dynamic>) {
          message = dField['message'] as String? ?? 'No feedback available';
        } else {
          print('Unexpected format for d field');
          return {
            'feedback': 'Unexpected response format',
            'emoji': '🤔',
            'comment': '',
            'message': ''
          };
        }

        if (data.isNotEmpty) {
          final feedbackItem = data[0] as Map<String, dynamic>;

          final feedback = feedbackItem['feedback'] as String? ?? 'No feedback';
          final comment = feedbackItem['comment'] as String? ?? '';
          String emoji;

          switch (feedback) {
            case 'Good':
              emoji = '😊'; // Happy face emoji
              break;
            case 'Poor':
              emoji = '😞'; // Sad face emoji
              break;
            case 'Very Poor':
              emoji = '😠'; // Angry face emoji
              break;
            case 'Okay':
              emoji = '😐'; // Neutral face emoji
              break;
            case 'Excellent':
              emoji = '😁'; // Grinning face emoji
              break;
            default:
              emoji = '🤔'; // Thinking face emoji for unknown feedback
          }

          return {
            'QRValue': qrTextVal,
            'feedback': feedback,
            'comment': comment,
            'emoji': emoji,
            'message': message
          };
        } else {
          print('No feedback available');
          return {
            'feedback': 'No feedback available',
            'emoji': '🤔',
            'comment': '',
            'message': message
          };
        }
      } else {
        print('Failed to submit feedback: ${response.statusCode}');
        return {
          'feedback': 'Failed to submit feedback',
          'emoji': '🤔',
          'comment': '',
          'message': ''
        };
      }
    } catch (e) {
      print("Error feedback: $e");
      logError('Error feedback: $e');
      return {
        'feedback': 'Error occurred',
        'emoji': '🤔',
        'comment': '',
        'message': ''
      };
    }
  }
}

//  Notication apis
class Notificationclass {
  final List<Notification> notifications;

  Notificationclass({required this.notifications});

  factory Notificationclass.fromJson(Map<String, dynamic> json) {
    var list = json['notifications'] as List;
    List<Notification> notificationList =
        list.map((i) => Notification.fromJson(i)).toList();

    return Notificationclass(notifications: notificationList);
  }
}

class Notification {
  final String title;
  final String message;
  final DateTime date;
  final String id;
  final int isread;
  final String qrvalue;

  Notification({
    required this.title,
    required this.message,
    required this.date,
    required this.id,
    required this.isread,
    required this.qrvalue,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: DateTime.parse(json['createddate'] ?? '1970-01-01T00:00:00Z'),
      id: json['id'] ?? '',
      isread: int.tryParse(json["isread"]?.toString() ?? '0') ?? 0,
      qrvalue: json['qrcodevalue'] ?? '',
    );
  }

  String getFormattedDate() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date);
  }

  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class Notificationapis {
  final String notificationUrl =
      staticverible.temqr + '/productdetailslist.aspx/GetnotificationFeedback';

  Future<Notificationclass> fetchNotification(BuildContext context) async {
    try {
      final Map<String, dynamic> requestBody = {
        "userid": staticverible.username,
      };

      final response = await http.post(
        Uri.parse(notificationUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String dataString = responseData['d'];
        final List<dynamic> jsonList = jsonDecode(dataString);
        int notinumber = jsonList.length;
        print('Number of notifications: $notinumber');
        return Notificationclass.fromJson({'notifications': jsonList});
      } else {
        throw Exception(
            'Failed to load notification, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error notification: $e');
      logError('Error notification $e');
      throw Exception('Failed to load notification: $e');
    }
  }
}

class NotificationCount {
  final int count;

  NotificationCount({required this.count});

  factory NotificationCount.fromJson(Map<String, dynamic> json) {
    return NotificationCount(
      count: json['count'] ?? 0,
    );
  }
}

class Noticount {
  final String noticountUrl = staticverible.temqr +
      '/productdetailslist.aspx/GetnotificationFeedbackCount';

  Future<NotificationCount> fetchNoticount(BuildContext context) async {
    try {
      final Map<String, dynamic> requestBody = {
        "userid": staticverible.username,
      };
      final response = await http.post(
        Uri.parse(noticountUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String dataString = responseData['d'];
        final List<dynamic> jsonList = jsonDecode(dataString);
        if (jsonList.isNotEmpty) {
          final Map<String, dynamic> countMap = jsonList[0];
          int notificationCount = countMap['COUNT(*)'] ?? 0;
          print('Number of notifications: $notificationCount');
          return NotificationCount(count: notificationCount);
        } else {
          throw Exception('No data available in the response.');
        }
      } else {
        throw Exception(
            'Failed to load notification, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error notification count: $e');
      logError('Error notification count $e');
      throw Exception('Failed to load notification count: $e');
    }
  }
}

class Notificationcheck {
  final String notificationcheckUrl = staticverible.temqr +
      '/productdetailslist.aspx/UpdatenotificationFeedback';

  Future<void> fetchNotificationcheck(BuildContext context, String id) async {
    try {
      final Map<String, dynamic> requestBody = {"id": id};
      final response = await http.post(
        Uri.parse(notificationcheckUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Check if the response body contains 'Success' and handle it
        if (response.body.contains('Success')) {
          print('Server returned success message.');
          return;
        }

        // Proceed to parse the JSON data
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String dataString = responseData['d'];

        // Handle JSON decoding and type safety
        try {
          final List<dynamic> jsonList = jsonDecode(dataString);
          print(jsonList);
          return;
        } catch (e) {
          print('Error decoding JSON list: $e');
          logError('Error decoding JSON list: $e');
          throw Exception('Failed to decode JSON list: $e');
        }
      } else {
        throw Exception(
            'Failed to load notification check, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error notification check: $e');
      logError('Error notification check $e');
      throw Exception('Failed to load notification check: $e');
    }
  }

  void logError(String message) {
    // Implement logging logic here
    print('Error logged: $message');
  }
}

// Model for individual notifications
class NotificationDisplay {
  final String state;
  final String district;
  final String department;
  final String type;
  final String organization;
  final String image;
  final String video;
  final String city;

  NotificationDisplay({
    required this.state,
    required this.district,
    required this.department,
    required this.type,
    required this.organization,
    required this.image,
    required this.video,
    required this.city,
  });

  factory NotificationDisplay.fromJson(Map<String, dynamic> json) {
    return NotificationDisplay(
      state: json["state"] ?? "",
      district: json["district"] ?? "",
      department: json["department"] ?? "",
      type: json["type"] ?? "",
      organization: json["organization"] ?? "",
      image: json["image"] ?? "",
      video: json["video"] ?? "",
      city: json["city"] ?? "",
    );
  }
}

// Model for list of notifications
class NotificationDisplayRecord {
  final List<NotificationDisplay> notifications;

  NotificationDisplayRecord({required this.notifications});

  factory NotificationDisplayRecord.fromJson(Map<String, dynamic> json) {
    var list = json['notifications'] as List;
    List<NotificationDisplay> notificationList =
        list.map((i) => NotificationDisplay.fromJson(i)).toList();

    return NotificationDisplayRecord(notifications: notificationList);
  }
}

// Class for fetching notification data
class NotificationDisplayService {
  final String notiDisplayUrl = staticverible.temqr +
      '/productdetailslist.aspx/Getnotificationfeedbackqrcodewise';

  Future<NotificationDisplayRecord?> fetchNotificationDisplay(
      BuildContext context, String qrval) async {
    try {
      final Map<String, dynamic> requestBody = {"qrcodevalue": qrval};
      final response = await http.post(Uri.parse(notiDisplayUrl),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String dataString = responseData['d'];
        final List<dynamic> jsonList = jsonDecode(dataString);
        print(jsonList);
        return NotificationDisplayRecord.fromJson({'notifications': jsonList});
      } else {
        print('Failed to load notifications');
        return null;
      }
    } catch (e) {
      print("Error fetching notification display: $e");
      return null;
    }
  }
}
