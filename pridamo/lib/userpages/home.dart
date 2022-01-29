import 'package:app_settings/app_settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:pridamo/ad_posting_page/main_ad_post_page.dart';
import 'package:pridamo/main_page/all_user_pages.dart';
import 'package:pridamo/sidebar_pages/about_app_page.dart';
import 'package:pridamo/sidebar_pages/all_delivery_requests_page.dart';
import 'package:pridamo/sidebar_pages/all_orders_made_page.dart';
import 'package:pridamo/sidebar_pages/help_page.dart';
import 'package:pridamo/sidebar_pages/wish_list_page.dart';
import 'package:pridamo/sidebar_pages/categories.dart';
import 'package:pridamo/sidebar_pages/recent_posts_page.dart';
import 'package:pridamo/userpages/notifications.dart';
import 'package:pridamo/userpages/particular_search_page.dart';
import 'package:pridamo/userpages/product_search_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'dart:ui';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//default_view_is_grid use to change view

class home_page extends StatefulWidget {
  @override
  _home_pageState createState() => _home_pageState();
}

class _home_pageState extends State<home_page> with AutomaticKeepAliveClientMixin<home_page>{
  var all_regions = [
    'All', "Ashanti", 'Greater Accra', "Northern", "Western", 'Volta', 'Oti', 'Central', 'Eastern', 'Upper East',
    'Upper West', 'Savannah', 'North East', 'Bono', 'Bono East', 'Ahafo', 'Western North'
  ];

  var current_region_districts = [
    [],
    [
      'All','Kumasi Metropolitan', 'Obuasi Municipal', 'Mampong Municipal', 'Asante Akim Central Municipal',
      'Asokore Mampong Municipal', 'Bekwai Municipal', 'Ejisu-Juaben Municipal', 'Offinso Municipal', 'Adansi North',
      'Adansi South', 'Afigya-Kwabre', 'Ahafo Ano North', 'Ahafo Ano South', 'Amansie Central', 'Amansie West',
      'Asante Akim North', 'Asante Akim South', 'Atwima Kwanwoma', 'Atwima Mponua', 'Atwima Nwabiagya', 'Bosome Freho',
      'Bosomtwe', 'Ejura-Sekyedumase', 'Kwabre', 'Offinso North', 'Sekyere Afram Plains', 'Sekyere Central',
      'Sekyere East', 'Sekyere Kumawu', 'Sekyere South'
    ],
    [
      'All','Accra Metropolitan', 'Tema Metropolitan', 'Ledzokuku-Krowor Municipal', '	La Dade Kotopon Municipal',
      'La Nkwantanang Madina Municipal', 'Adentan Municipal', 'Ashaiman Municipal', 'Ga Central Municipal',
      'Ga East Municipal', 'Ga South Municipal', 'Ga West Municipal', 'Ada East', 'Ada West', 'Kpone Katamanso',
      'Ningo Prampram', 'Shai Osudoku'
    ],
    [
      'All','Tamale Metropolitan', 'Yendi Municipal', 'Kpandai', 'Gushegu', 'Karaga', 'Kumbungu', 'Mion',
      'Nanton', 'Nanumba North', 'Nanumba South', 'Saboba', 'Sagnarigu', 'Savelugu', 'Tatale Sangule',
      'Tolon', 'Zabzugu'
    ],
    [
      'All','Sekondi-Takoradi Metropolitan', 'Ahanta West Municipal', 'Effia-Kwesimintsim Municipal', 'Jomoro Municipal',
      'Nzema East Municipal', 'Prestea-Huni Valley Municipal', 'Tarkwa Nsuaem Municipal', 'Wassa Amenfi East Municipal',
      'Wassa Amenfi West Municipal', 'Wassa East', 'Ellembelle', 'Mpohor', 'Shama', 'Wassa Amenfi Central'
    ],
    [
      'All','Ho Municipal', 'Keta Municipal', 'Hohoe Municipal', 'Ketu North Municipal', 'Ketu South Municipal',
      'Kpando Municipal', 'Anloga', 'Adaklu', 'Afadjato South', 'Agotime Ziope','Akatsi North', 'Akatsi South',
      'Central Tongu', 'Ho West', 'North Dayi', 'North Tongu', 'South Dayi', 'South Tongu'
    ],
    [
      'All','Biakoye District', 'Jasikan District', 'Kadjebi District', 'Krachi East District', 'Krachi Nchumuru District',
      'Krachi West District', 'Nkwanta North District', 'Nkwanta South District'
    ],
    [
      'All','Cape Coast Metropolitan', 'Effutu Municipal', 'Agona West Municipal', 'Assin North Municipal', 'Awutu Senya East Municipal',
      'Komenda/Edina/Egyafo/Abirem Municipal', 'Mfantsiman Municipal', 'Upper Denkyira East Municipal',
      'Abura/Asebu/Kwamankese', 'Agona East', 'Ajumako/Enyan/Essiam', 'Asikuma/Odoben/Brakwa', 'Assin South',
      'Awutu Senya West', 'Ekumfi', 'Gomoa East', 'Gomoa West', 'Twifo-Ati Morkwa', 'Twifo/Heman/Lower Denkyira',
      'Upper Denkyira West'
    ],
    [
      'All','New-Juaben Municipal', 'Nsawam Adoagyire Municipal', 'Suhum Municipal', 'Akuapim North Municipal',
      'West Akim Municipal', 'East Akim Municipal', 'Birim Central Municipal', 'Kwahu West Municipal',
      'Akuapim South', 'Akyemansa', 'Asuogyaman', 'Atiwa', 'Ayensuano', 'Birim North', 'Birim South',
      'Denkyembour', 'Fanteakwa', 'Kwaebibirem', 'Kwahu Afram Plains North', 'Kwahu Afram Plains South',
      'Kwahu East', 'Kwahu South', 'Lower Manya Krobo', 'Upper Manya Krobo', 'Upper West Akim', 'Yilo Krobo'
    ],
    [
      'All','Bolgatanga Municipal', 'Bawku West', 'Binduri', 'Bongo', 'Builsa North', 'Builsa South',
      'Garu', 'Kassena Nankana East', 'Kassena Nankana West', 'Nabdam', 'Pusiga', 'Talensi', 'Bolgatanga East',
      'Tempane'
    ],
    [
      'All','Wa Municipal', 'Daffiama Bussie Issa', 'Jirapa/Lambussie', 'Lambussie Karni', 'Lawra', 'Nadowli',
      'Nandom', 'Sissala East', 'Sissala West', 'Wa East', 'Wa West'
    ],
    [
      'All','East Gonja Municipal', 'Central Gonja', 'North Gonja', 'Bole', 'North East Gonja', 'West Gonja',
      'Sawla-Tuna-Kalba'
    ],
    [
      'All','East Mamprusi Municipal', 'West Mamprusi Municipal', 'Bunkpurugu-Nyakpanduri', 'Chereponi',
      'Mamprugu Moagduri', 'Yunyoo-Nasuan'
    ],
    [
      'All','Sunyani Municipal', 'Berekum East Municipal', 'Dormaa Central Municipal', 'Wenchi Municipal',
      'Jaman South Municipal', 'Banda', 'Berekum West', 'Dormaa East', 'Dormaa West', 'Jaman North',
      'Sunyani West', 'Tain'
    ],
    [
      'All','Techiman Municipal', 'Atebubu-Amanten Municipal', 'Nkoranza South Municipal', 'Kintampo North Municipal',
      'Kintampo South', 'Nkoranza North', 'Pru East', 'Pru West',
      'Sene East', 'Sene West', 'Techiman North'
    ],
    [
      'All','Asunafo North Municipal', 'Tano North Municipal', 'Tano South Municipal', 'Asunafo South',
      'Asutifi North', 'Asutifi South'
    ],
    [
      'All','Sefwi Wiawso Municipal', 'Aowin Municipal', 'Bibiani/Anhwiaso/Bekwai',
      'Bia East', 'Bia West', 'Bodi', 'Juaboso', 'Sefwi Akontombra', 'Suaman'
    ],
  ];

  var current_job_selected_index = 0;

  var selected_district_list = [];

  var current_district_selected_index = 0;

  var currently_selected_region = 0;

  var theme_type = 'light';

  List ads = [];

  List<Widget> haha = [];

  List refreshed_ads_slugs = [];

  int first_number = 0;

  int change = 12;

  var my_username = '';

  ScrollController _scrollController = ScrollController();

  var show_more_button = false;

  var kinda_request = 'first_district';

  var highlighted_region = '';

  var all_region_districts = [

  ];

  var kinda_choice = '';

  change_region_and_expected_show_more_behavior(choice){
    setState(() {
      if(choice == 'All'){
        selected_district_list.clear();

        kinda_request = 'all';
      }else{
        kinda_request = 'region';
      }

      show_more_button = false;

      haha = [];

      gridview_product_infos = [];

      list_of_all_product_slugs = [];

      kinda_choice = choice;

      highlighted_region = choice;

      first_number = 0;

      change = 12;

      selected_district_list = current_region_districts[all_regions.indexOf(choice)];

      current_district_selected_index = 0;

      if(has_direction_set_up != false){
        directions_count_num = 0;

        directions_count_change = 10;

        overall_container_of_all_close_products_returned = [];

        if(choice == 'All'){
          select_closest_products();
        }else{
          get_proximity_region_set_of_ads(choice);
        }
      }else{
        if(choice == 'All'){
          test();
        }else{
          get_region_set_of_ads(choice);
        }
      }
    });
  }

  change_district_and_expected_behavior(choice){
    setState(() {
      first_number = 0;

      change = 12;

      show_more_button = false;

      haha = [];

      gridview_product_infos = [];

      list_of_all_product_slugs = [];

      kinda_request = 'district';

      kinda_choice = choice;

      if(choice.toString().toLowerCase() == 'all'){
        change_region_and_expected_show_more_behavior(highlighted_region);
      }else{
        if(has_direction_set_up != false){
          directions_count_num = 0;

          directions_count_change = 10;

          overall_container_of_all_close_products_returned = [];

          change_proximity_app_district(choice);
        }else{
          change_app_district(choice);
        }
      }
    });
  }

  get_region_set_of_ads(choice)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_set_of_ads_region/${choice.toString().replaceAll(' ', '_')}?num=${first_number}&change=${change}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      received_response = true;
    });

    var ads = jsonDecode(response.body);

    if(ads.length != 0){
      if(ads[0]['show_more'] == 'yes'){
        setState(() {
          show_more_button = true;
        });
      }else{
        setState(() {
          show_more_button = false;
        });
      }
    }

    ads.forEach((ha){
      if(my_username == ha['owner_name_text']){
        if(ha['ad_type'] == 'picture'){
          setState(() {
            gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
            haha.add(_buildPost(ha['ad_profile_url'], ha['owner_name_text'], ha['image'], ha['product_name'], ha['price'], ha['product_slug'], true));
          });
        }else{
          setState(() {
            gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
            haha.add(_buildVideoPost(ha['ad_profile_url'], ha['owner_name_text'], ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], true));
          });
        }
      }else{
        if(ha['ad_type'] == 'picture'){
          setState(() {
            gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
            haha.add(_buildPost(ha['ad_profile_url'], ha['owner_name_text'], ha['image'], ha['product_name'], ha['price'], ha['product_slug'], false));
          });
        }else{
          setState(() {
            gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
            haha.add(_buildVideoPost(ha['ad_profile_url'], ha['owner_name_text'], ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], false));
          });
        }
      }
    });

    first_number += 12;

    change += 12;
  }

  change_app_district(choice)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/app_set_of_ads_district/${choice.toString().replaceAll(' ', '_')}?num=${first_number}&change=${change}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      received_response = true;
    });

    var ads = jsonDecode(response.body);

    if(ads.length != 0){
      if(ads[0]['show_more'] == 'yes'){
        setState(() {
          show_more_button = true;
        });
      }else{
        setState(() {
          show_more_button = false;
        });
      }
    }

    ads.forEach((ha){
      if(my_username == ha['owner_name_text']){
        if(ha['ad_type'] == 'picture'){
          setState(() {
            gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);

            haha.add(_buildPost(ha['ad_profile_url'], ha['owner_name_text'], ha['image'], ha['product_name'], ha['price'], ha['product_slug'], true));
          });
        }else{
          setState(() {
            gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);

            haha.add(_buildVideoPost(ha['ad_profile_url'], ha['owner_name_text'], ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], true));
          });
        }
      }else{
        if(ha['ad_type'] == 'picture'){
          setState(() {
            gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);

            haha.add(_buildPost(ha['ad_profile_url'], ha['owner_name_text'], ha['image'], ha['product_name'], ha['price'], ha['product_slug'], false));
          });
        }else{
          setState(() {
            gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);

            haha.add(_buildVideoPost(ha['ad_profile_url'], ha['owner_name_text'], ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], false));
          });
        }
      }
    });

    first_number += 12;

    change += 12;
  }

  var number_to_call = '';

  var mail_to_send_to = '';

  var received_response = false;

  var has_gotten_should_pay_message = false;

  var gridview_product_infos = [];

  var slider_number = '';

  var has_direction_set_up = false;

  var current_latitude_of_user = '0.0';

  var current_longitude_of_user = '0.0';

  Location location = new Location();

  reset_direction()async{
    var _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Fluttertoast.showToast(
          msg: "Please enable location permission in 'Permissions' for Pridamo and turn on Location for products to be displayed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        AppSettings.openAppSettings();
      }
    }

    if(_serviceEnabled){
      var _permissionGranted = await location.hasPermission();

      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Fluttertoast.showToast(
            msg: "Please enable location permission in 'Permissions' for Pridamo and turn on Location for products to be displayed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          );

          AppSettings.openAppSettings();
        }else{
          location.onLocationChanged.listen((LocationData currentLocation) {
            setState(() {
              current_latitude_of_user = currentLocation.latitude.toString();
              current_longitude_of_user = currentLocation.longitude.toString();
            });
          });
        }
      }else{
        location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            current_latitude_of_user = currentLocation.latitude.toString();
            current_longitude_of_user = currentLocation.longitude.toString();
          });
        });
      }
    }
  }

  get_current_location_of_user()async{
    if(current_latitude_of_user == '0.0'){
      await reset_direction();

      get_current_location_of_user();
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final String token = prefs.getString('token');

      await http.get(
          'https://pridamo.com/profile/app_set_current_latitude_and_longitude?latitude=$current_latitude_of_user&longitude=$current_longitude_of_user',
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }
      );
    }
  }

  Future test() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    var wallpaper_response = await http.get(
        'https://pridamo.com/get_app_wallpaper',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      if(jsonDecode(wallpaper_response.body)['has_direction_set'] == 'yes'){
        has_direction_set_up = true;
      }else{
        has_direction_set_up = false;
      }

      my_username = jsonDecode(wallpaper_response.body)['user_name'];

      number_to_call = jsonDecode(wallpaper_response.body)['number_to_call'];

      seller_or_not = jsonDecode(wallpaper_response.body)['seller_status'];

      mail_to_send_to = jsonDecode(wallpaper_response.body)['email'];

      if(all_sliding_images_url.isEmpty){
        popular_items = new List<String>.from(jsonDecode(wallpaper_response.body)['home_popular_searches']);

        all_sliding_images_url = new List<String>.from(jsonDecode(wallpaper_response.body)['all_sliding_images']);

        slider_number = jsonDecode(wallpaper_response.body)['contact_number'];

        all_sliding_images_url.asMap().forEach((index, url){
          all_icons_on_first_slider.add(Icon(
            Icons.horizontal_rule,
            color: current_index_on == index ? Colors.blue : Colors.grey[800],
            size: MediaQuery.of(context).size.height * 0.05,
          ),);
        });
      }

      if(has_gotten_should_pay_message == false){
        Future.delayed(Duration(minutes: 5), (){
          if(jsonDecode(wallpaper_response.body)['should_show_dialog'] == 'yes'){
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            jsonDecode(wallpaper_response.body)['should_show_dialog_message'],
                            textAlign: TextAlign.center,
                          ),
                          jsonDecode(wallpaper_response.body)['show_button_of_dialog'] == 'yes' ? FlatButton(
                            onPressed: (){
                              var original_number = jsonDecode(wallpaper_response.body)['contact_number'];

                              var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                              launchWhatsapp(correct_number, 'EL-Vision GRAPHIX');

                              Navigator.of(context).pop();
                            },
                            textColor: Colors.blue,
                            child: Text(
                              'Contact',
                              textAlign: TextAlign.center,
                            ),
                          ) : SizedBox.shrink(),
                          FlatButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            textColor: Colors.red,
                            child: Text(
                              'Close',
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
          }
        });
      }

      has_gotten_should_pay_message = true;

      currently_selected_region = 0;

      highlighted_region = 'All';

      current_district_selected_index = 0;
    });

    await get_current_location_of_user();

    if(has_direction_set_up == false){
      var response = await http.get(
          'https://pridamo.com/get_ads?num=${first_number}&change=${change}',
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }
      );

      setState(() {
        received_response = true;
      });

      var ads = jsonDecode(response.body);

      if(ads.length != 0){
        if(ads[0]['show_more'] == 'yes'){
          setState(() {
            show_more_button = true;
          });
        }else{
          setState(() {
            show_more_button = false;
          });
        }
      }

      ads.forEach((ha){
        if(my_username == ha['owner_name_text']){
          if(ha['ad_type'] == 'picture'){
            setState(() {
              gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
              haha.add(_buildPost(ha['ad_profile_url'], ha['owner_name_text'], ha['image'], ha['product_name'], ha['price'], ha['product_slug'], true));
            });
          }else{
            setState(() {
              gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
              haha.add(_buildVideoPost(ha['ad_profile_url'], ha['owner_name_text'], ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], true));
            });
          }
        }else{
          if(ha['ad_type'] == 'picture'){
            setState(() {
              gridview_product_infos.add([ha['image'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
              haha.add(_buildPost(ha['ad_profile_url'], ha['owner_name_text'], ha['image'], ha['product_name'], ha['price'], ha['product_slug'], false));
            });
          }else{
            setState(() {
              gridview_product_infos.add([ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], ha['ad_type']]);
              haha.add(_buildVideoPost(ha['ad_profile_url'], ha['owner_name_text'], ha['thumbnail'], ha['product_name'], ha['price'], ha['product_slug'], false));
            });
          }
        }
      });

      first_number += 12;

      change += 12;
    }else{
      if(overall_container_of_all_close_products_returned.isEmpty){
        select_closest_products();
      }else{
        add_on_closest_from_container_gotten();
      }
    }

  }

  Future _future_stuff;

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

  refresh_list()async{
    setState(() {
      if(has_direction_set_up == false){
        received_response = false;

        show_more_button = false;

        haha = [];

        first_number = 0;

        gridview_product_infos = [];

        list_of_all_product_slugs = [];

        change = 12;

        if(kinda_request == 'region'){
          get_region_set_of_ads(kinda_choice);
        }else if(kinda_request == 'district'){
          change_app_district(kinda_choice);
        }else{
          test();
        }
      }else{
        directions_count_num = 0;

        directions_count_change = 10;

        received_response = false;

        show_more_button = false;

        gridview_product_infos = [];

        list_of_all_product_slugs = [];

        haha = [];

        overall_container_of_all_close_products_returned = [];

        if(kinda_request == 'region'){
          get_proximity_region_set_of_ads(kinda_choice);
        }else if(kinda_request == 'district'){
          change_proximity_app_district(kinda_choice);
        }else{
          select_closest_products();
        }
      }
    });
  }

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

  get_more_data(){
    if(kinda_request == 'region'){
      get_region_set_of_ads(kinda_choice);
    }else if(kinda_request == 'district'){
      change_app_district(kinda_choice);
    }else{
      test();
    }
  }
  
  PageController _pageController;

  var current_index_on = 0;

  var popular_items = [];

  var all_sliding_images_url = [];

  List<Widget> all_icons_on_first_slider = [];

  var directions_count_num = 0;

  var directions_count_change = 10;

  var overall_container_of_all_close_products_returned = [];

  var list_of_all_product_slugs = [];

  select_closest_products()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/proximity_of_home_ads?directions_count_num=${directions_count_num}&directions_count_change=${directions_count_change}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      received_response = true;
    });

    var all_products = jsonDecode(response.body);

    if(all_products[0]['add_products'] == 'yes'){
      all_products.asMap().forEach((index,product){
        if(gridview_product_infos.isNotEmpty){
          if(index > 9){
            setState(() {
              if(!list_of_all_product_slugs.contains(product['product_slug'])){
                show_more_button = true;

                overall_container_of_all_close_products_returned.add(product);

                list_of_all_product_slugs.add(product['product_slug']);
              }
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(! list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }
          }
        }else{
          if(index > 9){
            setState(() {
              show_more_button = true;

              overall_container_of_all_close_products_returned.add(product);
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                  }
                });
              }else{
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                  }
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                  }
                });
              }else{
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                  }
                });
              }
            }
          }

          list_of_all_product_slugs.add(product['product_slug']);
        }
      });
    }

    if(all_products[0]['show_more_directions'] == 'no'){
      setState(() {
        if(overall_container_of_all_close_products_returned.isEmpty){
          show_more_button = false;
        }
      });
    }else{
      select_closest_products();
    }

    directions_count_num += 10;

    directions_count_change += 10;
  }

  add_on_closest_from_container_gotten(){
    overall_container_of_all_close_products_returned.asMap().forEach((index,product) {
      if(index <= 9){
        if(my_username == product['owner_name_text']){
          if(product['ad_type'] == 'picture'){
            setState(() {
              gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
            });
          }else{
            setState(() {
              gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
            });
          }
        }else{
          if(product['ad_type'] == 'picture'){
            setState(() {
              gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
            });
          }else{
            setState(() {
              gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
            });
          }
        }
      }
    });

    if(overall_container_of_all_close_products_returned.length >= 9){
      if(overall_container_of_all_close_products_returned.length == 9){
        overall_container_of_all_close_products_returned.removeRange(0, 9);
      }else{
        overall_container_of_all_close_products_returned.removeRange(0, 10);
      }
    }else{
      setState(() {
        overall_container_of_all_close_products_returned.clear();
        get_proximity_more_data();
      });
    }
  }

  get_proximity_region_set_of_ads(choice)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_set_of_ads_region/${choice.toString().replaceAll(' ', '_')}?directions_count_num=${directions_count_num}&directions_count_change=${directions_count_change}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      received_response = true;
    });

    var all_products = jsonDecode(response.body);

    if(all_products[0]['add_products'] == 'yes'){
      all_products.asMap().forEach((index,product){
        if(gridview_product_infos.isNotEmpty){
          if(index > 9){
            setState(() {
              if(!list_of_all_product_slugs.contains(product['product_slug'])){
                show_more_button = true;

                overall_container_of_all_close_products_returned.add(product);

                list_of_all_product_slugs.add(product['product_slug']);
              }
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(! list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }
          }
        }else{
          list_of_all_product_slugs.add(product['product_slug']);

          if(index > 9){
            setState(() {
              show_more_button = true;

              overall_container_of_all_close_products_returned.add(product);
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                });
              }else{
                setState(() {
                  gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                });
              }else{
                setState(() {
                  gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                });
              }
            }
          }
        }
      });
    }

    if(all_products[0]['show_more_directions'] == 'no'){
      setState(() {
        if(overall_container_of_all_close_products_returned.isEmpty){
          show_more_button = false;
        }
      });
    }else{
      get_proximity_region_set_of_ads(choice);
    }

    directions_count_num += 10;

    directions_count_change += 10;
  }

  change_proximity_app_district(choice)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_set_of_ads_district/${choice.toString().replaceAll(' ', '_')}?directions_count_num=${directions_count_num}&directions_count_change=${directions_count_change}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var all_products = jsonDecode(response.body);

    setState(() {
      received_response = true;
    });

    if(all_products[0]['add_products'] == 'yes'){
      all_products.asMap().forEach((index,product){
        if(gridview_product_infos.isNotEmpty){
          if(index > 9){
            setState(() {
              if(!list_of_all_product_slugs.contains(product['product_slug'])){
                show_more_button = true;

                overall_container_of_all_close_products_returned.add(product);

                list_of_all_product_slugs.add(product['product_slug']);
              }
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(! list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }
          }
        }else{
          list_of_all_product_slugs.add(product['product_slug']);

          if(index > 9){
            setState(() {
              show_more_button = true;

              overall_container_of_all_close_products_returned.add(product);
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                });
              }else{
                setState(() {
                  gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                });
              }else{
                setState(() {
                  gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  haha.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                });
              }
            }
          }
        }
      });
    }

    if(all_products[0]['show_more_directions'] == 'no'){
      setState(() {
        if(overall_container_of_all_close_products_returned.isEmpty){
          show_more_button = false;
        }
      });
    }else{
      change_proximity_app_district(choice);
    }

    directions_count_num += 10;

    directions_count_change += 10;
  }

  get_proximity_more_data(){
    if(overall_container_of_all_close_products_returned.isEmpty){
      if(kinda_request == 'region'){
        get_proximity_region_set_of_ads(kinda_choice);
      }else if(kinda_request == 'district'){
        change_proximity_app_district(kinda_choice);
      }else{
        select_closest_products();
      }
    }else{
      add_on_closest_from_container_gotten();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future_stuff = test();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(has_direction_set_up == false){
          if(show_more_button) {
            get_more_data();
          }
        }else{
          if(show_more_button){
            get_proximity_more_data();
          }
        }
      }
    });

    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
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
            'Pridamo'
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => notifications()
                  )
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => product_search_page(),
                    ),
                  );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.public,
              ),
              onPressed: (){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)
                      )
                    ),
                    builder: (context){
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Change your location',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          'Region',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.08,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: all_regions.length,
                                          itemBuilder: (context, index){
                                            return InkWell(
                                              onTap: (){
                                                setState(() {
                                                  received_response = false;

                                                  currently_selected_region = index;

                                                  selected_district_list = current_region_districts[currently_selected_region];

                                                  current_district_selected_index = 0;

                                                  change_region_and_expected_show_more_behavior(all_regions[currently_selected_region]);
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  all_regions[index],
                                                  style: TextStyle(
                                                    color: index == currently_selected_region ? Colors.blue : Colors.grey[600],
                                                    fontWeight: index == currently_selected_region ? FontWeight.bold : FontWeight.normal
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected_district_list.isNotEmpty ? Builder(
                                    builder: (context){
                                      return Column(
                                        children: [
                                          Text(
                                            'District',
                                            textAlign: TextAlign.center,
                                          ),
                                          Container(
                                            height: 40.0,
                                            margin: EdgeInsets.symmetric(vertical: 5.0),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: selected_district_list.length,
                                              itemBuilder: (context, index){
                                                return InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      current_district_selected_index = index;

                                                      received_response = false;

                                                      change_district_and_expected_behavior(selected_district_list[index]);
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Text(
                                                      selected_district_list[index],
                                                      style: TextStyle(
                                                        color: index == current_district_selected_index ? Colors.blue : Colors.grey[600],
                                                        fontWeight: index == current_district_selected_index ? FontWeight.bold : FontWeight.normal
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ) : SizedBox.shrink()
                                ],
                              ),
                            );
                          }
                      );
                    }
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: (){
            return refresh_list();
          },
          child: FutureBuilder(
            future: _future_stuff,
            builder: (context, snapshot) {
              if(haha.isEmpty){
                return received_response != true ? default_view_is_grid == false ? Shimmer.fromColors(
                  highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                  baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    controller: _scrollController,
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
                  cacheExtent: 9999,
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.27,
                        child: Stack(
                          children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                height: MediaQuery.of(context).size.height * 0.27,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 5),
                                enlargeCenterPage: true,
                              ),
                              itemCount: all_sliding_images_url.length,
                              itemBuilder: (context, index, real_index){
                                return InkWell(
                                  onTap: ()async{
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            content: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Contact Designer',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  FlatButton(
                                                    onPressed: (){
                                                      var original_number = slider_number;

                                                      var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                                                      launchWhatsapp(correct_number, 'EL-Vision GRAPHIX');

                                                      Navigator.of(context).pop();
                                                    },
                                                    textColor: Colors.blue,
                                                    child: Text(
                                                      'Contact',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    textColor: Colors.red,
                                                    child: Text(
                                                      'Close',
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
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.network(
                                        'https://media.pridamo.com/pridamo-static/${all_sliding_images_url[index]}',
                                        fit: BoxFit.cover,
                                        height: MediaQuery.of(context).size.width * 0.25,
                                        width: double.infinity,
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
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,12.0,0,14.0),
                      child: Text(
                          'Popular Searches',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: popular_items.length,
                        itemBuilder: (context, index){
                          return CupertinoButton(
                            borderRadius: BorderRadius.circular(80),
                            pressedOpacity: 0.7,
                            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 5.0),
//                            color: Colors.blue,
                            child: Text(popular_items[index]),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => particular_search_page(search_word: popular_items[index]),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,8.0,0,14.0),
                      child: Text(
                          'Choice Selection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                    Column(
                      children: haha,
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
                  ]
                ) : SingleChildScrollView(
                   physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                   controller: _scrollController,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.27,
                          child: Stack(
                            children: [
                              CarouselSlider.builder(
                                options: CarouselOptions(
                                  height: MediaQuery.of(context).size.height * 0.27,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  enlargeCenterPage: true,
                                ),
                                itemCount: all_sliding_images_url.length,
                                itemBuilder: (context, index, real_index){
                                  return InkWell(
                                    onTap: ()async{
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              content: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Contact Designer',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    FlatButton(
                                                      onPressed: (){
                                                        var original_number = slider_number;

                                                        var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                                                        launchWhatsapp(correct_number, 'EL-Vision GRAPHIX');

                                                        Navigator.of(context).pop();
                                                      },
                                                      textColor: Colors.blue,
                                                      child: Text(
                                                        'Contact',
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                    FlatButton(
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                      textColor: Colors.red,
                                                      child: Text(
                                                        'Close',
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
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Image.network(
                                          'https://media.pridamo.com/pridamo-static/${all_sliding_images_url[index]}',
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context).size.width * 0.25,
                                          width: double.infinity,
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
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,12.0,0,14.0),
                        child: Text(
                          'Popular Searches',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popular_items.length,
                          itemBuilder: (context, index){
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CupertinoButton(
                                borderRadius: BorderRadius.circular(80),
                                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 5.0),
//                                color: Colors.blueAccent,
                                pressedOpacity: 0.7,
                                child: Text(popular_items[index]),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => particular_search_page(search_word: popular_items[index]),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,8.0,0,14.0),
                        child: Text(
                          'Choice Selection',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          crossAxisCount: 2,
                          itemCount: haha.length,
                          itemBuilder: (BuildContext context, int index) => new Container(
                             child: ClipRRect(
                               borderRadius: BorderRadius.circular(5.0),
                               child: Card(
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
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Stack(
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
                                         padding: const EdgeInsets.fromLTRB(3.0,3.0,3.0,10.0),
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
                                 ),
                               ),
                             )
                         ),
                          staggeredTileBuilder: (int index) =>
                          new StaggeredTile.fit(1),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        ),
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
        drawer: Drawer(
          child: Padding(
              padding: EdgeInsets.fromLTRB(0,35.0,0,0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => recent_posts_page(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.new_releases,
                      color: Colors.red[500]
                    ),
                    title: Text(
                      'Recent Posts',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => categories(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.category,
                      color: Colors.blueGrey,
                    ),
                    title: Text(
                      'Categories',
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => wish_lists(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Wishlist',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                      leading: Icon(Icons.add_shopping_cart, color: Colors.blue[800]),
                      title: Text(
                        'Orders Placed',
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => all_orders_made_page(),
                          ),
                        );
                      }
                  ),
                  ListTile(
                      leading: Icon(Icons.directions_bike, color: Colors.blueGrey[800]),
                      title: Text(
                        'Delivery Requests',
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => all_delivery_requests_page(),
                          ),
                        );
                      }
                  ),

                  ListTile(
                      leading: Icon(Icons.help, color: Colors.deepOrange),
                      title: Text(
                        'Help',
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => help_page(),
                          ),
                        );
                      }
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => about_app_page(),
                        ),
                      );
                    },
                    leading: Icon(
                        Icons.rate_review,
                        color: Colors.blue
                    ),
                    title: Text(
                      'About App',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState){
                                  return AlertDialog(
                                    content: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FlatButton(
                                            onPressed: (){
                                              launch(
                                                  "tel://${number_to_call}"
                                              );
                                            },
                                            textColor: Colors.blue,
                                            child: Text(
                                              'Call',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: (){
                                              var original_number = number_to_call;

                                              var correct_number = original_number.toString().replaceFirst(RegExp('0'), '+233');

                                              launchWhatsapp(correct_number, 'Pridamo user inquiry');
                                            },
                                            textColor: Colors.blue,
                                            child: Text(
                                              'WhatsApp',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: ()async{
                                              final Uri params = Uri(
                                                scheme: 'mailto',
                                                path: '${mail_to_send_to}',
                                                query: 'subject=User Inquiry',
                                              );

                                              var url = params.toString();

                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              }else{
                                                Fluttertoast.showToast(
                                                  msg: "Cannot open Email",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            },
                                            textColor: Colors.blue,
                                            child: Text(
                                              'Email',
                                              textAlign: TextAlign.center,
                                            ),
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
                          }
                      );
                    },
                    leading: Icon(Icons.contact_mail, color: Colors.blue[500]),
                    title: Text(
                      'Contact Us',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
          ),
        ),
//        floatingActionButton: seller_or_not == true ? FloatingActionButton(
//          foregroundColor: theme_type == 'light' ? Colors.black : Colors.white,
//          onPressed: (){
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => main_ad_post_page(),
//              ),
//            );
//          },
//          tooltip: "Ads Page",
//          heroTag: 'Floating action button on homepage',
//          child: Icon(
//            Icons.add,
//            color: Colors.white,
//          ),
//          backgroundColor: Colors.blue,
//        ): SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPost(String profile_pic, String user_name, image, String product_name, price, String product_slug, bool my_ad_or_not){
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
                  my_ad_or_not ? CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage("https://media.pridamo.com/pridamo-static/$profile_pic"),
                  ):
                  InkWell(
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage("https://media.pridamo.com/pridamo-static/$profile_pic"),
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
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
              my_ad_or_not ?
              SizedBox.shrink():
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
                                          "Report",
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
              ),
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
              child: image_added(image_url: image),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product_name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    int.parse(price) != 1 ? '$price Cedis' : '$price Cedi',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.blue
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoPost(String profile_pic, String user_name, image, String product_name, price, String product_slug, bool my_ad_or_not){
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
                  my_ad_or_not ? CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage("https://media.pridamo.com/pridamo-static/$profile_pic"),
                  ):
                  InkWell(
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage("https://media.pridamo.com/pridamo-static/$profile_pic"),
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
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
              my_ad_or_not ?
              SizedBox.shrink():
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
                                          "Report",
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
              ),
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
              child: video_image_added(image_url: image),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product_name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    int.parse(price) != 1 ? '$price Cedis' : '$price Cedi',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.blue
                    ),
                  )
                ],
              ),
            ),
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


class video_image_added extends StatefulWidget {
  var image_url;

  video_image_added({Key key, @required this.image_url}) : super(key: key);

  @override
  _video_image_addedState createState() => _video_image_addedState();
}

class _video_image_addedState extends State<video_image_added> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          'https://media.pridamo.com/pridamo-static/${widget.image_url}',
          height: MediaQuery.of(context).size.width * 0.60,
          width: double.infinity,
          fit: BoxFit.cover,
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
    );
  }
}


class image_added extends StatefulWidget {
  var image_url;

  image_added({Key key, @required this.image_url}) : super(key: key);

  @override
  _image_addedState createState() => _image_addedState();
}

class _image_addedState extends State<image_added> with AutomaticKeepAliveClientMixin<image_added>{
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://media.pridamo.com/pridamo-static/${widget.image_url}',
      height: MediaQuery.of(context).size.width * 0.60,
      width: double.infinity,
      fit: BoxFit.cover,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}