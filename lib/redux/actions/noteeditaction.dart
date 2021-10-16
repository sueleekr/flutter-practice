
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/redux/base_action.dart';
import 'package:todo_with_redux/redux/states/notestate.dart';

class NoteEditAction extends BaseAction {
/*   final String item ;
  List<String> items= <String>[]; */
  Note note;
  List<Note> notes = <Note>[];

  NoteEditAction({ required this.note});

  @override
  Future<AppState> reduce() async {
    int idx;

    if(this.note.id == 0)
      throw Exception('This note doesn\'t have id');
    notes = List.of(state.noteState.notes) ;

    //idx = notes.indexOf(note);
    //notes[idx].title = notes[idx].title;


    NoteState itemState = NoteState( notes: notes, maxId: state.noteState.maxId);
    
    return state.copy(itemState: itemState);
  }
}