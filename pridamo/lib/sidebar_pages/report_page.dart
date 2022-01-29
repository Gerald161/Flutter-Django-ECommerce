import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class problem_report_page extends StatefulWidget {
  @override
  _problem_report_pageState createState() => _problem_report_pageState();
}

class _problem_report_pageState extends State<problem_report_page> {
  final _formKey = GlobalKey<FormState>();

  var common_problems = [
    'District',
    'Suggestion',
    'Subscription',
    'Payment Problem',
    'Categories',
    'Subcategories'
  ];

  var selected_problem;

  var typed_problem;

  var description;

  TextEditingController _controller1;

  var number_to_call = '';

  var my_username = '';

  var mail_to_send_to = '';

  get_numbers_to_call()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    var wallpaper_response = await http.get(
        'https://pridamo.com/get_app_wallpaper',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    my_username = jsonDecode(wallpaper_response.body)['user_name'];

    number_to_call = jsonDecode(wallpaper_response.body)['complain_number'];

    mail_to_send_to = jsonDecode(wallpaper_response.body)['email'];
  }

  var report_page_future;

  launchWhatsapp(number, message)async{
    var url = "whatsapp://send?phone=$number&text=$message";

    await canLaunch(url) ? launch(url) : Fluttertoast.showToast(
      msg: "Cannot open WhatsApp",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected_problem = common_problems[0];
    typed_problem = 'District';
    _controller1 = new TextEditingController(text: typed_problem);
    report_page_future = get_numbers_to_call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Report a problem"),
      ),
      body: FutureBuilder(
        future: report_page_future,
        builder: (context, snapshot){
          if(number_to_call == ''){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selected_problem,
                        onChanged: (String text) {
                          setState(() {
                            selected_problem = text;

                            typed_problem = text;

                            _controller1 = new TextEditingController(text: typed_problem);
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return common_problems.map<Widget>((String text) {
                            return Row(
                              children: <Widget>[
                                Icon(
                                  Icons.error,
                                  color: Colors.red[800],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                                  child: Text(
                                    "Nature of Problem: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                        text,
                                        overflow:
                                        TextOverflow.ellipsis
                                    )
                                ),
                              ],
                            );
                          }).toList();
                        },
                        items: common_problems.map<DropdownMenuItem<String>>((String text) {
                          return DropdownMenuItem<String>(
                            value: text,
                            child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controller1,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Type of problem',
                          icon: Icon(
                            Icons.edit,
                          ),
                        ),
                        validator: (input) => input.trim().length < 5
                            ? 'Please enter at least 5 characters'
                            : null,
                        onChanged: (val){
                          setState(() {
                            typed_problem = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          icon: Icon(
                            Icons.description,
                          ),
                        ),
                        validator: (input) => input.trim().length < 5
                            ? 'Please enter at least 5 characters'
                            : null,
                        onChanged: (val){
                          setState(() {
                            description = val;
                          });
                        },
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Send',
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                      onPressed: (){
                        if(_formKey.currentState.validate()){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState){
                                      return AlertDialog(
                                        content: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              FlatButton(
                                                onPressed: ()async{
                                                  var new_description = ""
                                                      "${typed_problem} from ${my_username} at Pridamo. "
                                                      "Problem description: $description";

                                                  final Uri params = Uri(
                                                    scheme: 'mailto',
                                                    path: '${mail_to_send_to}',
                                                    query: 'subject=$typed_problem',
                                                  );

                                                  var url = params.toString();

                                                  if (await canLaunch(url)) {
                                                    await launch("mailto:${mail_to_send_to}?subject=${typed_problem}&body=${new_description}");
                                                  }else{
                                                    Fluttertoast.showToast(
                                                      msg: "Cannot open Email",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.blue,
                                                      textColor: Colors.white,
                                                    );
                                                  }
                                                },
                                                textColor: Colors.blue,
                                                child: Text(
                                                  'Email',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              FlatButton(
                                                onPressed: (){
                                                  var original_number = number_to_call;

                                                  var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                                                  var new_description = ""
                                                      "${typed_problem} from ${my_username} at Pridamo. "
                                                      "Problem description: $description";

                                                  launchWhatsapp(correct_number, new_description);
                                                },
                                                textColor: Colors.blue,
                                                child: Text(
                                                  'WhatsApp',
                                                  textAlign: TextAlign.center,
                                                ),
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
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
