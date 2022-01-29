import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pridamo/userpages/particular_user_category.dart';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/profile_search.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/comment_history.dart';
import 'package:pridamo/userpages/picture_edit.dart';
import 'package:pridamo/userpages/video_edit.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:pridamo/userpages/your_subscriptions_page.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class profile_page extends StatefulWidget {
  @override
  _profile_pageState createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> with AutomaticKeepAliveClientMixin<profile_page>{
  var theme_type = 'light';

  var payment_group_value = 'week';

  final GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();

  String pic_url = '';

  String full_pic_url = '';

  bool uploaded = false;

  var loading = false;

  var about_read_more = false;

  String name = '';

  var full_name = '';

  String region = '';

  String district = '';

  String location = '';

  String about = '';

  var gotten_profile_photo = false;

  var new_image;

  Future<Null> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/app_profile_details',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );
    Map pic_urls = jsonDecode(response.body);

    pic_url = pic_urls['pic_url'];

    full_pic_url = '${pic_url}';

    setState(() {
      gotten_profile_photo = true;

      name = pic_urls['user_name'];

      full_name = pic_urls['full_name'];

      region = pic_urls['region'];

      district = pic_urls['district'];

      location = pic_urls['location'];

      about = pic_urls['about'];
    });
  }

  var picture_upload_in_progress = false;

  getImage() async {
    var image = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);

    if(image != null){
      new_image = File(image.files.first.path);

      upload() async {
        setState(() {
          picture_upload_in_progress = true;
        });

        var request = http.MultipartRequest('POST', Uri.parse('https://pridamo.com/app_profile_details'));

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final String token = await prefs.getString('token');

        request.headers['authorization'] = "Token $token";

        request.files.add(await http.MultipartFile.fromPath('file', image.files.first.path));

        var res = await http.Response.fromStream(await request.send());

        if(jsonDecode(res.body)['status'] == 'uploaded'){
          setState(() {
            uploaded = true;

            picture_upload_in_progress = false;
          });
        }

      }
      upload();
    }
  }

  List<Widget> ad_container = [];

  var show_more_ads = false;

  Future get_future_username_instance;

  String address_message = '';

  address_your_audience()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/profile/app_profile',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
        body: jsonEncode({
          'address': address_message,
        })
    );

    Map data = jsonDecode(response.body);

    if(data['status'] == 'addressed'){
      setState(() {
        loading = false;

        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Message sent successfully',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
                        textColor: Colors.blue,
                        onPressed: ()async{
                          Navigator.pop(context);
                        },
                      )
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
      });
    }else{
      setState(() {
        loading = false;

        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("Error occurred, please resend message"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
      });
    }
  }

  var all_menu_options_with_no_products = [
    'Directions', 'Your Subscriptions', 'Review/Reply History',
    'Share'
  ];

  var all_menu_options = [
    'Your Subscriptions', 'Review/Reply History',
    'Share'
  ];

  var starting_index = 0;

  var all_category_posting = [];

  var all_category_slugs = [];

  var category_ordering = [];

  Future<List> get_posted_ads() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.get(
        'https://pridamo.com/profile/app_profile',
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
        'https://pridamo.com/profile/app_profile?starting_index=$starting_index',
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

  delete_advert(product_slug, counting_index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.post(
        'https://pridamo.com/app_picture_edit/${product_slug.toString().toLowerCase()}?del=yeah&counting_index=$counting_index',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );
    var data = jsonDecode(response.body);

    if(data['status'] == 'deleted'){
      Fluttertoast.showToast(
        msg: "Post has successfully been removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      //more if checks
      if(data['next_ad'] != null){
        return data['next_ad'];
      }else{
        return '';
      }
    }
  }

  var initial_posts_future;

  var delete_button_clicked = false;

  refresh_list()async{
    setState(() {
      name = '';

      getting_new_set_of_posted_ads = false;

      picture_upload_in_progress = false;

      pic_url = '';

      full_pic_url = '';

      uploaded = false;

      about_read_more = false;

      region = '';

      district = '';

      location = '';

      about = '';

      gotten_profile_photo = false;

      ad_container = [];

      show_more_ads = false;

      address_message = '';

      starting_index = 0;

      all_category_posting = [];

      all_category_slugs = [];

      category_ordering = [];

      delete_button_clicked = false;

      getUserDetails();

      get_posted_ads();
    });
  }

  var renewal_all_duration = 'week';

  renew_all_ads()async{
    Fluttertoast.showToast(
      msg: "Please wait",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/payments/app_renew_all_ads?token=$token&duration=$renewal_all_duration',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    if(data['paid'] == 'yes'){
      Fluttertoast.showToast(
        msg: "All products successfully renewed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    }else if(data['paid'] == 'wrong'){
      Fluttertoast.showToast(
        msg: "Please enter a valid momo number, or set up your payment number if not already set",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }else if(data['paid'] == 'error'){
      Fluttertoast.showToast(
        msg: "Error occurred, please retry",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }else{
      Fluttertoast.showToast(
        msg: "Payment failed, please check if you have enough funds and retry",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_future_username_instance = getUserDetails();
    initial_posts_future = get_posted_ads();
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    double profile_pic_width = MediaQuery.of(context).size.width * 0.30;

    return WillPopScope(
      onWillPop: ()async{
        if(Platform.isAndroid){
          SystemNavigator.pop();
        }else{
          exit(0);
        }
        return false;
      },
      child: Scaffold(
        key: scaffold_key,
        appBar: AppBar(
          title: Text("Profile"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            PopupMenuButton(
              onSelected: (choice){
                if(choice == 'Your Subscriptions'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => subscription_page(),
                    ),
                  );
                }else if(choice == 'Review/Reply History'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => comment_history(),
                    ),
                  );
                }else{
                  Share.share("https://pridamo.com/profile/$name");
                }
              },
              itemBuilder: (context){
                return ad_container.isNotEmpty ? all_menu_options.map((choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Row(
                      children: [
                        Text(
                          choice
                        ),
                      ],
                    ),
                  );
                }).toList() : all_menu_options_with_no_products.map((choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Row(
                      children: [
                        Text(
                            choice
                        ),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        floatingActionButton: name != '' ? FloatingActionButton(
          foregroundColor: theme_type == 'light' ? Colors.black : Colors.white,
          onPressed: (){
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => find_profile(),
              ),
            );
          },
          tooltip: "Search for profile",
          heroTag: 'Floating action button on profile_page',
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
          backgroundColor: theme_type == 'light' ? Colors.blue : Colors.grey[800],
        ) : SizedBox.shrink(),
        body: RefreshIndicator(
          onRefresh: (){
            return refresh_list();
          },
          child: FutureBuilder(
              future: get_future_username_instance,
              builder: (context, snapshot) {
                if(name == ''){
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Shimmer.fromColors(
                      highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                      baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                      child: Column(
                        children: [
                          profile_page_shimmer(),
                        ],
                      ),
                    ),
                  );
                }else{
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: uploaded == true ? picture_upload_in_progress == true ?
                            Stack(
                              children: [
                                Material(
                                  elevation: 4.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image: FileImage(new_image),
                                    fit: BoxFit.cover,
                                    width: profile_pic_width,
                                    height: profile_pic_width,
                                    child: InkWell(
                                      onTap: () {
                                        name != '' ? getImage() : null;
                                      },
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              ],
                            )
                            : Material(
                              elevation: 4.0,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              child: Ink.image(
                                image: FileImage(new_image),
                                fit: BoxFit.cover,
                                width: profile_pic_width,
                                height: profile_pic_width,
                                child: InkWell(
                                  onTap: () {
                                    name != '' ? getImage() : null;
                                  },
                                ),
                              ),
                            )
                            : gotten_profile_photo == true ? picture_upload_in_progress == true ?
                            Stack(
                              children: [
                                Material(
                                  elevation: 4.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image: NetworkImage('https://media.pridamo.com/pridamo-static/$full_pic_url'),
                                    fit: BoxFit.cover,
                                    width: profile_pic_width,
                                    height: profile_pic_width,
                                    child: InkWell(
                                      onTap: () {
                                        name != '' ? getImage() : null;
                                      },
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              ],
                            ):
                            Material(
                              elevation: 4.0,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              child: Ink.image(
                                image: NetworkImage('https://media.pridamo.com/pridamo-static/$full_pic_url'),
                                fit: BoxFit.cover,
                                width: profile_pic_width,
                                height: profile_pic_width,
                                child: InkWell(
                                  onTap: () {
                                    name != '' ? getImage() : null;
                                  },
                                ),
                              ),
                            )
                            : SizedBox.shrink(),
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
                                fontWeight: FontWeight.bold
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
                                fontWeight: FontWeight.bold
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
                                fontWeight: FontWeight.bold
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
                                fontWeight: FontWeight.bold
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
                                fontWeight: FontWeight.bold
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
                      ),
                    ),
                  );
                }
              }
          ),
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
                                  Navigator.pop(context);

                                  if(all_category_posting[category_ordering.indexOf(category_name)][index]['ad_type'] == 'picture'){
                                    var old_page_change_result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => picture_ad_edit(particular_ad: all_category_posting[category_ordering.indexOf(category_name)][index]['slug'], deletion_index: all_category_slugs[category_ordering.indexOf(category_name)].length),
                                      ),
                                    );

                                    if(old_page_change_result != null){
                                      if(old_page_change_result == 'saved'){
                                        refresh_list();
                                      }else{
                                        if(old_page_change_result != ''){
                                          var page_change_result = jsonDecode(old_page_change_result)['next_ad'];

                                          if(page_change_result != ''){
                                            if(page_change_result['show_more'] == 'yes'){
                                              all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'yes';
                                            }else{
                                              all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';
                                            }
                                          }else{
                                            all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';
                                          }

                                          setState(() {
                                            if(all_category_slugs[category_ordering.indexOf(category_name)].length != 1){
                                              var index_to_take_off = all_category_slugs[category_ordering.indexOf(category_name)].indexOf(all_category_posting[category_ordering.indexOf(category_name)][index]['slug']);

                                              all_category_slugs[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              all_category_posting[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));

                                              if(page_change_result != ''){
                                                all_category_slugs[category_ordering.indexOf(category_name)].add(page_change_result['slug']);

                                                all_category_posting[category_ordering.indexOf(category_name)].add(page_change_result);

                                                ad_container.removeAt(category_ordering.indexOf(category_name));

                                                ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                                              }
                                            }else{
                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              all_category_slugs.removeAt(category_ordering.indexOf(category_name));

                                              all_category_posting.removeAt(category_ordering.indexOf(category_name));

                                              category_ordering.removeAt(category_ordering.indexOf(category_name));
                                            }
                                          });
                                        }else{
                                          all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';

                                          setState(() {
                                            if(all_category_slugs[category_ordering.indexOf(category_name)].length != 1){
                                              var index_to_take_off = all_category_slugs[category_ordering.indexOf(category_name)].indexOf(all_category_posting[category_ordering.indexOf(category_name)][index]['slug']);

                                              all_category_slugs[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              all_category_posting[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                                            }else{
                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              all_category_slugs.removeAt(category_ordering.indexOf(category_name));

                                              all_category_posting.removeAt(category_ordering.indexOf(category_name));

                                              category_ordering.removeAt(category_ordering.indexOf(category_name));
                                            }
                                          });
                                        }

                                      }

                                    }
                                  }else{
                                    var old_page_change_result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => video_ad_edit(particular_ad: all_category_posting[category_ordering.indexOf(category_name)][index]['slug'], deletion_index: all_category_slugs[category_ordering.indexOf(category_name)].length),
                                      ),
                                    );

                                    if(old_page_change_result != null){
                                      if(old_page_change_result == 'saved'){
                                        refresh_list();
                                      }else{
                                        if(old_page_change_result != ''){
                                          var page_change_result = jsonDecode(old_page_change_result)['next_ad'];

                                          if(page_change_result != ''){
                                            if(page_change_result['show_more'] == 'yes'){
                                              all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'yes';
                                            }else{
                                              all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';
                                            }
                                          }else{
                                            all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';
                                          }

                                          setState(() {
                                            if(all_category_slugs[category_ordering.indexOf(category_name)].length != 1){
                                              var index_to_take_off = all_category_slugs[category_ordering.indexOf(category_name)].indexOf(all_category_posting[category_ordering.indexOf(category_name)][index]['slug']);

                                              all_category_slugs[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              all_category_posting[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));

                                              if(page_change_result != ''){
                                                all_category_slugs[category_ordering.indexOf(category_name)].add(page_change_result['slug']);

                                                all_category_posting[category_ordering.indexOf(category_name)].add(page_change_result);

                                                ad_container.removeAt(category_ordering.indexOf(category_name));

                                                ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                                              }
                                            }else{
                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              all_category_slugs.removeAt(category_ordering.indexOf(category_name));

                                              all_category_posting.removeAt(category_ordering.indexOf(category_name));

                                              category_ordering.removeAt(category_ordering.indexOf(category_name));
                                            }
                                          });
                                        }else{
                                          all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';

                                          setState(() {
                                            if(all_category_slugs[category_ordering.indexOf(category_name)].length != 1){
                                              var index_to_take_off = all_category_slugs[category_ordering.indexOf(category_name)].indexOf(all_category_posting[category_ordering.indexOf(category_name)][index]['slug']);

                                              all_category_slugs[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              all_category_posting[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                                            }else{
                                              ad_container.removeAt(category_ordering.indexOf(category_name));

                                              all_category_slugs.removeAt(category_ordering.indexOf(category_name));

                                              all_category_posting.removeAt(category_ordering.indexOf(category_name));

                                              category_ordering.removeAt(category_ordering.indexOf(category_name));
                                            }
                                          });
                                        }

                                      }

                                    }

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
                              ),
                              FlatButton(
                                child: Text(
                                  'Delete'
                                ),
                                textColor: Colors.red,
                                onPressed: ()async{

                                  Navigator.pop(context);

                                  await showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            'Delete Post',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            'Permanently delete post?',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Yes"),
                                              onPressed: ()async{
                                                Navigator.pop(context);

                                                delete_button_clicked = true;
                                              },
                                              textColor: Colors.red,
                                            ),
                                            FlatButton(
                                              child: Text("Cancel"),
                                              onPressed: (){
                                                delete_button_clicked = false;
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      }
                                  );

                                  if(delete_button_clicked){
                                    var results = await delete_advert(all_category_posting[category_ordering.indexOf(category_name)][index]['slug'], all_category_slugs[category_ordering.indexOf(category_name)].length);

                                    if(results != ''){
                                      if(results['show_more'] == 'yes'){
                                        all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'yes';
                                      }else{
                                        all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';
                                      }
                                    }else{
                                      all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';
                                    }

                                    setState(() {
                                      if(all_category_slugs[category_ordering.indexOf(category_name)].length != 1){
                                        var index_to_take_off = all_category_slugs[category_ordering.indexOf(category_name)].indexOf(all_category_posting[category_ordering.indexOf(category_name)][index]['slug']);

                                        all_category_slugs[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                        all_category_posting[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                                        ad_container.removeAt(category_ordering.indexOf(category_name));

                                        ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));

                                        if(results != ''){
                                          all_category_slugs[category_ordering.indexOf(category_name)].add(results['slug']);

                                          all_category_posting[category_ordering.indexOf(category_name)].add(results);

                                          ad_container.removeAt(category_ordering.indexOf(category_name));

                                          ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                                        }
                                      }else{
                                        ad_container.removeAt(category_ordering.indexOf(category_name));

                                        all_category_slugs.removeAt(category_ordering.indexOf(category_name));

                                        all_category_posting.removeAt(category_ordering.indexOf(category_name));

                                        category_ordering.removeAt(category_ordering.indexOf(category_name));
                                      }
                                    });
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
          onPressed: ()async{
            var old_results = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => particular_user_category(particular_category: category_name, user_name: name, mine: 'yes'),
              ),
            );

            if(old_results != null){
              if(old_results['results'] == 'saved'){
                refresh_list();
              }else{
                var results = jsonDecode(old_results['results'])['next_ad'];

                if(old_results['index'] != null){
                  var index_to_take_off = old_results['index'];

                  setState(() {
                    all_category_slugs[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                    all_category_posting[category_ordering.indexOf(category_name)].removeAt(index_to_take_off);

                    ad_container.removeAt(category_ordering.indexOf(category_name));

                    ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));

                    all_category_slugs[category_ordering.indexOf(category_name)].add(results['slug']);

                    all_category_posting[category_ordering.indexOf(category_name)].add(results);

                    ad_container.removeAt(category_ordering.indexOf(category_name));

                    ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));

                    if(results['show_more'] == 'no'){
                      setState(() {
                        all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';

                        ad_container.removeAt(category_ordering.indexOf(category_name));

                        ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                      });
                    }
                  });

                }else{
                  if(results['show_more'] == 'no'){
                    setState(() {
                      all_category_posting[category_ordering.indexOf(category_name)][0]['show_more'] = 'no';

                      ad_container.removeAt(category_ordering.indexOf(category_name));

                      ad_container.insert(category_ordering.indexOf(category_name), category_and_related_posts(category_name));
                    });
                  }
                }
              }
            }
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
