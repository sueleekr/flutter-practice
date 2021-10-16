
import 'package:todo_with_redux/model/note.dart';

class NoteState {
/*   String item;
  List<String> items; */
  int maxId;
  List<Note> notes;

  NoteState({required this.notes, required this.maxId});

  static NoteState initialState()=>NoteState(maxId: 0, notes:[]);

  @override

  bool operator ==(Object other) {
    return identical(this, other)||
      other is NoteState &&
      runtimeType == other.runtimeType &&
      notes == other.notes&&
      maxId == other.maxId;
  }

  @override
 int get hashCode => 
        notes.hashCode^
        maxId.hashCode;
}