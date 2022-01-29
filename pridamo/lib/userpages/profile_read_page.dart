import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/other_profile_subs.dart';
import 'package:pridamo/userpages/particular_user_category.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class read_another_profile extends StatefulWidget {
  var particular_dude;

  read_another_profile({Key key, @required this.particular_dude})
      : super(key: key);
  @override
  _read_another_profileState createState() => _read_another_profileState();
}

class _read_another_profileState extends State<read_another_profile> {
  String name = '';

  var full_name = '';

  String profile_url = '';

  var loading = false;

  var gotten_image = false;

  var subscribed_or_not = false;

  var about_read_more = false;

  String region = '';

  String district = '';

  String location = '';

  String about = '';

  var phone_number = '';

  Future<Null> get_dude_details() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/app_other_profile_details?profile_user=${widget.particular_dude}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data.length != 0){
      setState(() {
        profile_url = data['pic_url'];

        name = data['user_name'];

        gotten_image = true;

        full_name = data['full_name'];

        region = data['region'];

        district = data['district'];

        location = data['location'];

        phone_number = data['phone_number'];

        about = data['about'];

        if(data['subscribed_or_not'] != 'no'){
          subscribed_or_not = true;
        }
      });
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/userpage', (route) => false);
    }
  }

  List<Widget> ad_container = [];

  var my_ad_num_value = 0;

  var my_ad_change_value = 15;

  Future that_user_profile_data;

  Future get_dude_posted_ads;

  Future<List> subscribe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/profile/app_subscribe/${widget.particular_dude}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var stuff_returned = jsonDecode(response.body);

    if(stuff_returned['status'] == 'subscribed'){
      setState(() {
        loading = false;
        subscribed_or_not = true;
      });
    }
  }

  Future<List> unsubscribe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/profile/app_unsubscribe/${widget.particular_dude}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var stuff_returned = jsonDecode(response.body);

    if(stuff_returned['status'] == 'unsubscribed'){
      setState(() {
        loading = false;
        subscribed_or_not = false;
      });
    }

  }

  var theme_type = 'light';

  var starting_index = 0;

  var all_category_posting = [];

  var all_category_slugs = [];

  var category_ordering = [];

  var initial_posts_future;

  var show_more_ads = false;

  Future<List> get_posted_ads() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/profile/app_other_profile?profile_name=${widget.particular_dude}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    List posts_returned = jsonDecode(response.body);

    if(posts_returned.isNotEmpty){
      if(posts_returned.last['show_more_ads'] == 'yes'){
        setState(() {
          show_more_ads = true;
        });
      }

      posts_returned.asMap().forEach((index, data) {
        var sub_category_postings = [];

        var sub_category_indexes = [];

        if(data is Map){
          if(data['last_category_index'] != null){
            if(data['last_category_index'] != 'none'){
              setState(() {
                starting_index = data['last_category_index'];
              });
            }
          }
        }else{
          category_ordering.add(data[0]['category']);

          data.forEach((datum){
            sub_category_postings.add(datum);
            sub_category_indexes.add(datum['slug']);
          });

          setState(() {
            all_category_posting.add(sub_category_postings);

            all_category_slugs.add(sub_category_indexes);

            ad_container.add(category_and_related_posts(data[0]['category']));
          });
        }

      });
    }

  }

  var getting_new_set_of_posted_ads = false;

  Future<List> get_new_set_of_posted_ads() async {
    setState(() {
      getting_new_set_of_posted_ads = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/profile/app_other_profile?profile_name=${widget.particular_dude}&starting_index=$starting_index',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    List posts_returned = jsonDecode(response.body);

    setState(() {
      getting_new_set_of_posted_ads = false;
    });

    if(posts_returned.isNotEmpty){
      if(posts_returned.last['show_more_ads'] == 'yes'){
        setState(() {
          show_more_ads = true;
        });
      }else{
        setState(() {
          show_more_ads = false;
        });
      }

      posts_returned.asMap().forEach((index, data) {
        var sub_category_postings = [];

        var sub_category_indexes = [];

        if(data is Map){
          if(data['last_category_index'] != null){
            if(data['last_category_index'] != 'none'){
              setState(() {
                starting_index = data['last_category_index'];
              });
            }
          }
        }else{
          category_ordering.add(data[0]['category']);

          data.forEach((datum){
            sub_category_postings.add(datum);
            sub_category_indexes.add(datum['slug']);
          });

          setState(() {
            all_category_posting.add(sub_category_postings);

            all_category_slugs.add(sub_category_indexes);

            ad_container.add(category_and_related_posts(data[0]['category']));
          });
        }

      });
    }

  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var gotten_map = false;

  var latitude_given = '0.0';

  var longitude_given = '0.0';

  var description = '';

  var image_url = '';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    that_user_profile_data = get_dude_details();

    initial_posts_future = get_posted_ads();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    double profile_pic_width = MediaQuery.of(context).size.width * 0.15;

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(toBeginningOfSentenceCase(widget.particular_dude)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            color: Colors.white,
            onPressed: (){
              Share.share("https://pridamo.com/profile/${widget.particular_dude}");
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: that_user_profile_data,
          builder: (context, snapshot){
            if(name == ''){
              return Shimmer.fromColors(
                highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                child: Column(
                  children: [
                    profile_page_shimmer(),
                  ],
                ),
              );
            }else{
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: gotten_image == true ? CircleAvatar(
                      radius: profile_pic_width,
                      backgroundImage: NetworkImage('${profile_url}')
                    ) : SizedBox.shrink(),
                  ),
                  Builder(
                    builder: (context){
                      if(subscribed_or_not){
                        return Center(
                          child: FlatButton(
                            child: Text(
                              'Receiving Updates',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            onPressed: (){
                              setState(() {
                                loading = true;
                              });
                              unsubscribe();
                            },
                          ),
                        );
                      }else{
                        return Center(
                          child: FlatButton(
                            color: Colors.blue,
                            child: Text(
                              'Receive Updates',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                            onPressed: (){
                              setState(() {
                                loading = true;
                              });
                              subscribe();
                            },
                          ),
                        );
                      }
                    },
                  ),
                  full_name != '' ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Full Name/Business Name",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  full_name != '' ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      full_name,
                    ),
                  ) : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Username/Business ID",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      toBeginningOfSentenceCase(name),
                    ),
                  ),
                  region != null ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Region",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  region != null ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      region,
                    ),
                  ) : SizedBox.shrink(),
                  district != null ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "District",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  district != null ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      district,
                    ),
                  ) : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Location",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      location,
                    ),
                  ),
                  about != '' && about != null ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "About",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  about != '' && about != null ? Container(
                    padding: EdgeInsets.symmetric(vertical: 7.0),
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                about.length >= 75 ? TextSpan(
                                    text: about.substring(0, 75)
                                ) : TextSpan(
                                    text: about
                                ),
                                about.length > 75 ? TextSpan(
                                    text: about_read_more ? about.substring(75) : ' read more',
                                    style: TextStyle(
                                        color: about_read_more == true ? Theme.of(context).textTheme.bodyText2.color : Colors.blue
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      setState(() {
                                        about_read_more = true;
                                      });
                                    }
                                ): TextSpan(),
                                about.length > 75 &&  about_read_more == true ? TextSpan(
                                    text: ' show less',
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      setState(() {
                                        if(about_read_more == false){
                                          about_read_more = true;
                                        }else{
                                          about_read_more = false;
                                        }
                                      });
                                    }
                                ): TextSpan(),
                              ]
                          ),
                        )
                      ],
                    ),
                  ) : SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Subscriptions',
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => other_profile_subs(particular_dude: widget.particular_dude),
                          ),
                        );
                      },
                    ),
                  ),
                  ad_container.isNotEmpty ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FlatButton(
                      onPressed: ()async{
                        var original_number = phone_number;

                        var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                        await launchWhatsapp(correct_number, 'Hello from Pridamo');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chat',
                            style: TextStyle(
                                color: Colors.blue
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5.0,0,0,0),
                            child: Icon(
                              Icons.message,
                              color: Colors.green,
                            ),
                          )
                        ],
                      ),
                    ),
                  ) : SizedBox.shrink(),
                  ad_container.isNotEmpty ?
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'All Products',
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ):
                  SizedBox.shrink(),
                  FutureBuilder(
                    future: initial_posts_future,
                    builder: (context, snapshot){
                      if(ad_container.isEmpty){
                        return SizedBox.shrink();
                      }else{
                        return Column(
                            children: ad_container
                        );
                      }
                    },
                  ),
                  Builder(
                    builder: (context){
                      if(show_more_ads){
                        return getting_new_set_of_posted_ads == false ? FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Show more products',
                              ),
                            ],
                          ),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: (){
                            get_new_set_of_posted_ads();
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
                    },
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget category_and_related_posts(category_name){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            category_name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue
            ),
          ),
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: all_category_posting[category_ordering.indexOf(category_name)].length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 1.0,
              childAspectRatio: 2.5/3,
            ),
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  if(all_category_posting[category_ordering.indexOf(category_name)][index]['ad_type'] == 'picture'){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => picture_read_more(particular_ad: all_category_posting[category_ordering.indexOf(category_name)][index]['slug']),
                      ),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => video_read_more(particular_ad: all_category_posting[category_ordering.indexOf(category_name)][index]['slug']),
                      ),
                    );
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://media.pridamo.com/pridamo-static/${all_category_posting[category_ordering.indexOf(category_name)][index]['image']}',
                          ),
                          fit: BoxFit.cover
                        )
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    all_category_posting[category_ordering.indexOf(category_name)][index]['ad_type'] != 'picture' ? Positioned(
                      right: 5,
                      top: 5,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                      ),
                    ): SizedBox.shrink()
                  ],
                ),
              );
            }
        ),
        all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] != 'no' ? FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View More',
              ),
            ],
          ),
          textColor: Colors.blue,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => particular_user_category(particular_category: category_name, user_name: widget.particular_dude, mine: 'no'),
              ),
            );
          },
        ): SizedBox.shrink(),
      ],
    );
  }

  Widget profile_page_shimmer(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: MediaQuery.of(context).size.width * 0.15,
          ),
          SizedBox(height: 5.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            margin: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
                ''
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            margin: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
                ''
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            margin: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
                ''
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.60,
            height: MediaQuery.of(context).size.width * 0.10,
            margin: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
                ''
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            margin: EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
                ''
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              '',
              textAlign: TextAlign.center,
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 2.5/3,
              ),
              itemBuilder: (context, index){
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ],
                );
              }
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.20,
            margin: EdgeInsets.symmetric(horizontal: 7.0, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text(
              '',
              textAlign: TextAlign.center,
            ),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 2.5/3,
              ),
              itemBuilder: (context, index){
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ],
                );
              }
          ),
        ],
      ),
    );
  }
}
