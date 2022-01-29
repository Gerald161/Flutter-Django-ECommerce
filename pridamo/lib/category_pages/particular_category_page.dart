import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pridamo/userpages/particular_search_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pridamo/userpages/profile_read_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:pridamo/userpages/picture_read_more.dart';
import 'package:pridamo/userpages/video_read_more.dart';
import 'dart:ui';

class particular_category_page extends StatefulWidget {
  var particular_category;

  var sub_category;

  var popular_items;

  particular_category_page({Key key, @required this.particular_category, @required this.sub_category, @required this.popular_items})
      : super(key: key);

  @override
  _particular_category_pageState createState() => _particular_category_pageState();
}

class _particular_category_pageState extends State<particular_category_page> {
  ScrollController _scrollController = ScrollController();

  var all_regions = [
    "All", "Ashanti", 'Greater Accra', "Northern", "Western", 'Volta', 'Oti', 'Central', 'Eastern', 'Upper East',
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

  var theme_type = 'light';

  List<Widget> all_category_posts_children = [];

  var current_subcategory_selected_index = 0;

  var initial_category_children_future;

  var selected_district_list = [];

  var current_district_selected_index = 0;

  var currently_selected_region = 0;

  var selected_sub_category = '';

  var num = 0;

  var change = 10;

  var highlighted_region = '';

  var my_username = '';

  var show_more_ads = false;

  get_my_user_name()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/get_app_wallpaper',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    setState(() {
      my_username = jsonDecode(response.body)['user_name'];

      if(jsonDecode(response.body)['has_direction_set'] == 'yes'){
        has_direction_set_up = true;
      }else{
        has_direction_set_up = false;
      }

      currently_selected_region = 0;

      highlighted_region = 'All';

      current_district_selected_index = 0;
    });
  }

  get_category_ads()async{
    if(my_username == ''){
      await get_my_user_name();
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    if(has_direction_set_up == false) {
      var response = await http.get(
          'https://pridamo.com/app_category_ads/${widget.particular_category.replaceAll(' ', '_').replaceAll(',', '-')}?num=${num}&change=${change}&request_type=$request_type&region=$region_chosen&district=$district_chosen&sub=${selected_sub_category.replaceAll(' ', '_')}',
          headers: {
            HttpHeaders.authorizationHeader: "Token $token",
          }
      );

      setState(() {
        received_response = true;
      });

      var ads = jsonDecode(response.body);

      if (ads.length != 0) {
        if (ads[0]['show_more'] == 'yes') {
          setState(() {
            show_more_ads = true;
          });
        } else {
          setState(() {
            show_more_ads = false;
          });
        }
      }

      ads.forEach((ha) {
        if (my_username == ha['owner_name_text']) {
          if (ha['ad_type'] == 'picture') {
            setState(() {
              gridview_product_infos.add([
                ha['image'],
                ha['product_name'],
                ha['price'],
                ha['product_slug'],
                ha['ad_type']
              ]);

              all_category_posts_children.add(_buildPost(
                  ha['ad_profile_url'],
                  ha['owner_name_text'],
                  ha['image'],
                  ha['product_name'],
                  ha['price'],
                  ha['product_slug'],
                  true));
            });
          } else {
            setState(() {
              gridview_product_infos.add([
                ha['thumbnail'],
                ha['product_name'],
                ha['price'],
                ha['product_slug'],
                ha['ad_type']
              ]);

              all_category_posts_children.add(_buildVideoPost(
                  ha['ad_profile_url'],
                  ha['owner_name_text'],
                  ha['thumbnail'],
                  ha['product_name'],
                  ha['price'],
                  ha['product_slug'],
                  true));
            });
          }
        } else {
          if (ha['ad_type'] == 'picture') {
            setState(() {
              gridview_product_infos.add([
                ha['image'],
                ha['product_name'],
                ha['price'],
                ha['product_slug'],
                ha['ad_type']
              ]);

              all_category_posts_children.add(_buildPost(
                  ha['ad_profile_url'],
                  ha['owner_name_text'],
                  ha['image'],
                  ha['product_name'],
                  ha['price'],
                  ha['product_slug'],
                  false));
            });
          } else {
            setState(() {
              gridview_product_infos.add([
                ha['thumbnail'],
                ha['product_name'],
                ha['price'],
                ha['product_slug'],
                ha['ad_type']
              ]);

              all_category_posts_children.add(_buildVideoPost(
                  ha['ad_profile_url'],
                  ha['owner_name_text'],
                  ha['thumbnail'],
                  ha['product_name'],
                  ha['price'],
                  ha['product_slug'],
                  false));
            });
          }
        }
      });

      num += 10;

      change += 10;
    }else{
      if(overall_container_of_all_close_products_returned.isEmpty){
        select_closest_products();
      }else{
        add_on_closest_from_container_gotten();
      }
    }
  }

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

  var region_chosen = '';

  var district_chosen = '';

  var request_type = 'none';

  change_region_and_expected_show_more_behavior(choice){
    setState(() {
      if(choice == 'All'){
        selected_district_list.clear();

        request_type = 'none';
      }else{
        request_type = 'region';
      }

      show_more_ads = false;

      all_category_posts_children = [];

      gridview_product_infos = [];

      list_of_all_product_slugs = [];

      highlighted_region = choice;

      num = 0;

      change = 10;

      selected_district_list = current_region_districts[all_regions.indexOf(choice)];

      current_district_selected_index = 0;

      region_chosen = choice.toString().replaceAll(' ', '_');

      if(has_direction_set_up != false){
        directions_count_num = 0;

        directions_count_change = 10;

        overall_container_of_all_close_products_returned = [];
        
        select_closest_products();
      }else{
        get_category_ads();
      }
    });
  }

  change_district_and_expected_behavior(choice){
    setState(() {
      num = 0;

      change = 10;

      show_more_ads = false;

      all_category_posts_children = [];

      gridview_product_infos = [];

      list_of_all_product_slugs = [];

      if(choice.toString().toLowerCase() == 'all'){
        change_region_and_expected_show_more_behavior(highlighted_region);
      }else{
        district_chosen = choice.toString().replaceAll(' ', '_');

        request_type = 'district';

        if(has_direction_set_up != false){
          directions_count_num = 0;

          directions_count_change = 10;

          overall_container_of_all_close_products_returned = [];

          select_closest_products();
        }else{
          get_category_ads();
        }
      }
    });
  }

  change_to_category(choice){
    setState(() {
      show_more_ads = false;

      all_category_posts_children = [];

      gridview_product_infos = [];

      list_of_all_product_slugs = [];

      overall_container_of_all_close_products_returned = [];

      directions_count_num = 0;

      directions_count_change = 10;

      num = 0;

      change = 10;

      if(choice.toString().toLowerCase() == 'all'){
        selected_sub_category = '';
      }else{
        selected_sub_category = choice;
      }

      get_category_ads();
    });
  }

  var received_response = false;

  refresh_list()async{
    setState(() {
      if(has_direction_set_up == false) {
        received_response = false;

        show_more_ads = false;

        all_category_posts_children = [];

        gridview_product_infos = [];

        list_of_all_product_slugs = [];

        num = 0;

        change = 10;

        get_category_ads();
      }else{
        directions_count_num = 0;

        directions_count_change = 10;

        received_response = false;

        show_more_ads = false;

        gridview_product_infos = [];

        list_of_all_product_slugs = [];

        all_category_posts_children = [];

        overall_container_of_all_close_products_returned = [];

        select_closest_products();
      }
    });
  }

  var default_view_is_grid = true;

  var grid_group_value = 'grid';

  var gridview_product_infos = [];

  change_grid_state(){
    setState(() {
      if(default_view_is_grid == false){
        default_view_is_grid = true;
      }else{
        default_view_is_grid = false;
      }
    });
  }

  var has_direction_set_up = false;

  var directions_count_num = 0;

  var directions_count_change = 10;

  var overall_container_of_all_close_products_returned = [];

  var list_of_all_product_slugs = [];

  select_closest_products()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_category_ads/${widget.particular_category.replaceAll(' ', '_').replaceAll(',', '-')}?directions_count_num=${directions_count_num}&directions_count_change=${directions_count_change}&request_type=$request_type&region=$region_chosen&district=$district_chosen&sub=${selected_sub_category.replaceAll(' ', '_')}',
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
                show_more_ads = true;

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
                    all_category_posts_children.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(! list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    all_category_posts_children.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    all_category_posts_children.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                    list_of_all_product_slugs.add(product['product_slug']);
                  }
                });
              }else{
                setState(() {
                  if(!list_of_all_product_slugs.contains(product['product_slug'])){
                    gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                    all_category_posts_children.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
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
              show_more_ads = true;

              overall_container_of_all_close_products_returned.add(product);
            });
          }else{
            if(my_username == product['owner_name_text']){
              if(product['ad_type'] == 'picture'){
                setState(() {
                  gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  all_category_posts_children.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
                });
              }else{
                setState(() {
                  gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  all_category_posts_children.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
                });
              }
            }else{
              if(product['ad_type'] == 'picture'){
                setState(() {
                  gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  all_category_posts_children.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
                });
              }else{
                setState(() {
                  gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
                  all_category_posts_children.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
                });
              }
            }
          }
        }
      });
    }

    if(all_products[0]['show_more_directions'] == 'no'){
      setState(() {
        if(overall_container_of_all_close_products_returned.isEmpty) {
          show_more_ads = false;
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
              all_category_posts_children.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], true));
            });
          }else{
            setState(() {
              gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              all_category_posts_children.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], true));
            });
          }
        }else{
          if(product['ad_type'] == 'picture'){
            setState(() {
              gridview_product_infos.add([product['image'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              all_category_posts_children.add(_buildPost(product['ad_profile_url'], product['owner_name_text'], product['image'], product['product_name'], product['price'], product['product_slug'], false));
            });
          }else{
            setState(() {
              gridview_product_infos.add([product['thumbnail'], product['product_name'], product['price'], product['product_slug'], product['ad_type']]);
              all_category_posts_children.add(_buildVideoPost(product['ad_profile_url'], product['owner_name_text'], product['thumbnail'], product['product_name'], product['price'], product['product_slug'], false));
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

  get_proximity_more_data(){
    if(overall_container_of_all_close_products_returned.isEmpty){
      select_closest_products();
    }else{
      add_on_closest_from_container_gotten();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_category_children_future = get_category_ads();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        if(has_direction_set_up == false) {
          if (show_more_ads == true) {
            get_category_ads();
          }
        }else{
          if(show_more_ads){
            get_proximity_more_data();
          }
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.particular_category
        ),
        actions: [
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
                                                currently_selected_region = index;

                                                received_response = false;

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
                                selected_district_list.isNotEmpty ?
                                Builder(
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
                                ):
                                SizedBox.shrink()
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: _scrollController,
          child: Column(
            children: [
              widget.sub_category.length > 1 ? Container(
                height: MediaQuery.of(context).size.height * 0.06,
                margin: EdgeInsets.symmetric(vertical: 5.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.sub_category.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          current_subcategory_selected_index = index;

                          received_response = false;

                          change_to_category(widget.sub_category[index]);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          widget.sub_category[index],
                          style: TextStyle(
                              color: index == current_subcategory_selected_index ? Colors.blue : Colors.grey[600],
                              fontWeight: index == current_subcategory_selected_index ? FontWeight.bold : FontWeight.normal
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : SizedBox.shrink(),
              FutureBuilder(
                future: initial_category_children_future,
                builder: (context, snapshot) {
                  if(all_category_posts_children.isEmpty){
                    return received_response != true ? default_view_is_grid == false ? Shimmer.fromColors(
                      highlightColor: theme_type == 'light' ? Colors.white.withOpacity(0.3) : Colors.grey[600].withOpacity(0.3),
                      baseColor: theme_type == 'light' ? Colors.grey[400] : Colors.grey[700],
                      child: Column(
                        children: [
                          shimmer_child(),
                          shimmer_child(),
                          shimmer_child(),
                        ],
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
                        : Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.80,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sorry no products present',
                              textAlign: TextAlign.center,
                            ),
                          )
                        ),
                      ],
                    );
                  }else{
                    return default_view_is_grid == false ? ListView(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      cacheExtent: 9999,
                      children: [
                        widget.popular_items.isNotEmpty ? Padding(
                          padding: const EdgeInsets.fromLTRB(0,12.0,0,14.0),
                          child: Text(
                              'Popular Searches',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ) : SizedBox.shrink(),
                        widget.popular_items.isNotEmpty ? Container(
                          height: MediaQuery.of(context).size.height * 0.07,
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.popular_items.length,
                            itemBuilder: (context, index){
                              return CupertinoButton(
                                borderRadius: BorderRadius.circular(80),
                                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 5.0),
                                pressedOpacity: 0.7,
//                                color: Colors.blue,
                                child: Text(widget.popular_items[index]),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => particular_search_page(search_word: widget.popular_items[index]),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ) : SizedBox.shrink(),
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
                          children: all_category_posts_children,
                        ),
                        show_more_ads == true ? Padding(
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
                    ) :
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          widget.popular_items.isNotEmpty ? Padding(
                            padding: const EdgeInsets.fromLTRB(0,12.0,0,14.0),
                            child: Text(
                                'Popular Searches',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ) : SizedBox.shrink(),
                          widget.popular_items.isNotEmpty ? Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            margin: EdgeInsets.symmetric(vertical: 5.0),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.popular_items.length,
                              itemBuilder: (context, index){
                                return CupertinoButton(
                                  borderRadius: BorderRadius.circular(80),
                                  padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 5.0),
                                  pressedOpacity: 0.7,
//                                  color: Colors.blue,
                                  child: Text(widget.popular_items[index]),
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => particular_search_page(search_word: widget.popular_items[index]),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ) : SizedBox.shrink(),
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
                          StaggeredGridView.countBuilder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            crossAxisCount: 2,
                            itemCount: all_category_posts_children.length,
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
                              if(show_more_ads){
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
            ],
          )
        ),
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
              child: Image.network(
                'https://media.pridamo.com/pridamo-static/$image',
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
                }
              ),
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
              child: Stack(
                children: [
                  Image.network(
                    'https://media.pridamo.com/pridamo-static/$image',
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
                    }
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
                          SizedBox(height: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.13,
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
}
