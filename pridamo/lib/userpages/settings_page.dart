import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pridamo/theme_changer.dart';
import 'package:pridamo/account_pages/set_ad_region.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/account_pages/account_setting_main_page.dart';

class settings_page extends StatefulWidget {
  @override
  _settings_pageState createState() => _settings_pageState();
}

class _settings_pageState extends State<settings_page> with AutomaticKeepAliveClientMixin<settings_page>{
  var theme_group_value = 'light';

  var theme_future;

  get_theme_future() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String theme = prefs.getString('theme');

    if(theme == 'dark'){
      setState(() {
        theme_group_value = 'dark';
      });
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefss = await SharedPreferences.getInstance();
    prefs.setString('username', '');
    prefss.setString('userName', '');
  }

  Future<Null> delete_user_Token() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
  }

  Future<http.Response> logoutuser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    await http.get(
        'https://pridamo.com/account/api',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );
    logout();
    delete_user_Token();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    theme_future = get_theme_future();
  }

  void changeTheme() {
    ThemeBuilder.of(context).changeTheme();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(Platform.isAndroid){
          SystemNavigator.pop();
        }else{
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: theme_future,
          builder: (context, snapshot){
            return ListView(
              children: <Widget>[
                ListTile(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState){
                                return AlertDialog(
                                  title: Text(
                                    'Select theme',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                    child: Column(
                                      children: [
                                        RadioListTile(
                                          value: 'light',
                                          groupValue: theme_group_value,
                                          title: Text('Light'),
                                          activeColor: Colors.green[600],
                                          onChanged: (value)async{
                                            setState(() {
                                              theme_group_value = value;
                                              changeTheme();
                                            });

                                            final SharedPreferences prefs = await SharedPreferences.getInstance();

                                            prefs.setString('theme',"light");
                                          },
                                        ),
                                        RadioListTile(
                                          value: 'dark',
                                          groupValue: theme_group_value,
                                          title: Text('Dark'),
                                          activeColor: Colors.green[600],
                                          onChanged: (value)async{
                                            setState(() {
                                              theme_group_value = value;
                                              changeTheme();
                                            });

                                            final SharedPreferences prefs = await SharedPreferences.getInstance();

                                            prefs.setString('theme',"dark");
                                          },
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)
                                        )
                                    ),
                                  ),
                                  scrollable: true,
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
                        }
                    );
                  },
                  title: Text(
                    "Theme",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => set_ad_region_page()
                        )
                    );
                  },
                  title: Text(
                    "Preference/Info/Ad Settings",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => main_account_change_page()
                        )
                    );
                  },
                  title: Text("Account Settings"),
                ),
                ListTile(
                  onTap: () async {
                    Fluttertoast.showToast(
                      msg: "Logging out",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                    );

                    await logoutuser();

                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  title: Text("Log Out"),
                )
              ],
            );
          },
        )
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
