import 'dart:ui';

import 'package:flutter/material.dart';

class AnimationBoard extends StatefulWidget {
  AnimationBoard({Key? key}) : super(key: key);

  @override
  _AnimationBoardState createState() => _AnimationBoardState();
}

class _AnimationBoardState extends State<AnimationBoard> with SingleTickerProviderStateMixin{

  static const double BASE_SPEED = 5000;
  double _speedMultiplier = 0.0; // [1,4]
  double _color = 0.0;
  double _size = 0.1;
  bool _animateEnable = false;

  Color _circleColor = Color.fromRGBO(255, 0, 0, 1);

  late final _animationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: BASE_SPEED.toInt())
  );

  @override
  void dispose(){
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(padding:EdgeInsets.only(left:20, right:20) ,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  // child: CustomPaint(
                  //   painter: OpenPainter(200*_size, _circleColor),
                  // ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200*_size),
                      color: _circleColor
                    ),
                    height: 200*_size,
                    width: 200*_size,
                  ),
                  builder: (context,child) {
                    return Transform.translate(
                      offset: Offset(0,400*(_animationController.value - 0.5).abs()),
                      child: child,
                    );
                  }
                ),
              ),

              Spacer(),

              Center(child: Text('Animated')),

              Center(
                child: Switch(
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
              ),

              Text('Bounce speed'),

              Slider(
                value: _speedMultiplier,
                onChanged: (value) {
                  setState(() {
                    _speedMultiplier = value;

                    double calculatedMultiplier = lerpDouble(1.0, 5.0, value)!;

                    _animationController.duration = Duration(milliseconds: (BASE_SPEED - (1000 * calculatedMultiplier)).toInt());

                    _animationController.repeat();
                  });

                }

              ),

              Text('Color'),

              Slider.adaptive(
                value: _color,
                onChanged: (value) => setState(() {
                  _color = value;

                  _circleColor = HSLColor.fromColor(_circleColor).withHue(_color*360).toColor();

                })
              ),

              Text('Size'),

              Slider.adaptive(
                value: _size,
                onChanged: (value) => setState(() {
                  _size = value;
                })
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
  bool shouldRepaint(OpenPainter oldDelegate) =>
    circleSize != oldDelegate.circleSize ||
    circleColor != oldDelegate.circleColor;
}