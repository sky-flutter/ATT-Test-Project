import 'package:test_project/imports.dart';
import 'package:test_project/src/bloc/base_bloc.dart';
import 'package:test_project/src/bloc/base_event.dart';
import 'package:test_project/src/bloc/base_state.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/service/error_code.dart';
import 'package:test_project/src/utils/preference.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/utils/utils.dart';
import 'package:test_project/src/views/note/home/model/home_data.dart';

import 'home_event.dart';

class HomeBloc extends BaseBloc<BaseEvent, BaseState> {
  HomeBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is NoteAddEvent) {
      yield* addNote(event);
    }

    if (event is NoteListEvent) {
      yield* getNotes(event);
    }
  }

  Stream<BaseState> addNote(NoteAddEvent event) async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var userId = await MyPreference.getUserId();
        var data = {
          Constants.TITLE: event.title,
          Constants.DESCRIPTION: event.content,
          Constants.COLOR: generateRandomColor(),
          Constants.USER_ID: "users/" + userId,
        };
        await notesRef().add(data);
        yield DataState(Strings.noteAddedSuccessfully);
        getNotes(NoteListEvent());
      } else {
        yield ErrorState(errorCode: ErrorCode.NO_INTERNET_CONNECTION, errorMessage: Strings.errorNoInternetConnection);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN, errorMessage: Strings.errorServerDown);
    }
  }

  Stream<BaseState> getNotes(NoteListEvent event) async* {
    try {
      yield LoadingState();
      if (await isConnectionAvailable()) {
        var userId = await MyPreference.getUserId();
        var dataSnapshot = await notesRef().where("user_id", isEqualTo: "users/$userId").get();
        if (dataSnapshot.docs != null && dataSnapshot.docs.isNotEmpty) {
          var homeData = HomeData.fromSnapshots(dataSnapshot.docs);
          yield DataState(homeData);
        } else {
          yield ErrorState(errorMessage: Strings.errorNoNotesAvailable);
        }
      } else {
        yield ErrorState(errorCode: ErrorCode.NO_INTERNET_CONNECTION, errorMessage: Strings.errorNoInternetConnection);
      }
    } catch (e) {
      yield ErrorState(errorCode: ErrorCode.SERVER_DOWN, errorMessage: Strings.errorServerDown);
    }
  }

  Future<String> getUserName() async {
    var loginData = await MyPreference.getLoginData();
    return loginData.name ?? "";
  }

  bool checkTitle(String strTitle) {
    return strTitle.isNotEmpty;
  }

  bool checkContent(String strContent) {
    return strContent.isNotEmpty;
  }
}
