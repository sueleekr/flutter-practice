import 'dart:math';

import 'package:flutter/material.dart';

class AnimationStep1 extends StatefulWidget {
  AnimationStep1({Key? key}) : super(key: key);

  @override
  _AnimationStep1State createState() => _AnimationStep1State();
}

class _AnimationStep1State extends State<AnimationStep1> {
  double _width = 200;
  double _height = 200;
  Color _color = Colors.red;
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          children: [
            AnimatedContainer(
              width: _width,
              height: _height,
              color: _color,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            ),
            TweenAnimationBuilder<double>(
              duration: Duration(seconds: 1), 
              tween: Tween(begin: 0.0, end: _value), 
              child:Container(
                width:120,
                height: 120,
                color: Colors.red
              ),
              builder: (context, value, child){
                return Transform.translate(
                  offset: Offset(value * 200 -100,0),
                  child: child,
                );
              }
            ),
            SizedBox(
              width:300,
              child:
              Slider.adaptive(
                value: _value, 
                onChanged: (value) => setState(()=> _value = value)
              )
            ),
            
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: _update
      ),
    );
  }

  final random = Random();

  void _update(){
    setState(() {
      _width = random.nextInt(200).toDouble();
      _height = random.nextInt(200).toDouble();
      _color = Color.fromRGBO(
        random.nextInt(128), 
        random.nextInt(128), 
        random.nextInt(128), 
        1);
    }); 
  }
}


class SineCurve extends Curve {
  final double count;

  SineCurve({this.count=1});

  @override

  double transformInternal(double t){
    return sin(count * 2 *pi * t) * 0.5 + 0.5;
  }

}