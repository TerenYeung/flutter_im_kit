import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/Style.dart';

enum BubblePosition {
  leftTop,
  leftCenter,
  leftBottom,
  topLeft,
  topCenter,
  topRight,
  rightTop,
  rightCenter,
  rightBottom,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

enum BubbleType {
  Normal,
  RoundRect,
}

const double kSpace = 10.0;

class ExcellentBubble extends StatelessWidget {
  const ExcellentBubble({
    Key? key,
    this.position = BubblePosition.leftTop,
    this.bubbleType = BubbleType.Normal,
    this.backgroundColor = Colors.lightBlue,
    this.arrowSize = 10.0,
    this.doRepaint = false,
    this.topLeft = 8.0,
    this.topRight = 8.0,
    this.bottomLeft = 8.0,
    this.bottomRight = 8.0,
    this.height = 36.0,
    this.padding = const EdgeInsets.all(kSpace),
    required this.child,
  }) :
        // assert(height >= 70.0),
        super(key: key);
  final BubblePosition? position;
  final BubbleType? bubbleType;
  final Color? backgroundColor;
  final bool doRepaint;
  final double? arrowSize;
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;
  final EdgeInsets padding;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(200, 60),
        painter: BubblePainter(
          position: position!,
          bubbleType: bubbleType!,
          backgroundColor: backgroundColor!,
          arrowSize: arrowSize!,
          topLeft: topLeft!,
          topRight: topRight!,
          bottomLeft: bottomLeft!,
          bottomRight: bottomRight!,
          padding: padding,
          doRepaint: doRepaint,
        ),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // border: Border.all(),
            ),
            constraints: BoxConstraints(
              minHeight: height,
            ),
            child: child),
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required this.position,
    required this.bubbleType,
    required this.backgroundColor,
    required this.arrowSize,
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomLeft = 0.0,
    this.bottomRight = 0.0,
    required this.padding,
    this.doRepaint = false,
  }) : super();

  final BubblePosition position;
  final BubbleType bubbleType;
  final Color backgroundColor;
  final double arrowSize;
  final EdgeInsets padding;
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;
  final bool? doRepaint;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round
      ..color = backgroundColor;
    // 描绘聊天容器
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          -padding.left,
          // -padding.top,
          0,
          size.width + padding.right,
          // size.height + padding.bottom,
          size.height,
          topLeft: Radius.circular(topLeft!),
          topRight: Radius.circular(topRight!),
          bottomLeft: Radius.circular(bottomLeft!),
          bottomRight: Radius.circular(bottomRight!),
        ),
        paint);

    if (bubbleType == BubbleType.Normal) {
      _drawNormalBubble(canvas: canvas, size: size, paint: paint);
    } else if (bubbleType == BubbleType.RoundRect) {
      _drawRoundRectBubble(canvas: canvas, size: size, paint: paint);
    }
  }

  void _drawNormalBubble({
    required Canvas canvas,
    required Size size,
    required Paint paint,
  }) {
    Path path = Path();
    double startX = -padding.left, startY = -padding.top, dx = 0.0, dy = 0.0;
    if (position == BubblePosition.leftTop ||
        position == BubblePosition.leftCenter ||
        position == BubblePosition.leftBottom) {
      startX = -padding.left;

      dx = arrowSize;
      dy = dx / tan(pi / 3);

      if (position == BubblePosition.leftTop) {
        startY = padding.top;
      } else if (position == BubblePosition.leftCenter) {
        startY = (size.height / 2) - dy;
      } else if (position == BubblePosition.leftBottom) {
        startY = (size.height - (2 * padding.bottom));
      }

      path
        ..moveTo(startX, startY)
        ..lineTo(startX - dx, startY + dy)
        ..lineTo(startX, startY + 2 * dy);
    } else if (position == BubblePosition.rightTop ||
        position == BubblePosition.rightCenter ||
        position == BubblePosition.rightBottom) {
      startX = size.width + padding.right;
      dx = arrowSize;
      dy = dx / tan(pi / 3);

      if (position == BubblePosition.rightTop) {
        startY = padding.top;
      } else if (position == BubblePosition.rightCenter) {
        startY = (size.height / 2) - dy;
      } else if (position == BubblePosition.rightBottom) {
        startY = (size.height - (2 * padding.bottom));
      }

      path
        ..moveTo(startX, startY)
        ..lineTo(startX + dx, startY + dy)
        ..lineTo(startX, startY + 2 * dy);
    } else if (position == BubblePosition.topLeft ||
        position == BubblePosition.topCenter ||
        position == BubblePosition.topRight) {
      startY = 0.0;
      dy = arrowSize;
      dx = dy / tan(pi / 3);

      if (position == BubblePosition.topLeft) {
        startX = 0.0;
      } else if (position == BubblePosition.topCenter) {
        startX = (size.width / 2) - dx;
      } else if (position == BubblePosition.topRight) {
        startX = (size.width - (padding.right));
      }

      path
        ..moveTo(startX, startY)
        ..lineTo(startX + dx, startY - dy)
        ..lineTo(startX + 2 * dx, startY);
    } else if (position == BubblePosition.bottomLeft ||
        position == BubblePosition.bottomCenter ||
        position == BubblePosition.bottomRight) {
      startY = size.height;
      dy = arrowSize;
      dx = dy / tan(pi / 3);

      if (position == BubblePosition.bottomLeft) {
        startX = 0.0;
      } else if (position == BubblePosition.bottomCenter) {
        startX = (size.width / 2) - dx;
      } else if (position == BubblePosition.bottomRight) {
        startX = (size.width - (padding.right));
      }

      path
        ..moveTo(startX, startY)
        ..lineTo(startX + dx, startY + dy)
        ..lineTo(startX + 2 * dx, startY);
    }

    canvas.drawPath(path, paint);
  }

  void _drawRoundRectBubble({
    required Canvas canvas,
    required Size size,
    required Paint paint,
  }) {
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return doRepaint!;
  }
}
