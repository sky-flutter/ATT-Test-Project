import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/imports.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/utils/preference.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/utils/utils.dart';
import 'package:test_project/src/widget/button/button_solid.dart';
import 'package:test_project/src/widget/input/text_field_icon.dart';
import 'package:test_project/src/widget/loading/loader.dart';

import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'model/login_data.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({Key? key}) : super(key: key);

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(),
      child: BlocListener<LoginBloc, BaseState>(
        listener: (BuildContext context, state) async {
          if (state is ErrorState) {
            showSnackBar(state.errorMessage);
          }

          if (state is DataState) {
            await MyPreference.add(
                Constants.LOGIN_DATA, json.encode((state.data as LoginData).toJson()), SharePrefType.String);
            await MyPreference.add(Constants.IS_LOGIN, true, SharePrefType.Bool);
            MyNavigator.pushAndRemove(Routes.strHomeRoute, "/");
          }
        },
        child: Column(
          children: [
            Expanded(
              child: LoginForm(),
            ),
            LoginFooter(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  var isPasswordTextVisible = true;

  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<LoginBloc>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Image.asset(
              Strings.splashLogo,
              height: rWidth(45),
              width: rWidth(45),
            ),
            margin: const EdgeInsets.only(top: 21, bottom: 36),
            alignment: Alignment.topCenter,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 8),
            child: MyText(
              Strings.login,
              fontWeight: FontWeight.bold,
              color: MyColors.color_2FA1DB,
              fontSize: 30,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 36),
            child: MyText(
              Strings.loginDesc,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.center,
              color: MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 39.0, bottom: 9),
            child: MyText(
              Strings.email,
              fontWeight: FontWeight.normal,
              color: isEmailFocused ? MyColors.color_F18719 : MyColors.color_6E7578,
              fontSize: 14,
            ),
          ),
          MyTextFieldPrefixSuffix(
              hint: Strings.email,
              controller: ctrlEmail,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              outlineColor: MyColors.color_E2E9EF,
              keyboardType: TextInputType.emailAddress,
              onFocusListener: (hasFocus) {
                isEmailFocused = hasFocus;
                setState(() {});
              },
              focusedColor: MyColors.color_F18719,
              prefix: Container(
                child: Icon(
                  Icons.mail_outline_rounded,
                  color: isEmailFocused ? MyColors.color_F18719 : MyColors.color_3F4446,
                ),
                margin: EdgeInsets.only(left: 19),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 39.0, bottom: 9, top: 15),
            child: MyText(
              Strings.password,
              fontWeight: FontWeight.normal,
              color: isPasswordFocused ? MyColors.color_F18719 : MyColors.color_3F4446,
              fontSize: 14,
            ),
          ),
          MyTextFieldPrefixSuffix(
            hint: Strings.password,
            controller: ctrlPassword,
            isObscureText: isPasswordTextVisible,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            outlineColor: MyColors.color_E2E9EF,
            keyboardType: TextInputType.text,
            suffix: Container(
              margin: const EdgeInsets.only(right: 19),
              child: GestureDetector(
                onTap: () {
                  isPasswordTextVisible = !isPasswordTextVisible;
                  setState(() {});
                },
                child: Icon(isPasswordTextVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
            focusedColor: MyColors.color_F18719,
            onFocusListener: (hasFocus) {
              isPasswordFocused = hasFocus;
              setState(() {});
            },
            prefix: Container(
              child: Icon(
                Icons.lock_outline_rounded,
                color: isPasswordFocused ? MyColors.color_F18719 : MyColors.color_3F4446,
              ),
              margin: EdgeInsets.only(left: 19),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 24, left: 20, right: 20),
            width: double.infinity,
            child: BlocBuilder<LoginBloc, BaseState>(
              builder: (BuildContext context, state) {
                if (state is LoadingState) {
                  return Loader();
                }
                return MyButton(
                  Strings.login,
                  () {
                    checkValidation(bloc);
                  },
                  outlineColor: MyColors.color_F18719,
                  textColor: MyColors.color_FFFFFF,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  buttonBgColor: MyColors.color_F18719,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void checkValidation(LoginBloc bloc) {
    if (!bloc.checkEmail(ctrlEmail.text.toString())) {
      showSnackBar(Strings.errorEnterEmail);
      return;
    }
    if (!bloc.checkPassword(ctrlPassword.text.toString())) {
      showSnackBar(Strings.errorEnterPassword);
      return;
    }

    bloc.add(LoginEvent(ctrlEmail.text.toString(), ctrlPassword.text.toString()));
  }
}

class LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.asset(
            Strings.loginBottomImage,
          ),
          GestureDetector(
            onTap: () {
              MyNavigator.pushNamed(Routes.strRegisterRoute);
            },
            child: AbsorbPointer(
              child: Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: Strings.dontHaveAccount,
                      style: Style.normal.copyWith(fontSize: 14, color: MyColors.color_6E7578)),
                  TextSpan(
                      text: Strings.signUp,
                      style: Style.normal
                          .copyWith(fontSize: 14, color: MyColors.color_2FA2DB, fontWeight: FontWeight.bold)),
                ])),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
