// // ignore_for_file: depend_on_referenced_packages

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// // class HttpResult {
// //   final int statusCode;
// //   final Map<String, dynamic> body;

// //   HttpResult({required this.statusCode, required this.body});
// // }

// class RemoteServices {
//   final HttpClient client = HttpClient();

//   static Future<HttpResult> httpRequest({
//     required String method,
//     required String url,
//     Map body = const {},
//     String accessToken = '',
//   }) async {
//     try {
//       final client = HttpClient();
//       late HttpClientRequest request;

//       if (method == 'POST') {
//         request = await client.postUrl(Uri.parse(url));
//       } else if (method == 'PUT') {
//         request = await client.putUrl(Uri.parse(url));
//       } else if (method == 'DELETE') {
//         request = await client.deleteUrl(Uri.parse(url));
//       } else if (method == 'GET') {
//         request = await client.getUrl(Uri.parse(url));
//       }

//       request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

//       if (accessToken.isNotEmpty) {
//         request.headers.set(
//           HttpHeaders.authorizationHeader,
//           "Bearer $accessToken",
//         );
//       }

//       if (method != 'GET') {
//         request.write(jsonEncode(body));
//       }

//       final response = await request.close();

//       final responseBody = await response.transform(utf8.decoder).join();

//       Map<String, dynamic> decodedBody = {};

//       try {
//         decodedBody = jsonDecode(responseBody);
//       } catch (e) {
//         print('JSON parsing error: $e');
//       }

//       return HttpResult(statusCode: response.statusCode, body: decodedBody);
//     } catch (e) {
//       print('Request error: $e');
//       rethrow;
//     }
//   }

//   static formDataRequest({
//     required String method,
//     required String url,
//     required Map<String, String> body,
//     required Map<String, String> files,
//     String accessToken = '',
//   }) async {
//     try {
//       var request = http.MultipartRequest(method, Uri.parse(url));
//       //
//       request.headers.addAll({
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $accessToken',
//       });
//       //
//       request.fields.addAll(body);

//       files.forEach((key, value) async {
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             key,
//             File(value).readAsBytesSync(),
//             filename: value.split("/").last,
//           ),
//         );
//         // request.files
//         //     .add(await http.MultipartFile.fromPath(value.split("/").last, value));
//       });
//       //
//       http.StreamedResponse response = await request.send();
//       final respStr = await response.stream.bytesToString();
//       final responseData = json.decode(respStr);

//       return responseData;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }


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
      print('HTTP Request: $method $url');
      print('Request Body: $body');
      
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

      print('HTTP Response Status: ${response.statusCode}');
      print('HTTP Response Data: $responseData');

      final decodedResponse = json.decode(responseData);
      return decodedResponse;
    } catch (e) {
      print('HTTP Request Error: $e');
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

 