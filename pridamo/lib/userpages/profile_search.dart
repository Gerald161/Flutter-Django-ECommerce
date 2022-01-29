import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class find_profile extends StatefulWidget {
  @override
  _find_profileState createState() => _find_profileState();
}

class _find_profileState extends State<find_profile> {
  TextEditingController _searchController = TextEditingController();

  var searching_length = 0;

  var all_products = [];

  Future<List> search_for_product(input) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_find_profile?search=${input}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      all_products = jsonDecode(utf8.decode(response.bodyBytes));
    });
  }

  @override
  Widget build(BuildContext context) {
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
              hintText: 'Search for profile/business',
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
        ),
      ),
      body: ListView(
        children: all_products.map(
          (product) => ListTile(
            title: RichText(
              text: TextSpan(
                text: product['fields']['user_name'].toString().length >= searching_length ? toBeginningOfSentenceCase(product['fields']['user_name'].substring(0, searching_length)): '',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: product['fields']['user_name'].toString().length >= searching_length ? product['fields']['user_name'].substring(searching_length): '',
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
                'https://media.pridamo.com/pridamo-static/${product['fields']['profile_img']}'
              ),
              backgroundColor: Colors.white,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => read_another_profile(particular_dude: product['fields']['user_name']),
                ),
              );
            },
          )
        ).toList(),
      ),
    );
  }
}
