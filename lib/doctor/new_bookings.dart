import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:heart_rate/api/bookingapi.dart';
import 'package:heart_rate/model/bookingmodel.dart';
import 'package:provider/provider.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedDate;
  List<String> _availableTimes = [
    '10:00am',
    '10:30 am',
    '11:00am',
    '11:30am',
    '2:00pm',
    '2:30pm',
    '3:00pm',
    '3:30pm',
    '4:00pm',
    '4:30pm',
    '5:00pm',
  ];
  List<String> _selectedTimes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callapi();
  }

  callapi() {
    Provider.of<BookingApi>(context, listen: false).getBookingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingApi>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Choose your Appointment Date and Time'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select a Date:'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    setState(() {
                      _selectedDate = value!;
                      _selectedTimes.clear();
                    });
                  });
                },
                child: Text(_selectedDate == null
                    ? 'Choose Date'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select Time(s):'),
            ),
            if (_selectedDate != null)
              Container(
                height: 100.0,
                child: ListView.builder(
                  itemCount: _availableTimes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final isSelected =
                        _selectedTimes.contains(_availableTimes[index]);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isSelected) {
                              _selectedTimes.remove(_availableTimes[index]);
                            } else {
                              _selectedTimes.add(_availableTimes[index]);
                              Provider.of<BookingApi>(context, listen: false)
                                  .getBookingDetails()
                                  .then((value) => Provider.of<BookingApi>(
                                          context,
                                          listen: false)
                                      .sendBooking(
                                        date: _selectedDate!.toString(),
                                        time: _availableTimes[index],
                                      )
                                      .then((value) => FlutterToastr.show(
                                          "Successfully Added", context)));
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              isSelected ? Colors.blue : Colors.grey),
                        ),
                        child: Text(_availableTimes[index]),
                      ),
                    );
                  },
                ),
              ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    // if (_selectedTimes.length <= 0) {
                    //   FlutterToastr.show("Select time", context);
                    // } else {
                    //   book.clear();
                    //   for (int i = 0; i < _selectedTimes.length; i++) {
                    //   Provider.of<BookingApi>(context, listen: false)
                    //       .sendBooking(
                    //     date: _selectedDate!.toString(),
                    //     time: _selectedTimes[i],
                    //   );
                    // }
                    //   FlutterToastr.show("Successfully Added", context);
                    // }
                    Navigator.of(context).pop();
                  },
                  child: Text('Done')),
            ),
          ],
        ),
      ),
    );
  }
}
