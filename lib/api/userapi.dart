import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heart_rate/model/heartmodel.dart';
import 'package:heart_rate/model/usermodel.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/doctormodel.dart';

int count = 0;

class UserApi with ChangeNotifier {
  Future sendDetails({
    String? name,
    String? number,
    String? email,
    String? password,
    bool? isDoctor,
    String? Doctorid,
    String? speciality,
    String? about,
    String? paitents,
    String? experience,
  }) async {
    print("here $isDoctor");
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/users';

    int c = count + 1;

    var response = await retry(
      () => http
          .post(Uri.parse(url),
              body: json.encode({
                "id": c.toString(),
                "name": name,
                "email": email,
                "password": password,
                "mobilenumber": number,
                "isDoctor": isDoctor,
                "hrate": [0],
                "history": [0]
              }))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var k = response.body;
      var n = json.decode(k);
      print(n);
      var id = prefs.setString("id", n["Item"]["id"]);
    }
  }

  Future updateDetails(String? heart, String? date) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/users';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    var map = new Map<String, dynamic>();

    var response = await retry(
      () => http
          .put(Uri.parse(url),
              body: json.encode({
                "id": id,
                "updateKey": "hrate",
                "updateValue": {"heart": heart, "date": date},
              }))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var k = response.body;
    var n = json.decode(k);
  }

  Future getDetails() async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/users';

    var map = new Map<String, dynamic>();

    var response = await retry(
      () => http
          .get(
            Uri.parse(url),
          )
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var k = response.body;
    var n = json.decode(k);

    remove();
    for (int i = 0; i < n["users"]["Items"].length; i++) {
      adduser(
          name: n["users"]["Items"][i]["name"],
          email: n["users"]["Items"][i]["email"],
          heartRate: n["users"]["Items"][i]["hrate"].toString(),
          history: n["users"]["Items"][i]["history"],
          mobile: n["users"]["Items"][i]["mobilenumber"],
          password: n["users"]["Items"][i]["password"],
          id: n["users"]["Items"][i]["id"]);

      count = n['users']['Count'];
      print("user $count");
    }
  }

  Future getSingleUserDetails() async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/users';

    var map = new Map<String, dynamic>();
    print('SIngle Sune');

    var response = await retry(
      () => http
          .get(
            Uri.parse(url),
          )
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var k = response.body;
    var n = json.decode(k);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('uid');
    remove();
    for (int i = 0; i < n["users"]["Items"].length; i++) {
      if (id == n["users"]["Items"][i]["id"])
        adduser(
            name: n["users"]["Items"][i]["name"],
            email: n["users"]["Items"][i]["email"],
            heartRate: n["users"]["Items"][i]["hrate"].toString(),
            history: n["users"]["Items"][i]["history"],
            mobile: n["users"]["Items"][i]["mobilenumber"],
            password: n["users"]["Items"][i]["password"],
            id: n["users"]["Items"][i]["id"]);

      count = n['users']['Count'];
      print("user $count");
    }
  }

  List<User> users = [];
  List<User> get user => users;

  void adduser({
    String? name,
    String? email,
    String? mobile,
    String? password,
    List<dynamic>? history,
    String? heartRate,
    String? id,
  }) {
    print("Adding");
    user.add(User(
        id: id!,
        name: name!,
        email: email!,
        mobile: mobile!,
        password: password!,
        history: history!,
        heartRate: heartRate!));
    notifyListeners();
  }

  void remove() {
    users.clear();
    notifyListeners();
  }
}
