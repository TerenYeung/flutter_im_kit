import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ExcellentSlider extends StatefulWidget {
  const ExcellentSlider({
    Key? key,
    this.defaultStrokeWidth = 4.0,
    this.onChanged,
    this.activeColor = Colors.white,
    this.color = Colors.grey,
    this.controllerColor = Colors.white,
    this.lowLimit = 1.0,     // 笔触最小值
    this.upperLimit = 10.0,  // 笔触最大值
    this.canvasWidth = 200.0, // 画布宽度
    this.canvasHeight = 50.0, // 画布高度
    this.sliderRadius = 16.0, // slider 圆角度数
    this.backgroundColor = Colors.black, // slider 背景色
  }) : super(key: key);

  final double? defaultStrokeWidth;
  final void Function(double value)? onChanged;
  final Color? activeColor;
  final Color? color;
  final double? lowLimit;
  final double? upperLimit;
  final double? canvasWidth;
  final double? canvasHeight;
  final double? sliderRadius;
  final Color? backgroundColor;
  final Color controllerColor;

  @override
  _ExcellentSliderState createState() => _ExcellentSliderState();
}

class _ExcellentSliderState extends State<ExcellentSlider> {
  Offset _point = Offset.zero;
  // 最小 1.0 最大 10
  double strokeWidth = 4.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      strokeWidth = widget.defaultStrokeWidth!;
      _point = Offset(40, widget.canvasHeight! / 2.0);
    });
  }

  double? _getComputedStrokeWidth() {
    double dx = _point.dx.clamp(0.0 + widget.sliderRadius!, widget.canvasWidth! - widget.sliderRadius!);
    double computedStrokeWidth = (widget.upperLimit! - widget.lowLimit!) * (dx/((widget.canvasWidth! - widget.sliderRadius!) - (0.0 + widget.sliderRadius!))) + widget.lowLimit!;


    if (widget.onChanged != null) {
      widget.onChanged!(computedStrokeWidth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.canvasWidth,
      height: widget.canvasHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        // border: Border.all(width: 2, color: Colors.tealAccent),
      ),
      child: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          // print('delta: ${details.delta}');
          setState(() {
            _point = details.localPosition;
          });
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          _getComputedStrokeWidth();
        },
        child: CustomPaint(
          painter: SliderPainter(
            point: _point,
            activeColor: widget.activeColor!,
            controllerColor: widget.controllerColor,
            color: widget.color!,
            sliderRadius: widget.sliderRadius!,
          ),
        ),
      ),
    );
  }
}

class SliderPainter extends CustomPainter {
  SliderPainter({
    required this.point,
    required this.activeColor,
    required this.color,
    required this.sliderRadius,
    required this.controllerColor,
  });
  final Offset point;
  final Color activeColor;
  final Color color;
  final double sliderRadius;
  final Color controllerColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint
      ..isAntiAlias = true
      ..color = color
    // ..color = Colors.lightBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    // canvas.saveLayer(Offset.zero & size, paint);
    // 绘制滑管背景
    Path path = Path();
    path.moveTo(5.0, size.height/2);
    path.addArc(Rect.fromCircle(center: Offset(5.0, size.height/2),radius: 5), pi/2, pi);
    path.lineTo(size.width - 10.0, size.height/2 - 10.0);
    path.addArc(Rect.fromCircle(center: Offset(size.width - 10.0, size.height/2),radius: 10), -pi/2, pi);
    path.lineTo(5.0, size.height/2 + 5.0);
    path.close();
    canvas.drawPath(path, paint);


    // 绘制滑管填充色
    Path path2 = Path();
    path2.moveTo(5.0, size.height/2);
    path2.addArc(Rect.fromCircle(center: Offset(5.0, size.height/2),radius: 5), pi/2, pi);
    double dx = point.dx.clamp(0.0 + sliderRadius, size.width - sliderRadius);
    double dy = dx * tan((size.height/2 - 10.0)/(size.width - 10.0));
    double y = (size.height / 2)  - dy;
    path2.lineTo(dx, y);
    path2.lineTo(dx, y + 2 * dy);
    path2.lineTo(5.0, size.height/2 + 5.0);
    path2.close();
    canvas.drawPath(path2, Paint()..color = activeColor
      ..isAntiAlias = true
    );

    paint
      ..color = controllerColor;
    canvas.drawCircle(Offset(dx, size.height / 2), sliderRadius, paint);
    // canvas.restore();
  }

  @override
  bool shouldRepaint(SliderPainter oldDelegate) {
    return oldDelegate.point != point;
  }
}
