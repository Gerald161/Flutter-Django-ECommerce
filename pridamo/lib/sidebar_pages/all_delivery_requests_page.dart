import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pridamo/sidebar_pages/particular_user_orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class all_delivery_requests_page extends StatefulWidget {
  @override
  _all_delivery_requests_pageState createState() => _all_delivery_requests_pageState();
}

class _all_delivery_requests_pageState extends State<all_delivery_requests_page> {
  List<Widget> all_stores_gotten = [];

  var initial_future;

  var show_more_button = false;

  var show_loading_spinner = false;

  var num = 0;

  var change = 10;

  var response_received = false;

  get_all_ordered_stores() async {
    setState(() {
      show_loading_spinner = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_get_all_ordered_users?num=$num&change=$change',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var all_stores = jsonDecode(response.body);

    setState(() {
      show_loading_spinner = false;

      response_received = true;
    });

    all_stores.forEach((store){
      setState(() {
        if(store['status'] == 'pending'){
          all_stores_gotten.add(
              profile_card(store['profile_url'], store['name'], 'pending', store['id'])
          );
        }else{
          all_stores_gotten.add(
              profile_card(store['profile_url'], store['name'], 'en route', store['id'])
          );
        }
      });
    });

    if(all_stores.length > 0){
      if(all_stores[0]['show_more_button'] == 'no'){
        setState(() {
          show_more_button = false;
        });
      }else{
        setState(() {
          show_more_button = true;
        });
      }

      num += 10;

      change += 10;
    }

  }

  refresh_list()async{
    setState(() {
      all_stores_gotten = [];

      response_received = false;

      show_more_button = false;

      show_loading_spinner = false;

      num = 0;

      change = 10;

      get_all_ordered_stores();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_future = get_all_ordered_stores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All delivery requests'),
        centerTitle: true,
      ),
        body: RefreshIndicator(
          onRefresh: (){
            return refresh_list();
          },
          child: FutureBuilder(
            future: initial_future,
            builder: (context, snapshot){
              if(all_stores_gotten.isNotEmpty){
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      Column(
                        children: all_stores_gotten,
                      ),
                      Builder(
                          builder: (context){
                            if(show_more_button == true){
                              return show_loading_spinner == false ? FlatButton(
                                child: Text(
                                  'Show More',
                                ),
                                textColor: Colors.blue,
                                onPressed: (){
                                  get_all_ordered_stores();
                                },
                              ) : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.08,
                                    width: MediaQuery.of(context).size.width * 0.08,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
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
                return response_received == false ? Center(
                  child: CircularProgressIndicator(),
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
                              'No deliveries requested',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }
            },
          ),
        )
    );
  }

  Widget profile_card(image_url, name, accepted_or_not, id){
    return ListTile(
      onTap: ()async{
        var order_reponse_received = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => particular_user_orders(store_id: id, name: name),
          ),
        );

        if(order_reponse_received != null){
          if(order_reponse_received == 'refresh'){
            refresh_list();
          }
        }
      },
      title: Text(
        toBeginningOfSentenceCase(name),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/$image_url'),
        radius: 25.0,
      ),
      subtitle: Text(
        accepted_or_not == 'pending' ? 'Pending Delivery' : 'En Route',
        style: TextStyle(
            color: Colors.green
        ),
      ),
    );
  }
}
