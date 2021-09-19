import 'package:test_project/src/bloc/base_event.dart';

class NoteAddEvent extends BaseEvent {
  final String title, content;

  NoteAddEvent(this.title, this.content);

  @override
  List<Object> get props => [this.title, this.content];
}

class NoteListEvent extends BaseEvent {
  NoteListEvent();

  @override
  List<Object> get props => [];
}
