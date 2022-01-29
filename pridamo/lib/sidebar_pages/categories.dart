import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pridamo/category_pages/particular_category_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class categories extends StatefulWidget {
  @override
  _categoriesState createState() => _categoriesState();
}

class _categoriesState extends State<categories> {
  var categories;

  var sub_categories = [];

  var popular_items = [];

  var all_images = [];

  var category_future;

  get_all_categories_plus()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/get_all_categories_plus',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    setState(() {
      sub_categories = data['side_bar_subs'];

      popular_items = data['popular_items'];

      all_images = data['sidebar_images'];

      categories = new List<String>.from(data['categories']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category_future = get_all_categories_plus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: category_future,
        builder: (context, snapshot){
          if(categories == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return GridView.builder(
              cacheExtent: 9999,
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => particular_category_page(particular_category: categories[index], sub_category: sub_categories[index], popular_items: popular_items[index],),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Image.network(
                          'https://media.pridamo.com/pridamo-static/${all_images[index]}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          alignment: Alignment.center,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            );
          }
        },
      ),
    );
  }
}
