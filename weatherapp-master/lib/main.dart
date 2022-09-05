import 'dart:convert';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/settings.dart';
import 'package:http/http.dart' as http;

void main() {
  initializeDateFormatting('ru');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static int temperature = 0;
  static int wind = 0;
  static int pressure = 0;

  static double temperature_value = 0;
  static double temperature_value_6 = 0;
  static double temperature_value_12 = 0;
  static double temperature_value_18 = 0;
  static String desc = "";
  static String desc_6 = "";
  static String desc_12 = "";
  static String desc_18 = "";
  static String time = "";
  static String time_6 = "";
  static String time_12 = "";
  static String time_18 = "";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage('Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage(this.title);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getImage(String desc) {
    String img = "";
    switch (desc) {
      case "Snow":
        img = "assets/images/snowy.png";
        break;
      case "Clouds":
        img = "assets/images/cloudy.png";
        break;
    }
    return img;
  }

  getSettings() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    MyApp.temperature = (sp.getInt("temperature") ?? 0);
    MyApp.wind = (sp.getInt("wind") ?? 0);
    MyApp.pressure = (sp.getInt("pressure") ?? 0);
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/onecall?lat=59.93&lon=30.30&exclude=minutely,daily,alerts&appid=8f8e8f48dd09df4c3eb379f88e838f39");
    var response = jsonDecode((await http.get(url)).body);
    //print(jsonDecode(response.body));
    print(response['current']);
    print("====");
    print(response['hourly'][6]);
    print(response['hourly'][12]);
    print(response['hourly'][18]);

    var formatter = new DateFormat('HH');
    MyApp.temperature_value = response['current']['temp'];
    MyApp.desc = response['current']['weather'][0]['main'];
    MyApp.time = formatter.format(
        DateTime.fromMillisecondsSinceEpoch(response['current']['dt'] * 1000)
            .add(new Duration(hours: 3)));

    MyApp.temperature_value_6 = response['hourly'][6]['temp'];
    MyApp.desc_6 = response['hourly'][6]['weather'][0]['main'];
    MyApp.time_6 = formatter.format(
        DateTime.fromMillisecondsSinceEpoch(response['hourly'][6]['dt'] * 1000)
            .add(new Duration(hours: 3)));

    MyApp.temperature_value_12 = response['hourly'][12]['temp'];
    MyApp.desc_12 = response['hourly'][12]['weather'][0]['main'];
    MyApp.time_12 = formatter.format(
        DateTime.fromMillisecondsSinceEpoch(response['hourly'][12]['dt'] * 1000)
            .add(new Duration(hours: 3)));

    MyApp.temperature_value_18 = response['hourly'][18]['temp'];
    MyApp.desc_18 = response['hourly'][18]['weather'][0]['main'];
    MyApp.time_18 = formatter.format(
        DateTime.fromMillisecondsSinceEpoch(response['hourly'][18]['dt'] * 1000)
            .add(new Duration(hours: 3)));
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.68,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Weather App",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  shape: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12)),
                  leading: Icon(
                    CupertinoIcons.settings,
                  ),
                  title: const Text('Настройки'),
                  horizontalTitleGap: -5,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Settings(setState)),
                    );
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  shape: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12)),
                  leading: Icon(
                    CupertinoIcons.heart_fill,
                  ),
                  title: const Text('Избранное'),
                  horizontalTitleGap: -5,
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  shape: Border(
                      bottom: BorderSide(width: 1, color: Colors.black12)),
                  leading: Icon(
                    CupertinoIcons.info,
                  ),
                  title: const Text('О приложении'),
                  horizontalTitleGap: -5,
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          ),
        ),
        key: _globalKey,
        body: ExpandableBottomSheet(
          background: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/day_theme.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NeumorphicButton(
                    style: NeumorphicStyle(
                      lightSource: LightSource.topLeft,
                      color: Colors.transparent,
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.circle(),
                      // shadowDarkColor: ,
                      depth: 1,
                    ),
                    child: NeumorphicIcon(
                      CupertinoIcons.circle_grid_3x3_fill,
                      size: 30,
                    ),
                    onPressed: () {
                      _globalKey.currentState!.openDrawer();
                    },
                  ),
                  FutureBuilder(
                      future: getSettings(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (MyApp.temperature == 0) ...[
                                Text(
                                    (MyApp.temperature_value - 273.15)
                                            .round()
                                            .toString() +
                                        "°C",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 55,
                                    )),
                              ] else ...[
                                Text(
                                    (MyApp.temperature_value * 1.8 - 459.6)
                                            .round()
                                            .toString() +
                                        "°F",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 55,
                                    )),
                              ],
                            ],
                          );
                        return Container(
                            child: Center(child: CircularProgressIndicator()));
                      }),
                  NeumorphicButton(
                    style: NeumorphicStyle(
                      lightSource: LightSource.topLeft,
                      color: Colors.transparent,
                      shape: NeumorphicShape.convex,
                      boxShape: NeumorphicBoxShape.circle(),
                      // shadowDarkColor: ,
                      depth: 1,
                    ),
                    child: NeumorphicIcon(
                      CupertinoIcons.add,
                      size: 30,
                    ),
                    onPressed: () {
                      print("add_town");
                    },
                  ),
                ],
              ),
            ),
          ),
          persistentContentHeight: 250,
          persistentHeader: Container(
            decoration: BoxDecoration(
                color: Color(0xFFE2EBFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
            height: 40,
            child: Center(
              child: Container(
                height: 4,
                width: 125,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
            ),
          ),
          expandableContent: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 500,
            color: Color(0xFFE2EBFF),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                          depth: 8,
                          lightSource: LightSource.topLeft,
                          color: Color(0xFFE2EBFF),
                        ),
                        child: Container(
                            height: 115,
                            width: 75,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((MyApp.time).toString() + ":00",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Container(
                                    width: 60,
                                    height: 50,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(getImage(MyApp.desc)),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  if (MyApp.temperature == 0) ...[
                                    Text(
                                        (MyApp.temperature_value - 273.15)
                                                .round()
                                                .toString() +
                                            "°C",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ] else ...[
                                    Text(
                                        (MyApp.temperature_value * 1.8 - 459.6)
                                                .round()
                                                .toString() +
                                            "°F",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ]
                                ]))),
                    Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                          depth: 8,
                          lightSource: LightSource.topLeft,
                          color: Color(0xFFE2EBFF),
                        ),
                        child: Container(
                            height: 115,
                            width: 75,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((MyApp.time_6).toString() + ":00",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Container(
                                    width: 60,
                                    height: 50,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage(getImage(MyApp.desc_6)),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  if (MyApp.temperature == 0) ...[
                                    Text(
                                        (MyApp.temperature_value_6 - 273.15)
                                                .round()
                                                .toString() +
                                            "°C",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ] else ...[
                                    Text(
                                        (MyApp.temperature_value_6 * 1.8 - 459.6)
                                                .round()
                                                .toString() +
                                            "°F",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ]
                                ]))),
                    Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                          depth: 8,
                          lightSource: LightSource.topLeft,
                          color: Color(0xFFE2EBFF),
                        ),
                        child: Container(
                            height: 115,
                            width: 75,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((MyApp.time_12).toString() + ":00",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Container(
                                    width: 60,
                                    height: 50,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage(getImage(MyApp.desc_12)),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  if (MyApp.temperature == 0) ...[
                                    Text(
                                        (MyApp.temperature_value_12 - 273.15)
                                                .round()
                                                .toString() +
                                            "°C",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ] else ...[
                                    Text(
                                        (MyApp.temperature_value_12 * 1.8 - 459.6)
                                                .round()
                                                .toString() +
                                            "°F",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ]
                                ]))),
                    Neumorphic(
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                          depth: 8,
                          lightSource: LightSource.topLeft,
                          color: Color(0xFFE2EBFF),
                        ),
                        child: Container(
                            height: 115,
                            width: 75,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text((MyApp.time_18).toString() + ":00",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      )),
                                  Container(
                                    width: 60,
                                    height: 50,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage(getImage(MyApp.desc_18)),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  if (MyApp.temperature == 0) ...[
                                    Text(
                                        (MyApp.temperature_value_18 - 273.15)
                                                .round()
                                                .toString() +
                                            "°C",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ] else ...[
                                    Text(
                                        (MyApp.temperature_value_18 * 1.8 - 459.6)
                                                .round()
                                                .toString() +
                                            "°F",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        )),
                                  ]
                                ])))
                  ],
                ),
                NeumorphicButton(
                    margin: EdgeInsets.only(top: 20),
                    style: NeumorphicStyle(
                      border: NeumorphicBorder(width: 3, color: Colors.blue),
                      depth: 10,
                      color: Color(0xFFE2EBFF),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "Расписание на неделю",
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
