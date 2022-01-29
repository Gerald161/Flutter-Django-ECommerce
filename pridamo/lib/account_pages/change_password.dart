import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class change_password extends StatefulWidget {
  @override
  _change_passwordState createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {
  final _formkey = GlobalKey<FormState>();

  bool loading = false;

  String error = '';

  String old_password = '';

  String new_password = '';

  Future<Map> change_password() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.put(
        'https://pridamo.com/account/api/change-password/',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
        body: jsonEncode({
          'old_password': old_password,
          'new_password': new_password,
        })
    );
    Map data = jsonDecode(response.body);

    return data;
  }

  var do_not_show_pass1 = true;

  var do_not_show_pass2 = true;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                TextFormField(
                  obscureText: do_not_show_pass1,
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2.0)
                    ),
                  ).copyWith(hintText: 'Old Password'),
                  validator: (val) => val.isEmpty ? 'Enter your old password' : null,
                  onChanged: (val){
                    setState(() {
                      old_password = val;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  child: Text(
                    do_not_show_pass1 == true ? 'Show Password': 'Hide Password',
                  ),
                  textColor: Colors.blue,
                  onPressed: (){
                    setState(() {
                      if(do_not_show_pass1 == false){
                        do_not_show_pass1 = true;
                      }else{
                        do_not_show_pass1 = false;
                      }
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
                  ).copyWith(hintText: 'New Password'),
                  validator: (val) => val.isEmpty ? 'Enter your new password' : null,
                  obscureText: do_not_show_pass2,
                  onChanged: (val){
                    setState(() {
                      new_password = val;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                FlatButton(
                  child: Text(
                    do_not_show_pass2 == true ? 'Show Password': 'Hide Password',
                  ),
                  textColor: Colors.blue,
                  onPressed: (){
                    setState(() {
                      if(do_not_show_pass2 == false){
                        do_not_show_pass2 = true;
                      }else{
                        do_not_show_pass2 = false;
                      }
                    });
                  },
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  onPressed: () async {
                    if(_formkey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic response = await change_password();

                      setState(() {
                        loading = false;
                      });

                      if(response['old_password'] == null){
                        setState(() {
                          error = 'Password Changed Successfully';
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                    title: Center(child: Text(error)),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                            "Ok",
                                            style: TextStyle(
                                                fontSize: 22.0
                                            )
                                        ),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]
                                );
                              }
                          );
                        });
                      }else{
                        setState(() {
                          error = 'Old Password is Wrong';
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                    title: Center(child: Text(error)),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                            "Ok",
                                            style: TextStyle(
                                                fontSize: 22.0
                                            )
                                        ),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]
                                );
                              }
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
