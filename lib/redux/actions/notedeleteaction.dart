
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/redux/base_action.dart';
import 'package:todo_with_redux/redux/states/notestate.dart';

class NoteDeleteAction extends BaseAction {
/*   final String item ;
  List<String> items= <String>[]; */
  Note note;
  List<Note> notes = <Note>[];

  NoteDeleteAction({ required this.note});

  @override
  Future<AppState> reduce() async {
    int idx, maxId;
    
    notes = List.of(state.noteState.notes) ;
    maxId = state.noteState.maxId;
    
    idx = notes.indexOf(note);
    
    dynamic  status = notes.removeAt(idx); 
    print(status);
    NoteState itemState = NoteState(maxId: maxId, notes: notes);
    
    return state.copy(itemState: itemState);
  }
}