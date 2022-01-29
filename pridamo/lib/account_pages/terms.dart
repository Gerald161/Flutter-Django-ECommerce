import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class terms extends StatefulWidget {
  @override
  _termsState createState() => _termsState();
}

class _termsState extends State<terms> {
  var launch_url = "https://www.pridamo.com/terms_and_conditions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
            width: MediaQuery.of(context).size.width * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please visit our website ',
                        style: TextStyle(
                          color: Colors.grey[500]
                        ),
                      ),
                      TextSpan(
                        text: "https://www.pridamo.com/terms_and_conditions",
                        style: TextStyle(
                          color: Colors.blue
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () async{
                          if(await canLaunch(launch_url)){
                            await launch(
                              launch_url,
                              forceSafariVC: false,
                              forceWebView: false,
                              headers: <String, String>{'header_key': 'header_value'},
                            );
                          }else{
                            throw "Could not launch $launch_url";
                          }
                        }
                      ),
                      TextSpan(
                        text: ' to read our terms and conditions, thank you.',
                        style: TextStyle(
                          color: Colors.grey[500]
                        ),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
