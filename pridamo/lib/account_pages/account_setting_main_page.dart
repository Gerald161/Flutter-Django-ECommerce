import 'dart:io';
import 'package:pridamo/main_page/all_user_pages.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pridamo/account_pages/change_password.dart';
import 'package:flutter/material.dart';
import 'package:pridamo/account_pages/change_details.dart';
import 'package:pridamo/account_pages/delete_account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class main_account_change_page extends StatefulWidget {
  @override
  _main_account_change_pageState createState() => _main_account_change_pageState();
}

class _main_account_change_pageState extends State<main_account_change_page> {
  var password = '';

  var received_response = false;

  turn_on_seller_mode()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/profile/app_check_validity_of_password',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
        body: jsonEncode({
          'password': password,
        })
    );

    Map data = jsonDecode(response.body);

    if(data['pass'] != null){
      if(data['pass'] == 'correct'){
        setState(() {
          seller_or_not = true;

          Fluttertoast.showToast(
            msg: "Seller mode active, please go ahead and post",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );
        });
      }else if(data['pass'] == 'incorrect'){
        Fluttertoast.showToast(
          msg: "Password incorrect, please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
      }else{
        Fluttertoast.showToast(
          msg: "Error occurred, please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
      }
    }
  }

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

          Fluttertoast.showToast(
            msg: "Seller mode inactive",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );
        });
      }
    }
  }

  check_seller_status()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    var response = await http.get(
      'https://pridamo.com/get_app_wallpaper',
      headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      }
    );

    setState(() {
      seller_or_not = jsonDecode(response.body)['seller_status'];

      received_response = true;
    });
    
  }

  var seller_status_future;

  var do_not_show_pass = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seller_status_future = check_seller_status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account Settings",
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => change_details()
                  )
                );
              },
              title: Text("Change Email/Username"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => change_password()
                  )
                );
              },
              title: Text("Change Password"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => delete_account()
                  )
                );
              },
              title: Text("Delete Account"),
            ),
          ),
          FutureBuilder(
            future: seller_status_future,
            builder: (context, snapshot){
              if(received_response == true){
                return InkWell(
                  onTap: (){
                    setState(() {
                      if(seller_or_not == false){
                        showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState){
                                return AlertDialog(
                                  title: Text(
                                    'Enter Password',
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            obscureText: do_not_show_pass,
                                            decoration: InputDecoration(
                                              hintText: 'Password',
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  Icons.remove_red_eye,
                                                  color: do_not_show_pass == true ? Colors.grey : Colors.blue,
                                                ),
                                                onPressed: (){
                                                  setState((){
                                                    if(do_not_show_pass == true){
                                                      do_not_show_pass = false;
                                                    }else{
                                                      do_not_show_pass = true;
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            validator: (input) => input.trim().length < 2
                                                ? 'Please enter a correct pass'
                                                : null,
                                            onChanged: (val){
                                              setState(() {
                                                password = val;
                                              });
                                            },
                                          ),
                                        ),
                                        FlatButton(
                                          child: Text(
                                            'Change user mode',
                                            textAlign: TextAlign.center,
                                          ),
                                          textColor: Colors.blue,
                                          onPressed: ()async{
                                            Navigator.pop(context);

                                            await turn_on_seller_mode();
                                          },
                                        )
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
                      }else{
                        turn_off_seller_mode();
                      }
                    });

                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seller Mode',
                            style: TextStyle(
                                fontSize: 16.0
                            ),
                          ),
                          Switch(
                              value: seller_or_not,
                              onChanged: (state){
                                setState(() {
                                  if(seller_or_not == false){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState){
                                                return AlertDialog(
                                                  title: Text(
                                                    'Enter Password',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Container(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            keyboardType: TextInputType.multiline,
                                                            obscureText: do_not_show_pass,
                                                            decoration: InputDecoration(
                                                              hintText: 'Password',
                                                              suffixIcon: IconButton(
                                                                icon: Icon(
                                                                  Icons.remove_red_eye,
                                                                  color: do_not_show_pass == true ? Colors.grey : Colors.blue,
                                                                ),
                                                                onPressed: (){
                                                                  setState((){
                                                                    if(do_not_show_pass == true){
                                                                      do_not_show_pass = false;
                                                                    }else{
                                                                      do_not_show_pass = true;
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            validator: (input) => input.trim().length < 2
                                                                ? 'Please enter a correct pass'
                                                                : null,
                                                            onChanged: (val){
                                                              setState(() {
                                                                password = val;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        FlatButton(
                                                          child: Text(
                                                            'Change user mode',
                                                            textAlign: TextAlign.center,
                                                          ),
                                                          textColor: Colors.blue,
                                                          onPressed: ()async{
                                                            Navigator.pop(context);

                                                            await turn_on_seller_mode();
                                                          },
                                                        )
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
                                  }else{
                                    turn_off_seller_mode();
                                  }
                                });
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Seller Mode',
                          style: TextStyle(
                            fontSize: 16.0
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                          child: CircularProgressIndicator(),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      )
    );
  }
}
