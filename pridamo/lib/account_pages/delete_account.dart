import 'package:flutter/material.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class delete_account extends StatefulWidget {
  @override
  _delete_accountState createState() => _delete_accountState();
}

class _delete_accountState extends State<delete_account> {
  final _formkey = GlobalKey<FormState>();

  var loading = false;

  String password = '';

  var do_not_show_pass = true;

  delete_account_permanently () async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.post(
        'https://pridamo.com/account/app_delete_account',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
        body: jsonEncode({
          'password': password,
        })
    );

    Map data = jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    if(data['status'] == 'error'){
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                  title: Center(
                    child: Text(
                      'Password Incorrect'
                    )
                  ),
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final SharedPreferences prefss = await SharedPreferences.getInstance();
      final SharedPreferences prefsss = await SharedPreferences.getInstance();

      prefs.setString('username', '');
      prefss.setString('userName', '');
      prefsss.setString('token', '');
      
      Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Account'
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'By deleting your account, your associated information will be permanently lost as well, please enter your password to proceed',
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: do_not_show_pass,
                    decoration: InputDecoration(
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange, width: 2.0)
                      ),
                    ).copyWith(hintText: 'Password'),
                    validator: (val) => val.isEmpty ? 'Enter your password' : null,
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
                  RaisedButton(
                    color: Colors.red,
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    onPressed: () async {
                      if(_formkey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        delete_account_permanently();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
