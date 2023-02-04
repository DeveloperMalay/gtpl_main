class GetBoardbadDetailsModel {
  GetBoardbadDetailsModel({
    this.status,
    this.resultUserDetail,
    this.getSubscriberDetail,
  });

  int? status;
  ResultUserDetail? resultUserDetail;
  GetSubscriberDetail? getSubscriberDetail;

  factory GetBoardbadDetailsModel.fromJson(Map<String, dynamic> json) =>
      GetBoardbadDetailsModel(
        status: json["status"],
        resultUserDetail: ResultUserDetail.fromJson(json["result_user_detail"]),
        getSubscriberDetail:
            GetSubscriberDetail.fromJson(json["get_subscriber_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result_user_detail": resultUserDetail!.toJson(),
        "get_subscriber_detail": getSubscriberDetail!.toJson(),
      };
}

class GetSubscriberDetail {
  GetSubscriberDetail({
    this.empty,
    this.dueDate,
    this.returnCode,
    this.returnMessage,
    this.billDate,
    this.subscriberName,
    this.subscriberCode,
    this.state,
    this.amount,
    this.stateCode,
  });

  GetSubscriberDetailClass? empty;
  String? dueDate;
  String? returnCode;
  String? returnMessage;
  String? billDate;
  String? subscriberName;
  String? subscriberCode;
  String? amount;
  String? state;
  String? stateCode;

  factory GetSubscriberDetail.fromJson(Map<String, dynamic> json) =>
      GetSubscriberDetail(
        empty: GetSubscriberDetailClass.fromJson(json["\u0024"]),
        dueDate: json["DueDate"],
        returnCode: json["returnCode"],
        returnMessage: json["returnMessage"],
        billDate: json["BillDate"],
        amount: '0.0',
        subscriberName: 'Undefine',
        subscriberCode: 'nocode',
        state: json["State"],
        stateCode: json["StateCode"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024": empty!.toJson(),
        "DueDate": dueDate,
        "returnCode": returnCode,
        "returnMessage": returnMessage,
        "BillDate": billDate,
        "State": state,
        "StateCode": stateCode,
      };
}

class GetSubscriberDetailClass {
  GetSubscriberDetailClass({
    this.xmlnsXsd,
    this.xmlnsXsi,
    this.xmlns,
  });

  String? xmlnsXsd;
  String? xmlnsXsi;
  String? xmlns;

  factory GetSubscriberDetailClass.fromJson(Map<String, dynamic> json) =>
      GetSubscriberDetailClass(
        xmlnsXsd: json["xmlns:xsd"],
        xmlnsXsi: json["xmlns:xsi"],
        xmlns: json["xmlns"],
      );

  Map<String, dynamic> toJson() => {
        "xmlns:xsd": xmlnsXsd,
        "xmlns:xsi": xmlnsXsi,
        "xmlns": xmlns,
      };
}

class ResultUserDetail {
  ResultUserDetail({
    this.status,
    this.expiryDate,
    this.returnCode,
    this.returnMessage,
    this.name,
    this.userId,
    this.address,
    this.area,
    this.city,
    this.state,
    this.nation,
    this.mobileNo,
    this.telephone,
    this.eMail,
    this.currentPlanName,
    this.partnerCode,
    this.outstandingAmount,
  });

  String? status;
  DateTime? expiryDate;
  String? returnCode;
  String? returnMessage;
  String? name;
  String? userId;
  String? address;
  String? area;
  String? city;
  String? state;
  String? nation;
  String? mobileNo;
  String? telephone;
  String? eMail;
  String? currentPlanName;
  String? partnerCode;
  String? outstandingAmount;

  factory ResultUserDetail.fromJson(Map<String, dynamic> json) =>
      ResultUserDetail(
        status: json["Status"],
        expiryDate: DateTime.parse(json["ExpiryDate"]),
        returnCode: json["returnCode"],
        returnMessage: json["returnMessage"],
        name: json["Name"],
        userId: json["UserId"],
        address: json["Address"],
        area: json["Area"],
        city: json["City"],
        state: json["State"],
        nation: json["Nation"],
        mobileNo: json["MobileNo"],
        telephone: json["Telephone"],
        eMail: json["EMail"],
        currentPlanName: json["CurrentPlanName"],
        partnerCode: json["PartnerCode"],
        outstandingAmount: json["OutstandingAmount"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "ExpiryDate": expiryDate!.toIso8601String(),
        "returnCode": returnCode,
        "returnMessage": returnMessage,
        "Name": name,
        "UserId": userId,
        "Address": address,
        "Area": area,
        "City": city,
        "State": state,
        "Nation": nation,
        "MobileNo": mobileNo,
        "Telephone": telephone,
        "EMail": eMail,
        "CurrentPlanName": currentPlanName,
        "PartnerCode": partnerCode,
        "OutstandingAmount": outstandingAmount,
      };
}
