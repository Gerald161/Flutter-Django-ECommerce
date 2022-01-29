import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/particular_search_page.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/product_voice_search_page.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:shared_preferences/shared_preferences.dart';

class product_search_page extends StatefulWidget {
  @override
  _product_search_pageState createState() => _product_search_pageState();
}

class _product_search_pageState extends State<product_search_page> {
  TextEditingController _searchController = TextEditingController();

  var searching_length = 0;

  var all_products = [];

  Future<List> search_for_product(search_term) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/search/app_search_results?search_term=${search_term}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      all_products = jsonDecode(utf8.decode(response.bodyBytes));
    });
  }

  var theme_type = 'light';

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search for product/ad',
              prefixIcon: IconButton(
                icon: Icon(
                    Icons.arrow_back
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear
                ),
                onPressed: (){
                  WidgetsBinding.instance.addPostFrameCallback((_) => _searchController.clear());
                  setState(() {
                    all_products = [];
                  });
                },
              ),
              filled: true
          ),
          onChanged: (input){
            searching_length = input.trim().length;

            if(input.trim().length != 0){
              setState(() {
                search_for_product(input);
              });
            }else{
              setState(() {
                all_products.clear();
              });
            }
          },
          onSubmitted: (input){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => particular_search_page(search_word: input),
              ),
            );
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.mic),
              color: theme_type == 'light' ? Colors.grey[800] : Colors.white,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => product_voice_search_page()
                    )
                );
              }
          )
        ],
      ),
      body: ListView(
        children: all_products.map(
          (product) => ListTile(
            title: RichText(
              text: TextSpan(
                text: product['title'].toString().length >= searching_length ? product['title'].substring(0, searching_length): '',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: product['title'].toString().length >= searching_length ? product['title'].substring(searching_length): '',
                    style: TextStyle(
                      color: Colors.grey
                    )
                  )
                ]
              )
            ),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                  'https://media.pridamo.com/pridamo-static/${product['image']}'
              ),
              backgroundColor: Colors.white,
            ),
            trailing: Text(
              product['ad_type'] == 'video' ? 'Video': '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue
              ),
            ),
            subtitle: Text(
                product['region'],
                style: TextStyle(
                    color: Colors.grey[600]
                ),
                overflow: TextOverflow.ellipsis
            ),
            onTap: (){
              if(product['ad_type'] == 'picture'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => picture_read_more(particular_ad: product['slug']),
                  ),
                );
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => video_read_more(particular_ad: product['slug']),
                  ),
                );
              }
            },
          )
        ).toList(),
      ),
    );
  }
}
