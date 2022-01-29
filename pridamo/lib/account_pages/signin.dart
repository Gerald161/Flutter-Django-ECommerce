import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pridamo/account_pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class signin extends StatefulWidget {
  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {
  final _formkey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  var loading = false;

  Future<Map> SignIn() async {
    var response = await http.post(
        'https://pridamo.com/account/app_login',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'password': password,
          'email': email
        })
    );
    Map data = jsonDecode(response.body);

    if(data['key'] == null){
      return data;
    }else{
      return data;
    }

  }

  Future<http.Response> GetToken() async {
    try{
      var response = await http.post(
          'https://pridamo.com/account/api/token',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'password': password,
            'username': email.toLowerCase()
          })
      );
      Map data = jsonDecode(response.body);

      if(data['non_field_errors'] == null){
        Future<Null> userToken() async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token',data['token']);
        }

        loginUser();
        userToken();
      }

    }catch(e){
      print(e.toString());
    }
  }

  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username',"user");
  }

  Future<List> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.getString('token');
    var response = await http.get('https://pridamo.com/account/app_username?token=${token}');
    final SharedPreferences prefss = await SharedPreferences.getInstance();
    prefss.setString('userName',jsonDecode(response.body)["name"]);
  }

  var do_not_show_pass = true;

  var has_seen_slideshow = false;

  PageController _pageController;

  var current_index_on = 0;

  var has_checked_slide_show = false;

  check_slide_show_state()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String slideshow = prefs.getString('slideshow');

    if(slideshow != null && slideshow != ''){
      setState(() {
        has_seen_slideshow = true;
      });
    }else{
      setState(() {
        has_seen_slideshow = false;
      });
    }

    setState(() {
      has_checked_slide_show = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    check_slide_show_state();
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
        body: has_seen_slideshow == true ? SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                    child: Text(
                      'Pridamo Login',
                    ),
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                          child: TextFormField(
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: TextFormField(
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
                            obscureText: do_not_show_pass,
                            onChanged: (val){
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                        ),
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
                        loading == false ? Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: RaisedButton(
                            color: Colors.blueAccent,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            onPressed: () async {
                              if(_formkey.currentState.validate()){
                                setState(() {
                                  loading = true;
                                });

                                Fluttertoast.showToast(
                                  msg: "Please wait...",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                                dynamic result = await SignIn();
                                if(result['email'] == null && result['key'] == null){
                                  await GetToken();
                                  await getUserName();
                                  await Navigator.pushReplacementNamed(context, '/userpage');
                                }else{
                                  setState(() {
                                    loading = false;
                                  });
                                }
                                if(result['email'] == null){

                                }else{
                                  setState(() {
                                    error = "Please enter a valid email";
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(
                                              "Error",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Text(
                                              error,
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Ok",
                                                ),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                              ),
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
                                if(result['key'] == null){
                                  //send to homepage
                                }
                                else{
                                  setState(() {
                                    error = result['key'];
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text(
                                              "Error",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Text(
                                              error,
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  "Ok",
                                                ),
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                              ),
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
                            },
                          ),
                        ) : Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
                          child: CircularProgressIndicator(),
                        ),
                        loading == true ? FlatButton(
                          onPressed: ()async{
                            if(_formkey.currentState.validate()){
                              setState(() {
                                loading = false;
                              });

                              Fluttertoast.showToast(
                                msg: "Please wait...",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                              );
                              dynamic result = await SignIn();
                              if(result['email'] == null && result['key'] == null){
                                await GetToken();
                                await getUserName();
                                await Navigator.pushReplacementNamed(context, '/userpage');
                              }else{
                                setState(() {
                                  loading = false;
                                });
                              }
                              if(result['email'] == null){

                              }else{
                                setState(() {
                                  error = "Please enter a valid email";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            "Error",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            error,
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Ok",
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
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
                              if(result['key'] == null){
                                //send to homepage
                              }
                              else{
                                setState(() {
                                  error = result['key'];
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            "Error",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            error,
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Ok",
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
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
                          },
                          child: Text(
                            'Retry',
                          ),
                          textColor: Colors.blue,
                        ) : SizedBox.shrink(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: RaisedButton(
                            child: Text("Sign Up"),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: (){
                              Navigator.pushReplacementNamed(context, '/signup');
                            },
                          ),
                        ),
                        FlatButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => reset_password()
                                )
                            );
                          },
                          child: Text(
                            'Forgot Password',
                          ),
                        ),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) :
        SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PageView(
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    onPageChanged: (index){
                      setState(() {
                        current_index_on = index;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Image.asset(
                            "assets/1.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Image.asset(
                            "assets/2.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Image.asset(
                            "assets/3.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Image.asset(
                            "assets/4.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Image.asset(
                            "assets/5.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Image.asset(
                            "assets/6.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ]
                ),
              ),
              current_index_on != 5 ? Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.03,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        current_index_on += 1;

                        _pageController.animateToPage(
                            current_index_on,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn
                        );
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.horizontal_rule,
                          color: current_index_on == 0 ? Colors.blue : Colors.grey[600],
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Icon(
                          Icons.horizontal_rule,
                          color: current_index_on == 1 ? Colors.blue : Colors.grey[600],
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Icon(
                          Icons.horizontal_rule,
                          color: current_index_on == 2 ? Colors.blue : Colors.grey[600],
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Icon(
                          Icons.horizontal_rule,
                          color: current_index_on == 3 ? Colors.blue : Colors.grey[600],
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Icon(
                          Icons.horizontal_rule,
                          color: current_index_on == 4 ? Colors.blue : Colors.grey[600],
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Icon(
                          Icons.horizontal_rule,
                          color: current_index_on == 5 ? Colors.blue : Colors.grey[600],
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),
              ) :
              Positioned.fill(
                bottom: MediaQuery.of(context).size.height * 0.03,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    onPressed: (){
                      setState(() {
                        current_index_on += 1;

                        _pageController.animateToPage(
                            current_index_on,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn
                        );
                      });
                    },
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                          ),
                        ],
                      ),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: ()async{
                        final SharedPreferences prefs = await SharedPreferences.getInstance();

                        prefs.setString('slideshow','seen');

                        setState(() {
                          has_seen_slideshow = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: has_seen_slideshow == false ? Colors.white : Theme.of(context).canvasColor,
      ),
    );
  }
}
