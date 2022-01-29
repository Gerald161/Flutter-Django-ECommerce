import 'package:flutter/material.dart';
import 'package:pridamo/userpages/picture_edit.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_edit.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

class particular_user_category extends StatefulWidget {
  var particular_category;

  var user_name;

  var mine;

  particular_user_category({Key key, @required this.particular_category, @required this.user_name, @required this.mine}) : super(key: key);

  @override
  _particular_user_categoryState createState() => _particular_user_categoryState();
}

class _particular_user_categoryState extends State<particular_user_category> {
  ScrollController _scrollController = ScrollController();

  List<Widget> particular_category_children = [];

  var show_more_button = false;

  var num = 0;

  var change = 10;

  var all_category_slugs = [];

  get_category_ads()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_category_posting?category=${widget.particular_category.replaceAll(' ', '_')}&username=${widget.user_name}&num=${num}&change=${change}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var ads = jsonDecode(response.body);

    ads.forEach((ad){
      setState(() {
        particular_category_children.add(_buildPost(ad['image_url'], ad['product_name'], ad['slug'], ad['ad_type'].toString().toLowerCase()));

        all_category_slugs.add(ad['slug']);
      });
    });

    if(ads[0]['show_more'] == 'yes'){
      setState(() {
        show_more_button = true;
      });
    }else{
      setState(() {
        show_more_button = false;
      });
    }

    num += 10;

    change += 10;
  }

  var initial_category_findings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_category_findings = get_category_ads();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(show_more_button) {
          get_category_ads();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.particular_category,
          overflow: TextOverflow.fade,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initial_category_findings,
        builder: (context, snapshot){
          if(particular_category_children.isNotEmpty){
            return FutureBuilder(
              future: initial_category_findings,
              builder: (context, snapshot){
                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Column(
                        children: particular_category_children,
                      ),
                      show_more_button == true ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.08,
                            width: MediaQuery.of(context).size.width * 0.08,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ):SizedBox.shrink()
                    ],
                  ),
                );
              },
            );
          }else{
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
      ),
    );
  }

  Widget _buildPost(String cover_photo, String product_name, slug, ad_type){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: (){
          if(widget.mine == 'yes'){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  content: Container(
                    child: Column(
                      children: [
                        FlatButton(
                          child: Text(
                            'Edit'
                          ),
                          textColor: Colors.blue,
                          onPressed: ()async{
                            if(ad_type != 'video'){
                              var results = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => picture_ad_edit(particular_ad: slug, deletion_index: 6),
                                ),
                              );

                              Map results_to_send_back = {};

                              if(results != null){
                                if(all_category_slugs.indexOf(slug) <= 5){
                                  results_to_send_back = {'results':results, 'index': all_category_slugs.indexOf(slug)};

                                  Navigator.pop(context);
                                }else{
                                  results_to_send_back = {'results':results};

                                  Navigator.pop(context);
                                }
                              }

                              Navigator.pop(context, results_to_send_back);
                            }else{
                              var results = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => video_ad_edit(particular_ad: slug, deletion_index: 6),
                                ),
                              );

                              Map results_to_send_back = {};

                              if(results != null){
                                if(all_category_slugs.indexOf(slug) <= 5){
                                  results_to_send_back = {'results':results, 'index': all_category_slugs.indexOf(slug)};

                                  Navigator.pop(context);
                                }else{
                                  results_to_send_back = {'results':results};

                                  Navigator.pop(context);
                                }
                              }

                              Navigator.pop(context, results_to_send_back);

                            }
                          },
                        ),
                        FlatButton(
                          child: Text(
                            'Go to post'
                          ),
                          textColor: Colors.blue,
                          onPressed: (){
                            Navigator.pop(context);

                            if(ad_type != 'video'){
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
          }else{
            if(ad_type == 'video'){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => video_read_more(particular_ad: slug),
                ),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => picture_read_more(particular_ad: slug),
                ),
              );
            }
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image(
                image: NetworkImage(
                  "https://media.pridamo.com/pridamo-static/$cover_photo",
                ),
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width * 0.30,
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
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ad_type == 'video' ? Text(
                    'Video',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ): SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
