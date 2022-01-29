import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/loading_spinkits/loading.dart';
import 'package:http/http.dart' as http;

class set_ad_region_page extends StatefulWidget {
  @override
  _set_ad_region_pageState createState() => _set_ad_region_pageState();
}

class _set_ad_region_pageState extends State<set_ad_region_page> {
  final _formkey = GlobalKey<FormState>();

  bool loading = false;

  String changed_status = '';

  Future<Map> set_new_ad_location() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    var response = await http.post(
        'https://pridamo.com/account/set_new_ad_region',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
        body: jsonEncode({
          'region': selected_region,
          'district': district_selected,
          'location': location.trim(),
          'phone_number': phone_number,
          'momo_number': momo_number,
          'about': description.trim(),
        })
    );

    String data = jsonDecode(response.body);

    if(data == 'changed'){
      Fluttertoast.showToast(
        msg: "Changes saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      setState(() {
        loading = false;
        Navigator.pop(context);
      });
    }
  }

  var region_target = [
    "Ashanti", 'Greater Accra', "Northern", "Western", 'Volta', 'Oti', 'Central', 'Eastern', 'Upper East',
    'Upper West', 'Savannah', 'North East', 'Bono', 'Bono East', 'Ahafo', 'Western North'
  ];

  var selected_region;

  var ad_region_future;

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

  var district_selected = '';

  var districts_in_question = [
    'Kumasi Metropolitan', 'Obuasi Municipal', 'Mampong Municipal', 'Asante Akim Central Municipal',
    'Asokore Mampong Municipal', 'Bekwai Municipal', 'Ejisu-Juaben Municipal', 'Offinso Municipal', 'Adansi North',
    'Adansi South', 'Afigya-Kwabre', 'Ahafo Ano North', 'Ahafo Ano South', 'Amansie Central', 'Amansie West',
    'Asante Akim North', 'Asante Akim South', 'Atwima Kwanwoma', 'Atwima Mponua', 'Atwima Nwabiagya', 'Bosome Freho',
    'Bosomtwe', 'Ejura-Sekyedumase', 'Kwabre', 'Offinso North', 'Sekyere Afram Plains', 'Sekyere Central',
    'Sekyere East', 'Sekyere Kumawu', 'Sekyere South'
  ];

  TextEditingController _controller1;

  TextEditingController _controller2;

  TextEditingController _controller3;

  TextEditingController _controller4;

  String location = '';

  var momo_number = '';

  String phone_number = '';

  String description = '';

  Future<List> get_selected_ad_region() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
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

      phone_number = data['number'];

      _controller2 = new TextEditingController(text: data['location']);

      _controller3 = new TextEditingController(text: data['about']);

      _controller4 = new TextEditingController(text: data['momo']);

      description = data['about'];

      location = data['location'];

      momo_number = data['momo'];

      districts_in_question = region_districts[region_target.indexOf(data['region'])];

      district_selected = data['district'];

      gotten_details = true;
    });
  }

  var gotten_details = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ad_region_future = get_selected_ad_region();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text(
            'Update Preference'
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ad_region_future,
        builder: (context, snapshot) {
          if(gotten_details){
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: region_target.indexOf(selected_region) == -1 || selected_region == '' ? region_target[0] : selected_region,
                          onChanged: (String text) {
                            setState(() {
                              selected_region = text;

                              var index_of_new_district = region_target.indexOf(selected_region);

                              district_selected = region_districts[index_of_new_district][0];

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
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                                    child: Text(
                                      "Region: ",
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '01234567890',
                            labelText: 'Your phone number',
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
                          controller: _controller4,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '01234567890',
                            labelText: 'Your momo number',
                          ),
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (val) => val.length < 10 ? 'Number must be 10 digits' : null,
                          onChanged: (val){
                            setState(() {
                              momo_number = val;
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
                          style: TextStyle(fontSize: 18.0),
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
                        child: TextFormField(
                          controller: _controller3,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            labelText: 'Short description about your business',
                          ),
                          validator: (input) => input.trim().length < 20
                              ? 'Please enter at least 20 characters'
                              : null,
                          onChanged: (val){
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                      ),
                      FlatButton(
                        onPressed: (){
                          setState(() {
                            loading = true;
                            set_new_ad_location();
                          });
                        },
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Text(
                        changed_status,
                        style: TextStyle(
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
       ),
    );
  }
}
