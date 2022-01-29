import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class comment_history extends StatefulWidget {
  @override
  _comment_historyState createState() => _comment_historyState();
}

class _comment_historyState extends State<comment_history> {
  List<Widget> all_comments_container = [];

  var comment_reply_number = 0;

  var comment_reply_change = 20;

  var received_response = false;

  var one = '1 week ago';

  var two = '2 weeks ago';

  var three = '3 weeks ago';

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

  get_comments_and_replies_typed()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_your_comments_replies?num=$comment_reply_number&change=$comment_reply_change',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    received_response = true;

    data.forEach((datum) async {
      var new_date = datum['date'].toString().split('T')[0];

      var date_array_received = new_date.split('-');

      var test_date_to_work_with = new DateTime.now();

      var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

      setState(() {
        all_comments_container.add(comment_card(date_you_want, datum['comment_id'], datum['message'], datum['comment_type'], datum['ad_name'], datum['picture_or_vid'], datum['ad_url']));
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

    comment_reply_number += 20;

    comment_reply_change += 20;
  }

  var initial_comment_history;

  var show_more_button = false;

  var loading = false;

  delete_comment(comment_id)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/profile/app_your_comments_replies?comment_id=$comment_id',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => comment_history(),
        ),
      );
    }
  }

  delete_reply(reply_id)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/profile/app_your_comments_replies?reply_id=$reply_id',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => comment_history(),
        ),
      );
    }
  }

  var theme_type = 'light';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_comment_history = get_comments_and_replies_typed();
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
        title: Text(
          'Comment/Reply History'
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initial_comment_history,
        builder: (context, snapshot){
          if(all_comments_container.isEmpty){
            return received_response != true ? Shimmer.fromColors(
              highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
              baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
              child: Center(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                      shimmer_child(),
                    ],
                  ),
                ),
              ),
            ) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text('No comments made')),
                ],
            );
          }else{
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Column(
                    children: all_comments_container,
                  ),
                  Builder(
                    builder: (context){
                      if(show_more_button){
                        return FlatButton(
                          child: Text(
                            'Show More',
                          ),
                          textColor: Colors.blue,
                          onPressed: (){
                            get_comments_and_replies_typed();
                          },
                        );
                      }else{
                        return SizedBox.shrink();
                      }
                    },
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget comment_card(date, comment_id, message, comment_type, ad_name, ad_type, ad_url){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                comment_type == 'response'?
                'Replied to a comment on ':
                'Commented on ',
              ),
              InkWell(
                onTap: (){
                  if(ad_type == 'picture'){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => picture_read_more(particular_ad: ad_url),
                      ),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => video_read_more(particular_ad: ad_url),
                      ),
                    );
                  }
                },
                child: Text(
                  ad_name,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
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
                      comment_type == 'response'? "Would you like to delete this reply?":
                      "Would you like to delete this comment?"
                      ,
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
                          if(comment_type == 'response'){
                            delete_reply(comment_id);
                          }else{
                            delete_comment(comment_id);
                          }
                          setState(() {
                            loading = true;
                          });
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
    );
  }

  Widget shimmer_child(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text(
                    ''
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.30,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text(
                    ''
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.grey,
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
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text(
                    ''
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
