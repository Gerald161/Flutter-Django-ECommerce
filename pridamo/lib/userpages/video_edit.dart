import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pridamo/main_page/all_user_pages.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';
import 'package:pridamo/chewy_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:intl/intl.dart';

var edit_second_selected = '';

class video_ad_edit extends StatefulWidget {
  var particular_ad;

  var deletion_index;

  video_ad_edit({Key key, @required this.particular_ad, @required this.deletion_index})
      : super(key: key);

  @override
  _video_ad_editState createState() => _video_ad_editState();
}

class _video_ad_editState extends State<video_ad_edit> {
  final _formKey = GlobalKey<FormState>();

  Map data = {};

  var index_of_category = 0;

  var initial_index_of_category;

  var age_target = [
    ''
  ];

  var region_target = [
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

  var categories;

  var sub_categories = [];

  var districts_in_question = [''];

  bool loading = false;

  bool picture_taken = false;

  bool video_taken = false;

  File _image;

  File _video;

  String Tap_to_select = 'Change your video';

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

            using_seconds_thumbnail = false;
          });
        }else{
          setState(() {
            Tap_to_select = 'Tap to select your video';

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
          width: 250,
          height: 250,
        );
      }
    }else{
      return Image.network(
        "https://media.pridamo.com/pridamo-static/${data['image']}",
        width: 250,
        height: 200,
        fit: BoxFit.cover,
      );
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
        using_seconds_thumbnail = false;

        picture_taken = false;

        _image = null;
      });
    }

  }

  testfunction(){
    setState(() {
      using_seconds_thumbnail = true;
    });
  }

  Widget video_path(){
    if(video_taken){
        return SizedBox.shrink();
    }else{
      return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        child: chewie_list_item(
          video_url: 'https://media.pridamo.com/pridamo-static/${data['video_url']}',
          video_type: 'network',
          testfunction: testfunction,
        ),
      );
    }
  }

  Widget new_video_path(){
    if(video_taken){
      if(_video == null){
        return SizedBox.shrink();
      }else{
        return Listener(
          onPointerDown: (e){
            setState(() {
              using_seconds_thumbnail = true;
            });
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.50,
            child: chewie_list_item(
              video_url: _video,
              video_type: 'file',
            ),
          ),
        );
      }
    }else{
      return SizedBox.shrink();
    }
  }

  Future delete_particular_image(index, number_of_images) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/delete_particular_picture/${widget.particular_ad}?index=$index&number_of_images=$number_of_images',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var what_it_said = jsonDecode(response.body);

    if(what_it_said['status'] == 'deleted'){
      Fluttertoast.showToast(
          msg: "Image has successfully been removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );

      Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (context) => video_ad_edit(particular_ad: widget.particular_ad, deletion_index: widget.deletion_index),
        ),
      );
    }
  }

  bool additional_image_taken = false;

  File additional_image;

  delete_advert(product_slug, counting_index) async {
    setState(() {
      Navigator.pop(context);
    });

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
        msg: "Successfully removed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      if(data['next_ad'] != null){
        Navigator.pop(context, '${response.body}');
      }else{
        Navigator.pop(context, '');
      }
    }
  }

  Future<Map> save_change(product_slug, product_name, description, price, phone_number, location, region, category, subcategory) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var request = http.MultipartRequest('POST', Uri.parse('https://pridamo.com/app_video_edit/${product_slug.toString().toLowerCase()}'));

    request.fields['product_name'] = product_name.trim();
    request.fields['phone_number'] = phone_number.trim();
    request.fields['price'] = price.trim();
    request.fields['description'] = description.trim();
    request.fields['category'] = category.trim();
    request.fields['subcategory'] = subcategory.trim();
    request.fields['region'] = region.trim();
    request.fields['district'] = data['district'].trim();
    request.fields['your_location'] = location.trim();

    request.fields['generate_thumbnail'] = using_seconds_thumbnail == true ? 'yes' : 'no';
    request.fields['second_chosen'] = edit_second_selected;


    request.headers['authorization'] = "Token $token";

    if(picture_taken){
      request.files.add(await http.MultipartFile.fromPath('image', _image.path));
    }

    if(video_taken){
      request.files.add(await http.MultipartFile.fromPath('video', _video.path));
    }

    if(additional_image_taken){
      imageArray.asMap().forEach((index, image) async {
        request.files.add(await http.MultipartFile.fromPath('additional_input$index', image));
      });
    }

    var res = await http.Response.fromStream(await request.send());

    if(jsonDecode(res.body)['status'] == 'complete'){
      Fluttertoast.showToast(
          msg: "Successfully updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
      );

      Navigator.pop(context, 'saved');
    }

  }

  List add = [];

  var expiration_time = '';

  get_all_categories_plus(token)async{
    var response = await http.get(
        'https://pridamo.com/profile/get_all_categories_plus',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var datum = jsonDecode(response.body);

    setState(() {
      categories = new List<String>.from(datum['categories']);

      sub_categories = datum['sub_categories'];

      data['category'] = categories[0];
    });
  }

  Future get_video_ad_initial_values() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    await get_all_categories_plus(token);

    var response = await http.get(
        'https://pridamo.com/app_get_ad/${widget.particular_ad}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var additional_pics_response = await http.get(
        'https://pridamo.com/app_get_additional_images/${widget.particular_ad}',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var all_additional_pics = await jsonDecode(utf8.decode(additional_pics_response.bodyBytes));

    if(all_additional_pics.isNotEmpty){
      all_additional_pics.forEach((additional_pic){
        add.add(additional_pic['fields']['additional_image']);
      });
    }

    var that_ad = jsonDecode(utf8.decode(response.bodyBytes));

    data['image'] = that_ad[0]['fields']['thumbnail'];

    data['category'] = that_ad[0]['fields']['category'];

    data['subcategory'] = that_ad[0]['fields']['subcategory'];

    data['product_name'] = that_ad[0]['fields']['product_name'];

    data['price'] = that_ad[0]['fields']['price'].toString();

    data['location'] = that_ad[0]['fields']['your_location'];

    data['description'] = that_ad[0]['fields']['description'];

    data['number'] = that_ad[0]['fields']['phone_number'];

    data['region'] = that_ad[0]['fields']['region'];

    data['video_url'] = that_ad[0]['fields']['video'];

    data['district'] = that_ad[0]['fields']['district'];

    data['product_slug'] = that_ad[0]['fields']['product_slug'];

    var day_month_and_year = DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(that_ad[0]['fields']['expiration']));

//    var twenty_four_hour_time = DateFormat('h:mm a').format(DateTime.parse(that_ad[0]['fields']['expiration']));

//    expiration_time = "Expires on ${day_month_and_year} at ${twenty_four_hour_time}";

    expiration_time = "Expires on ${day_month_and_year}";

    if(region_target.indexOf(data['region']) == -1){
      districts_in_question = region_districts[0];
    }else{
      districts_in_question = region_districts[region_target.indexOf(data['region'])];
    }
  
    if(categories.indexOf(data['category']) == -1){
      initial_index_of_category = 0;
    }else{
      initial_index_of_category = categories.indexOf(data['category']);
    }

    setState(() {
      age_target = new List<String>.from(sub_categories[initial_index_of_category]);
    });
  }

  Future _video_edit_future_instance;

  var imageArray = [];

  ScrollController _scrollController = ScrollController();

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
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5 - add.length,
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
          additional_image_taken = true;
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

  var users_should_pay = false;

  var using_seconds_thumbnail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _video_edit_future_instance = get_video_ad_initial_values();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit',
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _video_edit_future_instance,
        builder: (context, snapshot){
          if(data['image'] == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _video == null ? Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: video_path(),
                          ),
                        ):SizedBox.shrink(),
                        _video != null ? Container(
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new_video_path(),
                          ),
                        ): SizedBox.shrink(),
                      ],
                    ),
                    FlatButton(
                      onPressed: (){
                        _pickVideo();
                        setState(() {
                          video_taken = false;
                        });
                      },
                      child: Text(
                        Tap_to_select,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    using_seconds_thumbnail == false ? Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: image_path()
                        ),
                      ],
                    ) : SizedBox.shrink(),
                    using_seconds_thumbnail == true ? Text(
                      'Please note that the timestamp of video will be used as the thumbnail',
                      textAlign: TextAlign.center,
                    ) : SizedBox.shrink(),
                    FlatButton(
                      onPressed: (){
                        getImage();
                      },
                      child: Text(
                        'Change your thumbnail',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,20.0),
                          child: Builder(
                            builder: (context){
                              if(add.length >= 5){
                                return SizedBox.shrink();
                              }else{
                                return RaisedButton(
                                  child: Text("Add Extra images"),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  onPressed: loadAssets,
                                );
                              }
                            },
                          ),
                        ),
                        buildGridView()
                      ],
                    ),
                    Builder(
                        builder: (context){
                          if(add.isEmpty){
                            return SizedBox.shrink();
                          }else{
                            return ExpansionTile(
                              title: Text(
                                'Added Images',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent
                                ),
                              ),
                              children: <Widget>[
                                GridView.count(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  crossAxisCount: 3,
                                  children: List.generate(add.length, (index) {
                                    return InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Image.network(
                                          'https://media.pridamo.com/pridamo-static/${add[index]}',
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          height: MediaQuery.of(context).size.width * 0.1,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                                                          "Cancel",
                                                        ),
                                                        textColor: Colors.blue,
                                                        onPressed: ()async{
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child: Text(
                                                          "Delete",
                                                        ),
                                                        textColor: Colors.red,
                                                        onPressed: ()async{
                                                          setState(() {
                                                            Navigator.of(context).pop();
                                                            loading = true;
                                                            delete_particular_image(index, add.length);
                                                          });
                                                        },
                                                      ),
                                                    ],
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
                                    );
                                  }),
                                ),
                              ],
                            );
                          }
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: data['product_name'],
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
                            data['product_name'] = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: data['description'],
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'About Product(Description)',
                        ),
                        validator: (input) => input.trim().length < 1
                            ? 'Please Enter At least 1 Character'
                            : null,
                        onChanged: (val){
                          setState(() {
                            data['description'] = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: data['price'],
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Price of Product/Services',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (val) => val.length < 1 ? 'Number must be 1 digits' : null,
                        onChanged: (val){
                          setState(() {
                            data['price'] = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: data['number'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '01234567890',
                          labelText: 'Your Phone Number',
                        ),
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (val) => val.length < 10 ? 'Number must be 10 digits' : null,
                        onChanged: (val){
                          setState(() {
                            data['number'] = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        initialValue: data['location'],
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Location(Town)',
                        ),
                        validator: (input) => input.trim().length < 2
                            ? 'Please Enter At least 2 Characters'
                            : null,
                        onChanged: (val){
                          setState(() {
                            data['location'] = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: categories.indexOf(data['category']) == -1 || data['category'] == '' ? categories[0] : data['category'],
                        onChanged: (String text) {
                          setState(() {
                            data['category'] = text;

                            index_of_category = categories.indexOf(data['category']);

                            age_target = new List<String>.from(sub_categories[initial_index_of_category]);

                            age_target = new List<String>.from(sub_categories[index_of_category]);

                            data['subcategory'] = age_target[0];
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
                        value: age_target.indexOf(data['subcategory']) == -1 || data['subcategory'] == '' ? age_target[0] : data['subcategory'],
                        onChanged: (String text) {
                          setState(() {
                            data['subcategory'] = text;
                          });
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
                        value: region_target.indexOf(data['region']) == -1 || data['region'] == '' ? region_target[0] : data['region'],
                        onChanged: (String text) {
                          setState(() {
                            data['region'] = text;

                            var index_of_new_district = region_target.indexOf(data['region']);

                            data['district'] = region_districts[index_of_new_district][0];

                            districts_in_question = [];

                            districts_in_question = region_districts[index_of_new_district];
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return region_target.map<Widget>((String text) {
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
                        items: region_target.map<DropdownMenuItem<String>>((String text) {
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
                        value: districts_in_question.indexOf(data['district']) == -1 || data['district'] == '' ? districts_in_question[0] : data['district'],
                        onChanged: (String text) {
                          setState(() {
                            data['district'] = text;
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
                    FlatButton(
                      onPressed: () async{
                        if(_formKey.currentState.validate()){
                          setState(() {
                            loading = true;
                          });
                          save_change(data['product_slug'], data['product_name'], data['description'], data['price'], data['number'], data['location'], data['region'], data['category'], data['subcategory']);
                        }
                      },
                      textColor: Colors.blue,
                      child: Text(
                        'Save Changes',
                      ),
                    ),
                    FlatButton(
                      onPressed: () async{
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                scrollable: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                      bottomRight: Radius.circular(30.0),
                                    )
                                ),
                                content: Text(
                                  "Do you want to permanently delete this ad?",
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      "No",
                                    ),
                                    onPressed: ()async{
                                      Navigator.of(context).pop();
                                    },
                                    textColor: Colors.blue,
                                  ),
                                  FlatButton(
                                    child: Text(
                                      "Ok",
                                    ),
                                    onPressed: ()async{
                                      setState(() {
                                        loading = true;
                                      });
                                      await delete_advert(data['product_slug'], widget.deletion_index);
                                    },
                                    textColor: Colors.red,
                                  ),
                                ],
                              );
                            }
                        );
                      },
                      textColor: Colors.blue,
                      child: Text(
                        'Delete Ad',
                      ),
                    ),
                  ],
                ),
              )
            );
          }
        }
      )
    );
  }
}
