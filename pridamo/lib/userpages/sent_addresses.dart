import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/loading_spinkits/loading.dart';


class sent_address_page extends StatefulWidget {
  @override
  _sent_address_pageState createState() => _sent_address_pageState();
}

class _sent_address_pageState extends State<sent_address_page> {
  List<Widget> all_messages_sent = [];

  var show_more_button = false;

  var response_received = false;

  var message_num = 0;

  var message_change = 15;

  var loading = false;

  delete_message(delete_id)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_notifications_sent?delete=$delete_id',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => sent_address_page(),
        ),
      );
    }
  }

  get_messages()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_notifications_sent?num=$message_num&change=$message_change',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    setState(() {
      response_received = true;
    });

    data.forEach((datum) async {
      setState(() {
        all_messages_sent.add(message_card(datum['comment_id'], datum['message']));
      });
    });

    if(data.length != 0){
      if(data[0]['show_more'] == 'yes'){
        setState(() {
          show_more_button = true;
        });
      }else{
        setState(() {
          show_more_button = false;
        });
      }
    }else{
      setState(() {
        show_more_button = false;
      });
    }

    message_num += 15;

    message_change += 15;
  }

  var initial_messages;

  var theme_type = 'light';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_messages = get_messages();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text('Sent Addresses'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FutureBuilder(
          future: initial_messages,
          builder: (context, snapshot){
            if(all_messages_sent.isNotEmpty){
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      children: all_messages_sent,
                    ),
                    Builder(
                        builder: (context){
                          if(show_more_button){
                            return FlatButton(
                              child: Text(
                                'Show More',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: (){
                                get_messages();
                              },
                            );
                          }else{
                            return SizedBox.shrink();
                          }
                        }
                    )
                  ],
                ),
              );
            }else{
              return response_received != false ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text('No addresses sent'),
                  ),
                ],
              ) :  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget message_card(comment_id, message){
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: theme_type == 'light' ? Colors.grey : Colors.grey[700],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message,
                ),
              ],
            ),
          ),
          FlatButton(
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text(
                      "Delete",
                    ),
                    content: Text(
                      "Would you like to delete this message?"
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red
                          )
                        ),
                        onPressed: ()async{
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Yes",
                        ),
                        onPressed: (){
                          setState(() {
                            loading = true;
                          });
                          delete_message(comment_id);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
            },
          )
        ],
      ),
    );
  }
}
