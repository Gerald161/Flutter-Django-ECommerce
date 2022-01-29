import 'package:flutter/material.dart';
import 'package:pridamo/poc.dart';
import 'package:pridamo/theme_changer.dart';
import 'package:provider/provider.dart';
import 'bloc.dart';
import 'package:pridamo/account_pages/signin.dart';
import 'package:pridamo/account_pages/signup.dart';
import 'package:pridamo/main_page/all_user_pages.dart';

void main() => runApp(
    ThemeBuilder(
        defaultBrightness: Brightness.light,
        builder: (context, _brightness) {
          DeepLinkBloc _bloc = DeepLinkBloc();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: _brightness,
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    foregroundColor: Colors.white
                )
            ),
            home: Scaffold(
              body: Provider<DeepLinkBloc>(
                  create: (context) => _bloc,
                  dispose: (context, bloc) => bloc.dispose(),
                  child: PocWidget()
              )
            ),
            routes: {
              '/userpage': (context) => all_user_pages(),
              '/signin': (context) => signin(),
              '/signup': (context) => signup(worker_id: '1111'),
            },
          );
        }
    )
);
