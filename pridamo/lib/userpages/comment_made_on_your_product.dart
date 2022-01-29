import 'package:flutter/material.dart';
import 'package:pridamo/main_page/all_user_pages.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class product_comments extends StatefulWidget {
  var comment_id;

  product_comments({Key key, @required this.comment_id})
      : super(key: key);

  @override
  _product_commentsState createState() => _product_commentsState();
}

class _product_commentsState extends State<product_comments> {
  List<Widget> initial_comment_received = [];

  List<Widget> all_replies_received = [];

  var one = '1 week ago';

  var two = '2 weeks ago';

  var three = '3 weeks ago';

  var comment_id;

  check_leap_year(year){
    if(year % 4 == 0) {
      if(year % 100 == 0){
        if(year % 400 == 0){
          return true;
        }else{
          return false;
        }
      }else{
        return true;
      }
    }else{
      return false;
    }
  }

  calculate_time_passed(test_date_to_work_with, date_array){
    var formatter = new DateFormat('yyyy-MM-dd');

    String formattedDate = formatter.format(test_date_to_work_with);

    var test_date_array = formattedDate.split('-');

    var date_to_show = '';

    if(test_date_array[0] == date_array[0]){
      if(test_date_array[1] == date_array[1]){
        if(test_date_array[2] == date_array[2]){
          date_to_show = 'Today';

          return date_to_show;
        }else{
          var days = int.parse(test_date_array[2]) - int.parse(date_array[2]);

          if(days >= 7){
            if(days < 14){
              date_to_show = one;

              return date_to_show;
            }
            else if(days < 21){
              date_to_show = two;
              return date_to_show;
            }
            else{
              date_to_show = three;
              return date_to_show;
            }
          }else{
            if(days > 1){
              date_to_show = "${days} days ago";
            }else{
              date_to_show = 'Yesterday';
            }
            return date_to_show;
          }
        }
      }else{
        if((int.parse(test_date_array[1]) - int.parse(date_array[1])).abs() == 1){
          var months_with_30_days = [04,06,09,11];

          var month_is_30 = months_with_30_days.contains(int.parse(date_array[1]));

          if(month_is_30){
            var days_passed = 30 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

            if(days_passed >= 30){
              date_to_show = '1 month ago';
              return date_to_show;
            }else{
              if(days_passed >= 7){
                if(days_passed < 14){
                  date_to_show = one;

                  return date_to_show;
                }
                else if(days_passed < 21){
                  date_to_show = two;
                  return date_to_show;
                }
                else{
                  date_to_show = three;
                  return date_to_show;
                }
              }else{
                if(days_passed > 1){
                  date_to_show = "${days_passed} days ago";
                }else{
                  date_to_show = 'Yesterday';
                }
                return date_to_show;
              }
            }
          }else{
            if(int.parse(date_array[1]) == 2){
              if(check_leap_year(int.parse(date_array[0]))){
                var days_passed = 29 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

                if(days_passed >= 29){
                  date_to_show = '1 month ago';
                  return date_to_show;
                }else{
                  if(days_passed >= 7){
                    if(days_passed < 14){
                      date_to_show = one;

                      return date_to_show;
                    }
                    else if(days_passed < 21){
                      date_to_show = two;
                      return date_to_show;
                    }
                    else{
                      date_to_show = three;
                      return date_to_show;
                    }
                  }else{
                    if(days_passed > 1){
                      date_to_show = "${days_passed} days ago";
                    }else{
                      date_to_show = 'Yesterday';
                    }
                    return date_to_show;
                  }
                }
              }else{
                var days_passed = 28 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

                if(days_passed >= 28){
                  date_to_show = '1 month ago';
                  return date_to_show;
                }else{
                  if(days_passed >= 7){
                    if(days_passed < 14){
                      date_to_show = one;

                      return date_to_show;
                    }
                    else if(days_passed < 21){
                      date_to_show = two;
                      return date_to_show;
                    }
                    else{
                      date_to_show = three;
                      return date_to_show;
                    }
                  }else{
                    if(days_passed > 1){
                      date_to_show = "${days_passed} days ago";
                    }else{
                      date_to_show = 'Yesterday';
                    }
                    return date_to_show;
                  }
                }
              }
            }else{
              var days_passed = 31 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

              if(days_passed >= 31){
                date_to_show = '1 month ago';
                return date_to_show;
              }else{
                if(days_passed >= 7){
                  if(days_passed < 14){
                    date_to_show = one;

                    return date_to_show;
                  }
                  else if(days_passed < 21){
                    date_to_show = two;
                    return date_to_show;
                  }
                  else{
                    date_to_show = three;
                    return date_to_show;
                  }
                }else{
                  if(days_passed > 1){
                    date_to_show = "${days_passed} days ago";
                  }else{
                    date_to_show = 'Yesterday';
                  }
                  return date_to_show;
                }
              }
            }
          }
        }else{
          var months_passed = (int.parse(test_date_array[1]) - int.parse(date_array[1])).abs();

          date_to_show = '${months_passed} months ago';

          return date_to_show;
        }
      }
    }else{
      if(int.parse(test_date_array[0]) - int.parse(date_array[0]) == 1){
        var months_passed = int.parse(test_date_array[1]) - int.parse(date_array[1]) + 12;

        if(months_passed == 1){
          var months_with_30_days = [04,06,09,11];

          var month_is_30 = months_with_30_days.contains(int.parse(date_array[1]));

          if(month_is_30){
            var days_passed = 30 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

            if(days_passed >= 30){
              date_to_show = '1 month ago';

              return date_to_show;
            }else{
              if(days_passed >= 7){
                if(days_passed < 14){
                  date_to_show = one;

                  return date_to_show;
                }
                else if(days_passed < 21){
                  date_to_show = two;
                  return date_to_show;
                }
                else{
                  date_to_show = three;
                  return date_to_show;
                }
              }else{
                if(days_passed > 1){
                  date_to_show = "${days_passed} days ago";
                }else{
                  date_to_show = 'Yesterday';
                }
                return date_to_show;
              }
            }
          }else{
            if(int.parse(date_array[1]) == 2){
              if(check_leap_year(int.parse(date_array[0]))){
                var days_passed = 29 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

                if(days_passed >= 29){
                  date_to_show = '1 month ago';
                  return date_to_show;
                }else{
                  if(days_passed >= 7){
                    if(days_passed < 14){
                      date_to_show = one;

                      return date_to_show;
                    }
                    else if(days_passed < 21){
                      date_to_show = two;
                      return date_to_show;
                    }
                    else{
                      date_to_show = three;
                      return date_to_show;
                    }
                  }else{
                    if(days_passed > 1){
                      date_to_show = "${days_passed} days ago";
                    }else{
                      date_to_show = 'Yesterday';
                    }
                    return date_to_show;
                  }
                }
              }else{
                var days_passed = 28 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

                if(days_passed >= 28){
                  date_to_show = '1 month ago';
                  return date_to_show;
                }else{
                  if(days_passed >= 7){
                    if(days_passed < 14){
                      date_to_show = one;

                      return date_to_show;
                    }
                    else if(days_passed < 21){
                      date_to_show = two;
                      return date_to_show;
                    }
                    else{
                      date_to_show = three;
                      return date_to_show;
                    }
                  }else{
                    if(days_passed > 1){
                      date_to_show = "${days_passed} days ago";
                    }else{
                      date_to_show = 'Yesterday';
                    }
                    return date_to_show;
                  }
                }
              }
            }else{
              var days_passed = 31 - int.parse(date_array[2]) + int.parse(test_date_array[2]);

              if(days_passed >= 31){
                date_to_show = '1 month ago';
                return date_to_show;
              }else{
                if(days_passed >= 7){
                  if(days_passed < 14){
                    date_to_show = one;

                    return date_to_show;
                  }
                  else if(days_passed < 21){
                    date_to_show = two;
                    return date_to_show;
                  }
                  else{
                    date_to_show = three;
                    return date_to_show;
                  }
                }else{
                  if(days_passed > 1){
                    date_to_show = "${days_passed} days ago";
                  }else{
                    date_to_show = 'Yesterday';
                  }
                  return date_to_show;
                }
              }
            }
          }
        }else{
          if(months_passed >= 12){
            date_to_show = 'A year ago';
            return date_to_show;
          }else{
            date_to_show = '${months_passed} months ago';
            return date_to_show;
          }
        }
      }else{
        var years_passed = int.parse(test_date_array[0]) - int.parse(date_array[0]);

        date_to_show = '${years_passed} years ago';

        return date_to_show;
      }
    }
  }

  get_initial_comment()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_comment/${widget.comment_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    var new_date = data[0]['date'].toString().split('T')[0];

    var date_array_received = new_date.split('-');

    var test_date_to_work_with = new DateTime.now();

    var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

    comment_id = data[0]['comment_id'];

    setState(() {
      initial_comment_received.add(reply_child(data[0]['username'], data[0]['comment'], data[0]['profile_url'], date_you_want));
    });

    if(data[0]['response_img'] != 'none'){
      var new_date = data[0]['response_date'].toString().split('T')[0];

      var date_array_received = new_date.split('-');

      var test_date_to_work_with = new DateTime.now();

      var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

      setState(() {
        has_replies = true;

        all_replies_received.add(last_reply(data[0]['response_username'], data[0]['response_comment'], data[0]['response_img'], date_you_want, data[0]['response_id']));
      });
    }
  }

  app_delete_reply(reply_id)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/app_comment/${widget.comment_id}?id=$reply_id',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => product_comments(comment_id: widget.comment_id),
        ),
      );
    }
  }

  var has_replies = false;

  var inital_comment_future;

  var comment_message = '';

  add_new_comment()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/app_reply/${widget.comment_id}?response=$comment_message&id=${comment_id}&notification_id=${widget.comment_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );

    var data = jsonDecode(response.body);

    var new_date = data[0]['date'].toString().split('T')[0];

    var date_array_received = new_date.split('-');

    var test_date_to_work_with = new DateTime.now();

    var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

    setState(() {
      has_replies = true;
      all_replies_received.insert(1, last_reply(data[0]['username'], comment_message, data[0]['profile_img'], date_you_want, data[0]['response_id']));
    });
  }

  var theme_type = 'light';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inital_comment_future = get_initial_comment();
    all_replies_received.add(comment_button_stuff());
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Comment on a product'
        ),
      ),
      body: FutureBuilder(
        future: inital_comment_future,
        builder: (context, snapshot){
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Column(
                  children: initial_comment_received
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Builder(
                    builder: (context){
                      if(has_replies){
                        return Text(
                          'Replies',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        );
                      }else{
                        return Text(
                          'Reply',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: all_replies_received
                  ),
                )
              ],
            ),
          );
        },
      )
    );
  }

  Widget comment_button_stuff(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value){
                setState(() {
                  comment_message = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Add Reply',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0)
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.blue,
            onPressed: ()async{
              if(comment_message.isNotEmpty){
                add_new_comment();
              }
            },
          )
        ],
      ),
    );
  }

  Widget reply_child(String name, String comment, String image, String date){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/${image}'),
              backgroundColor: Colors.white,
              radius: 30.0,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      toBeginningOfSentenceCase(name),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,10.0,0,0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        date,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
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
                          comment,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget last_reply(String name, String comment, String image, String date, id){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/${image}'),
              backgroundColor: Colors.white,
              radius: 30.0,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      toBeginningOfSentenceCase(name),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,10.0,0,0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        date,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
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
                          comment,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.blue,
                        letterSpacing: 1.0
                      ),
                    ),
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Delete Comment"),
                              content: Text(
                                  "Would you like to permanently remove this comment?"
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: Colors.red
                                      )
                                  ),
                                  onPressed: (){
                                    app_delete_reply(id);

                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: (){
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
            ),
          ),
        ],
      ),
    );
  }
}
