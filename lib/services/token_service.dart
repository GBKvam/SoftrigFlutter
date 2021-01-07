import 'dart:convert';

import 'package:SoftrigFlutter/config/config.dart';
import 'package:SoftrigFlutter/model/token_model.dart';
import 'package:http/http.dart' as http;


class TokenService {
  Token token;
  String code = "";
  ServerUrls su = new ServerUrls();

  Future<Token> getToken(String appId, String appSecret, String newCode) async {
    print("Start: EXtra");

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final http.Request request = http.Request(
        'POST', Uri.parse('${su.tokenUrl}'));
    request.bodyFields = {
      'grant_type': 'authorization_code',
      'code': '$newCode',
      'redirect_uri': '${su.redirectUrl}',
      'client_id': '$appId',
      'client_secret': '$appSecret'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String rtnStr = "";
    if (response.statusCode == 200) {
      rtnStr = await response.stream.bytesToString();
      return new Token.fromMap(json.decode(rtnStr));
    } else {
      return null;
    }
  }

  Future<Token> getRefreshToken(
    String appId, String appSecret, String refreshtoken) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final http.Request request = http.Request(
        'POST', Uri.parse('${su.tokenUrl}'));
    request.bodyFields = {
      'client_id': '$appId',
      'refresh_token': '$refreshtoken',
      'grant_type': 'refresh_token',
      'client_secret': '$appSecret',
      'redirect_uri': '${su.redirectUrl}'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String rtnStr = "";
    if (response.statusCode == 200) {

      rtnStr = await response.stream.bytesToString();
      return new Token.fromMap(json.decode(rtnStr));
    } else {
      return null;
    }
  }
}
