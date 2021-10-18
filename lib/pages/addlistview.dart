import 'package:async_redux/async_redux.dart' as Redux;
import 'package:flutter/material.dart';
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/widgets/noteitme.dart';
import 'notedetails.dart';

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

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: 
        AppBar(
          title:Text('My Notes'),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 
                    '/notedetails', 
                    arguments: NoteDetailsArguments()
                  );
                },
                child: Icon(
                  Icons.add,
                  color: Colors.yellowAccent,
                  size: 40.0,
                ),
              )
            ),
          ],
        ),
        
/*         floatingActionButton:FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
            Navigator.pushNamed(context, 
              '/notedetails', 
              arguments: Note('',''),
            ) 
          } 
        ), */

      body:
        Center(
            child: 
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Expanded(
                    child: 
                      ListView.builder(
                        itemCount: widget.notes.length,
                        itemBuilder: (context, idx){
                          return 
                            NoteItem(note: widget.notes[idx]);
/*                             Card(
                              child: ListTile(
                                onTap: (){
                                  Navigator.pushNamed(context, 
                                    '/notedetails', 
                                    arguments: widget.notes[idx],
                                  );
                                },
                                leading: Text(widget.notes[idx].id.toString()),
                                title: Text(widget.notes[idx].title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.notes[idx].content),
                                    Text(widget.notes[idx].tag)
                                  ],
                                ),
                                
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
                  
                            ); */
                        }
                      ) 
                  )
                ],
              ),      
          )
    ) ;
  
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