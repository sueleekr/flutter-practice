import 'package:async_redux/async_redux.dart' as Redux;
import 'package:flutter/material.dart';
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/actions/notedeleteaction.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/redux/store.dart';
import 'dart:math' as math;

class _AddListView extends StatefulWidget {

  final List<Note> notes;

  _AddListView({required this.notes});
    
  @override
  __AddListViewState createState() => __AddListViewState();
}

class __AddListViewState extends State<_AddListView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController testController = TextEditingController();

  late Note note;

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: 
        AppBar(
          title:Text('My Notes')
        ),
      floatingActionButton:FloatingActionButton(
        //backgroundColor: Colors.lightGreen,
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.pushNamed(context, 
            '/notedetails', 
            arguments: Note('',''),
          ) 
        } 
      ),
      body:
        Center(
            child: 
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 30)),
/*                   ElevatedButton(
                    onPressed: ()=>
                      Navigator.of(context).pushNamed("/addnote"),
                    child: Text('Add new note')
                  ), */
/*                   TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title'
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Content'
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  ElevatedButton(
                    onPressed: ()=>
                      onPressAdd(),
                    child: Text('Add')
                  ), */
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Expanded(
                    child: 
                      ListView.builder(
                        itemCount: widget.notes.length,
                        itemBuilder: (context, idx){
                          return 
                            Card(
                              child: ListTile(
                                onTap: (){
                                  Navigator.pushNamed(context, 
                                    '/notedetails', 
                                    arguments: widget.notes[idx],
                                  );
                                },
                                leading: Text(widget.notes[idx].id.toString()),
                                title: Text(widget.notes[idx].title),
                                subtitle: Text(widget.notes[idx].content),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    bool result;
                                    result = await alertMessage('Do you want to delete?');

                                    if(result){
                                      testController.text = widget.notes[idx].content;
                                      store.dispatch(NoteDeleteAction(note: widget.notes[idx]));
                                    }
                                  },
                                  child: Transform.rotate( 
                                    angle: math.pi/4,
                                    child: Icon(Icons.add),
                                    
                                  ),
                                )
                              ),
                  
                            );
                        }
                      ) 
                  )
                ],
              ),      
          )
    ) ;
  
  }
/* 
  void onPressAdd() async {

    if(titleController.text == '' && contentController.text==''){
      bool result;
      result = await alertMessage("Both fields has no data, still want to add?");

      if (!result) return;
    }

    Note note = Note(titleController.text, contentController.text);

    store.dispatch(NoteAddAction(note: note));

    // init fields
    titleController.text = '';
    contentController.text = '';
  
  } */


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

class AddListViewModel extends Redux.BaseModel<AppState>{
  List<Note> notes=<Note>[];

  AddListViewModel();

  AddListViewModel.build({
    required this.notes,
  }) : super(equals:[notes]);

  @override
  Redux.BaseModel fromStore() {
    return AddListViewModel.build(
      notes: state.noteState.notes
    );
  }
}

class AddListView extends StatelessWidget {

  const AddListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, AddListViewModel>(
      model: AddListViewModel(),
      builder: (BuildContext context, AddListViewModel vm) => _AddListView(
        notes: vm.notes,
      ),
    );
  }
}