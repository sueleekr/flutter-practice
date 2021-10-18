import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_redux/pages/addlistview.dart';
import 'package:todo_with_redux/pages/notedetails.dart';
import 'package:todo_with_redux/redux/app_state.dart';
import 'package:todo_with_redux/redux/store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => StoreProvider<AppState> (
    store: store,
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/notelist',
      routes: {
        '/notelist': (content) => AddListView(),
        //'/addnote': (context) => NoteDetails(),
        '/notedetails': (context) 
          {
            final NoteDetailsArguments args = ModalRoute.of(context)!.settings.arguments as NoteDetailsArguments;
            return NoteDetails(note: args.note);
          }        
      },
    )
  );
}
/* 
class MyHomePage extends StatelessWidget {
  final String? title;
  const MyHomePage({Key? key, this.title }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: 
          AppBar(
            title:Text(this.title??'')
          ),
      
        body: AddListView(),
      );
  }
}
 */
