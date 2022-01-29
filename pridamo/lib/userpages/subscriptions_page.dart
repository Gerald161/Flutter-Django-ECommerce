import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'package:pridamo/userpages/your_subscriptions_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class subscriptions_page extends StatefulWidget {
  @override
  _subscriptions_pageState createState() => _subscriptions_pageState();
}

class _subscriptions_pageState extends State<subscriptions_page>with AutomaticKeepAliveClientMixin<subscriptions_page> {
  ScrollController _scrollController = ScrollController();

  Future subscription_future;

  List<Widget> container_of_subs = [];

  var received_response = false;

  var theme_type = 'light';

  var gridview_product_infos = [];

  Future add_to_wish_list(String product_slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_add_to_wish_list/$product_slug',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var stuff_returned = jsonDecode(response.body);

    if(stuff_returned['status'] == 'added'){
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Successfully added',
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.blue,
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
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
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already added to wishlist',
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.blue,
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
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
    }
  }

  Future report_ad(String product_slug) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_report_ad/$product_slug',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var stuff_returned = jsonDecode(response.body);

    if(stuff_returned['status'] == 'reported'){
      setState(() {
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Successfully reported, thank you.',
                        textAlign: TextAlign.center,
                      ),
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        textColor: Colors.blue,
                        child: Text(
                          'Ok',
                          textAlign: TextAlign.center,
                        ),
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
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text(
                  'Has already been reported, thank you.',
                ),
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

  List ads_returned = [];

  int number_value = 0;

  int change_value = 10;

  var has_gotten_subscriptions = false;

  get_subscriptions(token)async{
    var response = await http.get(
        'https://pridamo.com/profile/app_your_subscriptions_page?num=0&change=8',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = await jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      data.forEach((datum){
        all_subs_presented_user.add([datum['user_name'], datum['profile_url']]);
      });

      has_gotten_subscriptions = true;
    });
  }

  Future get_sub_ads() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    if(has_gotten_subscriptions == false){
      await get_subscriptions(token);
    }

    var response = await http.get(
        'https://pridamo.com/profile/app_update_next_set?num=$number_value&change=$change_value',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    data.asMap().forEach((index, ha){
      if(ha['ad_type'] == 'picture'){
        setState(() {
          gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
          container_of_subs.add(_buildPost("https://media.pridamo.com/pridamo-static/${ha['ad_profile_url']}", ha['owner_name_text'], 'https://media.pridamo.com/pridamo-static/${ha['image']}', ha['product_name'], ha['price'], ha['product_slug']));
        });
      }else{
        setState(() {
          gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
          container_of_subs.add(_buildVideoPost("https://media.pridamo.com/pridamo-static/${ha['ad_profile_url']}", ha['owner_name_text'], 'https://media.pridamo.com/pridamo-static/${ha['thumbnail']}', ha['product_name'], ha['price'], ha['product_slug']));
        });
      }
    });

    if(data.length != 0){
      if(data[0]['show_more'] == 'yes'){
        setState(() {
          show_more_button = true;
        });
      }else{
        setState(() {
          show_more_button = false;
        });
      }
    }

    setState(() {
      received_response = true;
    });

    number_value += 10;

    change_value += 10;
  }

  var show_more_button = false;

  refresh_list()async{
    setState(() {
      received_response = false;

      show_more_button = false;

      all_subs_presented_user = [];

      has_gotten_subscriptions = false;

      gridview_product_infos = [];

      container_of_subs = [];

      number_value = 0;

      change_value = 10;

      get_sub_ads();
    });
  }

  var default_view_is_grid = true;

  var grid_group_value = 'grid';

  change_grid_state(){
    setState(() {
      if(default_view_is_grid == false){
        default_view_is_grid = true;
      }else{
        default_view_is_grid = false;
      }
    });
  }

  var all_subs_presented_user = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subscription_future = get_sub_ads();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(show_more_button){
          get_sub_ads();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

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
        appBar: AppBar(
          title: Text(
            'Subscriptions'
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: RefreshIndicator(
          onRefresh: (){
            return refresh_list();
          },
          child: FutureBuilder(
            future: subscription_future,
            builder: (context, snapshot){
              if(container_of_subs.isEmpty){
                return received_response != true ? default_view_is_grid == false ? Shimmer.fromColors(
                  highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                  baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        shimmer_child(),
                        shimmer_child(),
                        shimmer_child(),
                      ],
                    ),
                  ),
                ) : Shimmer.fromColors(
                  highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                  baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    controller: _scrollController,
                    child: shimmer_child_grid(),
                  ),
                )
                  : ListView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sorry no products present',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }else{
                return default_view_is_grid == false ? ListView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  cacheExtent: 9999,
                  controller: _scrollController,
                  children: [
                    all_subs_presented_user.isNotEmpty ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.17,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ListView.builder(
                              itemCount: all_subs_presented_user.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return InkWell(
                                  onTap: ()async{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => read_another_profile(particular_dude: all_subs_presented_user[index][0]),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                            radius: MediaQuery.of(context).size.width * 0.08,
                                            backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/${all_subs_presented_user[index][1]}')
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(5.0),
                                          width: MediaQuery.of(context).size.width * 0.20,
                                          child: Text(
                                            all_subs_presented_user[index][0],
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              onPressed:(){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => subscription_page(),
                                  ),
                                );
                              },
                              child: Text(
                                'All',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              textColor: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ) : SizedBox.shrink(),
                    Column(
                      children: container_of_subs
                    ),
                    Builder(
                      builder: (context){
                        if(show_more_button){
                          return Padding(
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
                      }
                    ),
                  ],
                ) :
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  child: Column(
                    children: [
                      all_subs_presented_user.isNotEmpty ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ListView.builder(
                                itemCount: all_subs_presented_user.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index){
                                  return InkWell(
                                    onTap: ()async{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => read_another_profile(particular_dude: all_subs_presented_user[index][0]),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: CircleAvatar(
                                              radius: MediaQuery.of(context).size.width * 0.08,
                                              backgroundImage: NetworkImage('https://media.pridamo.com/pridamo-static/${all_subs_presented_user[index][1]}')
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            width: MediaQuery.of(context).size.width * 0.20,
                                            child: Text(
                                              all_subs_presented_user[index][0],
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FlatButton(
                                onPressed:(){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => subscription_page(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'All',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                textColor: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      ) : SizedBox.shrink(),
                      StaggeredGridView.countBuilder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 2,
                        itemCount: container_of_subs.length,
                        itemBuilder: (BuildContext context, int index) => new Container(
                            child: InkWell(
                              onTap: (){
                                if(gridview_product_infos[index][4] == 'picture'){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => picture_read_more(particular_ad: gridview_product_infos[index][3]),
                                    ),
                                  );
                                }else{
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => video_read_more(particular_ad: gridview_product_infos[index][3]),
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        'https://media.pridamo.com/pridamo-static/${gridview_product_infos[index][0]}',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null ?
                                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                      gridview_product_infos[index][4] == 'picture' ? SizedBox.shrink() :
                                      Positioned(
                                        right: 5,
                                        top: 5,
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      gridview_product_infos[index][1],
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      int.parse(gridview_product_infos[index][2]) != 1 ? '${gridview_product_infos[index][2]} Cedis' : '${gridview_product_infos[index][2]} Cedi',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                        staggeredTileBuilder: (int index) =>
                        new StaggeredTile.fit(1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                      Builder(
                        builder: (context){
                          if(show_more_button){
                            return Padding(
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
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPost(String profile_pic, String user_name, String cover_image, String product_name, price, String product_slug){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(profile_pic),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => read_another_profile(particular_dude: user_name.toLowerCase()),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Text(
                      toBeginningOfSentenceCase(user_name),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz
                ),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Container(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Add to wishlist",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onTap: (){
                                        add_to_wish_list(product_slug);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Report product",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onTap: (){
                                        report_ad(product_slug);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
              )
            ],
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => picture_read_more(particular_ad: product_slug),
                  ),
                );
              },
              child: Image.network(
                cover_image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.60,
                alignment: Alignment.center,
                loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ?
                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5.0, 10, 0),
                    child: Text(
                      product_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      int.parse(price) != 1 ? '$price Cedis' : '$price Cedi',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.blue
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildVideoPost(String profile_pic, String user_name, String cover_image, String product_name, price, String product_slug){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 5.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(profile_pic),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => read_another_profile(particular_dude: user_name.toLowerCase()),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: Text(
                      toBeginningOfSentenceCase(user_name),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          content: Container(
                            width: double.maxFinite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListView(
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Add to wishlist",
                                        ),
                                      ),
                                      onTap: (){
                                        add_to_wish_list(product_slug);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Report product",
                                        ),
                                      ),
                                      onTap: (){
                                        report_ad(product_slug);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  );
                },
              )
            ],
          ),
        ),
        Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => video_read_more(particular_ad: product_slug),
                  ),
                );
              },
              child: Stack(
                children: [
                  Image.network(
                    cover_image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.60,
                    alignment: Alignment.center,
                    loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null ?
                          loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5.0, 10, 0),
                    child: Text(
                      product_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      int.parse(price) != 1 ? '$price Cedis' : '$price Cedi',
                      style: TextStyle(
                          color: Colors.blue
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget shimmer_child(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.20,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Text(
                                ''
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: Colors.grey,
              )
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.60,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Text(
                      ''
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Text(
                      ''
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmer_child_grid(){
    return new StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisCount: 4,
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) => new Container(
        color: Colors.grey,
      ),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
