import 'package:todo_with_redux/redux/states/notestate.dart';

class AppState {

  final NoteState noteState;
  
  AppState({
    required this.noteState,
  });


  static AppState initialState() => AppState(
    noteState: NoteState.initialState(),
  );


  AppState copy({
    required NoteState itemState,
  }) {
    return AppState(
      noteState: itemState,
    );
  }

  
}

