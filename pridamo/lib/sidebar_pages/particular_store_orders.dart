import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class particular_store_orders extends StatefulWidget {
  var store_id;

  var name;

  particular_store_orders({Key key, @required this.store_id, @required this.name})
      : super(key: key);

  @override
  _particular_store_ordersState createState() => _particular_store_ordersState();
}

class _particular_store_ordersState extends State<particular_store_orders> {
  List<Widget> all_stores_gotten = [];

  var initial_future;

  var show_more_button = false;

  var show_loading_spinner = false;

  var num = 0;

  var change = 10;

  var total_price = '';

  var response_received = false;

  var delivery_fee = '0';

  var owner_number = '';

  var current_latitude_of_rider = '0.0';

  var current_longitude_of_rider = '0.0';

  var latitude_of_user = '0.0';

  var longitude_of_user = '0.0';

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

        show_loading_spinner = false;

        delivery_fee = all_stores[0]['delivery_fee'].toString();

        owner_number = all_stores[0]['owner_number'].toString();

        current_latitude_of_rider = all_stores[0]['current_latitude_of_rider'].toString();

        current_longitude_of_rider  = all_stores[0]['current_longitude_of_rider'].toString();
      });

      num += 10;

      change += 10;
    }else{
      Navigator.pop(context, 'refresh');
    }

  }

  remove_item_from_wishlist(product_slug)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_remove_particular_store_item?slug=$product_slug&id=${widget.store_id}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data_response_received = jsonDecode(response.body);

    if(data_response_received['status'] == 'success'){
      Fluttertoast.showToast(
        msg: "Order successfully removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      setState(() {
        all_stores_gotten = [];

        show_more_button = false;

        show_loading_spinner = false;

        num = 0;

        change = 10;

        total_price = '';

        response_received = false;

        if(data_response_received['show'] == 'yes'){
          get_all_ordered_stores();
        }else{
          if(delivery_fee == '0'){
            Navigator.pop(context, 'refresh');
          }else{
            var original_number = owner_number;

            var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

            launchWhatsapp(correct_number, 'Sorry but I want to cancel my order(Pridamo)');

            Navigator.pop(context, 'refresh');
          }
        }
      });
    }
  }

  Location location = new Location();

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

  refresh_list()async{
    setState(() {
      all_stores_gotten = [];

      show_more_button = false;

      show_loading_spinner = false;

      num = 0;

      change = 10;

      total_price = '';

      response_received = false;

      get_all_ordered_stores();
    });
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

  var current_latitude_of_user = '0.0';

  var current_longitude_of_user = '0.0';

  reset_direction()async{
    var _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Fluttertoast.showToast(
          msg: "Please enable location permission in 'Permissions' for Pridamo and turn on Location for products to be displayed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        AppSettings.openAppSettings();
      }
    }

    if(_serviceEnabled){
      var _permissionGranted = await location.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Fluttertoast.showToast(
            msg: "Please enable location permission in 'Permissions' for Pridamo and turn on Location for products to be displayed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );

          AppSettings.openAppSettings();
        }else{
          location.onLocationChanged.listen((LocationData currentLocation) {
            setState(() {
              current_latitude_of_user = currentLocation.latitude.toString();
              current_longitude_of_user = currentLocation.longitude.toString();
            });
          });
        }
      }else{
        location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            current_latitude_of_user = currentLocation.latitude.toString();
            current_longitude_of_user = currentLocation.longitude.toString();
          });
        });
      }
    }
  }

  get_current_location_of_user()async{
    if(current_latitude_of_user == '0.0'){
      await reset_direction();

      get_current_location_of_user();
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String token = prefs.getString('token');

      await http.get(
          'https://pridamo.com/profile/app_set_current_latitude_and_longitude?latitude=$current_latitude_of_user&longitude=$current_longitude_of_user',
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }
      );

      Fluttertoast.showToast(
        msg: "Current location updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }
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
              icon: Icon(Icons.public),
              color: Colors.white,
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
                                'Call'
                              ),
                              textColor: Colors.blue,
                              onPressed: ()async{
                                Navigator.pop(context);
                                launch(
                                  "tel://${owner_number}"
                                );
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Update Location'
                              ),
                              textColor: Colors.green,
                              onPressed: ()async{
                                await get_current_location_of_user();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Follow Order'
                              ),
                              textColor: Colors.blue,
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

                                      var url = 'https://www.google.com/maps/dir/?api=1&origin=$latitude_of_user,$longitude_of_user&destination=$current_latitude_of_rider,$current_longitude_of_rider';

                                      _launchURL(url);
                                    }
                                  }else{
                                    location.onLocationChanged.listen((LocationData currentLocation) {
                                      setState(() {
                                        latitude_of_user = currentLocation.latitude.toString();
                                        longitude_of_user = currentLocation.longitude.toString();
                                      });
                                    });

                                    var url = 'https://www.google.com/maps/dir/?api=1&origin=$latitude_of_user,$longitude_of_user&destination=$current_latitude_of_rider,$current_longitude_of_rider';

                                    _launchURL(url);
                                  }
                                }

                                Navigator.pop(context);
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
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.delete,
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
                                'Cancel Order'
                            ),
                            textColor: Colors.red,
                            onPressed: ()async{
                              remove_item_from_wishlist('');

                              Navigator.pop(context);
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
                            total_price != '1' ? 'Total price of items: $total_price cedis' : 'Total price of items: $total_price cedi',
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
                        'Remove Item'
                      ),
                      textColor: Colors.red,
                      onPressed: ()async{
                        remove_item_from_wishlist(slug);
                        Navigator.pop(context);
                      },
                    ),
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
