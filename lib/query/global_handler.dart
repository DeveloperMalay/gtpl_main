import 'package:flutter/material.dart';
import 'package:gtpl/view/login/login.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './const.dart';

class GlobalHandler {
  static Future setCustomerNo(String token) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString("customer_no", token);
      prefs.setBool("is_loggedin", true);
    });
  }

  static Future setBroadbandNo(String token) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString("user_id", token);
      prefs.setBool("is_loggedin", true);
    });
  }

  // static Future setBroadbandNo(String token) async {
  //   await SharedPreferences.getInstance().then((prefs) {
  //     prefs.setString("user_id", token);
  //     prefs.setBool("is_loggedin", true);
  //   });
  // }

  static Future<String?> getCustomerNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("customer_no");
    print("token form gtpl ----->$token");
    return token;
  }

  static Future<String?> getBroadbandNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("user_id");

    return token;
  }

  // static Future<String?> geBroadbandNo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString("user_id");
  //   return token;
  // }

  static logout(BuildContext context) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  static Future<bool> checkLogedin() async {
    var prefs = await SharedPreferences.getInstance();
    var isLogedin = prefs.getBool("is_loggedin");
    return isLogedin ?? false;
  }

  static Future<Map<String, String>?> getHeaders() async {
    var customerNo = await getCustomerNo();
    return {
      "Accept": "application/json",
      'customer_no': customerNo ?? "",
      'Content-Type': 'application/x-www-form-urlencoded'
    };
  }

  static Future<http.Response> requestPost(String path, Object? body) async {
    var headers = await getHeaders();

    var response = await http.post(
      Uri.parse(base_url + path),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestPostCompleteUrl(
      String path, Object? body) async {
    var headers = await getHeaders();
    var response = await http.post(
      Uri.parse(path),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestGet(String path) async {
    var headers = await getHeaders();
    var response = await http.get(
      Uri.parse(base_url + path),
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestGetFull(String path) async {
    var headers = await getHeaders();
    var response = await http.get(
      Uri.parse(path),
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestPut(String path, Object? body) async {
    var headers = await getHeaders();
    var response = await http.put(
      Uri.parse(base_url + path),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestDelete(String path) async {
    var headers = await getHeaders();
    var response = await http.delete(
      Uri.parse(base_url + path),
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestPatch(String path, Object? body) async {
    var headers = await getHeaders();
    var response = await http.patch(
      Uri.parse(base_url + path),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestUpload(String path, Object? body) async {
    var headers = await getHeaders();
    var response = await http.post(
      Uri.parse(base_url + path),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> requestDownload(String path) async {
    var headers = await getHeaders();
    var response = await http.get(
      Uri.parse(base_url + path),
      headers: headers,
    );
    return response;
  }

  static void snackBar(
      {required BuildContext context,
      required String message,
      bool? isSuccess,
      bool? isError,
      bool? isWarning}) {
    if (isSuccess != null && isSuccess) {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message: message,
          textStyle: const TextStyle(fontSize: 11, color: Colors.white),
        ),
      );
    }
    if (isError != null && isError) {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: message,
          textStyle: const TextStyle(fontSize: 11, color: Colors.white),
        ),
      );
    }
    if (isWarning != null && isWarning) {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message: message,
          textStyle: const TextStyle(fontSize: 11, color: Colors.white),
        ),
      );
    }
  }

  static void navigatorPush(BuildContext context, Widget child) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return child;
      },
    ));
  }

  static void navigatorPushReplacement(BuildContext context, Widget child) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return child;
      },
    ));
  }
}
