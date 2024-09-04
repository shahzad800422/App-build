import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:ui';

class Background extends CustomPainter {
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //绘制田字格核心代码
    final paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color.fromRGBO(255, 0, 0, 0.5)                
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint1);
    
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, size.width), paint1);
    canvas.drawLine(
        Offset(size.width, size.width), Offset(0, size.width), paint1);
    canvas.drawLine(Offset(0, size.width), Offset(0, 0), paint1);
    final paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..color = Color.fromRGBO(255, 0, 0, 0.5)
      ..strokeWidth = 1;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.width);
    
    path.moveTo(0, size.width);
    path.lineTo(size.width, 0);
    path.moveTo(0, size.width / 2);
    path.lineTo(size.width, size.width / 2);
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width / 2, size.width);
    canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList([5, 5])), paint2);
  }
}

//以下是path_drawing实现虚线的部分
Path dashPath(
  Path source, {
  @required CircularIntervalList<double> dashArray,
  DashOffset dashOffset,
}) {
  assert(dashArray != null);
  if (source == null) {
    return null;
  }

  dashOffset = dashOffset ?? const DashOffset.absolute(0.0);
  // TODO: Is there some way to determine how much of a path would be visible today?

  final Path dest = Path();
  for (final PathMetric metric in source.computeMetrics()) {
    double distance = dashOffset._calculate(metric.length);
    bool draw = true;
    while (distance < metric.length) {
      final double len = dashArray.next;
      if (draw) {
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
      }
      distance += len;
      draw = !draw;
    }
  }

  return dest;
}

enum _DashOffsetType { Absolute, Percentage }

class DashOffset {
  DashOffset.percentage(double percentage)
      : _rawVal = percentage.clamp(0.0, 1.0) ?? 0.0,
        _dashOffsetType = _DashOffsetType.Percentage;

  const DashOffset.absolute(double start)
      : _rawVal = start ?? 0.0,
        _dashOffsetType = _DashOffsetType.Absolute;

  final double _rawVal;
  final _DashOffsetType _dashOffsetType;

  double _calculate(double length) {
    return _dashOffsetType == _DashOffsetType.Absolute
        ? _rawVal
        : length * _rawVal;
  }
}

class CircularIntervalList<T> {
  CircularIntervalList(this._vals);

  final List<T> _vals;
  int _idx = 0;

  T get next {
    if (_idx >= _vals.length) {
      _idx = 0;
    }
    return _vals[_idx++];
  }
}
