import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class other_profile_subs extends StatefulWidget {
  var particular_dude;

  other_profile_subs({Key key, @required this.particular_dude})
      : super(key: key);

  @override
  _other_profile_subsState createState() => _other_profile_subsState();
}

class _other_profile_subsState extends State<other_profile_subs> {
  List<Widget> all_subscription_people_container = [];

  var received_response = false;

  var theme_type = 'light';

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
        'https://pridamo.com/profile/app_other_profile_subscriptions?profile_user=${widget.particular_dude}&num=$num&change=$change',
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
        all_subscription_people_container.add(profile_card(datum['profile_url'], datum['user_name'], datum['mine_or_not']));
      });
    });

    num += 10;

    change += 10;
  }

  var initial_subscription_results;

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
        title: Text('Profiles subscribed to'),
      ),
      body: FutureBuilder(
        future: initial_subscription_results,
        builder: (context, snapshot){
          if(all_subscription_people_container.isEmpty){
            return received_response != true ? Center(
              child: CircularProgressIndicator(),
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
                  ) : SizedBox.shrink()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget profile_card(image_url, name, mine_or_not){
    return ListTile(
      onTap: (){
        mine_or_not == 'no' ? Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => read_another_profile(particular_dude: name),
          ),
        ) : null;
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
}
