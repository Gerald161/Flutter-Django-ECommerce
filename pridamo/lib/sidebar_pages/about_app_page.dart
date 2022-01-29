import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class about_app_page extends StatefulWidget {
  @override
  _about_app_pageState createState() => _about_app_pageState();
}

class _about_app_pageState extends State<about_app_page> {
  List<Widget> all_steps_gotten = [];

  var initial_future;

  get_map_steps() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_about',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var all_steps = jsonDecode(response.body);

    all_steps.forEach((step){
      setState(() {
        all_steps_gotten.add(
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(step['step']),
            )
        );
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_future = get_map_steps();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Pridamo'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: initial_future,
          builder: (context, snapshot){
            if(all_steps_gotten.isNotEmpty){
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: all_steps_gotten,
                ),
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}
