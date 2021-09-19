import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/imports.dart';
import 'package:test_project/src/theme/dimens.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/utils/utils.dart';
import 'package:test_project/src/views/note/add/bloc/note_bloc.dart';
import 'package:test_project/src/views/note/home/bloc/home_event.dart';
import 'package:test_project/src/widget/loading/loader.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController ctrlContent = TextEditingController();
  TextEditingController ctrlTitle = TextEditingController();
  late NoteBloc _noteBloc;

  @override
  void initState() {
    super.initState();
    _noteBloc = NoteBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _noteBloc,
      child: BlocListener<NoteBloc, BaseState>(
        listener: (BuildContext context, state) async {
          if (state is ErrorState) {
            showSnackBar(state.errorMessage);
          }

          if (state is DataState) {
            showSnackBar(state.data);
            MyNavigator.navState?.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: MyText(
              Strings.addNewNote,
              fontSize: Dimens.dimen_20,
              fontWeight: FontWeight.w700,
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: Dimens.dimen_16,
                left: Dimens.dimen_16,
                right: Dimens.dimen_16,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: ctrlTitle,
                    style: TextStyle(
                      fontSize: Dimens.dimen_28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: Strings.title,
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        )),
                  ),
                  TextField(
                    controller: ctrlContent,
                    style: TextStyle(
                      fontSize: Dimens.dimen_20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                    decoration: InputDecoration(
                      hintText: Strings.content,
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              checkValidation();
            },
            child: BlocBuilder<NoteBloc, BaseState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return Loader();
                }
                return Icon(
                  Icons.check,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void checkValidation() {
    if (!_noteBloc.checkTitle(ctrlTitle.text.toString())) {
      showSnackBar(Strings.errorEnterTitle);
      return;
    }
    if (!_noteBloc.checkContent(ctrlContent.text.toString())) {
      showSnackBar(Strings.errorEnterContent);
      return;
    }

    _noteBloc.add(NoteAddEvent(ctrlTitle.text.toString(), ctrlContent.text.toString()));
  }
}
