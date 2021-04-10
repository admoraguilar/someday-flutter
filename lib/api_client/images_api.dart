import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImagesApi {
  Future<List<String>> getImages() async {
    Uri url = Uri.parse(
        "https://api.someday.so/api/v1/images/search?Query=anime%20girl");
    http.Response response = await http.get(url, headers: {
      'Referrer-Policy': 'no-referrer',
    });
    print(response.body);

    dynamic data = jsonDecode(response.body);
    return (data as List).cast<String>();
  }

  Future<Uint8List> getImageBytes(String url) async {
    Uri parsedUrl = Uri.parse(
        'https://api.someday.so/api/v1/proxy-2?url=${Uri.encodeComponent(url)}');
    http.Response response = await http.get(parsedUrl);
    print(response.body);
    print(response.headers['content-type']);
    // print(response.body);
    return response.bodyBytes;
  }
}
