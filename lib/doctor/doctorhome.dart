import 'package:flutter/material.dart';
import 'package:heart_rate/doctor/new_bookings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/bookingapi.dart';
import '../constants.dart';

class DoctorHome extends StatefulWidget {
  @override
  _DoctorHomeState createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  List<String> _bookings = [
    'John Doe (April 29, 2023 at 10:00am)',
    'Jane Smith (May 2, 2023 at 2:30pm)',
    'Mike Johnson (May 5, 2023 at 11:15am)',
  ];

  void didChangeDependencies() {
    super.didChangeDependencies();
    callapi();
  }

  callapi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('did').toString();
    Provider.of<BookingApi>(context, listen: false)
        .getConfirmBookingDetailsDoctor(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingApi>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text('Doctor Home'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String id = preferences.getString('did').toString();
                  Provider.of<BookingApi>(context, listen: false)
                      .getConfirmBookingDetailsDoctor(id: id);
                },
                child: Text("Refresh"))
          ],
        ),
        drawer: Drawer(),
        body: value.bm.length <= 0
            ? Container(
                child: Center(child: Text('No Bookings')),
              )
            : ListView.builder(
                itemCount: value.bm.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(value.bm[index].time!),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.pushNamed(
                            context, PageRouteNames.prebuilt_call,
                            arguments: <String, String>{
                              PageParam.call_id: 'hi',
                            });
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => BookingPage()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
