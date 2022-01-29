import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/main_page/all_user_pages.dart';
import 'package:pridamo/userpages/comment_made_on_your_product.dart';
import 'package:pridamo/userpages/notification_message_page.dart';
import 'package:pridamo/userpages/response_on_your_comment_page.dart';
import 'package:pridamo/userpages/sent_addresses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class notifications extends StatefulWidget {
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> with AutomaticKeepAliveClientMixin<notifications>{
  List<Widget> all_notification_container = [];

  var notification_num = 0;

  var received_response = false;

  var notification_change = 12;

  get_newer_notifications()async{
    setState(() {
      received_response = false;
    });

    notification_num = 0;

    notification_change = 12;

    all_notification_container = [];

    all_notification_ids = [];

    get_notification_set();
  }

  var all_notification_ids = [];

  get_notification_set()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_notifications?num=$notification_num&change=$notification_change',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    setState(() {
      received_response = true;
    });

    var heading;

    if(data.isNotEmpty){
      data.forEach((datum){
        if(datum['type'] == 'response'){
          heading = "${toBeginningOfSentenceCase(datum['username'])} responded to your comment";
        }else if(datum['type'] == 'message'){
          heading = "Address from ${toBeginningOfSentenceCase(datum['username'])}";
        }else if(datum['type'] == 'profile'){
          heading = "${toBeginningOfSentenceCase(datum['username'])} commented on ${datum['ad']}";
        }else{
          heading = "System Message";
        }

        var read = false;

        if(datum['status'] == 'read'){
          read = true;
        }else{
          read = false;
        }

        setState(() {
          all_notification_container.add(response_type(heading, datum['profile_url'], datum['message'], read, datum['type'], datum['notification_id']));
        });

        all_notification_ids.add(datum['notification_id']);
      });

      if(data[0]['show_more'] == 'yes'){
        setState(() {
          show_more_notifications_button = true;
        });
      }else{
        setState(() {
          show_more_notifications_button = false;
        });
      }

      notification_num += 12;

      notification_change += 12;
    }

  }

  var show_more_notifications_button = false;

  var initial_notifications_received;

  change_read_unread_status(type, id, subtitle)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_notifications?notification_number=$id',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'safe'){
      if(type == 'response' || type == 'profile'){
        if(type == 'response'){
          notification_num = 0;

          notification_change = 12;

          all_notification_container = [];

          await get_notification_set();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => comment_response_page(comment_id: id),
            ),
          );
        }else{
          notification_num = 0;

          notification_change = 12;

          all_notification_container = [];

          await get_notification_set();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => product_comments(comment_id: id),
            ),
          );
        }
      }else{
        if(type == 'message'){
          notification_num = 0;

          notification_change = 12;

          all_notification_container = [];

          await get_notification_set();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => notification_message_page(message_type: 'Address', message: subtitle),
            ),
          );
        }else{
          notification_num = 0;

          notification_change = 12;

          all_notification_container = [];

          await get_notification_set();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => notification_message_page(message_type: 'System Message', message: subtitle),
            ),
          );
        }

      }
    }
  }

  mark_all_unread()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_notifications?action=ok',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'safe'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => all_user_pages(),
        ),
      );
    }
  }

  var theme_type = 'light';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_notifications_received = get_notification_set();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'Addressing Place Thingy',
          backgroundColor: theme_type == 'light' ? Colors.blue : Colors.grey[800],
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => sent_address_page(),
              ),
            );
          },
          tooltip: "Sent Addresses",
          child: Icon(
            Icons.send,
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Reviews'
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: (){
            return get_newer_notifications();
          },
          child: FutureBuilder(
            future: initial_notifications_received,
            builder: (context, snapshot){
              if(all_notification_container.isEmpty){
                return received_response != true ? Shimmer.fromColors(
                  highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                  baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                        notification_shimmer(),
                      ],
                    ),
                  ),
                ) : ListView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sorry no review present',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }else{
                return SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        all_notification_container.isNotEmpty ? FlatButton(
                          child: Text(
                            'Mark all as read',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0
                            ),
                          ),
                          onPressed: (){
                            mark_all_unread();
                          },
                        ): SizedBox.shrink(),
                        Column(
                          children: all_notification_container,
                        ),
                        Builder(
                          builder: (context){
                            if(show_more_notifications_button){
                              return FlatButton(
                                child: Text(
                                  'Show More',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: (){
                                  get_notification_set();
                                },
                              );
                            }else{
                              return SizedBox.shrink();
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
        )
    );
  }

  Widget response_type(heading, image_url, subtitle, read, type, id){
    return read ? ListTile(
      onTap: (){
        if(read == false){
          var old_index = all_notification_ids.indexOf(id);

          all_notification_container.removeAt(old_index);

          all_notification_container.insert(old_index, response_type(heading, image_url, subtitle, true, type, id));
        }

        change_read_unread_status(type, id, subtitle);
      },
      title: Text(
        heading,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/$image_url'),
        radius: 25.0,
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ) : ListTile(
      onTap: (){
        if(read == false){
          var old_index = all_notification_ids.indexOf(id);

          all_notification_container.removeAt(old_index);

          all_notification_container.insert(old_index, response_type(heading, image_url, subtitle, true, type, id));
        }

        change_read_unread_status(type, id, subtitle);
      },
      title: Text(
        heading,
        style: TextStyle(
          color: Colors.white
        ),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/$image_url'),
        radius: 25.0,
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget notification_shimmer(){
    return ListTile(
      title: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Text(
            ''
        ),
      ),
      subtitle: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        margin: EdgeInsets.only(top: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Text(
            ''
        ),
      ),
      leading: CircleAvatar(

      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
