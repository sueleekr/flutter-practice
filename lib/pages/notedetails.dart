
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/redux/actions/noteaddaction.dart';
import 'package:todo_with_redux/redux/actions/noteeditaction.dart';
import 'package:todo_with_redux/redux/store.dart';

class NoteDetails extends StatefulWidget {
  final Note? note;
  
  NoteDetails({Key? key, required this.note}) : super(key: key);
//NoteDetails({Key? key}) : super(key: key);
  @override
  _NoteDetailsState createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController tagsController = TextEditingController();

  List<String>? tags = <String>[];

  @override

  void initState() {
    if (widget.note !=null) {
      super.initState();
      tags = widget.note!.tags;
    }
  
  }

  Widget build(BuildContext context) {
    titleController.text = widget.note?.title ?? '';
    contentController.text = widget.note?.content ?? '';
    //tagsController.text = (widget.note?.tags!.length == null ? '' : widget.note?.tags!.join(','))!;

    return Scaffold(
      body: SingleChildScrollView(
        child:
        Padding(
          padding: EdgeInsets.only(top: 50,left: 30, right: 30, bottom: 50),
          child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),

/*                   if(widget.note.tag!='')
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children:[
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          width: widget.note.tag.length.toDouble()*8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:Colors.blue
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFFFECB3)
                          ),
                          child: Center(
                            child: Text(widget.note.tag.toUpperCase(),
                            style: TextStyle(
                              fontSize: 13
                            ),
                          )),
                        ),
                    ]
                  ), */

                  TextField(
                    maxLength: 30,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    controller: tagsController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                      labelText: 'Tags'
                    ),

                    onSubmitted: (value) => onTagSubmit(value),
                  ),
                  if(tags != null)
                    Wrap(
                      children: tags!.asMap().entries.map((tag){
                        return
                          InputChip(
                            backgroundColor: Colors.lime,
                            label: Text(tag.value),
                            labelStyle: TextStyle(
                              color: Colors.black 
                            ),
                            onDeleted: (){
                              setState(() {
                                tags!.removeAt(tag.key);
                              });
                              
                            },
                          ); 
                      }).toList()
                    ),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: ()=>
                          Navigator.pop(context),
                        child: Text('Exit'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(100,35),
                          side: BorderSide(color: Colors.grey,
                            width: 1.0  
                          )
                        ),
                      ), 
                      Padding(padding: EdgeInsets.only(left: 10)),
                      ElevatedButton(
                        onPressed: ()=>
                          onSave(),
                        child: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.black,
                          onSurface: Colors.red,
                          minimumSize: Size(100, 35)
                        ),
                      ), 
                    ],
                  )
                ], 
              ) 


          ),
        ),
      )
    );
  
  }


  onTagSubmit(String value) async {
    List<String> newTags = value.split(',');

     if (newTags.where((tag) => (tag.length >= 10)).length > 0) {
      await alertMessage("Tag limit is 10");
      return;
    } 

    if(newTags.length + tags!.length > 10) {
      await alertMessage("You can attach tags upto 10");
      return;
    } 

    setState(() {
      List<String> values = value.split(',') ;
      tags!.addAll(values);
    });

    tagsController.text = '';
    //print(widget.note!.tags);   
  }

  void onSave() async {

    if(titleController.text == '' && contentController.text==''){
      bool result;
      result = await alertMessage("Both fields has no data, still want to continue?");

      if (!result) return;
    }

    Note note = Note(title: titleController.text, content: contentController.text, tags: tags, id: widget.note?.id);

    if(note.id ==null) 
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

class NoteDetailsArguments {
  Note? note;

  NoteDetailsArguments({ this.note });
}


