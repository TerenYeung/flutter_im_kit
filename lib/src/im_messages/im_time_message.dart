import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';

typedef TimeFormatConvertor = String Function(int milliseconds);

class ImTimeMessage extends StatelessWidget {
  const ImTimeMessage({
    Key? key,
    this.milliseconds = 0,
    this.textStyle = const TextStyle(
      color: Style.TEXT_SECONDARY_COLOR,
      fontSize: 12.0,
    ),
    this.timeFormatConvertor = Tool.getFormatTime,
  }) : super(key: key);
  final int milliseconds;
  final TextStyle textStyle;
  final TimeFormatConvertor? timeFormatConvertor;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeFormatConvertor!(milliseconds),
      style: textStyle,
    );
  }
}