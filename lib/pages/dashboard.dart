import 'package:async_redux/async_redux.dart' as Redux;
import 'package:flutter/material.dart';
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/widgets/noteitme.dart';
import 'notedetails.dart';

class _Dashboard extends StatefulWidget {

  final List<Note> notes;

  _Dashboard({required this.notes});
    
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<_Dashboard> {

  TextEditingController searchItemControler = TextEditingController();

  List<Note>? searchedNotes = <Note>[];

  String searchItem = '';

  void onSubmitSearch(value) {
    setState(() {
      searchItem = value;
    });
  }

  @override

  Widget build(BuildContext context) {
    
    searchedNotes = 
      widget.notes.where((note) {
        bool retVal =false;
        String uppserSearchItem = searchItem.toUpperCase();

          if (uppserSearchItem == '') return true;

          if (note.title.toUpperCase().contains(uppserSearchItem)||note.content.toUpperCase().contains(uppserSearchItem)) {
            retVal = true;
          }

          if(note.tags!.where((tag) => tag.toUpperCase().contains(uppserSearchItem)).length > 0) {
            retVal = true;
          }

          return retVal;
        }
      ).toList();

    return 
    Scaffold(
/*       appBar: 
        AppBar(
          backgroundColor: Colors.white,
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
                  color: Colors.blue,
                  size: 40.0,
                ),
              )
            ),
          ],
        ), */
        
        floatingActionButton:FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => {
            Navigator.pushNamed(context, 
              '/notedetails', 
              arguments: NoteDetailsArguments()
            )
          } 
        ),

      body:
        Center(
            child: 
              Column(
                children: [
                  Padding(padding: EdgeInsets.all(10),
                    child:
                      TextField(
                        controller: searchItemControler,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          labelText: 'Search',
                          labelStyle: TextStyle(color: Colors.blueAccent,
                            fontSize: 15, 
                            fontWeight: FontWeight.bold
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.lightGreen
                            )
                          ),
                          focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                          ),  
                        ),
                        onSubmitted: (value) => onSubmitSearch(value),
                      ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Expanded(
                    child: 
                      ListView.builder(
                        itemCount: searchedNotes!.length,
                        itemBuilder: (context, idx){
                          return 
                            NoteItem(note: searchedNotes![idx]);
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

class DashboardModel extends Redux.BaseModel<AppState>{
  List<Note> notes=<Note>[];

  DashboardModel();

  DashboardModel.build({
    required this.notes,
  }) : super(equals:[notes]);

  @override
  Redux.BaseModel fromStore() {
    return DashboardModel.build(
      notes: state.noteState.notes
    );
  }
}

class Dashboard extends StatelessWidget {

  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Redux.StoreConnector<AppState, DashboardModel>(
      model: DashboardModel(),
      builder: (BuildContext context, DashboardModel vm) => _Dashboard(
        notes: vm.notes,
      ),
    );
  }
}