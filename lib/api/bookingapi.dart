import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/bookingmodel.dart';

int count = 0;

class BookingApi with ChangeNotifier {
  Future sendBooking({
    String? date,
    String? time,
  }) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/booking';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var did = prefs.getString("did");
    int c = count + 1;
    var response = await retry(
      () => http
          .post(Uri.parse(url),
              body: json.encode({
                "bid": c.toString(),
                "did": did,
                "date": date,
                "time": time,
                "status": "Pending",
                "uid": "0",
                "link": "empty",
              }))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var k = response.body;
      var n = json.decode(k);
      print(n);
    }
  }

  Future updateBookingDetails({String? id, String? link}) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/booking';

    var map = new Map<String, dynamic>();

    var response = await retry(
      () => http
          .put(Uri.parse(url),
              body: json.encode(
                  {"bid": id, "updateKey": "status", "updateValue": "Confirm"}))
          .timeout(Duration(seconds: 5)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    ).then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var uid = prefs.get("uid");
      print(uid);
      var response1 = await retry(
        () => http
            .put(Uri.parse(url),
                body: json.encode({
                  "bid": id,
                  "updateKey": "uid",
                  "updateValue": uid,
                }))
            .timeout(Duration(seconds: 5)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
    });
  }

  Future getBookingDetails({String? id}) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/booking';

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

    count = n['bookings']['Count'];
    remove();
    for (int i = 0; i < n["bookings"]["Items"].length; i++) {
      if (n["bookings"]["Items"][i]['did'] == id &&
          n["bookings"]["Items"][i]['status'] == 'Pending')
        addbms(
            bid: n["bookings"]["Items"][i]['bid'],
            date: n["bookings"]["Items"][i]['date'],
            did: n["bookings"]["Items"][i]['did'],
            status: n["bookings"]["Items"][i]['status'],
            time: n["bookings"]["Items"][i]['time'],
            uid: n["bookings"]["Items"][i]['uid'],
            link: n["bookings"]["Items"][i]['link']);
    }
  }

  Future getConfirmBookingDetailsUser({String? id}) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/booking';

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

    count = n['bookings']['Count'];
    remove();
    print('yess');

    for (int i = 0; i < n["bookings"]["Items"].length; i++) {
      print(n["bookings"]["Items"][i]['uid']);
      print(id);
      if (n["bookings"]["Items"][i]['uid'] == id &&
          n["bookings"]["Items"][i]['status'] == 'Confirm') {
        print('yess');
        addbms(
            bid: n["bookings"]["Items"][i]['bid'],
            date: n["bookings"]["Items"][i]['date'],
            did: n["bookings"]["Items"][i]['did'],
            status: n["bookings"]["Items"][i]['status'],
            time: n["bookings"]["Items"][i]['time'],
            uid: n["bookings"]["Items"][i]['uid'],
            link: n["bookings"]["Items"][i]['link']);
      }
    }
  }

  Future getConfirmBookingDetailsDoctor({String? id}) async {
    String url =
        'https://kswkb91yx6.execute-api.us-east-2.amazonaws.com/basicapis/booking';

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

    count = n['bookings']['Count'];
    remove();
    for (int i = 0; i < n["bookings"]["Items"].length; i++) {
      if (n["bookings"]["Items"][i]['did'] == id &&
          n["bookings"]["Items"][i]['status'] == 'Confirm')
        addbms(
            bid: n["bookings"]["Items"][i]['bid'],
            date: n["bookings"]["Items"][i]['date'],
            did: n["bookings"]["Items"][i]['did'],
            status: n["bookings"]["Items"][i]['status'],
            time: n["bookings"]["Items"][i]['time'],
            uid: n["bookings"]["Items"][i]['uid'],
            link: n["bookings"]["Items"][i]['link']);
    }
  }

  List<BookingModel> bm = [];
  List<BookingModel> get bms => bm;

  void addbms(
      {String? bid,
      String? did,
      String? date,
      String? time,
      String? uid,
      String? status,
      String? link}) {
    bms.add(BookingModel(
        bid: bid,
        did: did,
        date: date,
        time: time,
        uid: uid,
        status: status,
        link: link));
    notifyListeners();
  }

  void remove() {
    bms.clear();
    notifyListeners();
  }
}
