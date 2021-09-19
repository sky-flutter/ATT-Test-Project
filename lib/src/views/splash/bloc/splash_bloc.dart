import 'package:test_project/imports.dart';
import 'package:test_project/src/bloc/base_bloc.dart';
import 'package:test_project/src/bloc/base_event.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/utils/preference.dart';
import 'package:test_project/src/views/splash/bloc/splash_event.dart';
import 'package:test_project/src/views/splash/bloc/splash_state.dart';

class SplashBloc extends BaseBloc<BaseEvent, BaseState> {
  SplashBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is SplashEvent) {
      yield* isUserAuthorized();
    }
  }

  Stream<BaseState> isUserAuthorized() async* {
    yield LoadingState();
    try {
      bool isLoggedIn = await MyPreference.get(Constants.IS_LOGIN, SharePrefType.Bool);
      if (isLoggedIn != null && isLoggedIn)
        yield AuthorizedState();
      else
        yield UnAuthorizedState();
    } catch (e) {
      yield UnAuthorizedState();
    }
  }
}
