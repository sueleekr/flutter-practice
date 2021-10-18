import 'package:flutter/material.dart';
import 'package:todo_with_redux/model/note.dart';
import 'package:todo_with_redux/pages/notedetails.dart';
import 'package:todo_with_redux/redux/actions/notedeleteaction.dart';
import 'package:todo_with_redux/redux/store.dart';
import 'dart:math' as math;
import 'package:collection/collection.dart';

class NoteItem extends StatelessWidget {
    const NoteItem({Key? key, required this.note}) : super(key: key);
  
    final Note note;
    
    @override
    Widget build(BuildContext context) {

      const int maxTags = 30;
      int totTags = 0;
      int maxTagIdx = 0;

      List<Widget> tagWidget = <Widget>[];
      
      //Max display tag(length) == maxTags
      do { 
        totTags += note.tags![maxTagIdx].length;

        tagWidget.add(
          Container(
            width: note.tags![maxTagIdx].length*10,

            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color:Colors.blue
              ),
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFECB3)
            ),
            child: Center(
              child: Text(note.tags![maxTagIdx].toUpperCase(),
              style: TextStyle(
                fontSize: 12
              ),
            )),
          )
        );
        maxTagIdx++;
      } while (totTags <= maxTags);

      if(maxTagIdx <= (note.tags!.length))
        tagWidget.add(
          Text((note.tags!.length - maxTagIdx).toString() + ' more')
        );
 
      return GestureDetector(
        onTap:(){
          Navigator.pushNamed(context, 
            '/notedetails', 
            arguments: NoteDetailsArguments(note: note));
        },
        child: Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10,right: 10),
          child : 
          Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFF9D5)
            ),
            child: 
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green,
                        child: Text(note.id.toString(),
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10)
                        ),
                        Wrap(
                          direction: Axis.horizontal ,
                          children: 
                            tagWidget.toList()
/*                             note.tags!.sublist(0,maxTagIdx).map((tag){
                              return 
                                Container(
                                  width: tag.length*10,

                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color:Colors.blue
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFFFECB3)
                                  ),
                                  child: Center(
                                    child: Text(tag.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12
                                    ),
                                  )),
                                ); 
                              }
                            ).toList(), */
                            
                        ),
/*                         
                        Container(
                          height: 15,
                          width: note.tag.length.toDouble()*8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:Colors.blue
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFFFECB3)
                          ),
                          child: Center(
                            child: Text(note.tag.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11
                            ),
                          )),
                        ), 
                        */
                        Padding(
                          padding: EdgeInsets.only(top: 5)
                        ),
                        Text(note.title,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5)
                        ),
                        Text(note.content,
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )
                      ],
                    )
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool result;
                      result = await alertMessage(context, 'Do you want to delete?');

                      if(result){
                        store.dispatch(NoteDeleteAction(note: note));
                      }
                    },
                    child: Transform.rotate( 
                      angle: math.pi/4,
                      child: Icon(Icons.add),
                    ),
                  )
                ],
              )
            ),
          ), 
        )
      );
    }

    Future<bool> alertMessage (BuildContext context, String msg) async {
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

  