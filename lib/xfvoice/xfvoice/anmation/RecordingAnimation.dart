import 'dart:math';

import 'package:flutter/material.dart';

class RecordingAnimation extends StatefulWidget {
  @override
  _RecordingAnimationState createState() => _RecordingAnimationState();
}

class _RecordingAnimationState extends State<RecordingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<double> _lineHeights;

  @override
  void initState() {
    super.initState();
    _lineHeights = List<double>.generate(4, (index) => 0.0);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animationController.addListener(() {
      setState(() {
        _updateLineHeights();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateLineHeights() {
    final random = Random();
    for (int i = 0; i < _lineHeights.length; i++) {
      _lineHeights[i] = random.nextDouble() * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RecordingAnimationPainter(_lineHeights),
    );
  }
}

class RecordingAnimationPainter extends CustomPainter {
  final List<double> lineHeights;

  RecordingAnimationPainter(this.lineHeights);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0;

    final lineSpacing = size.width / 6;
    final lineHeightFactor = size.height / 100;

    for (int i = 0; i < lineHeights.length; i++) {
      final x = (i * 2 + 1) * lineSpacing;
      final y = size.height / 2;

      canvas.drawLine(
        Offset(x, y - lineHeights[i] * lineHeightFactor / 2),
        Offset(x, y + lineHeights[i] * lineHeightFactor / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}