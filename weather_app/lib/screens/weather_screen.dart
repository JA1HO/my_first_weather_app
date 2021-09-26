import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/model.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const MAP_API = "AIzaSyDh5N1CvKXoghUgNJOkmnoZto0HsMTQaHk";

class WeatherScreen extends StatefulWidget {
  WeatherScreen({this.parseWeatherData, this.parsePollutionData});
  final parseWeatherData;
  final parsePollutionData;
  static final kInitialPosition = LatLng(0.0, 0.0);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Model model = Model();
  String cityName = "";
  var temp = 0;
  var date = DateTime.now();
  late Widget icon;
  late Widget airIcon;
  late Widget airState;
  late String des;
  late double fineDust;
  late double superFineDust;


  void initState(){
    super.initState();
    initData(widget.parseWeatherData, widget.parsePollutionData);
  }

  void initData(dynamic weatherData, dynamic pollutionData){
      double temp2 = weatherData['main']['temp'].toDouble();
      temp = temp2.round();
      cityName = weatherData['name'];
      int condition = weatherData['weather'][0]['id'];
      des = weatherData['weather'][0]['description'];

      int index = pollutionData['list'][0]['main']['aqi'];
      fineDust = pollutionData['list'][0]['components']['pm2_5'];
      superFineDust = pollutionData['list'][0]['components']['pm10'];

      icon = model.getWeatherIcon(condition);
      airIcon = model.getAirIcon(index);
      airState = model.getAirCondition(index);

      print(temp);
      print(cityName);
      print(des);
  }

  void updateData(dynamic weatherData, dynamic pollutionData){
    setState((){
      double temp2 = weatherData['main']['temp'].toDouble();
      temp = temp2.round();
      cityName = weatherData['name'];
      int condition = weatherData['weather'][0]['id'];
      des = weatherData['weather'][0]['description'];

      int index = pollutionData['list'][0]['main']['aqi'];
      fineDust = pollutionData['list'][0]['components']['pm2_5'];
      superFineDust = pollutionData['list'][0]['components']['pm10'];

      icon = model.getWeatherIcon(condition);
      airIcon = model.getAirIcon(index);
      airState = model.getAirCondition(index);
    }
    );
  }

  String getSystemTime(){
    var now = DateTime.now();
    return DateFormat("h:mm a").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("",),
        leading: IconButton(
          icon: Icon(Icons.near_me),
          onPressed: (){
            updateData(widget.parseWeatherData, widget.parsePollutionData);
          },
          iconSize: 30.0,
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.favorite,
                ),
                onPressed: (){
                  Scaffold.of(context).openEndDrawer();
                },
                iconSize: 30.0,
              );
            }
          )
        ],
      ),
        endDrawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text("My Favorate Cities",
                style: TextStyle(
                  color : Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),),
                tileColor: Colors.black,
              ),
              ListTile(
                title: Text("Paris",
                style: TextStyle(
                  color:Colors.blueAccent,
                  fontSize: 15.0,
                ),
                ),
                onTap: (){
                  
                },
              ),
              ListTile(
                title: Text("Seoul",
                  style: TextStyle(
                    color:Colors.blueAccent,
                    fontSize: 15.0,
                  ),
                ),
                onTap: (){

                },
              ),
              ListTile(
                title: Text("London",
                  style: TextStyle(
                    color:Colors.blueAccent,
                    fontSize: 15.0,
                  ),
                ),
                onTap: (){

                },
              ),
            ],
          ),
        ),
      body: Container(
        child: Stack(
          children: [
            Image.asset("images/background.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          "$cityName",
                          style: GoogleFonts.lato(
                            fontSize: 35.0,
                            fontWeight:  FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        Row(
                          children: [
                            TimerBuilder.periodic(
                                Duration(minutes: 1),
                                builder: (context) {
                                  print("${getSystemTime()}");
                                  return Text(
                                    '${getSystemTime()}',
                                    style: GoogleFonts.lato(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                                ),
                            Text(
                              DateFormat(" - EEEE, ").format(date),
                              style: GoogleFonts.lato(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              DateFormat("d MMM, yyy").format(date),
                              style: GoogleFonts.lato(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$temp\u2103',
                            style: GoogleFonts.lato(
                                fontSize: 85.0,
                                fontWeight:  FontWeight.w300,
                                color: Colors.white
                            ),
                          ),
                          Row(
                            children: [
                              icon,
                              SizedBox(
                                width:10.0,
                              ),
                              Text("$des",
                                style: GoogleFonts.lato(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                        ],
                    ),
                ]
            ),
          ),
                  Column(
                    children: [
                      Divider(
                        height: 15.0,
                        thickness: 2.0,
                        color: Colors.white30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children:[
                              Text(
                                "AQI(대기질지수)",
                                style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    fontWeight:  FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                              SizedBox(
                                height:10.0,
                              ),
                              airIcon,
                              SizedBox(
                                height:10.0,
                              ),
                              airState,
                            ]
                      ),
                          Column(
                              children:[
                                Text(
                                  "미세먼지",
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      fontWeight:  FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height:10.0,
                                ),
                                Text(
                                  "$fineDust",
                                  style: GoogleFonts.lato(
                                      fontSize: 24.0,
                                      fontWeight:  FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  "ug/m3",
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      fontWeight:  FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ]
                          ),
                          Column(
                              children:[
                                Text(
                                  "초 미세먼지",
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      fontWeight:  FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(
                                  height:10.0,
                                ),
                                Text(
                                  "$superFineDust",
                                  style: GoogleFonts.lato(
                                      fontSize: 24.0,
                                      fontWeight:  FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                                Text(
                                  "ug/m3",
                                  style: GoogleFonts.lato(
                                      fontSize: 14.0,
                                      fontWeight:  FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ]
                          )
                    ],)]
                  )

        ]
              ),

          )
        ],

      ),
    )
  );
}
}
