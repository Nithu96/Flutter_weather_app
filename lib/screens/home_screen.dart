import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/screens/login_screen.dart';

import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  TextEditingController _cityName = TextEditingController();

  late Response response;

  var dio = Dio();
  CurrentCity? currentCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Weather App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 40, bottom: 20, right: 20),
                child: Container(
                  //width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextField(
                    controller: _cityName,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: InputDecoration(
                      // icon: new Icon(Icons.search),
                      labelText: "City",
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      contentPadding: EdgeInsets.all(20.0),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: const BorderSide(
                          color: Color(0xFF283946),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Color(0xFF283946)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        // Optionally the request above could also be done as
                        var response = await dio.get(
                            'http://api.weatherstack.com/current',
                            queryParameters: {
                              'access_key': "f237fe9f82a482e1e3e2c14d5037ac1f",
                              'query': _cityName.text
                            });
                        print(response.data);
                        print(response.data["request"]);
                        print(response.data["request"]['type']);
                        currentCity = CurrentCity.fromSnapshot(response.data);
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF0091cf),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('City')),
                ),
              ),
              currentCity == null ? Container() : weatherBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: () async {
                        logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF0091cf),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('Log out')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget weatherBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width / 2 - 80,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("${currentCity?.current!['weather_icons'][0]}"),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.rectangle),
                    ),
                  )
                ],
              ),
              SizedBox(width: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 420,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${currentCity?.location!['name']}",
                      maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            )),
                        Text("${currentCity?.location!['region']}",
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("Lat : " '${currentCity?.location!['lat']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("Lon : "'${currentCity?.location!['lon']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("TimeZone: "'${currentCity?.location!['timezone_id']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("localtime : "'${currentCity?.location!['localtime']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("localtime epoch : "'${currentCity?.location!['localtime_epoch']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("utc offset : "'${currentCity?.location!['utc_offset']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("observation time : "'${currentCity?.current!['observation_time']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("temperature : "'${currentCity?.current!['temperature']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("weather code : "'${currentCity?.current!['weather_code']}',
                          maxLines: 20,style:const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("weather descriptions : "'${currentCity?.current!['weather_descriptions'][0]}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("wind speed : "'${currentCity?.current!['wind_speed']}',
                          maxLines: 20,style:const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("wind degree : "'${currentCity?.current!['wind_degree']}',
                          maxLines: 20,style:const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("wind dir : "'${currentCity?.current!['wind_dir']}',
                          maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("pressure : "'${currentCity?.current!['pressure']}',
                            maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("precip : "'${currentCity?.current!['precip']}',
                            maxLines: 20,style:const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("humidity : "'${currentCity?.current!['humidity']}',
                            maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("cloud cover : "'${currentCity?.current!['cloudcover']}',
                            maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("feels like : "'${currentCity?.current!['feelslike']}',
                            maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("uv index : "'${currentCity?.current!['uv_index']}',
                            maxLines: 20,style:const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("cloud cover : "'${currentCity?.current!['cloudcover']}',
                            maxLines: 20,style:const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("visibility : "'${currentCity?.current!['visibility']}',
                            maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                        Text("is_day : "'${currentCity?.current!['is_day']}',
                            maxLines: 20,style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                            )),
                      ],
                    ),
                  ),

                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
