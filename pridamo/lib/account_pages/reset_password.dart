import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pridamo/loading_spinkits/loading.dart';


class reset_password extends StatefulWidget {
  @override
  _reset_passwordState createState() => _reset_passwordState();
}

class _reset_passwordState extends State<reset_password> {
  bool loading = false;

  final _formkey = GlobalKey<FormState>();

  String error = '';

  String email = '';

  String success = '';

  Future<Map> reset_password_mail() async {
    var response = await http.post(
        'https://pridamo.com/account/app_reset_password/',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email,
        })
    );
    Map data = jsonDecode(response.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
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
                  decoration: InputDecoration(
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2.0)
                    ),
                  ).copyWith(hintText: 'Email'),
                  validator: (val) => !val.contains('@') ? 'Please enter a valid email' : null,
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 10.0),
                Container(
                  width: 150,
                  child: RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: () async {
                      if(_formkey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic response = await reset_password_mail();

                        setState(() {
                          loading = false;
                        });

                        if(response['email'] != null){
                          setState(() {
                            success = '';
                            error = 'Please enter a valid email address';
                          });
                        }else{
                          setState(() {
                            success = 'Password-Reset has been sent';
                            error = '';
                          });
                        }


                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'If you do not see the email in your inbox, please check your spam folder'
                  ),
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                ),
                Text(
                  success,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
