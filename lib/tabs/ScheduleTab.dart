import 'package:flutter/material.dart';
import 'package:heart_rate/api/bookingapi.dart';
import 'package:heart_rate/constants.dart';
import 'package:heart_rate/styles/colors.dart';
import 'package:heart_rate/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

enum FilterStatus { Upcoming, Complete, Cancel }

List<Map> schedules = [
  {
    'img': 'assets/doctor01.jpeg',
    'doctorName': 'Dr. Anastasya Syahid',
    'doctorTitle': 'Dental Specialist',
    'reservedDate': 'Monday, Aug 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  },
  {
    'img': 'assets/doctor02.png',
    'doctorName': 'Dr. Mauldya Imran',
    'doctorTitle': 'Skin Specialist',
    'reservedDate': 'Monday, Sep 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  },
  {
    'img': 'assets/doctor03.jpeg',
    'doctorName': 'Dr. Rihanna Garland',
    'doctorTitle': 'General Specialist',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  },
  {
    'img': 'assets/doctor04.jpeg',
    'doctorName': 'Dr. John Doe',
    'doctorTitle': 'Something Specialist',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Complete
  },
  {
    'img': 'assets/doctor05.jpeg',
    'doctorName': 'Dr. Sam Smithh',
    'doctorTitle': 'Other Specialist',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Cancel
  },
  {
    'img': 'assets/doctor05.jpeg',
    'doctorName': 'Dr. Sam Smithh',
    'doctorTitle': 'Other Specialist',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Cancel
  },
];

class _ScheduleTabState extends State<ScheduleTab> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    callapi();
  }

  callapi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('uid').toString();
    Provider.of<BookingApi>(context, listen: false)
        .getConfirmBookingDetailsUser(id: id);
  }

  @override
  Widget build(BuildContext context) {
    List<Map> filteredSchedules = schedules.where((var schedule) {
      return schedule['status'] == status;
    }).toList();

    return Consumer<BookingApi>(
      builder: (context, value, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Schedule',
                textAlign: TextAlign.center,
                style: kTitleStyle,
              ),
              ElevatedButton(
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String id = preferences.getString('uid').toString();
                    Provider.of<BookingApi>(context, listen: false)
                        .getConfirmBookingDetailsUser(id: id);
                  },
                  child: Text('Refresh')),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: value.bm.length,
                  itemBuilder: (context, index) {
                    bool isLastElement = value.bm.length + 1 == index;
                    return Card(
                      margin: !isLastElement
                          ? EdgeInsets.only(bottom: 20)
                          : EdgeInsets.zero,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // CircleAvatar(
                                //   backgroundImage: AssetImage(_schedule['img']),
                                // ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.bm[index].date!,
                                      style: TextStyle(
                                        color: Color(MyColors.header01),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      value.bm[index].time!,
                                      style: TextStyle(
                                        color: Color(MyColors.grey02),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (ZegoUIKitPrebuiltCallMiniOverlayMachine()
                                        .isMinimizing) {
                                      /// when the application is minimized (in a minimized state),
                                      /// disable button clicks to prevent multiple PrebuiltCall components from being created.
                                      return;
                                    }

                                    Navigator.pushNamed(
                                        context, PageRouteNames.prebuilt_call,
                                        arguments: <String, String>{
                                          PageParam.call_id: 'hi',
                                        });
                                  },
                                  child: const Text('Call Button'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            DateTimeCard(),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  const DateTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg03),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color(MyColors.primary),
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Mon, July 29',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.access_alarm,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '11:00 ~ 12:10',
                style: TextStyle(
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
