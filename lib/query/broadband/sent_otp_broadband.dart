import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gtpl/query/global_handler.dart';

Future<GetResponseOTPModel?> sentOtpBroadband(
    BuildContext context, String userId) async {
  try {
    var response = await GlobalHandler.requestPost(
        "/broadband/auth/phone", {"user_id": userId});
    var js = json.decode(response.body);

    GetResponseOTPModel res = GetResponseOTPModel.fromJson(js);
    print('test -- ${res}');
    return res;
  } catch (e) {
    GlobalHandler.snackBar(
        context: context, message: e.toString(), isError: true);
    return null;
  }
}

class GetResponseOTPModel {
  int? status;
  int? otp;
  String? mobile;
  String? userId;

  GetResponseOTPModel({this.status, this.otp, this.mobile, this.userId});

  GetResponseOTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otp = json['otp'];
    mobile = json['mobile'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['mobile'] = this.mobile;
    data['user_id'] = this.userId;
    return data;
  }
}
