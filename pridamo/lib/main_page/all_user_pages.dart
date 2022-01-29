import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pridamo/ad_posting_page/main_ad_post_page.dart';
import 'package:pridamo/userpages/profile_page.dart';
import 'package:pridamo/userpages/home.dart';
import 'package:pridamo/userpages/settings_page.dart';
import 'package:pridamo/userpages/subscriptions_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';

var seller_or_not = false;

class all_user_pages extends StatefulWidget {
  @override
  _all_user_pagesState createState() => _all_user_pagesState();
}

class _all_user_pagesState extends State<all_user_pages>{
  int _currentIndex = 0;

  PageController _pageController;

  var theme_type = 'light';

  turn_off_seller_mode()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
      'https://pridamo.com/profile/app_turn_off_seller_mode',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token $token"
      },
    );

    Map data = jsonDecode(response.body);

    if(data['status'] != null){
      if(data['status'] == 'off'){
        setState(() {
          seller_or_not = false;

          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text(
                    "Seller mode turned off",
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    "Seller mode has been turned off due to inactivity, this is to protect your information and details from fraudsters",
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    FlatButton(
                      child: Text('Ok'),
                      textColor: Colors.blue,
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      )
                  ),
                );
              }
          );

        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();

    _initializeTimer();
  }

  Timer _timer;

  void _handleUserInteraction([_]) {
    _initializeTimer();
  }

  void _initializeTimer() {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(const Duration(hours: 5), _logOutUser);
  }

  void _logOutUser() {
    _timer?.cancel();

    _timer = null;

    if(seller_or_not == true){
      turn_off_seller_mode();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleUserInteraction,
      onPanDown: _handleUserInteraction,
      child: Scaffold(
        body: Builder(
          builder: (context){
            return PageView(
              controller: _pageController,
              children: [
                home_page(),
                profile_page(),
                subscriptions_page(),
                settings_page()
              ],
              onPageChanged: (index){
                setState(() {
                  _currentIndex = index;
                });
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: theme_type == 'light' ? Colors.black : Colors.white,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => main_ad_post_page(),
              ),
            );
          },
          tooltip: "Product post page",
          heroTag: 'Floating action button on homepage',
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: theme_type == 'light' ? Colors.blue : Colors.grey[800],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: _currentIndex,
          backgroundColor: Theme.of(context).canvasColor,
          activeColor: theme_type == 'light' ? Theme.of(context).primaryColor : Colors.white,
          onTap: (index){
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(
                Icons.favorite,
              ),
              label: "Subscriptions",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings"
            ),
          ],
        ),
      ),
    );
  }
}