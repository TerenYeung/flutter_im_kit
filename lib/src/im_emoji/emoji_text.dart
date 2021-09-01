import 'dart:collection';

import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'emoji.dart';

///emoji/image text
class EmojiText extends SpecialText {

  EmojiText(TextStyle textStyle, {this.start, this.emojis = const []})
      : super(EmojiText.flag, ']', textStyle) {
    for(Emoji emoji in emojis!) {
      emojiMap[emoji.value] = emoji.path;
    }
  }

  static const String flag = '[';
  final int? start;
  final List<Emoji>? emojis;
  final Map<String, String> emojiMap = {};

  @override
  InlineSpan finishText() {
    final String key = toString();
    ///https://github.com/flutter/flutter/issues/42086
    /// widget span is not working on web

    if (emojiMap.containsKey(key) && !kIsWeb &&  emojiMap[key] != null) {
      //fontsize id define image height
      //size = 30.0/26.0 * fontSize
      const double size = 19.0;

      ///fontSize 26 and text height =30.0
      //final double fontSize = 26.0;
      return ImageSpan(
          AssetImage(
              emojiMap[key]!,
          ),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start ?? 0,
          fit: BoxFit.fill,
          margin: const EdgeInsets.only(left: 0, top: 0, right: 1, bottom: 1));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

