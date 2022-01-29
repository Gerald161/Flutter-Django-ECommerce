import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';

class wish_lists extends StatefulWidget {
  @override
  _wish_listsState createState() => _wish_listsState();
}

class _wish_listsState extends State<wish_lists> {
  List<Widget> ad_container = [];

  String it_is_empty_message = '';

  List product_slug_container = [];

  ScrollController _scrollController = ScrollController();

  Future<List> remove_ad_from_wish_list(product_slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/profile/app_remove_ad_from_wish_list/$product_slug',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['status'] == 'removed'){
      var index_of_removed_item = product_slug_container.indexOf(product_slug);
      setState(() {
        product_slug_container.removeAt(index_of_removed_item);
        ad_container.removeAt(index_of_removed_item);

        Fluttertoast.showToast(
          msg: "Product removed from list",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      });
    }
  }

  Future wish_list_items_added_initially() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_wishlist',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    List stuff_returned = jsonDecode(response.body);

    stuff_returned.asMap().forEach((index, ha) async {
      if(ha['fields']['ad_type'] == 'picture'){
        ad_container.add(_buildPost("https://media.pridamo.com/pridamo-static/${ha['fields']['image']}", ha['fields']['product_name'], ha['fields']['product_slug']));
      }else{
        ad_container.add(buildVideoSearchResult(ha['fields']['product_name'], ha['fields']['thumbnail'], ha['fields']['product_slug']));
      }
      product_slug_container.add(ha['fields']['product_slug']);
    });
    if(product_slug_container.isEmpty){
      setState(() {
        it_is_empty_message = 'No product in your wishlist';
      });
    }

    setState(() {
      gotten_response = true;
    });
  }

  var gotten_response = false;

  Future all_wishlists;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_wishlists = wish_list_items_added_initially();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: all_wishlists,
        builder: (context, snapshot) {
          if(ad_container.isEmpty){
            if(gotten_response){
              return Center(
                  child: Text(
                    it_is_empty_message,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  )
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }else{
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                  children: ad_container
              ),
            );
          }
        }
      ),
    );
  }

  Widget _buildPost(String cover_photo, String product_name, String product_slug){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => picture_read_more(particular_ad: product_slug),
            ),
          );
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          secondaryActions: [
            Builder(
              builder: (context) => IconSlideAction(
                caption: 'Remove',
                color: Colors.red[600],
                icon: Icons.delete,
                onTap: () {
                  setState(() {
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            content: Text(
                              'Remove $product_name from your list?',
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("No"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text("Ok"),
                                onPressed: (){
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                  remove_ad_from_wish_list(product_slug);
                                },
                              )
                            ],
                          );
                        }
                    );
                  });
                },
              ),
            )
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Image(
                  image: NetworkImage(cover_photo),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 0
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          product_name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Tap To View Ad",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoSearchResult(String product_name,String thumbnail, String product_slug){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => video_read_more(particular_ad: product_slug),
            ),
          );
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          secondaryActions: [
            Builder(
              builder: (context) => IconSlideAction(
                caption: 'Remove',
                color: Colors.red[600],
                icon: Icons.delete,
                onTap: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Text(
                            'Remove $product_name from your list?',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("No"),
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text("Ok"),
                              onPressed: (){
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                                remove_ad_from_wish_list(product_slug);
                              },
                            )
                          ],
                        );
                      }
                    );
                  });
                },
              ),
            )
          ],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Image(
                  image: NetworkImage("https://media.pridamo.com/pridamo-static/${thumbnail}"),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 10, top: 0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          product_name,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Video",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
