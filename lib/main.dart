// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:heart_rate/api/bookingapi.dart';
import 'package:heart_rate/api/doctorapi.dart';
import 'package:heart_rate/api/imagetotext.dart';
import 'package:heart_rate/api/userapi.dart';
import 'package:provider/provider.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final cacheUserID = prefs.get(cacheUserIDKey) as String? ?? '';
  if (cacheUserID.isNotEmpty) {
    currentUser.id = cacheUserID;
    currentUser.name = 'user_$cacheUserID';
  }

  final navigatorKey = GlobalKey<NavigatorState>();
  ZegoUIKit().initLog().then((value) {
    runApp(MyApp(
      navigatorKey: navigatorKey,
    ));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String? ids;

  void initState() {
    super.initState();
    // Call your function here
    performTaskOnPageLoad();
  }

  Future<void> performTaskOnPageLoad() async {
    // Perform your task here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    setState(() {
      ids = id;
    });
    print("hey $ids");
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserApi()),
          ChangeNotifierProvider.value(value: DoctorApi()),
          ChangeNotifierProvider.value(value: BookingApi()),
          ChangeNotifierProvider.value(value: ImageApi()),
        ],
        child: MaterialApp(
          routes: routes,
          initialRoute: PageRouteNames.signin,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
          navigatorKey: widget.navigatorKey,
          builder: (BuildContext context, Widget? child) {
            return Stack(
              children: [
                child!,
                ZegoUIKitPrebuiltCallMiniOverlayPage(
                  contextQuery: () {
                    return widget.navigatorKey.currentState!.context;
                  },
                ),
              ],
            );
          },
        ));
  }
}
