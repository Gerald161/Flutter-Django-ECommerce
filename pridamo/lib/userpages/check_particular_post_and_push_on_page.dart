import 'package:flutter/material.dart';
import 'package:pridamo/account_pages/signup.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:pridamo/account_pages/signin.dart';
import 'package:pridamo/main_page/all_user_pages.dart';
import 'package:pridamo/theme_changer.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class check_particular_post_and_push_on_page extends StatefulWidget {
  var snapshotdata;

  check_particular_post_and_push_on_page({Key key, @required this.snapshotdata})
      : super(key: key);

  @override
  _check_particular_post_and_push_on_pageState createState() => _check_particular_post_and_push_on_pageState();
}

class _check_particular_post_and_push_on_pageState extends State<check_particular_post_and_push_on_page> {
  get_ad(ad_slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_get_ad/${ad_slug}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var that_ad = jsonDecode(utf8.decode(response.bodyBytes));

    if(that_ad.length != 0){
      if(that_ad[0]['fields']['ad_type'] == 'picture'){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => all_user_pages(),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => picture_read_more(particular_ad: ad_slug),
          ),
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => all_user_pages(),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => video_read_more(particular_ad: ad_slug),
          ),
        );
      }
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/userpage', (route) => false);
    }
  }

  push_to_profile(profile_slug)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/app_other_profile_details?profile_user=${profile_slug}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data.length != 0){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => all_user_pages(),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => read_another_profile(particular_dude: profile_slug),
        ),
      );
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/userpage', (route) => false);
    }
  }

  redirect_to_appropriate_page() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');

    final SharedPreferences prefs2 = await SharedPreferences.getInstance();
    final String theme = prefs2.getString('theme');

    if(theme != null && theme != ''){
      if(theme == 'dark'){
        setState(() {
          ThemeBuilder.of(context).changeTheme();
        });
      }
    }

    if(userId != null && userId != '') {
      var all_data = widget.snapshotdata;

      if(all_data.split('/').length < 4){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => all_user_pages()
          )
        );
      }else if(all_data.split('/').length == 4){
        await get_ad(all_data.split('/')[3]);
      }else{
        if(all_data.split('/')[3] == 'profile'){
          await push_to_profile(all_data.split('/')[4]);
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => all_user_pages()
            )
          );
        }
      }
    }else{
      var all_data = widget.snapshotdata;

      if(all_data.split('/')[3] == 'sign'){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => signup(worker_id: all_data.split('/')[4]),
          ),
        );
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => signin()
            )
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect_to_appropriate_page();
  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }
}
