// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class RemoteServices {
  final HttpClient client = HttpClient();

  static httpRequest(
      {required String method,
      required String url,
      Map body = const {},
      String accessToken = ''}) async {
    try {
      final client = HttpClient();
      late HttpClientRequest request;
      if (method == 'POST') {
        request = await client.postUrl(Uri.parse(url));
      } else if (method == 'PUT') {
        request = await client.putUrl(Uri.parse(url));
      } else if (method == 'DELETE') {
        request = await client.deleteUrl(Uri.parse(url));
      } else if (method == 'GET') {
        request = await client.getUrl(Uri.parse(url));
      }
//
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
      if (accessToken != '') {
        request.headers
            .set(HttpHeaders.authorizationHeader, "Bearer $accessToken");
      }
//
      if (method != 'GET') {
        request.write(json.encode(body));
      }
//
      final response = await request.close();
      final responseData = await response.transform(utf8.decoder).join();

      return json.decode(responseData);
    } catch (e) {
      rethrow;
    }
  }

  static formDataRequest(
      {required String method,
      required String url,
      required Map<String, String> body,
      required Map<String, String> files,
      String accessToken = ''}) async {
    try {
      var request = http.MultipartRequest(method, Uri.parse(url));
//
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      });
//
      request.fields.addAll(body);

      files.forEach((key, value) async {
        request.files.add(http.MultipartFile.fromBytes(
            key, File(value).readAsBytesSync(),
            filename: value.split("/").last));
        // request.files
        //     .add(await http.MultipartFile.fromPath(value.split("/").last, value));
      });
//
      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      final responseData = json.decode(respStr);

      return responseData;
    } catch (e) {
      rethrow;
    }
  }
}
