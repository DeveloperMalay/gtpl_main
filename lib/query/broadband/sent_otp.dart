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
    print('res ---$res');
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
  String? module;
  String? cUSTOMERNO;

  GetResponseOTPModel({this.status, this.otp, this.module, this.cUSTOMERNO});

  GetResponseOTPModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    otp = json['otp'];
    module = json['mobile'];
    cUSTOMERNO = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['otp'] = otp;
    data['mobile'] = module;
    data['user_id'] = cUSTOMERNO;
    return data;
  }
}
