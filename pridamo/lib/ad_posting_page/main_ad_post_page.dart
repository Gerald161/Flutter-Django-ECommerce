import 'package:flutter/material.dart';
import 'package:pridamo/ad_posting_page/add_advert.dart';
import 'package:pridamo/ad_posting_page/add_video_ad.dart';
import 'package:pridamo/ad_posting_page/ad_slot_purchase_page.dart';

class main_ad_post_page extends StatefulWidget {
  @override
  _main_ad_post_pageState createState() => _main_ad_post_pageState();
}

class _main_ad_post_pageState extends State<main_ad_post_page> {
  var direction_set_up = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product add page'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            ListTile(
              onTap: ()async{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => advertisement(),
                  ),
                );
              },
              title: Text(
                "Add picture product/services",
              ),
            ),
            ListTile(
              onTap: ()async{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => video_advert_add(),
                  ),
                );
              },
              title: Text(
                "Add video product/services",
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ad_slot_purchase_page(),
                  ),
                );
              },
              title: Text(
                "Purchase product slot/space",
              ),
            ),
          ],
        )
      ),
    );
  }
}
