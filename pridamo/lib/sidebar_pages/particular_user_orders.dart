import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class particular_user_orders extends StatefulWidget {
  var store_id;

  var name;

  particular_user_orders({Key key, @required this.store_id, @required this.name})
      : super(key: key);

  @override
  _particular_user_ordersState createState() => _particular_user_ordersState();
}

class _particular_user_ordersState extends State<particular_user_orders> {
  List<Widget> all_stores_gotten = [];

  var initial_future;

  var show_more_button = false;

  var show_loading_spinner = false;

  var user_number = '';

  var num = 0;

  var change = 10;

  var total_price = '';

  var response_received = false;

  var delivery_fee = '';

  var latitude_given = '0.0';

  var longitude_given = '0.0';

  var latitude_of_user = '0.0';

  var longitude_of_user = '0.0';

  var direction_image = '';

  var direction_description = '';

  var got_direction_image = false;

  get_all_ordered_stores() async {
    setState(() {
      show_loading_spinner = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_get_particular_store_orders?num=$num&change=$change&id=${widget.store_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var all_stores = jsonDecode(response.body);

    all_stores.forEach((store){
      setState(() {
        if(store['ad_type'] == 'picture'){
          all_stores_gotten.add(
              profile_card(store['image'], store['name'], store['price'], store['product_slug'], store['ad_type'])
          );
        }else{
          all_stores_gotten.add(
              profile_card(store['thumbnail'], store['name'], store['price'], store['product_slug'], store['ad_type'])
          );
        }
      });
    });

    if(all_stores.length > 0){
      if(all_stores[0]['show_more'] == 'no'){
        setState(() {
          show_more_button = false;
        });
      }else{
        setState(() {
          show_more_button = true;
        });
      }

      setState(() {
        total_price = all_stores[0]['total_price'].toString();

        response_received = true;

        user_number = all_stores[0]['phone_number'].toString();

        latitude_given = all_stores[0]["latitude"];

        longitude_given = all_stores[0]["longitude"];

        delivery_fee = all_stores[0]['delivery_fee'].toString();

        if(all_stores[0]['direction_image'] != ''){
          direction_image = all_stores[0]['direction_image'];

          got_direction_image = true;
        }else{
          got_direction_image = false;
        }

        direction_description = all_stores[0]['direction_description'];

        show_loading_spinner = false;
      });

      num += 10;

      change += 10;
    }else{
      Navigator.pop(context, 'refresh');
    }

  }

  refresh_list()async{
    setState(() {
      all_stores_gotten = [];

      user_number = '';

      show_more_button = false;

      show_loading_spinner = false;

      num = 0;

      change = 10;

      total_price = '';

      response_received = false;

      get_all_ordered_stores();
    });
  }

  Location location = new Location();

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

  accepted_to_deliver()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_accept_particular_user_order?delivery_fee=$delivery_fee&id=${widget.store_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'success'){
      Fluttertoast.showToast(
        msg: "Order has been accepted and awaiting your delivery",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      var original_number = user_number;

      var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

      launchWhatsapp(correct_number, 'Order has been accepted via Pridamo, please await our arrival');
    }
  }

  accept_order(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return AlertDialog(
                  title: Text(
                    'Start Delivery',
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    child: Column(
                      children: [
                        FlatButton(
                          child: Text(
                            'Deliver',
                            textAlign: TextAlign.center,
                          ),
                          textColor: Colors.blue,
                          onPressed: ()async{
                            accepted_to_deliver();

                            Navigator.pop(context);

                            Navigator.pop(context);
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
  }

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

    refresh_list();
  }

  reject_order()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_reject_particular_user_order?id=${widget.store_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'success'){
      Fluttertoast.showToast(
        msg: "Order has been declined",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrange,
        textColor: Colors.white,
      );

      var original_number = user_number;

      var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

      launchWhatsapp(correct_number, 'Sorry but we cannot currently take this order(Pridamo)');

      Navigator.pop(context, 'refresh');
    }
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
                  padding: const EdgeInsets.all(8.0),
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
                      Text(direction_description)
                    ],
                  ),
                ),
                got_direction_image == true ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Image of destination',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ) : SizedBox.shrink(),
                got_direction_image == true ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    'https://media.pridamo.com/pridamo-static/$direction_image',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.30,
                    alignment: Alignment.center,
                  ),
                ) : SizedBox.shrink(),
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

  change_current_lat_and_long_of_rider(latitude_selected, longitude_selected)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    await http.get(
        'https://pridamo.com/profile/app_get_particular_store_orders?id=${widget.store_id}&lat=$latitude_selected&long=$longitude_selected',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );
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
          title: Text(toBeginningOfSentenceCase(widget.name)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.location_on),
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

                          change_current_lat_and_long_of_rider(currentLocation.latitude.toString(), currentLocation.longitude.toString());
                        });
                      });

                      show_bottom_sheet_of_map();
                    }
                  }else{
                    location.onLocationChanged.listen((LocationData currentLocation) {
                      setState(() {
                        latitude_of_user = currentLocation.latitude.toString();
                        longitude_of_user = currentLocation.longitude.toString();

                        change_current_lat_and_long_of_rider(currentLocation.latitude.toString(), currentLocation.longitude.toString());
                      });
                    });

                    show_bottom_sheet_of_map();
                  }
                }
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          onPressed: (){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Container(
                      child: Column(
                        children: [
                          FlatButton(
                            child: Text(
                              'Accept Order'
                            ),
                            textColor: Colors.blue,
                            onPressed: ()async{
                              accept_order();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Reject Order'
                            ),
                            textColor: Colors.red,
                            onPressed: ()async{
                              reject_order();
                            },
                          ),
                          FlatButton(
                            child: Text(
                                'Call'
                            ),
                            textColor: Colors.blue,
                            onPressed: ()async{
                              Navigator.pop(context);
                              launch(
                                "tel://${user_number}"
                              );
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Cancel'
                            ),
                            textColor: Colors.blue,
                            onPressed: ()async{
                              Navigator.pop(context);
                            },
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
          },
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            total_price != '1' ? 'Total Price: $total_price cedis' : 'Total Price: $total_price cedi',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            delivery_fee != '1' ? 'Delivery fee: $delivery_fee cedis' : 'Delivery fee: $delivery_fee cedi',
                            textAlign: TextAlign.center,
                          ),
                        ),
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
                              'Sorry no orders to this store',
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

  Widget profile_card(image_url, name, price, slug, ad_type){
    return ListTile(
      onTap: (){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    children: [
                      FlatButton(
                        child: Text(
                            'View Product'
                        ),
                        textColor: Colors.blue,
                        onPressed: ()async{
                          Navigator.pop(context);

                          if(ad_type == 'picture'){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => picture_read_more(particular_ad: slug),
                              ),
                            );
                          }else{
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => video_read_more(particular_ad: slug),
                              ),
                            );
                          }
                        },
                      ),
                      FlatButton(
                        child: Text(
                            'Cancel'
                        ),
                        textColor: Colors.blue,
                        onPressed: ()async{
                          Navigator.pop(context);
                        },
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
      },
      title: Text(
        toBeginningOfSentenceCase(name),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/$image_url'),
        radius: 25.0,
      ),
      subtitle: Text(
        price,
      ),
    );
  }
}
