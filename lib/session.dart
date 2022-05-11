import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prorum_flutter/fetch_api.dart';

class Session {
  static const storage = FlutterSecureStorage();
  static bool isLoggedin = false;

  static initState() async {
    String cookie = await storage.read(key: 'cookie') ?? '';
    if (cookie != '') {
      FetchApi.headers['cookie'] = cookie;

      final y =
          await FetchApi.get('https://nest-prorum.herokuapp.com/api/users/me');
      Map<String, dynamic> body = jsonDecode(y.body);

      if (body['statusCode'] == 200) {
        Session.isLoggedin = true;
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
