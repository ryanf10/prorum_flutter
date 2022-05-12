import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prorum_flutter/constant.dart';
import 'package:prorum_flutter/fetch_api.dart';

import 'models/user.dart';

class Session {
  static const storage = FlutterSecureStorage();
  static bool isLoggedin = false;
  static User? user;

  static initState() async {
    String cookie = await storage.read(key: 'cookie') ?? '';
    if (cookie != '') {
      FetchApi.headers['cookie'] = cookie;
      await Session.getUser();
    }
  }

  static getUser() async {
    final response = await FetchApi.get(baseApiUrl + '/users/me');
    Map<String, dynamic> body = jsonDecode(response.body);

    if (body['statusCode'] == 200) {
      Session.isLoggedin = true;
      Session.user = User.fromJson(body['data']['user']);

      final responseForAvatar =
          await FetchApi.get(baseApiUrl + '/users/me/avatar');
      Map<String, dynamic> bodyForAvatar = jsonDecode(responseForAvatar.body);

      if(bodyForAvatar['statusCode'] == 200){
        Session.user!.base64Avatar = bodyForAvatar['data'];
      }
    }
  }

  static saveCookie(response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      FetchApi.headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
      storage.write(key: 'cookie', value: rawCookie);
    }
  }

  static destroyAll() async {
    await storage.deleteAll();
    FetchApi.headers = {};
    Session.isLoggedin = false;
  }
}
