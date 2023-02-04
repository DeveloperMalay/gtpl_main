import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gtpl/query/global_handler.dart';
import '../api_layer/models/get_broadband_details_model.dart';
import '../api_layer/models/get_broadband_details_new.dart';

Future<dynamic> getBroadbandUserDetails(
    BuildContext context, String userid) async {
  var response = await GlobalHandler.requestPost(
      "/broadband/user/details", {"user_id": userid});
  var js = json.decode(response.body);

  if (js['status'] == 200) {
    if (js['get_subscriber_detail']['returnCode'] == 0.toString()) {
      print("from if ${js['get_subscriber_detail']['returnCode']}");
      var res = GetBoardbadDetailsModel.fromJson(js);
      return res;
    } else {
      print("from else -->${js['get_subscriber_detail']['returnCode']}");
      var res = GetBoardbadDetailsModel2.fromJson(js);
      return res;
    }
  } else if (js['status'] != 200) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(js['responseInfo']['returnMessage']),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  } else {
    print("getting error");
  }
}

// class GetBroadbandDetailsModel {
//   int? status;
//   String? message;
//   ResultUserDetail? resultUserDetail;
//   GetSubscriberDetail? getSubscriberDetail;

//   GetBroadbandDetailsModel(
//       {this.status, this.resultUserDetail, this.getSubscriberDetail});

//   GetBroadbandDetailsModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     resultUserDetail = json['result_user_detail'] != null
//         ? ResultUserDetail.fromJson(json['result_user_detail'])
//         : null;
//     getSubscriberDetail = json['get_subscriber_detail'] != null
//         ? GetSubscriberDetail.fromJson(json['get_subscriber_detail'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     if (resultUserDetail != null) {
//       data['result_user_detail'] = resultUserDetail!.toJson();
//     }
//     if (getSubscriberDetail != null) {
//       data['get_subscriber_detail'] = getSubscriberDetail!.toJson();
//     }
//     return data;
//   }
// }

// class ResultUserDetail {
//   String? status;
//   String? expiryDate;
//   String? returnCode;
//   String? returnMessage;
//   String? name;
//   String? userId;
//   String? address;
//   String? area;
//   String? city;
//   String? state;
//   String? nation;
//   String? mobileNo;
//   String? telephone;
//   String? eMail;
//   String? currentPlanName;
//   String? partnerCode;
//   String? outstandingAmount;

//   ResultUserDetail(
//       {this.status,
//       this.expiryDate,
//       this.returnCode,
//       this.returnMessage,
//       this.name,
//       this.userId,
//       this.address,
//       this.area,
//       this.city,
//       this.state,
//       this.nation,
//       this.mobileNo,
//       this.telephone,
//       this.eMail,
//       this.currentPlanName,
//       this.partnerCode,
//       this.outstandingAmount});

//   ResultUserDetail.fromJson(Map<String, dynamic> json) {
//     status = json['Status'];
//     expiryDate = json['ExpiryDate'];
//     returnCode = json['returnCode'];
//     returnMessage = json['returnMessage'];
//     name = json['Name'];
//     userId = json['UserId'];
//     address = json['Address'];
//     area = json['Area'];
//     city = json['City'];
//     state = json['State'];
//     nation = json['Nation'];
//     mobileNo = json['MobileNo'];
//     telephone = json['Telephone'];
//     eMail = json['EMail'];
//     currentPlanName = json['CurrentPlanName'];
//     partnerCode = json['PartnerCode'];
//     outstandingAmount = json['OutstandingAmount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Status'] = status;
//     data['ExpiryDate'] = expiryDate;
//     data['returnCode'] = returnCode;
//     data['returnMessage'] = returnMessage;
//     data['Name'] = name;
//     data['UserId'] = userId;
//     data['Address'] = address;
//     data['Area'] = area;
//     data['City'] = city;
//     data['State'] = state;
//     data['Nation'] = nation;
//     data['MobileNo'] = mobileNo;
//     data['Telephone'] = telephone;
//     data['EMail'] = eMail;
//     data['CurrentPlanName'] = currentPlanName;
//     data['PartnerCode'] = partnerCode;
//     data['OutstandingAmount'] = outstandingAmount;
//     return data;
//   }
// }

// class GetSubscriberDetail {
//   String? dueDate;
//   String? returnCode;
//   String? returnMessage;
//   String? subscriberName;
//   String? subscriberCode;
//   String? amount;
//   String? billDate;

//   GetSubscriberDetail(
//       {this.dueDate,
//       this.returnCode,
//       this.returnMessage,
//       this.subscriberName,
//       this.subscriberCode,
//       this.amount,
//       this.billDate});

//   GetSubscriberDetail.fromJson(Map<String, dynamic> json) {
//     dueDate = json['DueDate'];
//     returnCode = json['returnCode'];
//     returnMessage = json['returnMessage'];
//     subscriberName = json['SubscriberName'];
//     subscriberCode = json['SubscriberCode'];
//     amount = json['Amount'];
//     billDate = json['BillDate'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['DueDate'] = dueDate;
//     data['returnCode'] = returnCode;
//     data['returnMessage'] = returnMessage;
//     data['SubscriberName'] = subscriberName;
//     data['SubscriberCode'] = subscriberCode;
//     data['Amount'] = amount;
//     data['BillDate'] = billDate;
//     return data;
//   }
// }
