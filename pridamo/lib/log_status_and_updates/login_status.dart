import 'package:flutter/material.dart';
import 'package:pridamo/account_pages/signin.dart';
import 'package:pridamo/main_page/all_user_pages.dart';
import 'package:pridamo/theme_changer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pridamo/loading_spinkits/loading.dart';

class login_status extends StatefulWidget {
  @override
  _login_statusState createState() => _login_statusState();
}

class _login_statusState extends State<login_status> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

   autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('username');

    final SharedPreferences prefs2 = await SharedPreferences.getInstance();
    final String theme = prefs2.getString('theme');

    if(theme != null && theme != ''){
      if(theme == 'dark'){
        setState(() {
          ThemeBuilder.of(context).changeTheme();
        });
      }
    }

    if (userId != null && userId != '') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => all_user_pages()
        )
      );
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => signin()
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Loading();
  }

}
