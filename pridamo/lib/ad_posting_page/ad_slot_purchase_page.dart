import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ad_slot_purchase_page extends StatefulWidget {
  @override
  _ad_slot_purchase_pageState createState() => _ad_slot_purchase_pageState();
}

class _ad_slot_purchase_pageState extends State<ad_slot_purchase_page> {
  var payment_group_value = '1pic_weekly';

  var price_selected = '';

  var type_of_ad_slot = 'pic';

  var ad_duration = 'week';

  var loading = false;

  var amount_of_ads = '1';

  make_payment()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/payments/app_pay_for_ad_slot?payment_amount=$price_selected&ad_duration=$ad_duration&amount_of_ads=$amount_of_ads&type_of_ad_slot=$type_of_ad_slot&token=$token',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var data = jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    if(data['paid'] == 'yes'){
      Fluttertoast.showToast(
        msg: "Product slot successfully purchased, please go ahead and post your ads",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );

      Navigator.pop(context);
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

  List<Widget> all_payment_requests = [];

  get_payment_future()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String token = prefs.getString('token');

    var response = await http.get(
        'https://pridamo.com/profile/app_get_payment_amounts',
        headers: {
          HttpHeaders.authorizationHeader: "Token $token",
        }
    );

    var payment_response = jsonDecode(response.body);

    if(payment_response.isNotEmpty){
      payment_response.forEach((payment){
        setState(() {
          stored_payment_response = payment_response;

          all_payment_requests.add(
            payment_widget(payment['title'], payment['offers'])
          );
        });
      });

      setState(() {
        price_selected = payment_response[0]['offers'][0]['price'];
      });
    }
  }

  var stored_payment_response;

  var initial_future;

  change_stuff(value, offers, index){
   setState(() {
     payment_group_value = value;

     price_selected = offers[index]['price'];

     type_of_ad_slot = offers[index]['type_of_ad_slot'];

     ad_duration = offers[index]['ad_duration'];

     amount_of_ads = offers[index]['amount_of_ads'];

     all_payment_requests.clear();

     stored_payment_response.forEach((payment){
       setState(() {
         all_payment_requests.add(
             payment_widget(payment['title'], payment['offers'])
         );
       });
     });

   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial_future = get_payment_future();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase a product slot'),
      ),
      body: FutureBuilder(
        future: initial_future,
        builder: (context, snapshot){
          if(all_payment_requests.isEmpty){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Please note, payment will be requested from Adamo Services/Adamo'
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: all_payment_requests
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Amount to be paid",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "${price_selected} Cedis",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  loading == false ? FlatButton(
                    child: Text(
                        'Make Purchase'
                    ),
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: ()async{
                      setState(() {
                        loading = true;
                      });

                      Fluttertoast.showToast(
                        msg: "Payment being processed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                      );

                      make_payment();
                    },
                  ) : CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget payment_widget(title, offers){
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState){
       return Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(
               title,
               style: TextStyle(
                   fontWeight: FontWeight.bold
               ),
             ),
           ),
           ListView.builder(
             itemCount: offers.length,
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             itemBuilder: (context, index){
               return RadioListTile(
                 value: offers[index]['radio_list_value'],
                 groupValue: payment_group_value,
                 title: Text(
                     offers[index]['amount_of_slots_in_text']
                 ),
                 activeColor: Colors.green[600],
                 onChanged: (value){
                   change_stuff(value, offers, index);
                 },
               );
             },
           )
         ],
       );
      }
    );
  }
}
