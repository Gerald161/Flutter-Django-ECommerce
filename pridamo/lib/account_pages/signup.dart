import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pridamo/account_pages/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class signup extends StatefulWidget {
  var worker_id = '';

  signup({Key key, @required this.worker_id})
      : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final _formkey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String username = '';
  var full_name = '';
  String error = '';
  String error2 = '';

  var loading = false;

  Future<Map> createAccount() async {
      var response = await http.post(
          'https://pridamo.com/account/api?region=${region_selected}',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "email": email.toLowerCase(),
            'password': password,
            'username': username.toLowerCase(),
            'location': location,
            'district': district_selected,
            'about': description,
            'number': phone_number,
            'full_name': full_name,
          })
      );

      Map data = jsonDecode(response.body);

      return data;
  }

  Future<http.Response> GetToken() async {
    var tokenresponse = await http.post(
        'https://pridamo.com/account/api/token',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'password': password,
          'username': email.toLowerCase()
        })
    );
    Map token = jsonDecode(tokenresponse.body);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token',token['token']);

  }

  Future<Null> loginUser() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username',"user");
  }

  Future<List> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = await prefs.getString('token');
    var response = await http.get('https://pridamo.com/account/app_username?token=${token}');
    final SharedPreferences prefss = await SharedPreferences.getInstance();
    prefss.setString('userName',jsonDecode(response.body)["name"]);
  }

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

  var region_selected;

  var location;

  var district_selected;

  var districts_in_question;

  var phone_number;

  var description;

  var do_not_show_pass = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    region_selected = regions[0];

    district_selected = region_districts[0][0];

    districts_in_question = region_districts[0];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacementNamed(context, '/signin');
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Text(
                        'Pridamo Signup',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Email'),
                        validator: (val) => !val.contains('@') ? 'Please enter a valid email' : null,
                        onChanged: (val){
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Username/Business ID'),
                        validator: (val) => val.isEmpty ? 'Enter your Username/Business ID' : null,
                        onChanged: (val){
                          setState(() {
                            username = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                      child: Text(
                          "Username/Business ID can only be letters (a-z), numbers (0-9) and dashes (-)"
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Full name/Business name'),
                        validator: (val) => val.isEmpty ? 'Enter your Full name/Business name' : null,
                        onChanged: (val){
                          setState(() {
                            full_name = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange, width: 2.0)
                          ),
                        ).copyWith(hintText: 'Password'),
                        validator: (val) => val.isEmpty ? 'Enter your password' : null,
                        obscureText: do_not_show_pass,
                        onChanged: (val){
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        do_not_show_pass == true ? 'Show Password': 'Hide Password',
                      ),
                      textColor: Colors.blue,
                      onPressed: (){
                        setState(() {
                          if(do_not_show_pass == false){
                            do_not_show_pass = true;
                          }else{
                            do_not_show_pass = false;
                          }
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: region_selected,
                        onChanged: (String text) {
                          setState(() {
                            region_selected = text;

                            var index_of_new_district = regions.indexOf(region_selected);

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
                        items: regions.map<DropdownMenuItem<String>>((String text) {
                          return DropdownMenuItem<String>(
                            value: text,
                            child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: district_selected,
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
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Location(Town)',
                        ),
                        validator: (input) => input.trim().length < 2
                            ? 'Please Enter At least 2 Characters'
                            : null,
                        onChanged: (val){
                          setState(() {
                            location = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
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
                            phone_number = val;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Short description about your business(Optional)',
                        ),
                        onChanged: (val){
                          setState(() {
                            description = val;
                          });
                        },
                      ),
                    ),
                    loading == false ? Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: RaisedButton(
                        color: Colors.blue[400],
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        onPressed: () async {
                          if(_formkey.currentState.validate()){
                            setState(() {
                              loading = true;
                            });

                            Fluttertoast.showToast(
                              msg: "Please wait information,being processed",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                            );
                            dynamic result = await createAccount();
                            if(result['email'] == null && result['username'] == null){
                              await loginUser();
                              await GetToken();
                              await getUserName();
                              await Navigator.pushReplacementNamed(context, '/userpage');
                            }else{
                              setState(() {
                                loading = false;
                              });

                              if(result['email'] != null){
                                setState(() {
                                  error = "Email is already in use";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            "Error",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            error,
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Ok",
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
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
                                  error = '';
                                });
                              }
                              if(result['username'] != null){
                                setState(() {
                                  error2 = "Username/Business ID is already in use";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            "Error",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            error2,
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Ok",
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
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
                                  error2 = '';
                                });
                              }
                            }
                          }
                        },
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,8.0),
                      child: CircularProgressIndicator(),
                    ),
                    loading == true ? Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: RaisedButton(
                        color: Colors.blue[400],
                        child: Text(
                          "Retry",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        onPressed: () async {
                          if(_formkey.currentState.validate()){
                            setState(() {
                              loading = false;
                            });

                            Fluttertoast.showToast(
                              msg: "Please wait information,being processed",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                            );
                            dynamic result = await createAccount();
                            if(result['email'] == null && result['username'] == null){
                              await loginUser();
                              await GetToken();
                              await getUserName();
                              await Navigator.pushReplacementNamed(context, '/userpage');
                            }else{
                              setState(() {
                                loading = false;
                              });

                              if(result['email'] != null){
                                setState(() {
                                  error = "Email is already in use";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            "Error",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            error,
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Ok",
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
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
                                  error = '';
                                });
                              }
                              if(result['username'] != null){
                                setState(() {
                                  error2 = "Username is already in use";
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text(
                                            "Error",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            error2,
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "Ok",
                                              ),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
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
                                  error2 = '';
                                });
                              }
                            }
                          }
                        },
                      ),
                    ) : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'By signing up you agree to our ',
                                style: TextStyle(
                                  color: Colors.grey[500]
                                ),
                              ),
                              TextSpan(
                                text: "Terms and Conditions",
                                style: TextStyle(
                                  color: Colors.blue
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => terms(),
                                    ),
                                  );
                                }
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
