import 'package:flutter/material.dart';
import 'package:todo_with_redux/pages/animation.dart';
import 'package:todo_with_redux/pages/dashboard.dart';

import 'isolates.dart';

class MainBoard extends StatefulWidget {
  @override
  _MainBoardState createState() => _MainBoardState();
}

class _MainBoardState extends State<MainBoard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sue\'s Flutter'),
      ),
      body: DefaultTabController(
        length: 3, // length of tabs
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Dashboard'),
                Tab(text: 'Animation'),
                Tab(text: 'Isolate'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Dashboard(),
                  AnimationBoard(),
                  IsolatesBoard()
                ]
              ),
            )
          ]
        )
      ),
    );
  }
}