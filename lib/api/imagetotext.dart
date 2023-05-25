import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retry/retry.dart';

import 'package:http/http.dart' as http;

class ImageApi with ChangeNotifier {
  Future getImage(List<int>? image) async {
    String url =
        'https://km47em587j.execute-api.us-east-2.amazonaws.com/default/getTextFromImage';
        

    var response = await retry(
      () => http
          .post(Uri.parse(url),
              body: json.encode({
                "Image": image!,
              }))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response.body);
    print(response.statusCode);
  }
}
