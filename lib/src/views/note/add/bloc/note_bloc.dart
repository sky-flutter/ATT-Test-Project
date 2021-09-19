import 'package:test_project/imports.dart';
import 'package:test_project/src/bloc/base_bloc.dart';
import 'package:test_project/src/bloc/base_event.dart';
import 'package:test_project/src/bloc/base_state.dart';
import 'package:test_project/src/service/constants.dart';
import 'package:test_project/src/service/error_code.dart';
import 'package:test_project/src/utils/preference.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/utils/utils.dart';
import 'package:test_project/src/views/note/home/bloc/home_event.dart';

class NoteBloc extends BaseBloc<BaseEvent, BaseState> {
  NoteBloc() : super(UnInitiatedState());

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is NoteAddEvent) {
      yield* addNote(event);
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
