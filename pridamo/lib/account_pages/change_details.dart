import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class change_details extends StatefulWidget {
  @override
  _change_detailsState createState() => _change_detailsState();
}

class _change_detailsState extends State<change_details> {
  final _formkey = GlobalKey<FormState>();
  Future<List> _futures;
  String email = '';
  String password = '';
  String username = '';
  var full_name = '';
  bool loading = false;
  String initial_email = '';
  String initial_username = '';

  TextEditingController _controller1;
  TextEditingController _controller2;
  TextEditingController _controller3;

  Future change_user_details() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    if(initial_username.toLowerCase() != username.toLowerCase() && initial_email.toLowerCase() != email.toLowerCase()){
      var response = await http.post(
          'https://pridamo.com/account/app_change_details?email=yes&username=yes',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode({
            'password': password,
            'email': email,
            'username': username,
            'full_name': full_name
          })
      );
      Map data = jsonDecode(response.body);

      if(data['key'] != null){
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: Text(
                    'Password Incorrect',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
          );
        });
      }else{
        if(data['username'] != null){
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(
                      'Username/Business ID is already being used sorry',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          });
        }else if(data['email'] != null){
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(
                      'Email is already being used sorry',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          });
        }else{
          setState(() {
            initial_email = email;
            initial_username = username;
          });
          setState(() {
            Navigator.of(context).pushNamedAndRemoveUntil('/userpage', (route) => false);
          });
        }
      }
      setState(() {
        loading = false;
      });
    }else if(initial_username.toLowerCase() != username.toLowerCase() && initial_email.toLowerCase() == email.toLowerCase()){
      var response = await http.post(
          'https://pridamo.com/account/app_change_details?username=yes',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode({
            'password': password,
            'email': email,
            'username': username,
            'full_name': full_name
          })
      );
      Map data = jsonDecode(response.body);

      if(data['key'] != null){
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: Text(
                    'Password Incorrect',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
          );
        });
      }else{
        if(data['username'] != null){
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(
                      'Username is already being used sorry',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          });
        }else{
          setState(() {
            initial_email = email;
            initial_username = username;
          });
          setState(() {
            Navigator.pushReplacementNamed(context, '/userpage');
          });
        }
      }

      setState(() {
        loading = false;
      });
    }else if(initial_username.toLowerCase() == username.toLowerCase() && initial_email.toLowerCase() != email.toLowerCase()){
      var response = await http.post(
          'https://pridamo.com/account/app_change_details?email=yes',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode({
            'password': password,
            'email': email,
            'username': username,
            'full_name': full_name
          })
      );
      Map data = jsonDecode(response.body);

      if(data['key'] != null){
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: Text(
                    'Password Incorrect',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
          );
        });
      }else{
        if(data['email'] != null){
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(
                      'Email is already being used sorry',
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Ok"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
          });
        }else{
          setState(() {
            initial_email = email;
            initial_username = username;
          });
          setState(() {
            Navigator.pushReplacementNamed(context, '/userpage');
          });
        }
      }
      setState(() {
        loading = false;
      });
    }else{
      var response = await http.post(
          'https://pridamo.com/account/app_change_details?full_name=yes',
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Token $token"
          },
          body: jsonEncode({
            'full_name': full_name,
            'password': password,
          })
      );
      Map data = jsonDecode(response.body);

      if(data['key'] != null){
        setState(() {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: Text(
                    'Password Incorrect',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }
          );
        });
      }else{
        Fluttertoast.showToast(
          msg: "Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      }

      setState(() {
        loading = false;
      });
    }


  }

  Future<List> get_old_details() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/account/app_account_user',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );
    Map data = jsonDecode(response.body);
    setState(() {
      email = data['email'];
      username = data['username'];
      initial_email = email;
      initial_username = username;
      _controller1 = new TextEditingController(text: data['email']);
      _controller2 = new TextEditingController(text: data['username']);
      _controller3 = new TextEditingController(text: data['full_name']);

      gotten_details = true;
    });
  }

  var gotten_details = false;

  var do_not_show_pass = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futures = get_old_details();
  }


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Change Username/Email"),
      ),
      body: FutureBuilder(
        future: _futures,
        builder: (context, snapshot) {
          if(gotten_details){
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _controller1,
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Email'),
                        validator: (val) => val.isEmpty ? 'Enter your new email' : null,
                        onChanged: (val){
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _controller2,
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Username/Business ID'),
                        validator: (val) => val.isEmpty ? 'Enter your new Username/Business ID' : null,
                        onChanged: (val){
                          setState(() {
                            username = val;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Username can only be letters (a-z), numbers (0-9) and dashes (-)"
                        ),
                      ),
                      TextFormField(
                        controller: _controller3,
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Full name/Business name'),
                        validator: (val) => val.isEmpty ? 'Enter your new Full name/Business name' : null,
                        onChanged: (val){
                          setState(() {
                            full_name = val;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Password'),
                        validator: (val) => val.isEmpty ? 'Enter your password' : null,
                        obscureText: do_not_show_pass,
                        onChanged: (val){
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      FlatButton(
                        child: Text(
                          do_not_show_pass == true ? 'Show Password': 'Hide Password',
                        ),
                        textColor: Colors.blue,
                        onPressed: (){
                          setState(() {
                            if(do_not_show_pass == false){
                              do_not_show_pass = true;
                            }else{
                              do_not_show_pass = false;
                            }
                          });
                        },
                      ),
                      SizedBox(height: 10.0),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        onPressed: () async {
                          if(_formkey.currentState.validate()){
                            setState(() {
                              loading = true;
                            });
                            change_user_details();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      ),
    );
  }
}
