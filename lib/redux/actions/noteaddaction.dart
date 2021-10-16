
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/redux/base_action.dart';
import 'package:todo_with_redux/redux/states/notestate.dart';

class NoteAddAction extends BaseAction {
/*   final String item ;
  List<String> items= <String>[]; */
  Note note;
  List<Note> notes = <Note>[];

  NoteAddAction({ required this.note});

  @override
  Future<AppState> reduce() async {
    int maxId = state.noteState.maxId + 1;

    notes = List.of(state.noteState.notes) ;
    
    this.note.id = maxId;
    notes.add(this.note); 

    NoteState itemState = NoteState( maxId : maxId, notes: notes);
    
    return state.copy(itemState: itemState);
  }
}