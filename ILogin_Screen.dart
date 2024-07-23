import 'package:flutter/material.dart';
import 'package:nehhdc_app/Model_Screen/APIs_Screen.dart';
import 'package:nehhdc_app/Screen/Bottom_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Setting_Screen.dart';
import 'package:nehhdc_app/Setting_Screen/Static_Verible';
import 'package:nehhdc_app/Welcome_Screen/Firstlogin_Screen.dart';
import 'package:nehhdc_app/Welcome_Screen/Login_Screen.dart';

class LoginHandler {
  final BuildContext context;
  final TextEditingController userController;
  final TextEditingController passController;

  LoginHandler(this.context, this.userController, this.passController);

  Future<String> login(bool isAuto, bool remember) async {
    final String username = userController.text.trim();
    final String password = passController.text.trim();
    plaesewaitmassage(context);
    try {
      final LoginAPIs apiService = LoginAPIs();
      Login? tempData =
          await apiService.fetchLogin(context, username, password);

      Navigator.pop(context);

      if (tempData != '') {
        String responseMessage = tempData.tempmass;
        int statusCode = tempData.status;
        if (statusCode == 1) {
          if (!isAuto && remember) {
            List<Map<String, dynamic>>? existingUrls =
                await DatabaseHelper.getUrls();
            bool urlExists = existingUrls != null && existingUrls.isNotEmpty;

            if (urlExists) {
              int id = existingUrls.first['id'];
              await DatabaseHelper.updateUrl(
                id: id,
                url: existingUrls.first['url'],
                username: username,
                password: password,
              );
            }
          }
          staticverible.username = username;
          staticverible.password = password;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Bottom_Screen()),
          );
        } else if (statusCode == 0) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => First_Login()),
          );
        } else if (statusCode == 3) {
          showCustomAlert(context, responseMessage);
        } else {
          if (isAuto) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Login_Screen()),
            );
          } else {
            showMessageDialog(context, responseMessage);
          }
        }
        return responseMessage;
      } else {
        return "Login Failed";
      }
    } catch (e) {
      Navigator.pop(context);
      print(e);
      return e.toString();
    }
  }

  void showCustomAlert(BuildContext context, String responseMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          titlePadding: EdgeInsets.zero,
          title: Column(
            children: [
              Container(
                width: double.infinity,
                color: Color(ColorVal),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Version Update",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New version Available",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  responseMessage,
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
