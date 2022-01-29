import 'package:flutter/material.dart';
import 'package:pridamo/sidebar_pages/direction_help.dart';
import 'package:pridamo/sidebar_pages/how_to_post_ad_page.dart';
import 'package:pridamo/sidebar_pages/report_page.dart';

class help_page extends StatefulWidget {
  @override
  _help_pageState createState() => _help_pageState();
}

class _help_pageState extends State<help_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => how_to_post_ad_page()
                )
              );
            },
            title: Text("How to post an ad"),
          ),
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => direction_help()
                )
              );
            },
            title: Text("How to add your direction/workplace location"),
          ),
          ListTile(
              title: Text(
                'Report a problem/concern',
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => problem_report_page(),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}
