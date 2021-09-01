import 'package:flutter/material.dart';
import 'utils.dart';

typedef BadgeCountConvertor = String Function(int count);

class BadgePosition {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  BadgePosition({this.top, this.right, this.bottom, this.left});

  factory BadgePosition.topLeft({double? top, double? left}) {
    return BadgePosition(top: top ?? -9, left: left ?? -9);
  }

  factory BadgePosition.topRight({double? top, double? right}) {
    return BadgePosition(top: top ?? -9, right: right ?? -9);
  }

  factory BadgePosition.bottomRight({double? bottom, double? right}) {
    return BadgePosition(bottom: bottom ?? -9, right: right ?? -9);
  }

  factory BadgePosition.bottomLeft({double? bottom, double? left}) {
    return BadgePosition(bottom: bottom ?? -9, left: left ?? -9);
  }
}

class BadgePositioned extends StatelessWidget {
  final Widget child;
  final BadgePosition? position;

  const BadgePositioned({Key? key, this.position, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      final topRight = BadgePosition.topRight();
      return Positioned(
        top: topRight.top,
        right: topRight.right,
        child: child,
      );
    }

    return Positioned(
        top: position?.top,
        right: position?.right,
        bottom: position?.bottom,
        left: position?.left,
        child: child);
  }
}

class BadgeStyle {
  BadgeStyle({
    this.size = 18.0,
    this.textStyle,
    this.position,
  });

  final double? size;
  final TextStyle? textStyle;
  final BadgePosition? position;

  BadgeStyle merge(BadgeStyle? other) {
    if (other == null) return this;

    return copyWith(
      size: other.size,
      position: other.position,
      textStyle: other.textStyle,
    );
  }

  BadgeStyle copyWith({
    double? size,
    TextStyle? textStyle,
    BadgePosition? position,
  }) {
    return BadgeStyle(
      size: size ?? this.size,
      textStyle: textStyle ?? this.textStyle,
      position: position ?? this.position,
    );
  }
}

class ExcellentBadge extends StatelessWidget {
  const ExcellentBadge({
    Key? key,
    required this.child,
    this.count = 0,
    this.showBadge = true,
    this.position,
    this.textStyle,
    this.size = 18.0,
    // BoxDecoration? badgeDecoration,
    // BadgeCountConvertor? badgeCountConvertor,
    this.badgeDecoration = const BoxDecoration(
      color: Color(0xFFF53F3F),
      borderRadius: BorderRadius.all(Radius.circular(9.0)),
    ),
    this.badgeCountConvertor = Tool.getComputedCount,
    this.useRedDot = false,
    this.builder,
  }) :
        // badgeDecoration = const BoxDecoration(
        //   color:  Color(0xFFF53F3F),
        //   borderRadius: BorderRadius.all(Radius.circular(9.0)),
        // ),
        // badgeCountConvertor = Tool.getComputedCount,
        super(key: key);
  final Widget child;
  final int? count;
  final bool showBadge;
  final BadgePosition? position;
  final TextStyle? textStyle;
  final double size;
  final BoxDecoration badgeDecoration;
  final BadgeCountConvertor badgeCountConvertor;
  final bool? useRedDot;
  final Widget Function(BuildContext context, int count)? builder;

  bool get showBadgeWithCount => showBadge && !useRedDot! && !showCustomBadge;
  bool get showBadgeWithRedDot => useRedDot! && !showCustomBadge;
  bool get showCustomBadge => builder != null;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child,
        Visibility(
            visible: showBadgeWithCount,
            child: BadgePositioned(
              position: position,
              child: Container(
                height: size,
                padding: EdgeInsets.symmetric(horizontal: 4.5),
                constraints: BoxConstraints(
                  minWidth: size,
                ),
                decoration: badgeDecoration,
                child: Align(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    child: Text(
                      badgeCountConvertor(count!),
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            )),
        Visibility(
          visible: showBadgeWithRedDot,
          child: BadgePositioned(
            position: position,
            child: Container(
              height: size,
              width: size,
              // color: Colors.red,
              decoration: badgeDecoration,
            ),
          ),
        ),
        if (builder != null)
          BadgePositioned(
            position: position,
            child: builder!(context, count!),
          ),
      ],
    );
  }
}
