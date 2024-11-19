import 'dart:convert';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:scenario_management/constants/response.dart';
import 'package:http_parser/http_parser.dart';

import 'data_service.dart';

class Services extends DataService {
  final fileUploadUrl = "https://dev.orderbookings.com/api/image-test-upload";
  @override
  Future<Response> uploadFile(Uint8List? fileBytes, String? fileName) async {
    return await performHTTPPOST(fileUploadUrl,
        fileBytes: fileBytes, fileName: fileName);
  }
  Future<Response> performHTTPGET(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return Response(data: jsonDecode(response.body), err: "");
      } else {
        return Response(
            data: null, err: 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      return Response(data: null, err: 'Failed to load data: $e');
    }
  }

  Future<Response> performHTTPPOST(
      String url, {
        dynamic data,
        Uint8List? fileBytes,
        String? fileName,
      }) async {
    try {
      http.Response response;
      if (fileBytes != null && fileName != null) {
        String? mimeType = lookupMimeType(fileName); // Lookup the MIME type based on the file extension
        if (mimeType == null) {
          return Response(
            data: null,
            err: 'Could not determine file MIME type',
          );
        }
        var mediaType = mimeType.split('/');

        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.files.add(http.MultipartFile.fromBytes(
          'image', // The key name for the file in the API (matches your cURL example)
          fileBytes,
          filename: fileName,
          contentType: MediaType(mediaType[0], mediaType[1]),
        ));

        if (data != null) {
          data.forEach((key, value) {
            request.fields[key] = value.toString();
          });
        }

        var streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Response(data: jsonDecode(response.body), err: "");
      } else {
        return Response(
            data: null, err: 'Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      return Response(data: null, err: 'Failed to upload image: $e');
    }
  }


  Future<Response> performHTTPPUT(
      String url, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print("Updated ${response.statusCode}");
      if (response.statusCode == 200) {
        return Response(data: jsonDecode(response.body), err: "");
      } else {
        return Response(
            data: null, err: 'Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      return Response(data: null, err: 'Failed to update data: $e');
    }
  }

  Future<Response> performHTTPDELETE(String url) async {
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Deleted ${response.statusCode}');
        return Response(data: jsonDecode(response.body), err: "");
      } else {
        return Response(
            data: null, err: 'Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }
}
