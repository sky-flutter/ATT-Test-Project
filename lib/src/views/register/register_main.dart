import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/imports.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/theme/dimens.dart';
import 'package:test_project/src/utils/preference.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/utils/utils.dart';
import 'package:test_project/src/views/login/bloc/login_bloc.dart';
import 'package:test_project/src/views/login/bloc/login_event.dart';
import 'package:test_project/src/views/login/model/login_data.dart';
import 'package:test_project/src/widget/button/button_solid.dart';
import 'package:test_project/src/widget/input/text_field_icon.dart';
import 'package:test_project/src/widget/loading/loader.dart';

class RegisterMain extends StatefulWidget {
  const RegisterMain({Key? key}) : super(key: key);

  @override
  _RegisterMainState createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
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
            // Show Success
            MyNavigator.pushAndRemove(Routes.strHomeRoute, "/");
          }
        },
        child: RegistrationForm(),
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool isNameFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  var isPasswordTextVisible = true;

  TextEditingController ctrlName = TextEditingController();
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
              height: rWidth(Dimens.dimen_45),
              width: rWidth(Dimens.dimen_45),
            ),
            margin: const EdgeInsets.only(top: Dimens.dimen_21, bottom: Dimens.dimen_36),
            alignment: Alignment.topCenter,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: Dimens.dimen_08),
            child: MyText(
              Strings.register,
              fontWeight: FontWeight.bold,
              color: MyColors.color_2FA1DB,
              fontSize: Dimens.dimen_30,
            ),
          ),
          const SizedBox(
            height: Dimens.dimen_36,
          ),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.dimen_39, bottom: Dimens.dimen_09),
            child: MyText(
              Strings.name,
              fontWeight: FontWeight.normal,
              color: isNameFocused ? MyColors.color_F18719 : MyColors.color_6E7578,
              fontSize: Dimens.dimen_14,
            ),
          ),
          MyTextFieldPrefixSuffix(
              hint: Strings.name,
              controller: ctrlName,
              margin: const EdgeInsets.symmetric(horizontal: Dimens.dimen_20),
              outlineColor: MyColors.color_E2E9EF,
              keyboardType: TextInputType.name,
              onFocusListener: (hasFocus) {
                isNameFocused = hasFocus;
                setState(() {});
              },
              focusedColor: MyColors.color_F18719,
              prefix: Container(
                child: Icon(
                  Icons.person_outline,
                  color: isNameFocused ? MyColors.color_F18719 : MyColors.color_3F4446,
                ),
                margin: EdgeInsets.only(left: Dimens.dimen_20),
              )),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.dimen_39, bottom: Dimens.dimen_09, top: Dimens.dimen_16),
            child: MyText(
              Strings.email,
              fontWeight: FontWeight.normal,
              color: isEmailFocused ? MyColors.color_F18719 : MyColors.color_6E7578,
              fontSize: Dimens.dimen_14,
            ),
          ),
          MyTextFieldPrefixSuffix(
              hint: Strings.email,
              controller: ctrlEmail,
              margin: const EdgeInsets.symmetric(horizontal: Dimens.dimen_20),
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
                margin: EdgeInsets.only(left: Dimens.dimen_20),
              )),
          Padding(
            padding: const EdgeInsets.only(left: Dimens.dimen_39, bottom: Dimens.dimen_09, top: Dimens.dimen_16),
            child: MyText(
              Strings.password,
              fontWeight: FontWeight.normal,
              color: isPasswordFocused ? MyColors.color_F18719 : MyColors.color_3F4446,
              fontSize: Dimens.dimen_14,
            ),
          ),
          MyTextFieldPrefixSuffix(
            hint: Strings.password,
            controller: ctrlPassword,
            isObscureText: isPasswordTextVisible,
            margin: const EdgeInsets.symmetric(horizontal: Dimens.dimen_20),
            outlineColor: MyColors.color_E2E9EF,
            keyboardType: TextInputType.text,
            suffix: Container(
              margin: const EdgeInsets.only(right: Dimens.dimen_20),
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
              margin: EdgeInsets.only(left: Dimens.dimen_20),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: Dimens.dimen_24, left: Dimens.dimen_20, right: Dimens.dimen_20),
            width: double.infinity,
            child: BlocBuilder<LoginBloc, BaseState>(
              builder: (BuildContext context, state) {
                if (state is LoadingState) {
                  return Loader();
                }
                return MyButton(
                  Strings.signUp,
                  () {
                    checkValidation(bloc);
                  },
                  outlineColor: MyColors.color_F18719,
                  textColor: MyColors.color_FFFFFF,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.dimen_18,
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
    if (!bloc.checkName(ctrlName.text.toString())) {
      showSnackBar(Strings.errorEnterName);
      return;
    } else if (!bloc.checkEmail(ctrlEmail.text.toString())) {
      showSnackBar(Strings.errorEnterEmail);
      return;
    } else if (!bloc.checkPassword(ctrlPassword.text.toString())) {
      showSnackBar(Strings.errorEnterPassword);
      return;
    }

    bloc.add(RegisterEvent(ctrlName.text.toString(), ctrlEmail.text.toString(), ctrlPassword.text.toString()));
  }
}
