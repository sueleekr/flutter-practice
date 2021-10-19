import 'dart:math';

import 'package:flutter/material.dart';

class AnimationBoard extends StatefulWidget {
  AnimationBoard({Key? key}) : super(key: key);

  @override
  _AnimationBoardState createState() => _AnimationBoardState();
}

class _AnimationBoardState extends State<AnimationBoard> with SingleTickerProviderStateMixin{

  double _speed = 0.0;
  double _color = 0.0;
  double _size = 0.1;
  bool _animateEnable = false;

  Color _circleColor = Color.fromRGBO(255, 0, 0, 1);

  late final _animationController = AnimationController(
    vsync: this,
    duration: Duration(microseconds: ((1-_speed)*100).toInt() == 0 ? 1000 :10000*((1-_speed)*100).toInt())
    //Duration(seconds: 1)
  );
  
  @override
  void initState() {
  
    //_animationController.repeat();
    
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
      body:Padding(padding:EdgeInsets.only(left:20, right:20) ,
        child:
          Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedBuilder(
                animation: _animationController,
                child: CustomPaint(
                  painter: OpenPainter(200*_size, _circleColor),
                ),
                builder: (context,child) { 
                  return Transform.translate(
                    offset: Offset(0,400*(_animationController.value - 0.5).abs()),
                    child: child,
                  );
                }
              )
              ),
              Text('Animated'),
              
              Switch(
                value: _animateEnable,
                onChanged: (value) {
                  setState(() {

                    _animateEnable = value;
                    if (value) {
                      _animationController.repeat();
                    }
                    else{
                      _animationController.stop(canceled: false);
                    }
                  });
                },

              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Bounc speed'),],
              ),
              
              SizedBox(
                width:400,
                child:
                Slider.adaptive(
                  value: _speed, 
                  onChanged: (value) {
                    setState(() {
                      _speed = value;

                      _animationController.duration = Duration(microseconds: ((1-_speed)*100).toInt() == 0 ? 1000 :10000*((1-_speed)*100).toInt());
                      
                      _animationController.repeat();
                    });

                  }
                  
                )
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Color'),],
              ),
              SizedBox(
                width:400,
                child:
                Slider.adaptive(
                  value: _color, 
                  onChanged: (value) => setState(() {
                    _color = value;

                    _circleColor = HSLColor.fromColor(_circleColor).withHue(_color*360).toColor();

                  })
                )
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Size'),],
              ),
              SizedBox(
                width:400,
                child:
                Slider.adaptive(
                  value: _size, 
                  onChanged: (value) => setState(() {
                    _size = value;
                  })
                )
              ),
            ]
          ),
        ),
      )
    );
  }

}


class OpenPainter extends CustomPainter {
  double circleSize = 0.0;
  Color circleColor;
  OpenPainter(this.circleSize, this.circleColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(0, 100), this.circleSize, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}