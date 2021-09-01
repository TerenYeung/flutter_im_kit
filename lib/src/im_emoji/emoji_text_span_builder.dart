import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'emoji.dart';
import 'emoji_text.dart';

class EmojiTextSpanBuilder extends SpecialTextSpanBuilder {

  EmojiTextSpanBuilder(this.emojis);

  final List<Emoji> emojis;

  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }

    return super.build(data, textStyle: textStyle, onTap: onTap);
  }

  @override
  SpecialText? createSpecialText(String? flag,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, int? index}) {
    if (flag == null || flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle ?? TextStyle(), start: index! - (EmojiText.flag.length - 1), emojis: emojis);
    }
    return null;
  }
}
