import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/imports.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/views/splash/bloc/splash_state.dart';
import 'package:test_project/src/widget/loading/loader.dart';

import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';

class SplashMain extends StatefulWidget {
  @override
  _SplashMainState createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> {
  late SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc = SplashBloc();
    _splashBloc.add(SplashEvent());
  }

  moveToNext(String routeName) {
    Timer(Duration(seconds: 3), () {
      MyNavigator.pushReplacedNamed(routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (context) => _splashBloc,
      child: BlocListener<SplashBloc, BaseState>(
        listener: (BuildContext context, state) {
          if (state is AuthorizedState) {
            moveToNext(Routes.strHomeRoute);
          }
          if (state is UnAuthorizedState) {
            moveToNext(Routes.strLoginRoute);
          }
        },
        child: Scaffold(
          backgroundColor: MyColors.color_FFFFFF,
          body: Container(
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    Strings.splashLogo,
                  ),
                ),
                BlocBuilder<SplashBloc, BaseState>(builder: (context, state) {
                  if (state is LoadingState) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Loader(),
                        margin: EdgeInsets.symmetric(vertical: 24),
                      ),
                    );
                  }
                  return Container();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
