import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:weather/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  Settings(this.setState, {Key? key}) : super(key: key);

  Function(VoidCallback fn) setState;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 5),
          child: ListView(children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.back)),
                Text(
                  "Настройки",
                  style: TextStyle(
                    fontSize: 19,
                  ),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Единицы измерения",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Neumorphic(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("Температура"),
                            ),
                            Expanded(
                              flex: 3,
                              child: Toggle("°C", "°F", 0),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text("Сила ветра"),
                          ),
                          Expanded(
                            flex: 3,
                            child: Toggle("м/c", "км/ч", 1),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text("Давление"),
                            ),
                            Expanded(
                              flex: 3,
                              child: Toggle("мм.рт.ст", "гПа", 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}

class Toggle extends StatefulWidget {
  String unit1;
  String unit2;
  int number;

  Toggle(
      this.unit1,
      this.unit2,
      this.number,{
        Key? key,
      }) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();


}

class _ToggleState extends State<Toggle> {
  int index = 0;

  setSettings(String key,int value)
  async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setInt(key, value);
    print(sp.getInt(key));

  }
  getSettings()
  async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
        MyApp.temperature = (sp.getInt("temperature") ?? 0);
        MyApp.wind = (sp.getInt("wind") ?? 0);
        MyApp.pressure = (sp.getInt("pressure") ?? 0);
    });
  }


  @override
  Widget build(BuildContext context) {

    getSettings();
    if(widget.number == 0)
    {
      index = MyApp.temperature;
    }
    if(widget.number == 1)
    {
      index = MyApp.wind;
    }
    if(widget.number == 2)
    {
      index = MyApp.pressure;
    }
    return NeumorphicToggle(

      selectedIndex: index,
      onChanged: (value) {
        setState(() {

          if(widget.number == 0)
          {
            MyApp.temperature = value;
            setSettings("temperature", value);

          }
          if(widget.number == 1)
          {
            MyApp.wind = value;
            setSettings("wind", value);
          }
          if(widget.number == 2)
          {
            MyApp.pressure = value;
            setSettings("pressure", value);
          }



        });
      },
      children: [
        ToggleElement(
          background: Container(
            child: Center(
              child: Text(widget.unit1),
            ),
          ),
          foreground: Container(
            child: Center(
              child: Text(widget.unit1, style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        ToggleElement(
          background: Container(
            child: Center(
              child: Text(widget.unit2),
            ),
          ),
          foreground: Container(
            child: Center(
              child: Text(
                widget.unit2,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
      thumb: Container(
        color: Colors.blueGrey,
      ),
    );
  }
}

