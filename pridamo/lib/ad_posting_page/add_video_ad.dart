import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:http/http.dart' as http;
import 'package:pridamo/ad_posting_page/ad_slot_purchase_page.dart';
import 'package:pridamo/chewy_list_item.dart';
import 'dart:io';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

var second_selected = '';

class video_advert_add extends StatefulWidget {
  @override
  _video_advert_addState createState() => _video_advert_addState();
}

class _video_advert_addState extends State<video_advert_add> {
  bool loading = false;

  var time_group_value = 'week';

  var time_selected = 'week';

  bool picture_taken = false;

  bool video_taken = false;

  var _image;

  File _video;

  String Tap_to_select = 'Tap to select/change your video';

  _pickVideo() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.video);

    if(result != null){
      File video = File(result.files.first.path);

      if(video != null){
        VideoPlayerController controller = new VideoPlayerController.file(video);

        await controller.initialize();

        var video_length_gibberish = controller.value.duration;

        var video_length_array = video_length_gibberish.toString().split(":");

        if(int.parse(video_length_array[1]) > 0){
          setState(() {
            Tap_to_select = 'Please limit video to 1 minute';

            video_taken = false;

            _video = null;

            using_seconds_thumbnail = false;
          });
        }else{
          setState(() {
            Tap_to_select = 'Tap to select/change your video';

            _video = video;

            video_taken = true;

            using_seconds_thumbnail = true;
          });
        }
      }else{
        setState(() {
          video_taken = false;

          using_seconds_thumbnail = false;

          _video = null;
        });
      }
    }else{
      setState(() {
        video_taken = false;

        using_seconds_thumbnail = false;

        _video = null;
      });
    }

  }

  Widget image_path(){
    if(picture_taken){
      if(_image == null){
        return SizedBox.shrink();
      }else{
        return Image.file(
          _image,
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.50,
          fit: BoxFit.cover,
        );
      }
    }else{
      return SizedBox.shrink();
    }
  }

  Widget video_path(){
    if(video_taken){
      if(_video == null){
        return SizedBox.shrink();
      }else{
        return Container(
          height: MediaQuery.of(context).size.height * 0.50,
          child: chewie_list_item(
            video_type: 'file',
            video_url: _video,
          ),
        );
      }
    }else{
      return SizedBox.shrink();
    }
  }

  getImage() async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);

    if(result != null){
      File image = File(result.files.first.path);

      if(image != null){
        setState(() {
          using_seconds_thumbnail = false;

          _image = image;

          picture_taken = true;
        });
      }else{
        setState(() {
          using_seconds_thumbnail = true;

          picture_taken = false;

          _image = null;
        });
      }
    }else{
      setState(() {
        using_seconds_thumbnail = true;

        picture_taken = false;

        _image = null;
      });
    }

  }

  final _formKey = GlobalKey<FormState>();

  String product_name = '';

  String description = '';

  String location = '';

  String phone_number;

  String price;

  String about = '';

  var categories;

  var sub_categories = [];

  var age_target = [
    '',
  ];

  var regions = [
    "Ashanti", 'Greater Accra', "Northern", "Western", 'Volta', 'Oti', 'Central', 'Eastern', 'Upper East',
    'Upper West', 'Savannah', 'North East', 'Bono', 'Bono East', 'Ahafo', 'Western North'
  ];

  var region_districts = [
    [
      'Kumasi Metropolitan', 'Obuasi Municipal', 'Mampong Municipal', 'Asante Akim Central Municipal',
      'Asokore Mampong Municipal', 'Bekwai Municipal', 'Ejisu-Juaben Municipal', 'Offinso Municipal', 'Adansi North',
      'Adansi South', 'Afigya-Kwabre', 'Ahafo Ano North', 'Ahafo Ano South', 'Amansie Central', 'Amansie West',
      'Asante Akim North', 'Asante Akim South', 'Atwima Kwanwoma', 'Atwima Mponua', 'Atwima Nwabiagya', 'Bosome Freho',
      'Bosomtwe', 'Ejura-Sekyedumase', 'Kwabre', 'Offinso North', 'Sekyere Afram Plains', 'Sekyere Central',
      'Sekyere East', 'Sekyere Kumawu', 'Sekyere South'
    ],
    [
      'Accra Metropolitan', 'Tema Metropolitan', 'Ledzokuku-Krowor Municipal', '	La Dade Kotopon Municipal',
      'La Nkwantanang Madina Municipal', 'Adentan Municipal', 'Ashaiman Municipal', 'Ga Central Municipal',
      'Ga East Municipal', 'Ga South Municipal', 'Ga West Municipal', 'Ada East', 'Ada West', 'Kpone Katamanso',
      'Ningo Prampram', 'Shai Osudoku'
    ],
    [
      'Tamale Metropolitan', 'Yendi Municipal', 'Kpandai', 'Gushegu', 'Karaga', 'Kumbungu', 'Mion',
      'Nanton', 'Nanumba North', 'Nanumba South', 'Saboba', 'Sagnarigu', 'Savelugu', 'Tatale Sangule',
      'Tolon', 'Zabzugu'
    ],
    [
      'Sekondi-Takoradi Metropolitan', 'Ahanta West Municipal', 'Effia-Kwesimintsim Municipal', 'Jomoro Municipal',
      'Nzema East Municipal', 'Prestea-Huni Valley Municipal', 'Tarkwa Nsuaem Municipal', 'Wassa Amenfi East Municipal',
      'Wassa Amenfi West Municipal', 'Wassa East', 'Ellembelle', 'Mpohor', 'Shama', 'Wassa Amenfi Central'
    ],
    [
      'Ho Municipal', 'Keta Municipal', 'Hohoe Municipal', 'Ketu North Municipal', 'Ketu South Municipal',
      'Kpando Municipal', 'Anloga', 'Adaklu', 'Afadjato South', 'Agotime Ziope','Akatsi North', 'Akatsi South',
      'Central Tongu', 'Ho West', 'North Dayi', 'North Tongu', 'South Dayi', 'South Tongu'
    ],
    [
      'Biakoye District', 'Jasikan District', 'Kadjebi District', 'Krachi East District', 'Krachi Nchumuru District',
      'Krachi West District', 'Nkwanta North District', 'Nkwanta South District'
    ],
    [
      'Cape Coast Metropolitan', 'Effutu Municipal', 'Agona West Municipal', 'Assin North Municipal', 'Awutu Senya East Municipal',
      'Komenda/Edina/Egyafo/Abirem Municipal', 'Mfantsiman Municipal', 'Upper Denkyira East Municipal',
      'Abura/Asebu/Kwamankese', 'Agona East', 'Ajumako/Enyan/Essiam', 'Asikuma/Odoben/Brakwa', 'Assin South',
      'Awutu Senya West', 'Ekumfi', 'Gomoa East', 'Gomoa West', 'Twifo-Ati Morkwa', 'Twifo/Heman/Lower Denkyira',
      'Upper Denkyira West'
    ],
    [
      'New-Juaben Municipal', 'Nsawam Adoagyire Municipal', 'Suhum Municipal', 'Akuapim North Municipal',
      'West Akim Municipal', 'East Akim Municipal', 'Birim Central Municipal', 'Kwahu West Municipal',
      'Akuapim South', 'Akyemansa', 'Asuogyaman', 'Atiwa', 'Ayensuano', 'Birim North', 'Birim South',
      'Denkyembour', 'Fanteakwa', 'Kwaebibirem', 'Kwahu Afram Plains North', 'Kwahu Afram Plains South',
      'Kwahu East', 'Kwahu South', 'Lower Manya Krobo', 'Upper Manya Krobo', 'Upper West Akim', 'Yilo Krobo'
    ],
    [
      'Bolgatanga Municipal', 'Bawku West', 'Binduri', 'Bongo', 'Builsa North', 'Builsa South',
      'Garu', 'Kassena Nankana East', 'Kassena Nankana West', 'Nabdam', 'Pusiga', 'Talensi', 'Bolgatanga East',
      'Tempane'
    ],
    [
      'Wa Municipal', 'Daffiama Bussie Issa', 'Jirapa/Lambussie', 'Lambussie Karni', 'Lawra', 'Nadowli',
      'Nandom', 'Sissala East', 'Sissala West', 'Wa East', 'Wa West'
    ],
    [
      'East Gonja Municipal', 'Central Gonja', 'North Gonja', 'Bole', 'North East Gonja', 'West Gonja',
      'Sawla-Tuna-Kalba'
    ],
    [
      'East Mamprusi Municipal', 'West Mamprusi Municipal', 'Bunkpurugu-Nyakpanduri', 'Chereponi',
      'Mamprugu Moagduri', 'Yunyoo-Nasuan'
    ],
    [
      'Sunyani Municipal', 'Berekum East Municipal', 'Dormaa Central Municipal', 'Wenchi Municipal',
      'Jaman South Municipal', 'Banda', 'Berekum West', 'Dormaa East', 'Dormaa West', 'Jaman North',
      'Sunyani West', 'Tain'
    ],
    [
      'Techiman Municipal', 'Atebubu-Amanten Municipal', 'Nkoranza South Municipal', 'Kintampo North Municipal',
      'Kintampo South', 'Nkoranza North', 'Pru East', 'Pru West',
      'Sene East', 'Sene West', 'Techiman North'
    ],
    [
      'Asunafo North Municipal', 'Tano North Municipal', 'Tano South Municipal', 'Asunafo South',
      'Asutifi North', 'Asutifi South'
    ],
    [
      'Sefwi Wiawso Municipal', 'Aowin Municipal', 'Bibiani/Anhwiaso/Bekwai',
      'Bia East', 'Bia West', 'Bodi', 'Juaboso', 'Sefwi Akontombra', 'Suaman'
    ],
  ];

  get_all_categories_plus(token)async{
    var response = await http.get(
        'https://pridamo.com/profile/get_all_categories_plus',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    setState(() {
      categories = new List<String>.from(data['categories']);

      sub_categories = data['sub_categories'];

      selected = categories[0];

      age_target = new List<String>.from(sub_categories[0]);

      age_selected = age_target[0];
    });
  }

  Future<List> get_selected_ad_region() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    await get_all_categories_plus(token);

    var response = await http.get(
        'https://pridamo.com/account/set_new_ad_region',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );
    var data = jsonDecode(response.body);

    setState(() {
      selected_region = data['region'];

      _controller1 = new TextEditingController(text: data['number']);

      _controller2 = new TextEditingController(text: data['location']);

      phone_number = data['number'];

      location = data['location'];

      districts_in_question = region_districts[regions.indexOf(data['region'])];

      district_selected = data['district'];
    });
  }

  var selected;

  var district_selected = '';

  var districts_in_question = [
      'Kumasi Metropolitan', 'Obuasi Municipal', 'Mampong Municipal', 'Asante Akim Central Municipal',
      'Asokore Mampong Municipal', 'Bekwai Municipal', 'Ejisu-Juaben Municipal', 'Offinso Municipal', 'Adansi North',
      'Adansi South', 'Afigya-Kwabre', 'Ahafo Ano North', 'Ahafo Ano South', 'Amansie Central', 'Amansie West',
      'Asante Akim North', 'Asante Akim South', 'Atwima Kwanwoma', 'Atwima Mponua', 'Atwima Nwabiagya', 'Bosome Freho',
      'Bosomtwe', 'Ejura-Sekyedumase', 'Kwabre', 'Offinso North', 'Sekyere Afram Plains', 'Sekyere Central',
      'Sekyere East', 'Sekyere Kumawu', 'Sekyere South'
  ];

  var age_selected;

  var selected_region;

  TextEditingController _controller1;

  TextEditingController _controller2;

  var index_of_category = 0;

  var ad_region_future;

  var imageArray = [];

  ScrollController _scrollController = ScrollController();

  Future<Map> post_vid_ad() async {
    var request = http.MultipartRequest('POST', Uri.parse('https://pridamo.com/handle_app_video_upload?time_selected=${time_selected}'));

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = await prefs.getString('token');
    request.fields['product_name'] = product_name.trim();
    request.fields['phone_number'] = phone_number.trim();
    request.fields['price'] = price.trim();
    request.fields['description'] = description.trim();
    request.fields['category'] = selected.trim();
    request.fields['subcategory'] = age_selected.trim();
    request.fields['region'] = selected_region.trim();
    request.fields['district'] = district_selected.trim();
    request.fields['your_location'] = location.trim();

    request.fields['generate_thumbnail'] = using_seconds_thumbnail == true ? 'yes' : 'no';
    request.fields['second_chosen'] = second_selected;

    request.headers['authorization'] = "Token $token";

    request.files.add(await http.MultipartFile.fromPath('video', _video.path));

    if(_image != null ){
      request.files.add(await http.MultipartFile.fromPath('thumbnail', _image.path));
    }

    imageArray.asMap().forEach((index, image) async {
      request.files.add(await http.MultipartFile.fromPath('additional_input$index', image));
    });

    var res = await http.Response.fromStream(await request.send());

    if(jsonDecode(res.body)['status'] == 'uploaded'){
      Fluttertoast.showToast(
          msg: "Successfully posted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );

      Navigator.pop(context, '');
    }
  }

  var using_seconds_thumbnail = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ad_region_future = get_selected_ad_region();
  }

  Widget buildGridView() {
    if(images.length == 0){
      return SizedBox.shrink();
    }else{
      return GridView.count(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
          );
        }),
      );
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pridamo",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );

      resultList.forEach((image) async{
        var path = await FlutterAbsolutePath.getAbsolutePath(image.identifier);
        setState(() {
          imageArray.add(path);
        });
      });

    } on Exception catch (e) {

    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(
          'Post a video product/service',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ad_region_future,
        builder: (context, snapshot) {
          if(categories == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _video != null ? Container(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: video_path(),
                        ),
                      ):SizedBox.shrink(),
                      FlatButton(
                        onPressed: (){
                          _pickVideo();
                          setState(() {
                            video_taken = false;
                          });
                        },
                        child: Text(
                          Tap_to_select,
                        ),
                        textColor: Colors.blue,
                      ),
                      using_seconds_thumbnail == true ? Text(
                        'Please note that the timestamp of video will be used as the thumbnail',
                        textAlign: TextAlign.center,
                      ) : SizedBox.shrink(),
                      Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5.0),
                              child: image_path()
                          ),
                        ],
                      ),
                      FlatButton(
                        onPressed: (){
                          setState(() {
                            getImage();
                          });
                        },
                        child: Text(
                          'Add/Change video thumbnail',
                        ),
                        textColor: Colors.blue,
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,0,0,5.0),
                            child: RaisedButton(
                              child: Text("Add extra images"),
                              onPressed: loadAssets,
                              color: Colors.blue,
                              textColor: Colors.white,
                            ),
                          ),
                          buildGridView()
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: product_name,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                          ),
                          validator: (input) => input.trim().length < 1
                              ? 'Please Enter a longer Title'
                              : null,
                          onChanged: (val){
                            setState(() {
                              product_name = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: description,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'About Product(Description)',
                          ),
                          validator: (input) => input.trim().length < 1
                              ? 'Please enter at least 1 character'
                              : null,
                          onChanged: (val){
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Price of product/services',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (val) => val.length < 1 ? 'Number must be at least 1 cedi' : null,
                          onChanged: (val){
                            setState(() {
                              price = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _controller1,
                          decoration: InputDecoration(
                            hintText: '01234567890',
                            labelText: 'Your contact number',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (val) => val.length < 10 ? 'Number must be 10 digits' : null,
                          onChanged: (val){
                            setState(() {
                              phone_number = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: _controller2,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: 'Location(Town)',
                          ),
                          validator: (input) => input.trim().length < 2
                              ? 'Please enter at least 2 characters'
                              : null,
                          onChanged: (val){
                            setState(() {
                              location = val;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selected,
                          onChanged: (String text) {
                            setState(() {
                              selected = text;
                              index_of_category = categories.indexOf(selected);
                              age_target = new List<String>.from(sub_categories[0]);
                              age_target = new List<String>.from(sub_categories[index_of_category]);
                              age_selected = age_target[0];
                            });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return categories.map<Widget>((String text) {
                              return Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.format_list_bulleted,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                                    child: Text(
                                      "Category: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                          text,
                                          overflow:
                                          TextOverflow.ellipsis
                                      )
                                  ),
                                ],
                              );
                            }).toList();
                          },
                          items: categories.map<DropdownMenuItem<String>>((String text) {
                            return DropdownMenuItem<String>(
                              value: text,
                              child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: age_selected,
                          onChanged: (String text) {
                            setState(() { age_selected = text; });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return age_target.map<Widget>((String text) {
                              return Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.category,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                                    child: Text(
                                      "Sub-Category: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                          text,
                                          overflow:
                                          TextOverflow.ellipsis
                                      )
                                  ),
                                ],
                              );
                            }).toList();
                          },
                          items: age_target.map<DropdownMenuItem<String>>((String text) {
                            return DropdownMenuItem<String>(
                              value: text,
                              child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: regions.indexOf(selected_region) == -1 || selected_region == '' ? regions[0] : selected_region,
                          onChanged: (String text) {
                            setState(() {
                              selected_region = text;

                              var index_of_new_district = regions.indexOf(selected_region);

                              district_selected = region_districts[index_of_new_district][0];

                              districts_in_question = [];

                              districts_in_question = region_districts[index_of_new_district];
                            });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return regions.map<Widget>((String text) {
                              return Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.public,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                                    child: Text(
                                      "Your Region: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                          text,
                                          overflow:
                                          TextOverflow.ellipsis
                                      )
                                  ),
                                ],
                              );
                            }).toList();
                          },
                          items: regions.map<DropdownMenuItem<String>>((String text) {
                            return DropdownMenuItem<String>(
                              value: text,
                              child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: districts_in_question.indexOf(district_selected) == -1 || district_selected == '' ? districts_in_question[0] : district_selected,
                          onChanged: (String text) {
                            setState(() {
                              district_selected = text;
                            });
                          },
                          selectedItemBuilder: (BuildContext context) {
                            return districts_in_question.map<Widget>((String text) {
                              return Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.public,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                                    child: Text(
                                      "District: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                          text,
                                          overflow:
                                          TextOverflow.ellipsis
                                      )
                                  ),
                                ],
                              );
                            }).toList();
                          },
                          items: districts_in_question.map<DropdownMenuItem<String>>((String text) {
                            return DropdownMenuItem<String>(
                              value: text,
                              child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                     Padding(
                       padding: const EdgeInsets.fromLTRB(10.0,0,10,0),
                       child: FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Post',
                              ),
                            ),
                          ],
                        ),
                         onPressed: ()async{
                           if(_formKey.currentState.validate()){
                             if(video_taken == false){
                               showDialog(
                                   context: context,
                                   builder: (BuildContext context){
                                     return AlertDialog(
                                       title: Text(
                                         "Missing media",
                                         textAlign: TextAlign.center,
                                         style: TextStyle(
                                             color: Colors.red
                                         ),
                                       ),
                                       content: Text(
                                         "Please make sure video is uploaded",
                                         textAlign: TextAlign.center,
                                       ),
                                       actions: <Widget>[
                                         FlatButton(
                                           child: Text(
                                             "Ok",
                                           ),
                                           onPressed: ()async{
                                             Navigator.of(context).pop();
                                           },
                                         ),
                                       ],
                                     );
                                   }
                               );
                             }else{
                               setState(() {
                                 loading = true;
                               });

                               dynamic result = await post_vid_ad();
                             }
                           }
                         },
                         color: Colors.blue,
                         textColor: Colors.white,
                       ),
                     ),
                    ],
                  ),
                )
            );
          }
        }
      ),
    );
  }
}