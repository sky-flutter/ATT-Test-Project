import 'package:test_project/imports.dart';
import 'package:test_project/src/bloc/base_bloc.dart';
import 'package:test_project/src/bloc/base_event.dart';
import 'package:test_project/src/bloc/base_state.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/service/error_code.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/views/login/bloc/login_event.dart';
import 'package:test_project/src/views/login/model/login_data.dart';

class LoginBloc extends BaseBloc<BaseEvent, BaseState> {
  LoginBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is LoginEvent) {
      yield* doLogin(event);
    }

    if (event is RegisterEvent) {
      yield* doRegister(event);
    }
  }

  Stream<BaseState> doLogin(event) async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var querySnapshot = await usersRef()
            .where(Constants.EMAIL, isEqualTo: (event as LoginEvent).strEmail)
            .where(Constants.PASSWORD, isEqualTo: (event).strPassword)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          var loginData = LoginData.fromJson(querySnapshot.docs[0].data());
          loginData.id = querySnapshot.docs[0].id;
          yield DataState(loginData);
        } else {
          yield ErrorState(errorMessage: Strings.errorLogin);
        }
      } else {
        yield ErrorState(errorCode: ErrorCode.NO_INTERNET_CONNECTION, errorMessage: Strings.errorNoInternetConnection);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN, errorMessage: Strings.errorServerDown);
    }
  }

  Stream<BaseState> doRegister(RegisterEvent event) async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var map = {
          Constants.NAME: event.strName,
          Constants.EMAIL: event.strEmail,
          Constants.PASSWORD: event.strPassword,
        };
        var querySnapshot = await usersRef().where(Constants.EMAIL, isEqualTo: event.strEmail).get();
        if (querySnapshot.docs.isNotEmpty) {
          yield ErrorState(errorMessage: Strings.errorEmailAlreadyExists);
        } else {
          var documentReference = await usersRef().add(map);
          var future = await documentReference.get();
          var loginData = LoginData.fromJson(future.data());
          loginData.id = future.id;
          yield DataState(loginData);
        }
      } else {
        yield ErrorState(errorCode: ErrorCode.NO_INTERNET_CONNECTION, errorMessage: Strings.errorNoInternetConnection);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN, errorMessage: Strings.errorServerDown);
    }
  }

  bool checkName(String strName) {
    return strName.isNotEmpty;
  }

  bool checkEmail(String strEmail) {
    return strEmail.isNotEmpty;
  }

  bool checkPassword(String strPassword) {
    return strPassword.isNotEmpty;
  }
}
