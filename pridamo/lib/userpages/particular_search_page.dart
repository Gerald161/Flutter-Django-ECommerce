import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class particular_search_page extends StatefulWidget {
  var search_word;

  particular_search_page({Key key, @required this.search_word})
      : super(key: key);

  @override
  _particular_search_pageState createState() => _particular_search_pageState();
}

class _particular_search_pageState extends State<particular_search_page> {
  List<Widget> all_products = [];

  var num = 0;

  var change = 10;

  var show_more = false;

  search_for_product(search_term) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/search/app_search_results?search_term=${search_term}&num=$num&change=$change',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    data.forEach((datum){
      if(datum['ad_type'] == 'picture'){
        all_products.add(_buildPost(datum['image'], datum['title'], datum['slug']));
      }else{
        all_products.add(buildVideoSearchResult(datum['title'], datum['image'], datum['slug']));
      }
    });

    if(data.length != 0){
      setState(() {
        if(data[0]['show_more'] == 'yes'){
          show_more = true;
        }else{
          show_more = false;
        }

        num += 10;

        change += 10;
      });
    }

    setState(() {
      has_gotten_results = true;
    });

  }

  var initial_future;

  var has_gotten_results = false;

  ScrollController _scrollController = ScrollController();

  refresh_list()async{
    setState(() {
      has_gotten_results = false;

      num = 0;

      change = 10;

      show_more = false;

      all_products = [];

      search_for_product(widget.search_word);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_future = search_for_product(widget.search_word);

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(show_more) {
          search_for_product(widget.search_word);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search results for "${widget.search_word}"'),
      ),
      body: RefreshIndicator(
        onRefresh: (){
          return refresh_list();
        },
        child: FutureBuilder(
          future: initial_future,
          builder: (context, snapshot){
            if(has_gotten_results == false){
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Stack(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: Center(
                          child: CircularProgressIndicator(),
                        )
                    ),
                  ],
                )
              );
            }else{
              return all_products.isNotEmpty ? SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                child: Column(
                  children: [
                    Column(
                      children: all_products,
                    ),
                    show_more == true ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.08,
                          width: MediaQuery.of(context).size.width * 0.08,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                    : SizedBox.shrink()
                  ],
                ),
              ) : SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Stack(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.80,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sorry no results for "${widget.search_word}"',
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPost(String cover_photo, String product_name, String product_slug){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: (){
          Navigator.push(
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
          Navigator.push(
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
                        fontSize: 15,
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
}
