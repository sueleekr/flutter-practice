import 'package:flutter/material.dart';







AlertDialog alertDialogYN(BuildContext context,String title, String msg){
  // ignore: unused_local_variable
  bool _yesno = false;
  void _onPressedYes() {
    Navigator.pop(context, 'Yes');
    _yesno = true;
    print(_yesno);
  }
  void _onPressedNo() {
    Navigator.pop(context, 'No');
    _yesno = false;
    print(_yesno);
  }
  return AlertDialog(
        title: Text(title),
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
}

