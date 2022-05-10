import 'package:http/http.dart' as http;

class FetchApi {
  static Map<String, String> headers = {};

  static get(String url) async {
    final response = await http.get(Uri.parse(url), headers: FetchApi.headers);
    return response;
  }

  static post(String url, dynamic data) async {
    final response =
        await http.post(Uri.parse(url), body: data, headers: FetchApi.headers);
    return response;
  }

  static patch(String url, dynamic data) async {
    final response =
        await http.patch(Uri.parse(url), body: data, headers: FetchApi.headers);
    return response;
  }

  static delete(String url, dynamic data) async {
    final response =
        await http.delete(Uri.parse(url), body: data, headers: FetchApi.headers);
    return response;
  }
}
