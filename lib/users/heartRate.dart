import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:heart_rate/api/userapi.dart';
import 'package:heart_rate/model/heartmodel.dart';
import 'package:heart_rate/styles/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HealthApp extends StatefulWidget {
  @override
  _HealthAppState createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  List<HealthDataPoint> _healthDataList = [];
  List<String> healthL = [];
  List<String> dateData = [];
  List<Heart> h = [];

  Future fetchData() async {
    // create a HealthFactory for use in the app
    HealthFactory health = HealthFactory();

    // define the types to get
    var types = [
      HealthDataType.STEPS,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEART_RATE,
    ];

    // requesting access to the data types before reading them
    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    types = [HealthDataType.HEART_RATE];
    var permissions = [HealthDataAccess.READ_WRITE];
    await health.requestAuthorization(types, permissions: permissions);

    List<HealthDataPoint> success = await health.getHealthDataFromTypes(
        DateTime(2022), DateTime(2024), types);
    healthL.clear();
    dateData.clear();
    print(success[1]);

    for (int i = 0; i < success.length; i++) {
      healthL.add(success[i].value.toString());
      dateData.add(success[i].dateFrom.toString());
    }
    print(healthL);
    print(dateData);
    h.clear();
    for (int i = 0; i < healthL.length; i++) {
      h.add(Heart(hrate: healthL[i], date: dateData[i]));
    }

    h.forEach((v) {
      Provider.of<UserApi>(context, listen: false)
          .updateDetails(v.hrate, v.date);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(MyColors.primary),
        title: const Text('Heart rate'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              fetchData();
            },
          ),
        ],
      ),
      body: healthL.length <= 0
          ? Center(
              child: Container(
                child: Text("No data"),
              ),
            )
          : Container(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Heart rate analysis'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<Heart, String>>[
                    LineSeries<Heart, String>(
                        dataSource: h,
                        xValueMapper: (Heart sales, _) =>
                            sales.date.toString().split(' ')[0],
                        yValueMapper: (Heart sales, _) =>
                            double.parse(sales.hrate!).toInt(),
                        name: 'Sales',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ]),
              //   ListView.builder(
              //   itemCount: healthL.length,
              //   itemBuilder: (context, index) {
              //     return Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text("Heart Rate"),
              //             SizedBox(
              //               width: 20,
              //             ),
              //             Text("Date")
              //           ],
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(healthL[index].toString()),
              //             SizedBox(
              //               width: 20,
              //             ),
              //             Text(dateData[index].toString())
              //           ],
              //         ),
              //       ],
              //     );
              //   },
              // )
            ),
    );
  }
}
