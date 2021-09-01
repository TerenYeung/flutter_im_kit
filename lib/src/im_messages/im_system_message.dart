import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';

class ImSystemMessage extends StatelessWidget {
  const ImSystemMessage({
    Key? key,
    required this.content,
    this.backgroundColor = Style.TEXT_BACKGROUND,
    this.textStyle = const TextStyle(
      color: Style.TEXT_SECONDARY_COLOR,
      fontSize: 12.0,
    ),
    this.builder,
  }) : super(key: key);
  final String content;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BuilderType? builder;

  @override
  Widget build(BuildContext context) {

    if (builder != null) {
      return builder!(context);
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(content, style: textStyle,),
    );
  }
}
