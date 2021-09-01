
import 'package:flutter/services.dart';
import 'dart:convert';

import 'emoji.dart';

/// emoji manager
class EmojiManager {

  static EmojiManager? _instance;
  static EmojiManager get instance => _instance ??= EmojiManager._();

  EmojiManager._();

  Future<List<Emoji>> getEmojis({
  String? pathPrefix,
    String? pathSuffix,
}) async {
    String config = await _loadEmojiConfig();
    JsonCodec jsonCodec = const JsonCodec();
    List list = jsonCodec.decode(config);
    List<Emoji> emojis = [];
    for (var element in list) {

      Emoji emoji;

      if (pathPrefix != null && pathSuffix != null) {
        emoji = Emoji(element['code'], element['value'], pathPrefix: pathPrefix, pathSuffix: pathSuffix);
      } else {
        emoji = Emoji(element['code'], element['value']);
      }
      emojis.add(emoji);
    }
    return emojis;
  }

  Future<String> _loadEmojiConfig() async {
    var ret = await rootBundle.loadString('assets/emoji/emoji.txt');
    return ret;
  }
}