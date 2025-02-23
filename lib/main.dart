import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(HeadphoneAnimation());

class HeadphoneAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: AnimatedHeadphoneLogo(),
        ),
      ),
    );
  }
}

class AnimatedHeadphoneLogo extends StatefulWidget {
  @override
  _AnimatedHeadphoneLogoState createState() => _AnimatedHeadphoneLogoState();
}

class _AnimatedHeadphoneLogoState extends State<AnimatedHeadphoneLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double progress = _controller.value;

        return CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          painter: HeadphonePainter(progress),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class HeadphonePainter extends CustomPainter {
  final double progress;
  HeadphonePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    double lineLength = size.width * 0.6;
    double animatedLine = lineLength * (1.0 - progress.clamp(0.0, 0.2) / 0.2);

    canvas.drawLine(
      Offset(centerX - animatedLine / 2, centerY),
      Offset(centerX + animatedLine / 2, centerY),
      paint,
    );

    if (progress >= 0.2) {
      int segments = 10;
      double radius =
          (size.width / 3) * ((progress - 0.2) / 0.5).clamp(0.0, 1.0);
      double angleStep = (2 * pi) / segments;
      for (int i = 0; i < segments; i++) {
        double angle = i * angleStep;
        Offset start = Offset(
          centerX + radius * cos(angle - pi / 2),
          centerY + radius * sin(angle - pi / 2),
        );
        Offset end = Offset(
          centerX + (radius + 20) * cos(angle - pi / 2),
          centerY + (radius + 20) * sin(angle - pi / 2),
        );
        canvas.drawLine(start, end, paint);
      }
    }

    if (progress >= 0.7) {
      double headphoneScale = ((progress - 0.7) / 0.2).clamp(0.0, 1.0);
      Paint headphonePaint = Paint()
        ..color = Colors.white.withOpacity(headphoneScale)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, centerY),
          size.width * 0.2 * headphoneScale, headphonePaint);
    }

    if (progress >= 0.9) {
      double expandProgress = ((progress - 0.9) / 0.1).clamp(0.0, 1.0);
      Paint transitionPaint = Paint()
        ..color = Colors.white.withOpacity(expandProgress);
      canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height), transitionPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
