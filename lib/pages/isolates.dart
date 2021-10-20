import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';

class IsolatesBoard extends StatefulWidget {
  IsolatesBoard({Key? key}) : super(key: key);

  @override
  _IsolatesBoardState createState() => _IsolatesBoardState();
}

class _IsolatesBoardState extends State<IsolatesBoard> {
  TextEditingController _textController = TextEditingController(text: '10');
  int _calculated = 1;

  
  
  ReceivePort receivePort = ReceivePort();
  late Isolate isolate;

  @override
  void initState() {
    super.initState();
    
  }

  Future<dynamic> calculateIsolate() async {

    Completer completer = new Completer<SendPort>();

    receivePort = ReceivePort();

    try {

      receivePort.listen((dynamic message) {

        if (message is SendPort) {
          print('main -> middle ');
          SendPort mainToIsolateStream = message;
          completer.complete(mainToIsolateStream);
        } else {
          print('Isolate -> middle $message');
          setState(() {
            _calculated = int.parse(message);
          });
        }
        
       });

      
      isolate = await Isolate.spawn(calculateFibonacci, receivePort.sendPort);

    }
    catch(e){
      print("Error:$e");
    }
    return completer.future;    
  }

  @override
  void dispose(){
    super.dispose();

    receivePort.close();
    
    isolate.kill();
  }

  static void calculateFibonacci(SendPort receivePort) {
    List<int> pibonacciSequence = <int>[];
    int num=1;
  
    ReceivePort toIsolateStreem = ReceivePort();
    receivePort.send(toIsolateStreem.sendPort);

    toIsolateStreem.listen((message) {
      if (message == null || message == '') return;
      
      print('Receved in isolate : $message');

      num = int.parse(message);

      for(var idx = 1; idx <= num; idx++) {
        //int nextsequence = 0;

        if(idx == 1 || idx == 2){
          pibonacciSequence.add(1);
        }
        else {
          pibonacciSequence.add(pibonacciSequence[idx-3] + pibonacciSequence[idx-2]);
        } 

        //print(pibonacciSequence);
      }
      int totVal = pibonacciSequence.reduce((value, element) => value+element);

      receivePort.send(totVal.toString());
    });
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          controller: _textController,
        ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _calculated = 0;  
            });
            
            SendPort mainToIsolateStream = await calculateIsolate();
            mainToIsolateStream.send(_textController.text);
           
          },
          child: Text('Calculate')
        ),
        Text('Calculated: $_calculated')
      ],
    );
  }
}