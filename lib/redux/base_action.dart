import 'package:async_redux/async_redux.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/redux/states/notestate.dart';

abstract class BaseAction extends ReduxAction<AppState> {
  // States
  NoteState get noteState => state.noteState;
}