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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to Weather App"),
          centerTitle: true,
        ),
        body: Padding(
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
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    decoration: new InputDecoration(
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
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF0091cf),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text('City')),
                ),
              ),
              weatherBox(),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 100,
              //   color: Colors.blue,
              //   child: Row(
              //     children: [
              //
              //     ],
              //   )
              //   // Text(
              //   //     // '${CurrentCity.query}'
              //   //   //'${response.data["request"]['type']}',
              //   //     'err'
              //   //   ),
              // ),
              Container(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget weatherBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width /2 - 70,
                  decoration: BoxDecoration(
                    //border: Border.all(color: const Color(0xFFFFCF4E)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width / 2 - 80,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage('https://assets.weatherstack.com/images/wsymbols01_png_64/wsymbol_0002_sunny_intervals.png'),
                                fit: BoxFit.cover,
                              ),
                              shape: BoxShape.rectangle),
                        ),
                      )
                    ],
                  )),
              Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width /2 - 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFFCF4E)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width / 2 - 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("textOne",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                )),
                            Text('textTwo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                )),
                            Text('textTwo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                )),
                            Text('textTwo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                )),
                            Text('textTwo',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                )),

                          ],
                        ),
                      ),

                    ],
                  ))
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
