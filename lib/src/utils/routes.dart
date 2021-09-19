import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:test_project/src/views/login/login_main.dart';
import 'package:test_project/src/views/note/add/add_note.dart';
import 'package:test_project/src/views/note/home/home_main.dart';
import 'package:test_project/src/views/register/register_main.dart';
import 'package:test_project/src/views/splash/splash_main.dart';

class Routes {
  static const String strSplashScreenRoute = "splash_screen";
  static const String strLoginRoute = "login";
  static const String strRegisterRoute = "register";
  static const String strHomeRoute = "home";
  static const String strAddNoteRoute = "add_note";

  static appRoutes() {
    Map<String, WidgetBuilder> routes = HashMap();
    routes[Routes.strSplashScreenRoute] = (context) => SplashMain();
    routes[Routes.strLoginRoute] = (context) => LoginMain();
    routes[Routes.strRegisterRoute] = (context) => RegisterMain();
    routes[Routes.strHomeRoute] = (context) => HomeMain();
    routes[Routes.strAddNoteRoute] = (context) => AddNote();
    return routes;
  }
}
