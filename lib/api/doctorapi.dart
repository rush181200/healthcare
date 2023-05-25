import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heart_rate/model/usermodel.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/doctormodel.dart';

int count = 0;

class DoctorApi with ChangeNotifier {
  Future sendDocDetails({
    String? name,
    String? number,
    String? email,
    String? password,
    String? Doctorid,
    String? speciality,
    String? about,
    String? paitents,
    String? experience,
  }) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/doctor';

    int c = count + 1;
    print(name);
    var response = await retry(
      () => http
          .post(Uri.parse(url),
              body: json.encode({
                "did": c.toString(),
                "name": name,
                "email": email,
                "password": password,
                "mobilenumber": number,
                "Doctorid": Doctorid,
                "speciality": speciality,
                "about": about,
                "paitents": paitents,
                "experience": experience
              }))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var k = response.body;
      var n = json.decode(k);
      print(n);
      var id = prefs.setString("did", n["Item"]["did"]);
    }
  }

  Future getDoctorDetails() async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/doctor';

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
    print(n);
    removeDoctor();
    for (int i = 0; i < n["doctor"]["Items"].length; i++) {
      adddoctor(
        id: n["doctor"]["Items"][i]["did"],
        name: n["doctor"]["Items"][i]["name"],
        email: n["doctor"]["Items"][i]["email"],
        mobile: n["doctor"]["Items"][i]["mobilenumber"],
        paitents: n["doctor"]["Items"][i]["paitents"],
        doctorId: n["doctor"]["Items"][i]["Doctorid"],
        about: n["doctor"]["Items"][i]["about"],
        experience: n["doctor"]["Items"][i]["experience"],
        speciality: n["doctor"]["Items"][i]["speciality"],
        password: n["doctor"]["Items"][i]["password"],
      );

      count = n['doctor']['Count'];
      print("user $count");
    }
  }

  List<Doctor> doctors = [];
  List<Doctor> get doctor => doctors;

  void adddoctor({
    String? id,
    String? name,
    String? email,
    String? mobile,
    String? doctorId,
    String? speciality,
    String? about,
    String? paitents,
    String? experience,
    String? password,
  }) {
    doctor.add(Doctor(
        id: id!,
        name: name!,
        email: email!,
        mobile: mobile!,
        doctorId: doctorId!,
        speciality: speciality!,
        experience: experience!,
        password: password!,
        about: about!,
        paitents: paitents!));
    notifyListeners();
  }

  void removeDoctor() {
    doctor.clear();
    notifyListeners();
  }
}
