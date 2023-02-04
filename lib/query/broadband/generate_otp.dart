import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gtpl/query/global_handler.dart';

Future<GetResponseOTPModel?> generateOtpBroadband(
    BuildContext context, String phoneNo) async {
  try {
    var response = await GlobalHandler.requestPost(
        "/broadband/auth/otp", {"phone_no": phoneNo});
    var js = json.decode(response.body);
    print('js --$js');
    GetResponseOTPModel res = GetResponseOTPModel.fromJson(js);
    return res;
  } catch (e) {
    GlobalHandler.snackBar(
        context: context, message: e.toString(), isError: true);
    return null;
  }
}

class GetResponseOTPModel {
  int? status;
  String? message;
  int? otp;

  GetResponseOTPModel({this.status, this.message, this.otp});

  GetResponseOTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['otp'] = this.otp;
    return data;
  }
}
