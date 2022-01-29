import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/watch_video_page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:intl/intl.dart';

class video_read_more extends StatefulWidget {
  var particular_ad;

  video_read_more({Key key, @required this.particular_ad})
      : super(key: key);

  @override
  _video_read_moreState createState() => _video_read_moreState();
}

class _video_read_moreState extends State<video_read_more> {
  Map data = {};

  PageController _pageController;

  List<Widget> pageview_children = [];

  Future get_video_ad_initial_values() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_get_ad/${widget.particular_ad}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var additional_pics_response = await http.get(
        'https://pridamo.com/app_get_additional_images/${widget.particular_ad}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var all_additional_pics = await jsonDecode(utf8.decode(additional_pics_response.bodyBytes));

    if(all_additional_pics.isNotEmpty){
      all_additional_pics.forEach((additional_pic){
        setState(() {
          pageview_children.add(
            image_added(image_url: "https://media.pridamo.com/pridamo-static/${additional_pic['fields']['additional_image']}")
          );
        });
      });
    }

    var that_ad = jsonDecode(utf8.decode(response.bodyBytes));

    if(that_ad.length != 0){
      data['image'] = that_ad[0]['fields']['thumbnail'];

      data['category'] = that_ad[0]['fields']['category'].replaceAll(RegExp('-'), ' ');

      data['subcategory'] = that_ad[0]['fields']['subcategory'].replaceAll(RegExp('-'), ' ');

      data['product_name'] = that_ad[0]['fields']['product_name'];

      data['price'] = that_ad[0]['fields']['price'].toString();

      data['location'] = that_ad[0]['fields']['your_location'];

      data['description'] = that_ad[0]['fields']['description'];

      data['number'] = that_ad[0]['fields']['phone_number'];

      data['region'] = that_ad[0]['fields']['region'];

      data['video_url'] = "https://media.pridamo.com/pridamo-static/${that_ad[0]['fields']['video']}";

      data['product_slug'] = that_ad[0]['fields']['product_slug'];

      data['phone_number'] = that_ad[0]['fields']['phone_number'];

      data['owner_name_text'] = that_ad[0]['fields']['owner_name_text'];

      setState(() {
        pageview_children.insert(0,
            image_added(image_url: "https://media.pridamo.com/pridamo-static/${data['image']}")
        );
      });
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/userpage', (route) => false);
    }

  }

  Future _video_read_future_instance;

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

//    date_array = ['2020','12','31'];
//
//    test_date_array = ['2021','01','02'];

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

  var comment_future;

  List<Widget> comments_container = [];

  List<List<Widget>> replies_container = [];

  var comment_number = 0;

  var change_number = 15;

  var one = '1 week ago';

  var two = '2 weeks ago';

  var three = '3 weeks ago';

  List get_all_comment_ids = [];

  List all_comment_reply_button_before_values = [];

  var show_more_button = false;

  get_initial_comments()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var wallpaper_response = await http.get(
        'https://pridamo.com/get_app_wallpaper',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    if(jsonDecode(wallpaper_response.body)['image'] != ''){
      setState(() {
        my_username = jsonDecode(wallpaper_response.body)['user_name'];
      });
    }

    var response = await http.get(
        'https://pridamo.com/app_get_ad_comments/${widget.particular_ad}?num=$comment_number&change=$change_number',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      if(data.length != 0){
        number_of_comments_received = data[0]['comment_count'];
      }
    });


    if(data.length != 0){
      if(data[0]['show_more_button'] == 'yes'){
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

    data.asMap().forEach((index, datum) async {
      var new_date = datum['date'].toString().split('T')[0];

      var date_array_received = new_date.split('-');

      var test_date_to_work_with = new DateTime.now();

      var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

      var mine = false;

      if(datum['mine_or_not'] == 'yes'){
        mine = true;
      }else{
        mine = false;
      }

      var reply_number = datum['reply_number'];

      var comment_id = datum['comment_id'];

      setState(() {
        comments_container.add(comment(datum['username'], datum['comment'], datum['profile_url'], date_you_want, mine, reply_number, comment_id, false));

        how_many_replies_to_bring_per_comment.add([0,10]);

        get_all_comment_ids.add(comment_id);

        all_comment_reply_button_before_values.add([datum['username'], datum['comment'], datum['profile_url'], date_you_want, mine, reply_number, comment_id, false]);

        replies_container.add([]);

        all_replies_to_comments_ids.add([]);

        show_reply_button_or_not.add('not');
      });
    });

    comment_number += 15;

    change_number += 15;
  }

  var number_of_comments_received = 0;

  List how_many_replies_to_bring_per_comment = [];

  List show_reply_button_or_not = [];

  List all_replies_to_comments_ids = [];

  var my_username;

  get_replies_of_comment(int comment_id, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_respond_to_comment/${widget.particular_ad}?id=$comment_id&num=${how_many_replies_to_bring_per_comment[index][0]}&change=${how_many_replies_to_bring_per_comment[index][1]}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    how_many_replies_to_bring_per_comment[index][0] += 10;

    how_many_replies_to_bring_per_comment[index][1] += 10;

    var show_more_reply_button = false;

    data.asMap().forEach((new_index, datum) async {
      var new_date = datum['date'].toString().split('T')[0];

      var date_array_received = new_date.split('-');

      var test_date_to_work_with = new DateTime.now();

      var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

      var mine = false;

      if(datum['mine_or_not'] == 'yes'){
        mine = true;
      }else{
        mine = false;
      }

      setState(() {
        replies_container[index].add(reply_child(datum['username'], datum['comment'], datum['profile_url'], date_you_want, mine, datum['comment_id'], comment_id));
        all_replies_to_comments_ids[index].add(datum['comment_id']);
      });
    });

    if(data.isNotEmpty){
      if(data[0]['show_more_button'] == 'yes'){
        show_more_reply_button = true;

        all_comment_reply_button_before_values[index][7] = true;
      }else{
        show_more_reply_button = false;
      }
    }

    setState(() {
      if(replies_container[index].isEmpty){
        replies_container[index].insert(0, reply_button_stuff(comment_id, index));
      }

      comments_container.removeAt(index + 1);

      comments_container.insert(index + 1, comment(all_comment_reply_button_before_values[index][0], all_comment_reply_button_before_values[index][1],
          all_comment_reply_button_before_values[index][2], all_comment_reply_button_before_values[index][3],
          all_comment_reply_button_before_values[index][4], all_comment_reply_button_before_values[index][5],
          all_comment_reply_button_before_values[index][6], show_more_reply_button
      ));
    });


  }

  var comment_message = '';

  var comment_holder = TextEditingController();

  var reply_holder = TextEditingController();

  add_new_comment()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    comment_holder.clear();

    Fluttertoast.showToast(
      msg: "Posting review",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    var response = await http.post(
        'https://pridamo.com/app_get_ad/${widget.particular_ad}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'comment': comment_message,
        })
    );

    var data = jsonDecode(response.body);

    if(data[0]['status'] == 'commented'){
      number_of_comments_received += 1;

      how_many_replies_to_bring_per_comment.insert(0, [0,10]);

      replies_container.insert(0, []);

      all_replies_to_comments_ids.insert(0, []);

      show_reply_button_or_not.insert(0, 'not');

      data.asMap().forEach((index, datum) async {
        var new_date = datum['date'].toString().split('T')[0];

        var date_array_received = new_date.split('-');

        var test_date_to_work_with = new DateTime.now();

        var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

        var mine = true;

        var comment_id = datum['comment_id'];

        setState(() {
          comments_container.insert(1, comment(datum['username'], comment_message, datum['profile_img'], date_you_want, mine, 0, comment_id, false));

          get_all_comment_ids.insert(0, comment_id);

          all_comment_reply_button_before_values.insert(0, [datum['username'], comment_message, datum['profile_img'], date_you_want, mine, 0, comment_id, false]);
        });
      });

      comment_number += 1;

      change_number += 1;

      Fluttertoast.showToast(
        msg: "Review posted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  add_new_reply(comment_id, index)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    reply_holder.clear();

    Fluttertoast.showToast(
      msg: "Replying",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    var response = await http.post(
        'https://pridamo.com/app_respond_to_comment/${widget.particular_ad}?id=${comment_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'response': reply_message,
        })
    );

    var data = jsonDecode(response.body);

    if(data[0]['status'] == 'replied'){
      data.asMap().forEach((new_index, datum) async {
        var new_date = datum['date'].toString().split('T')[0];

        var date_array_received = new_date.split('-');

        var test_date_to_work_with = new DateTime.now();

        var date_you_want = await calculate_time_passed(test_date_to_work_with, date_array_received);

        var mine = true;

        var reply_id = datum['comment_id'];

        how_many_replies_to_bring_per_comment[index][0] += 1;

        how_many_replies_to_bring_per_comment[index][1] += 1;

        setState(() {
          replies_container[index].insert(1, reply_child(datum['username'], reply_message, datum['profile_img'], date_you_want, mine, reply_id, comment_id));
          all_replies_to_comments_ids[index].insert(0, reply_id);
        });

        setState(() {
          comments_container.removeAt(index + 1);

          comments_container.insert(index + 1, comment(all_comment_reply_button_before_values[index][0], all_comment_reply_button_before_values[index][1],
              all_comment_reply_button_before_values[index][2], all_comment_reply_button_before_values[index][3],
              all_comment_reply_button_before_values[index][4], all_comment_reply_button_before_values[index][5] += 1,
              all_comment_reply_button_before_values[index][6], all_comment_reply_button_before_values[new_index][7]
          ));
        });
      });

      Fluttertoast.showToast(
        msg: "Replied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }

  }

  app_delete_comment(id)async{
    Fluttertoast.showToast(
      msg: "Deleting review",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
      'https://pridamo.com/app_get_ad_comments/${widget.particular_ad}?delete=${id}',
      headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      },
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      var new_index = get_all_comment_ids.indexOf(id);

      number_of_comments_received -= 1;

      how_many_replies_to_bring_per_comment.removeAt(new_index);

      replies_container.removeAt(new_index);

      show_reply_button_or_not.removeAt(new_index);

      all_replies_to_comments_ids.removeAt(new_index);

      setState(() {
        comments_container.removeAt(new_index + 1);
      });

      all_comment_reply_button_before_values.removeAt(get_all_comment_ids.indexOf(id));

      get_all_comment_ids.removeAt(get_all_comment_ids.indexOf(id));

      comment_number -= 1;

      change_number -= 1;

      Fluttertoast.showToast(
        msg: "Review deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
  }

  app_delete_reply(reply_id, comment_id)async{
    Fluttertoast.showToast(
      msg: "Deleting reply",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
      'https://pridamo.com/app_respond_to_comment/${widget.particular_ad}?delete=${reply_id}',
      headers: {
        HttpHeaders.authorizationHeader: "Token $token",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      var new_index = get_all_comment_ids.indexOf(comment_id);

      how_many_replies_to_bring_per_comment[new_index][0] -= 1;

      how_many_replies_to_bring_per_comment[new_index][1] -= 1;

      setState(() {
        replies_container[new_index].removeAt(all_replies_to_comments_ids[new_index].indexOf(reply_id) + 1);
      });

      all_replies_to_comments_ids[new_index].removeAt(all_replies_to_comments_ids[new_index].indexOf(reply_id));

      setState(() {
        comments_container.removeAt(new_index + 1);

        comments_container.insert(new_index + 1, comment(all_comment_reply_button_before_values[new_index][0], all_comment_reply_button_before_values[new_index][1],
            all_comment_reply_button_before_values[new_index][2], all_comment_reply_button_before_values[new_index][3],
            all_comment_reply_button_before_values[new_index][4], all_comment_reply_button_before_values[new_index][5] -= 1,
            all_comment_reply_button_before_values[new_index][6], all_comment_reply_button_before_values[new_index][7]
        ));
      });

      Fluttertoast.showToast(
        msg: "Reply deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
  }

  var reply_message = '';

  List<Widget> similar_ads_children = [];

  var similar_ads_future;

  get_list_of_similar_ads()async{
    var response = await http.get(
      'https://pridamo.com/app_get_similar_ads/${widget.particular_ad}',
    );

    var all_similar_ads = await jsonDecode(utf8.decode(response.bodyBytes));

    if(all_similar_ads.isNotEmpty){

      all_similar_ads.forEach((similar_ad){
        if(similar_ad['fields']['ad_type'] == 'picture'){
          similar_ads_children.add(_buildPost(similar_ad['fields']['image'], similar_ad['fields']['product_name'], similar_ad['fields']['product_slug']));
        }else{
          similar_ads_children.add(buildVideoSearchResult(similar_ad['fields']['product_name'], similar_ad['fields']['thumbnail'], similar_ad['fields']['product_slug']));
        }
      });
    }

  }

  var theme_type = 'light';

  var current_picture_you_are_on = 1;

  var poster_user_name = '';

  var poster_profile_image_url = '';

  var poster_location = '';

  var poster_slug = '';

  var seller_is_you = false;

  get_profile_of_seller()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
      'https://pridamo.com/app_get_seller_posted_profile?ad=${widget.particular_ad}',
      headers: {
        HttpHeaders.authorizationHeader: "Token $token",
      },
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    if(data['mine'] == 'yes'){
      setState(() {
        seller_is_you = true;
      });
    }

    setState(() {
      poster_user_name = data['name'];

      poster_slug = data['slug'];

      poster_profile_image_url = data['pic_image'];

      poster_location = data['location'];

      gotten_seller_profile = true;
    });
  }

  var gotten_seller_profile = false;

  var profile_of_seller_future;

  var tapped_image_to_full_screen = false;

  final ScrollController _controller = ScrollController();

  var adding_to_list = false;

  Future add_to_wish_list(String product_slug) async {
    setState(() {
      adding_to_list = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_add_to_wish_list/$product_slug',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var stuff_returned = jsonDecode(response.body);

    setState(() {
      adding_to_list = false;
    });

    if(stuff_returned['status'] == 'added'){
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Successfully added',
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.blue,
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
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
      });
    }else{
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already added to wishlist',
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.blue,
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
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
      });
    }
  }

  Future report_ad(String product_slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_report_ad/$product_slug',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var stuff_returned = jsonDecode(response.body);

    if(stuff_returned['status'] == 'reported'){
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ad has been reported,thank you for making Pridamo a better place.',
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.blue,
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
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
      });
    }else{
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text(
                  'Ad has already been reported and is being held up for review,thank you for making Pridamo a better place',
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
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Cannot open your map",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
  }

  var latitude_given = '0.0';

  var longitude_given = '0.0';

  var description = '';

  var image_url = '';

  Location location = new Location();

  var map_response_received_positive = false;

  var map_future;

  var latitude_of_user = '0.0';

  var longitude_of_user = '0.0';

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

  show_bottom_sheet_of_map(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)
            )
        ),
        builder: (context){
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Description of destination',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7.0),
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(description)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Image of destination',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    'https://media.pridamo.com/pridamo-static/$image_url',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.30,
                    alignment: Alignment.center,
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    var url = 'https://www.google.com/maps/dir/?api=1&origin=$latitude_of_user,$longitude_of_user&destination=$latitude_given,$longitude_given';

                    _launchURL(url);
                  },
                  child: Text(
                      'Follow Map'
                  ),
                  textColor: Colors.blue,
                )
              ],
            ),
          );
        }
    );
  }

  var all_menu_options = [
    'Add to wishlist', 'Report', 'Share'
  ];

  var ordering_button_pushed = false;

  reset_direction()async{
    var _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    if(_serviceEnabled){
      var _permissionGranted = await location.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }else{
          location.onLocationChanged.listen((LocationData currentLocation) {
            setState(() {
              latitude_of_user = currentLocation.latitude.toString();
              longitude_of_user = currentLocation.longitude.toString();
            });
          });
        }
      }else{
        location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            latitude_of_user = currentLocation.latitude.toString();
            longitude_of_user = currentLocation.longitude.toString();
          });
        });
      }
    }
  }

  order_product()async{
    if(latitude_of_user == '0.0'){
      await reset_direction();

      order_product();
    }else{
      setState((){
        ordering_button_pushed = true;
      });

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String token = prefs.getString('token');

      var response = await http.get(
          'https://pridamo.com/profile/app_order_product?product_slug=${widget.particular_ad}&latitude=$latitude_of_user&longitude=$longitude_of_user',
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }
      );

      var response_received = jsonDecode(response.body);

      setState(() {
        ordering_button_pushed = false;

        if(response_received['status'] == 'success'){
          if(response_received['already_added'] == 'false'){
            Fluttertoast.showToast(
              msg: "Order successfully placed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            );

            Fluttertoast.showToast(
              msg: "Please do not make any payment until you receive your product",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepOrange,
              textColor: Colors.white,
            );

            var original_number = data['phone_number'];

            var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

            launchWhatsapp(correct_number, 'New order from Pridamo');
          }else{
            Fluttertoast.showToast(
              msg: "Order already placed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.deepOrangeAccent,
              textColor: Colors.white,
            );
          }
        }else{
          Fluttertoast.showToast(
            msg: "An error occured, please try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _video_read_future_instance = get_video_ad_initial_values();

    comment_future = get_initial_comments();

    comments_container.add(comment_button_stuff());

    similar_ads_future = get_list_of_similar_ads();

    profile_of_seller_future = get_profile_of_seller();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return WillPopScope(
      onWillPop: ()async{
        if(tapped_image_to_full_screen == false){
          return true;
        }else{
          setState(() {
            tapped_image_to_full_screen = false;
          });
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: tapped_image_to_full_screen == false ? Theme.of(context).canvasColor : Colors.black,
        body: Builder(
          builder: (context){
            if(data['image'] == null){
              return Shimmer.fromColors(
                highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      shimmer_child(),
                    ],
                  ),
                ),
              );
            }else{
              return CustomScrollView(
                physics: tapped_image_to_full_screen == false ? ScrollPhysics() : NeverScrollableScrollPhysics(),
                controller: _controller,
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: tapped_image_to_full_screen == false ? MediaQuery.of(context).size.height * 0.40 : MediaQuery.of(context).size.height * 1,
                    pinned: true,
                    leading: tapped_image_to_full_screen == false ? IconButton(
                      icon: Icon(
                          Icons.arrow_back
                      ),
                      onPressed: (){
                        if(tapped_image_to_full_screen == true){
                          setState(() {
                            tapped_image_to_full_screen = false;
                          });
                        }else{
                          Navigator.pop(context);
                        }
                      },
                    ) : SizedBox.shrink(),
                    actions: [
                      seller_is_you == false ? Builder(
                        builder: (context){
                          if(tapped_image_to_full_screen == false){
                            return PopupMenuButton(
                              onSelected: (choice){
                                if(choice == 'Report') {
                                  report_ad(widget.particular_ad);
                                }else if(choice == 'Share'){
                                  Share.share("https://pridamo.com/${widget.particular_ad}");
                                }else{
                                  add_to_wish_list(widget.particular_ad);
                                }
                              },
                              itemBuilder: (context){
                                return all_menu_options.map((choice) {
                                  return PopupMenuItem(
                                    value: choice,
                                    child: Row(
                                      children: [
                                        Text(
                                            choice
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList();
                              },
                            );
                          }else{
                            return SizedBox.shrink();
                          }
                        },
                      ) : SizedBox.shrink(),
                      seller_is_you == true ? PopupMenuButton(
                          onSelected: (choice){
                            Share.share("https://pridamo.com/${widget.particular_ad}");
                          },
                          itemBuilder: (context){
                            return ['Share'].map((choice){
                              return PopupMenuItem(
                                value: choice,
                                child: Row(
                                  children: [
                                    Text(choice)
                                  ],
                                ),
                              );
                            }).toList();
                          }
                      ) : SizedBox.shrink()
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: pageview_children.length > 1 ? Stack(
                        children: [
                          InkWell(
                            onTap:(){
                              if(tapped_image_to_full_screen == false){
                                Fluttertoast.showToast(
                                  msg: "Double tap to view full image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                              }else{
                                Fluttertoast.showToast(
                                  msg: "Double tap to exit full image display",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            onDoubleTap: (){
                              setState(() {
                                if(tapped_image_to_full_screen == false){
                                  tapped_image_to_full_screen = true;

                                  _controller.animateTo(
                                      0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeOut
                                  );
                                }else{
                                  tapped_image_to_full_screen = false;
                                }
                              });
                            },
                            child: tapped_image_to_full_screen == false ? CarouselSlider.builder(
                              options: CarouselOptions(
                                  height: MediaQuery.of(context).size.height * 0.40,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  autoPlayInterval: Duration(seconds: 3),
                                  onPageChanged: (index, something){
                                    setState(() {
                                      current_picture_you_are_on = index + 1;
                                    });
                                  }
                              ),
                              itemCount: pageview_children.length,
                              itemBuilder: (context, index, real_index){
                                return pageview_children[index];
                              },
                            ) : PageView(
                              controller: _pageController,
                              children: pageview_children,
                            ),
                          ),
                          tapped_image_to_full_screen == false ? Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: Icon(
                                        Icons.camera_alt,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        '${current_picture_you_are_on}/${pageview_children.length}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ) : SizedBox.shrink(),
                          tapped_image_to_full_screen == false ?
                          seller_is_you != true ? Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: IconButton(
                                    icon: Icon(Icons.message_rounded),
                                    onPressed: ()async{
                                      var original_number = data['phone_number'];

                                      var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                                      await launchWhatsapp(correct_number, 'Hello from Pridamo');
                                    },
                                  ),
                                ),
                            ),
                          ) : SizedBox.shrink()
                          : SizedBox.shrink(),
                          tapped_image_to_full_screen == false ? Positioned.fill(
                            bottom: 10.0,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 60.0,
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => watch_video_page(video_url: data['video_url'], video_name: data['product_name']),
                                      ),
                                    );
                                  },
                                )
                            ),
                          ) : SizedBox.shrink(),
                        ],
                      ) : Stack(
                        children: [
                          InkWell(
                            onTap:(){
                              if(tapped_image_to_full_screen == false){
                                Fluttertoast.showToast(
                                  msg: "Double tap to view full image",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                              }else{
                                Fluttertoast.showToast(
                                  msg: "Double tap to exit full image display",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                );
                              }
                            },
                            onDoubleTap: (){
                              setState(() {
                                if(tapped_image_to_full_screen == false){
                                  tapped_image_to_full_screen = true;

                                  _controller.animateTo(
                                      0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeOut
                                  );
                                }else{
                                  tapped_image_to_full_screen = false;
                                }
                              });
                            },
                            child: PageView(
                                controller: _pageController,
                                children: pageview_children
                            ),
                          ),
                          tapped_image_to_full_screen == false ?
                          seller_is_you != true ? Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: IconButton(
                                    icon: Icon(Icons.message_rounded),
                                    onPressed: ()async{
                                      var original_number = data['phone_number'];

                                      var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                                      await launchWhatsapp(correct_number, 'Hello from Pridamo');
                                    },
                                  ),
                                ),
                            ),
                          ) : SizedBox.shrink()
                            : SizedBox.shrink(),
                          tapped_image_to_full_screen == false ? Positioned.fill(
                            bottom: 10.0,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  iconSize: 60.0,
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => watch_video_page(video_url: data['video_url'], video_name: data['product_name']),
                                      ),
                                    );
                                  },
                                )
                            ),
                          ) : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: ordering_button_pushed == false ?
                      seller_is_you == false ? FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Order',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            )
                          ],
                        ),
                        color: Colors.orange[800],
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                        onPressed: ()async{
                          var _serviceEnabled = await location.serviceEnabled();

                          if (!_serviceEnabled) {
                            _serviceEnabled = await location.requestService();
                            if (!_serviceEnabled) {
                              return;
                            }
                          }

                          if(_serviceEnabled){
                            var _permissionGranted = await location.hasPermission();

                            if (_permissionGranted == PermissionStatus.denied) {
                              _permissionGranted = await location.requestPermission();
                              if (_permissionGranted != PermissionStatus.granted) {
                                return;
                              }else{
                                location.onLocationChanged.listen((LocationData currentLocation) {
                                  setState(() {
                                    latitude_of_user = currentLocation.latitude.toString();
                                    longitude_of_user = currentLocation.longitude.toString();
                                  });
                                });

                                order_product();
                              }
                            }else{
                              location.onLocationChanged.listen((LocationData currentLocation) {
                                setState(() {
                                  latitude_of_user = currentLocation.latitude.toString();
                                  longitude_of_user = currentLocation.longitude.toString();
                                });
                              });

                              order_product();
                            }
                          }
                        },
                      ) : SizedBox.shrink()
                          : Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                          child: CircularProgressIndicator(),
                        ),
                      )
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Seller",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: FutureBuilder(
                          future: profile_of_seller_future,
                          builder: (context, snapshot){
                            if(gotten_seller_profile == true){
                              return ListTile(
                                onTap: (){
                                  seller_is_you == false ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => read_another_profile(particular_dude: poster_slug.toLowerCase()),
                                    ),
                                  ) : null;
                                },
                                title: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5
                                  ),
                                  child: Text(
                                    toBeginningOfSentenceCase(poster_user_name),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/$poster_profile_image_url'),
                                  radius: 25.0,
                                ),
                                subtitle: Text(
                                  poster_location,
                                  maxLines: null,
                                ),
                              );
                            }else{
                              return Center(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.08,
                                  width: MediaQuery.of(context).size.width * 0.08,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }
                      )
                  ),
                  SliverToBoxAdapter(
                    child: FlatButton(
                      textColor: Colors.green,
                      onPressed: (){
                        var url = 'https://www.google.com/maps/dir/?api=1&origin=6.6674596,-1.5864236&destination=6.684873,-1.5730912';

                        _launchURL(url);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              'Directions'
                          ),
                          Icon(
                              Icons.directions
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        toBeginningOfSentenceCase(data['product_name']),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['description'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        int.parse(data["price"]) != 1 ? '${data["price"]} Cedis' : '${data["price"]} Cedi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Region: ${data["region"]}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Location: ${data["location"]}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: FlatButton(
                      onPressed: () => launch(
                        "tel://${data['phone_number']}"
                      ),
                      child: new Text(
                        'Phone Number: ${data['phone_number']}'
                      ),
                      textColor: Colors.blueAccent,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: FutureBuilder(
                      future: similar_ads_future,
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.done){
                          if(similar_ads_children.isEmpty){
                            return SizedBox.shrink();
                          }else{
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,10,0,15),
                                  child: Text(
                                    'Similar Products/Services',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Column(
                                  children: similar_ads_children,
                                ),
                              ],
                            );
                          }
                        }else{
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ExpansionTile(
                      title: Text(
                        '$number_of_comments_received ${comments_container.length == 2 ? 'Review': 'Reviews' } '
                      ),
                      children: <Widget>[
                        FutureBuilder(
                          future: comment_future,
                          builder: (context, snapshot){
                            return Column(
                              children: [
                                Column(
                                  children: comments_container
                                ),
                                Column(
                                  children: [
                                    Builder(
                                      builder: (context){
                                        if(show_more_button){
                                          return FlatButton(
                                            child: Text(
                                              'Show More',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18.0
                                              )
                                            ),
                                            onPressed: (){
                                              get_initial_comments();
                                            },
                                          );
                                        }else{
                                          return SizedBox.shrink();
                                        }
                                      },
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
          }
        ),
      ),
    );
  }

  Widget comment_button_stuff(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: comment_holder,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value){
                setState(() {
                  comment_message = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Add A Public Comment',
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
                await add_new_comment();
              }
            },
          )
        ],
      ),
    );
  }

  Widget reply_button_stuff(comment_id, reply_container_index){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: reply_holder,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value){
                setState(() {
                  reply_message = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Reply to comment',
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
              if(reply_message.isNotEmpty){
                await add_new_reply(comment_id, reply_container_index);
              }
            },
          )
        ],
      ),
    );
  }

  Widget comment(String name, String comment, String image, String date, bool mine, int reply_number, comment_id, show_more_replies_button){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: InkWell(
              onTap: (){
                if(my_username != name.toLowerCase()){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => read_another_profile(particular_dude: name),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/${image}'),
                backgroundColor: Colors.white,
                radius: 30.0,
              ),
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
                  SizedBox(height: 10.0),
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
                          comment,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Builder(
                          builder: (context){
                            var reply_number_text;

                            if(reply_number > 0){
                              if(reply_number == 1){
                                reply_number_text = '1 Reply';
                              }else{
                                reply_number_text = '$reply_number Replies';
                              }
                            }else{
                              reply_number_text = 'Reply';
                            }
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                child: Text(
                                  reply_number_text,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onTap: (){
                                  if(show_reply_button_or_not[get_all_comment_ids.indexOf(comment_id)] == 'show'){
                                    setState(() {
                                      show_reply_button_or_not[get_all_comment_ids.indexOf(comment_id)] = 'not';
                                    });
                                  }else{
                                    setState(() {
                                      show_reply_button_or_not[get_all_comment_ids.indexOf(comment_id)] = 'show';
                                    });
                                  }

                                  get_replies_of_comment(comment_id, get_all_comment_ids.indexOf(comment_id));
                                },
                              ),
                            );
                          }
                      ),
                      Builder(
                          builder: (context){
                            if(mine){
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.blue,
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
                                                  app_delete_comment(comment_id);

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
                                ),
                              );
                            }else{
                              return SizedBox.shrink();
                            }
                          }
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Builder(
                        builder: (context){
                          if(show_reply_button_or_not[get_all_comment_ids.indexOf(comment_id)] == 'not'){
                            return SizedBox.shrink();
                          }else{
                            if(show_more_replies_button){
                              return Column(
                                children: [
                                  Column(
                                      children: replies_container[get_all_comment_ids.indexOf(comment_id)]
                                  ),
                                  Column(
                                    children: [
                                      FlatButton(
                                        child: Text(
                                          'Show More',
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        onPressed: (){
                                          get_replies_of_comment(comment_id, get_all_comment_ids.indexOf(comment_id));
                                        },
                                      )
                                    ],
                                  )
                                ],
                              );
                            }else{
                              return Column(
                                  children: replies_container[get_all_comment_ids.indexOf(comment_id)]
                              );
                            }
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget reply_child(String name, String comment, String image, String date, bool mine, int reply_id, comment_id){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: InkWell(
              onTap: (){
                if(my_username != name.toLowerCase()){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => read_another_profile(particular_dude: name),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/${image}'),
                backgroundColor: Colors.white,
                radius: 30.0,
              ),
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
                  Builder(
                      builder: (context){
                        if(mine){
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("Delete Reply"),
                                        content: Text(
                                            "Would you like to permanently remove your reply?"
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red
                                                )
                                            ),
                                            onPressed: ()async{
                                              app_delete_reply(reply_id, comment_id);
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
                            ),
                          );
                        }else{
                          return SizedBox.shrink();
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPost(String cover_photo, String product_name, String product_slug){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => picture_read_more(particular_ad: product_slug),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image(
                image: NetworkImage("https://media.pridamo.com/pridamo-static/$cover_photo"),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      product_name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoSearchResult(String product_name,String thumbnail, String product_slug){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => video_read_more(particular_ad: product_slug),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image(
                image: NetworkImage("https://media.pridamo.com/pridamo-static/$thumbnail"),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.15,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      product_name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Video',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmer_child(){
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.40,
          margin: EdgeInsets.only(bottom: 10.0),
          color: Colors.grey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.15,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: Text(
                '',
              ),
            ),
          ],
        )
      ],
    );
  }

}


class image_added extends StatefulWidget {
  var image_url;

  image_added({Key key, @required this.image_url}) : super(key: key);

  @override
  _image_addedState createState() => _image_addedState();
}

class _image_addedState extends State<image_added> with AutomaticKeepAliveClientMixin<image_added>{
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 1.5,
      child: Center(
        child: Image.network(
          widget.image_url,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null ?
                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
