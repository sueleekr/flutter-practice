import 'dart:math';

import 'package:flutter/material.dart';

class AnimationStep2 extends StatefulWidget {
  AnimationStep2({Key? key}) : super(key: key);

  @override
  _AnimationStep2State createState() => _AnimationStep2State();
}

class _AnimationStep2State extends State<AnimationStep2> with SingleTickerProviderStateMixin{

  late final _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500)
  );

  double _rotateDirection = 0.5;

  @override
  void initState() {
    _animationController.repeat();
    super.initState();
  }

  @override

  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context,child) {  
            return Transform.rotate(
              angle: _rotateDirection*pi*_animationController.value,
              child: child
            );
          },
          child: Container(
            width: 180,
            height: 180,
            color: Colors.red,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: _update
      ),
    );
  }

  void _update(){
    setState(() {
      _rotateDirection = _rotateDirection*-1;
    }); 
  }  
}