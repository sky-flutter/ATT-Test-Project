import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/src/views/note/home/bloc/home_bloc.dart';

import 'imports.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        )
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(fontFamily: "Roboto"),
        builder: (context, child) {
          return Scaffold(
            key: scaffoldKey,
            body: SafeArea(
              child: child!,
            ),
          );
        },
        initialRoute: Routes.strSplashScreenRoute,
        routes: Routes.appRoutes(),
      ),
    );
  }
}
