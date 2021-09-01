class Emoji {
  final int code;
  final String value;
  final String path;
  // static const String pathPrefix = 'assets/emoji/imsdk_emoji_';
  // static const String pathSuffix = '.webp';
  final String? pathPrefix;
  final String? pathSuffix;

  Emoji(this.code, this.value,
  {
    this.pathPrefix = 'assets/emoji/imsdk_emoji_',
    this.pathSuffix = '.webp',
  }
      ) : path = pathPrefix! + code.toString() + pathSuffix!;

  @override
  String toString() {
    return "Emoji[$code]: $value, $path";
  }
}