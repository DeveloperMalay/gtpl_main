import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gtpl/api_layer/models/get_operator_model.dart';
import 'package:gtpl/api_layer/models/ticket_model.dart';
import 'package:gtpl/api_layer/models/token_model.dart';
import 'package:http/http.dart' as http;

final baseUrl = 'http://3.111.229.113:3000/';

final _secureStorage = FlutterSecureStorage();

//function to getting user token
Future<Token> getToken() async {
  var authUser = await _secureStorage.read(key: 'user');
  // print("user from gettoken---->${authUser}");
  final response = await http.get(Uri.parse('${baseUrl}userlogin/${authUser}'));
  var jsonResponse = json.decode(response.body);
  await _secureStorage.write(key: "token", value: jsonResponse['token']);
  if (response == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return Token.fromJson(jsonResponse);
  } else {
    throw Exception("Don't get any token ");
  }
}

//function to get operator_id
Future<GetOperator> getOperator() async {
  var authUser = await _secureStorage.read(key: "user");

  var response = await http.post(
    Uri.parse("${baseUrl}broadband/user/details"),
    headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: jsonEncode(
      <String, String>{"user_id": authUser!},
    ),
  );

  // print("user from getoperator---->${authUser}");

  if (response.statusCode == 200) {
    var jsonResponse = GetOperator.fromJson(json.decode(response.body));

    await _secureStorage.write(
      key: "operator",
      value: jsonResponse.resultUserDetail.partnerCode,
    );
    // print(
    //'Result from getOperator---->${jsonResponse.resultUserDetail.partnerCode}');
    return jsonResponse;
  } else {
    throw Exception('data loading failed!');
  }
}

//function to post ticket issue for broadband
Future<http.Response> postTicket(String desc, String issue) async {
  var authUser = await _secureStorage.read(key: "user");
  var authToken = await _secureStorage.read(key: "token");
  var operatorCode = await _secureStorage.read(key: "operator");

  // print("Token from postTicket---->${authToken}");
  print("operator from postTicket---->${operatorCode}");
  // print("user from postTicket---->${authUser}");

  return http.post(
    Uri.parse("${baseUrl}newTicket"),
    headers: {
      HttpHeaders.authorizationHeader: authToken!,
      HttpHeaders.contentTypeHeader: "application/json"
    },
    body: json.encode(
      <String, dynamic>{
        "user_id": authUser,
        "description": desc,
        "issue_type": issue,
        "oparetor_id": operatorCode,
      },
    ),
  );

  // if (response.statusCode == 201) {
  //   var result = await UserTicket.fromJson(json.decode(response.body));
  //   print('result from postticket------>${result}');

  //   return result;
  // } else {
  //   throw Exception('post ticket action loading failed!---------->');
  // }
}

//function to fetch the ticket data for a perticular user
Future<List<UserTicket>> fetchTicketData() async {
  var authUser = await _secureStorage.read(key: 'user');
  var authToken = await _secureStorage.read(key: 'token');
  // var opreator = await _secureStorage.read(key: 'operator');
  print("user from fetchTicketData---->${authUser}");
  print("token from fetchTicketData---->${authToken}");
  // print("operator from fetchTicketData---->${opreator}");
  final response = await http.get(
    Uri.parse('${baseUrl}ticket/${authUser}'),
    headers: {
      HttpHeaders.authorizationHeader: authToken!,
      HttpHeaders.contentTypeHeader: 'application/json'
    },
  );
  if (response.statusCode == 200) {
    // var jsonResponse = json.decode(response.body);
    // print(jsonResponse['data']);
    // if (json.decode(response.body)['data'] == 0) {
    //   print('dtasdjfhiurfgrgfiuerfg');
    // }
    List jsonListResponse = json.decode(response.body);

    return jsonListResponse.map((data) => UserTicket.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

//function to close ticket
Future<http.Response> closeTicket(String ticketId) async {
  var authUser = await _secureStorage.read(key: "user");
  var authToken = await _secureStorage.read(key: "token");
  print("Token from postTicket---->${authToken}");
  print("user from postTicket---->${authUser}");
  print("tickedID from postTicket---->${ticketId}");
  return http.post(
    Uri.parse("${baseUrl}close_ticket/${ticketId}"),
    headers: {
      HttpHeaders.authorizationHeader: authToken!,
      HttpHeaders.contentTypeHeader: "application/json"
    },
    body: jsonEncode(
      <String, dynamic>{
        "user_id": authUser,
      },
    ),
  );

  // if (response.statusCode == 201) {
  //   var result = await UserTicket.fromJson(json.decode(response.body));
  //   print('result from postticket------>${result}');

  //   return result;
  // } else {
  //   throw Exception('post ticket action loading failed!---------->');
  // }
}

//function to close ticket
Future giveRating(String ticketId, int rating) async {
  var authUser = await _secureStorage.read(key: "user");
  var authToken = await _secureStorage.read(key: "token");
  var operatorCode = await _secureStorage.read(key: "operator");
  return await http.post(
    Uri.parse(
        "${baseUrl}user/give/star/${authUser}/${operatorCode}/${rating}/${ticketId}"),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: authToken!,
    },
  );
}
