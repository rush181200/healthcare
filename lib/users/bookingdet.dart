import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:provider/provider.dart';

import '../api/bookingapi.dart';

class BookingDets extends StatefulWidget {
  const BookingDets({super.key});

  @override
  State<BookingDets> createState() => _BookingDetsState();
}

class _BookingDetsState extends State<BookingDets> {
  int? _selectedRadioValue;
  String? bid;
  String? datetime;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingApi>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Booking Details'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Provider.of<BookingApi>(context, listen: false)
                      .updateBookingDetails(id: bid, link: datetime);
                  Navigator.of(context).pop();
                  FlutterToastr.show("Booked", context);
                },
                child: Text('Book'))
          ],
        ),
        body: ListView.builder(
          itemCount: value.bms.length,
          itemBuilder: (context, index) => RadioListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(value.bm[index].date.toString().split(' ')[0]),
                    Text(value.bm[index].time.toString())
                  ],
                )
              ],
            ),
            value: index,
            groupValue: _selectedRadioValue,
            onChanged: (value1) {
              setState(() {
                _selectedRadioValue = value1;
                bid = value.bm[index].bid.toString();
                datetime =
                    value.bm[index].date.toString().split(' ')[0].toString() +
                        value.bm[index].time.toString();
              });
            },
          ),
        ),
      ),
    );
  }
}
