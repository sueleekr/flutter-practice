import 'package:flutter/material.dart';
import 'package:todo_with_redux/pages/animation.dart';
import 'package:todo_with_redux/pages/dashboard.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  Container(
                    child: TabBar(
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Dashboard'),
                        Tab(text: 'Animation'),
                      ],
                    ),
                  ),
                  Container(
                    height: 630, //height of TabBarView
                   child: TabBarView(
                      children: [
                        Dashboard(),
                        AnimationBoard()
                      ]
                    )
                  )
                ]
              )
            ),
        ]),
      ),
    );
  }
}