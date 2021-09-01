import 'package:flutter_im_kit/src/im_emoji/emoji.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji_manager.dart';

class ImEmojiCache {
  static ImEmojiCache? _instance;
  static ImEmojiCache get instance => _instance ??= ImEmojiCache._();

  List<Emoji> _systemEmojis = [];

  ImEmojiCache._();

  void putSystemEmojis(Iterable<Emoji> emojis) {
    _systemEmojis.clear();
    _systemEmojis.addAll(emojis);
  }

  List<Emoji> getSystemEmojis() => _systemEmojis;

  void getSystemEmojisAsync(void Function(List<Emoji> emojis, bool isAsync) callback, {
    String? emojiPathPrefix,
    String? emojiPathSuffix,
  }) async {
    if(_systemEmojis.isEmpty) {
      List<Emoji> emojis = await EmojiManager.instance.getEmojis(
        pathSuffix: emojiPathSuffix,
        pathPrefix: emojiPathPrefix,
      );
      _systemEmojis.addAll(emojis);
      callback(_systemEmojis, true);
    } else {
      callback(_systemEmojis, false);
    }
  }
}