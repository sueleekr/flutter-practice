import 'package:flutter/material.dart';
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/actions/noteaddaction.dart';
import 'package:todo_with_redux/redux/actions/noteeditaction.dart';
import 'package:todo_with_redux/redux/store.dart';

class NoteDetails extends StatefulWidget {
  final Note note;
  
  NoteDetails({Key? key, required this.note}) : super(key: key);
//NoteDetails({Key? key}) : super(key: key);
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.note.title;
    contentController.text = widget.note.content;
    tagController.text = widget.note.tag;
    return Scaffold(
      body: 
        Padding(
          padding: EdgeInsets.only(top: 50,left: 30, right: 30, bottom: 50),
          child: Center(
              child: Column(
                 children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.blueAccent,
                          fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.bold),
                      enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color: Colors.blue),   
                              ),  
                      focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                    ),  
                    ),
                    onChanged: (val)=> widget.note.title = titleController.text ,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  TextField(
                    maxLines: 5,
                    controller: contentController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      labelText: 'Content'
                    ),
                    onChanged: (val)=> widget.note.content = contentController.text ,
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  TextField(
                    controller: tagController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      labelText: 'Tag'
                    ),
                    onChanged: (val)=> widget.note.tag = tagController.text ,
                  ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  ElevatedButton(
                    onPressed: ()=>
                      onSave(widget.note),
                    child: Text('Save')
                  ), 
                ], 
              ) 


          ),
        )
      ,

    );
  }

  void onSave(Note note) async {

    if(titleController.text == '' && contentController.text==''){
      bool result;
      result = await alertMessage("Both fields has no data, still want to continue?");

      if (!result) return;
    }

    if(note.id == 0) 
      store.dispatch(NoteAddAction(note: note));
  
    else
      store.dispatch(NoteEditAction(note: note));

    // init fields
    titleController.text = '';
    contentController.text = '';
  
    Navigator.pop(context);
  }


  Future<bool> alertMessage (String msg) async {
    bool retVal = false;

    void _onPressedYes() {
        Navigator.pop(context, true);
    }
    void _onPressedNo() {
        Navigator.pop(context, false);
    }

    AlertDialog alertMessage = 
      AlertDialog(
        title: Text('WARNING!!'),
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: _onPressedYes, 
            child: Text('Yes')
          ),
          ElevatedButton(
            onPressed: _onPressedNo, 
            child: Text('No')
          ),
        ],
      );

    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return alertMessage;
      }
    ).then((value) { retVal = value; });

    return retVal;
  }  


}