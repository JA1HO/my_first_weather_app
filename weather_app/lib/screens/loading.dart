import 'package:flutter/material.dart';
import 'package:weather_app/data/my_location.dart';
import 'package:weather_app/data/network.dart';
import 'package:weather_app/screens/weather_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const APIKEY = "597ae83fb9e4718f23dcb2c7ecce3444";

class Loading extends StatefulWidget {

  @override
  _LoadingState createState() => _LoadingState();

}

class _LoadingState extends State<Loading> {

  double latitude3 = 0;
  double longitude3 = 0;

  void initState(){
    super.initState();
    getLocation();
  }
  void getLocation() async{
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude3 = myLocation.latitude2;
    longitude3 = myLocation.longitude2;

    print(latitude3);
    print(longitude3);

    Network network = Network('https://api.openweathermap.org/data/2.5/weather?lat=$latitude3&lon=$longitude3&appid=$APIKEY&units=metric');
    var weatherData = await network.getJsonData();
    print(weatherData);

    Network network1 = Network("http://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude3&lon=$longitude3&appid=$APIKEY");
    var pollutionData = await network1.getJsonData();
    print(pollutionData);

    Navigator.push(context, MaterialPageRoute(builder: (context){
      return WeatherScreen(parseWeatherData: weatherData, parsePollutionData: pollutionData,);
    }));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
