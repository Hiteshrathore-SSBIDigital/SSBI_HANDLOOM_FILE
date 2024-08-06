import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  final String _languageCodeKey = 'languageCode';
  final String _countryCodeKey = 'countryCode';

  Future<void> saveLanguage(String languageCode, String countryCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, languageCode);
    await prefs.setString(_countryCodeKey, countryCode);
  }

  Future<Locale> getSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_languageCodeKey);
    String? countryCode = prefs.getString(_countryCodeKey);

    if (languageCode != null && countryCode != null) {
      return Locale(languageCode, countryCode);
    }
    // Default to English if no language is saved
    return Locale('en', 'US');
  }
}

class LocaleString extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        //ENGLISH LANGUAGE
        'en_US': {
          'Home': 'Home',
          'Product': 'Add Product',
          'View Product': 'Product Report',
          'Device': 'Device',
          'Language': 'Language',
          'Contact Us': 'Contact Us',
          'Manage Password': 'Manage Password',
          'Log out': 'Log out',
          'Name': 'Name',
          'Email': 'Email',
          'Mobile No': 'Mobile No',
          'Suggestion': 'Suggestion',
          'Message': 'Message',
          'Upload Document': 'Upload Document',
          'Captcha': 'Captcha',
          'Enter Captcha': 'Enter Captcha',
          'Current Password': 'Current Password',
          'New Password': 'New Password',
          'Confirm Password': 'Confirm Password',
          'State': 'State',
          'Districts': 'Districts',
          'Department': 'Department',
          'Type': 'Type',
          'City': 'City',
          'Role': 'Role',
          'Weaver Id': 'Weaver Id',
          'Organization': 'Organization',
          'First Name': 'First Name',
          'Last Name': 'Last Name',
          'Gender': 'Gender',
          'Date of birth': 'Date of birth',
          'Profile': "Profile",
          'QR value': 'QR value',
          'Weaver Name': 'Weaver Name',
          'Product Name': 'Product Name',
          'Dimension': 'Dimension',
          'Dyeing Status': 'Dyeing Status',
          'Nature of Dye': 'Nature of Dye',
          'Type of Weave': 'Type of Weave',
          'Type of Yarn': 'Type of Yarn',
          'Yarn Count': 'Yarn Count',
          'Type of Loom': 'Type of Loom',
          'Help': 'Help',
          'Call': 'Call',
          'Feedback': 'Feedback',
          'Menual Download': 'Menual Download',
          'Wrape': 'Wrape',
          'Weft': 'Weft',
          'Extra Weft': 'Extra Weft',
          'Wrape Count': 'Wrape',
          'Count': 'Count',
          'Weft Count': "Weft Count",
          'Extra Weft Count': "Weft Count",
          "Image": "Image",
          "Video": "Video"
        },
        //HINDI LANGUAGE
        'hi_IN': {
          'Home': 'होम',
          'Product': 'उत्पाद जोड़ें',
          'View Product': 'उत्पाद रिपोर्ट',
          'Device': 'उपकरण',
          'Language': 'भाषा चुने',
          'Contact Us': 'हमसे संपर्क करें',
          'Manage Password': 'पासवर्ड प्रबंधित करें',
          'Log out': 'लॉग आउट करें',
          'Name': 'नाम',
          'Email': 'ईमेल',
          'Mobile No': 'मोबाइल नंबर',
          'Suggestion': 'सुझाव',
          'Message': 'संदेश',
          'Upload Document': 'दस्तावेज़ अपलोड करें',
          'Captcha': 'कैप्चा',
          'Enter Captcha': 'केप्चा भरे',
          'Current Password': 'वर्तमान पासवर्ड',
          'New Password': 'नया पासवर्ड',
          'Confirm Password': 'पुष्टि पासवर्ड',
          'State': 'राज्य',
          'Districts': 'जिले',
          'Department': 'विभाग',
          'Type': 'प्रकार',
          'City': 'शहर',
          'Role': 'भूमिका',
          'Weaver Id': 'बुनकर आईडी',
          'Organization': 'संगठन',
          'First Name': 'पहला नाम',
          'Last Name': 'अंतिम नाम',
          'Gender': 'लिंग',
          'Date of birth': 'जन्म तिथि',
          'Profile': "प्रोफ़ाइल",
          'QR value': 'क्यूआर मान',
          'Weaver Name': 'बुनकर का नाम',
          'Product Name': 'उत्पाद का नाम ',
          'Dimension': 'आयाम',
          'Dyeing Status': 'रंगाई की स्थिति',
          'Nature of Dye': 'रंगाई की प्रकृति',
          'Type of Weave': 'बुनाई का प्रकार',
          'Type of Yarn': 'धागे का प्रकार',
          'Yarn Count': 'धागे की संख्या',
          'Type of Loom': 'करघे का प्रकार',
          'Help': 'मदद',
          'Call': 'कॉल',
          'Feedback': 'प्रतिक्रिया',
          'Menual Download': 'मैनुअल डाउनलोड',
          'Wrape': 'लपेटना',
          'Weft': 'बाना',
          'Extra Weft': 'अतिरिक्त बाना',
          'Count': 'गिनती करना',
          'Wrape Count': 'लपेटो गिनती',
          'Weft Count': "बाने की गिनती",
          'Extra Weft Count': "अतिरिक्त वेफ्ट गिनती",
          "Image": "छवि",
          "Video": "वीडियो"
        },
        // ASSAMESE LANGUAGE
        'as_IN': {
          'Home': 'গৃহ',
          'Product': 'প্ৰডাক্ট যোগ কৰক',
          'View Product': 'প্ৰডাক্ট ৰিপৰ্ট',
          'Device': 'ডিভাইচ',
          'Language': 'ভাষা',
          'Contact Us': 'আমাৰ সৈতে যোগাযোগ কৰক',
          'Manage Password': 'পাছৱৰ্ড ব্যৱস্থাপনা কৰক',
          'Log out': 'লগ আউট কৰক',
          'Name': 'নাম',
          'Email': 'ইমেইল',
          'Mobile No': 'মোবাইল নং',
          'Suggestion': 'পৰামৰ্শ',
          'Message': 'বাৰ্তা',
          'Upload Document': 'নথিপত্ৰ আপলোড কৰক',
          'Captcha': 'কেপচা',
          'Enter Captcha': 'কেপচা প্ৰৱেশ কৰক',
          'Current Password': 'বৰ্তমানৰ পাছৱৰ্ড',
          'New Password': 'নতুন পাছৱৰ্ড',
          'Confirm Password': 'পাছৱৰ্ড নিশ্চিত কৰক',
          'State': 'ৰাজ্য',
          'Districts': 'জিলাসমূহ',
          'Department': 'বিভাগ',
          'Type': 'প্ৰকাৰ',
          'City': 'চহৰ',
          'Role': 'ভূমিকা',
          'Weaver Id': 'ৱেভাৰ আইডি',
          'Organization': 'সংস্থা',
          'First Name': 'প্ৰথম নাম',
          'Last Name': 'উপাধি',
          'Gender': 'লিংগ',
          'Date of birth': 'জন্ম তাৰিখ',
          'Profile': "ৰূপৰেখা",
          'QR value': 'QR মান',
          'Weaver Name': 'শিপিনীৰ নাম',
          'Product Name': 'পণ্যৰ নাম',
          'Dimension': 'মাত্ৰা',
          'Dyeing Status': 'ৰং কৰা অৱস্থা',
          'Nature of Dye': 'ডাইৰ প্ৰকৃতি',
          'Type of Weave': 'বয়নৰ ধৰণ',
          'Type of Yarn': 'সূতাৰ প্ৰকাৰ',
          'Yarn Count': 'সূতাৰ সংখ্যা',
          'Type of Loom': 'তাঁতশালৰ ধৰণ',
          'Help': 'সহায়',
          'Call': 'কল',
          'Feedback': 'মতামত',
          'Menual Download': 'মেনুৱেল ডাউনলোড',
          'Wrape': 'ৰেপ কৰক',
          'Weft': 'ৱেফ্ট',
          'Extra Weft': 'অতিৰিক্ত ৱেফ্ট',
          'Count': 'হিচাপ কৰা',
          'Wrape Count': 'ৰেপ কাউণ্ট',
          'Weft Count': "ৱেফ্ট কাউণ্ট",
          'Extra Weft Count': "অতিৰিক্ত ৱেফ্ট কাউণ্ট",
          "Image": "ছৱি",
          "Video": "ভিডিঅ"
        }
      };
}
