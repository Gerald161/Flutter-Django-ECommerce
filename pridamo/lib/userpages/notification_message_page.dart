import 'package:flutter/material.dart';

class notification_message_page extends StatefulWidget {
  var message;

  var message_type;

  notification_message_page({Key key, @required this.message, @required this.message_type})
      : super(key: key);

  @override
  _notification_message_pageState createState() => _notification_message_pageState();
}

class _notification_message_pageState extends State<notification_message_page> {
  var theme_type = 'light';

  @override
  Widget build(BuildContext context) {
    if(Theme.of(context).accentColor == Color(0xff2196f3)){
      theme_type = 'light';
    }else{
      theme_type = 'dark';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.message_type),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme_type == 'light' ? Colors.grey : Colors.grey[700],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0),
            topLeft: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0)
          )
        ),
        child: Text(
          widget.message,
          textAlign: TextAlign.center,
        ),
      )
    );
  }
}
