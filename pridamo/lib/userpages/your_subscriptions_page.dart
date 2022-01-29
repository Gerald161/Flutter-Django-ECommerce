import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class subscription_page extends StatefulWidget {
  @override
  _subscription_pageState createState() => _subscription_pageState();
}

class _subscription_pageState extends State<subscription_page> {
  List<Widget> all_subscription_people_container = [];

  var received_response = false;

  var num = 0;

  var change = 10;

  var show_more_button = true;

  var show_prog_indicator_for_show_more = false;

  get_initial_subscriptions()async{
    setState(() {
      show_prog_indicator_for_show_more = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_your_subscriptions_page?num=$num&change=$change',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    setState(() {
      received_response = true;

      show_prog_indicator_for_show_more = false;
    });

    if(data[0]['show_more'] == 'yes'){
      setState(() {
        show_more_button = true;
      });
    }else{
      setState(() {
        show_more_button = false;
      });
    }

    data.forEach((datum){
      setState(() {
        all_subscription_people_container.add(profile_card(datum['profile_url'], datum['user_name']));
      });
    });

    num += 10;

    change += 10;
  }

  var initial_subscription_results;

  var theme_type = 'light';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_subscription_results = get_initial_subscriptions();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Subscriptions',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initial_subscription_results,
        builder: (context, snapshot){
          if(all_subscription_people_container.isEmpty){
            return received_response != true ? Shimmer.fromColors(
              highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
              baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                    notification_shimmer(),
                  ],
                ),
              ),
            ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Center(child: Text('No added subscriptions')),
                    ],
                  ),
                ],
            );
          }else{
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: all_subscription_people_container,
                  ),
                  show_more_button == true ? show_prog_indicator_for_show_more == false ? FlatButton(
                    child: Text('Show more'),
                    textColor: Colors.blue,
                    onPressed: (){
                      get_initial_subscriptions();
                    },
                  ) : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                    : SizedBox.shrink()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget profile_card(image_url, name){
    return ListTile(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => read_another_profile(particular_dude: name),
          ),
        );
      },
      title: Text(
        toBeginningOfSentenceCase(name),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/$image_url'),
        radius: 25.0,
      ),
    );
  }

  Widget notification_shimmer(){
    return ListTile(
      title: Container(
        width: MediaQuery.of(context).size.width * 0.40,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Text(
            ''
        ),
      ),
      leading: CircleAvatar(

      ),
    );
  }
}
