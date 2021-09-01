import 'package:flutter/cupertino.dart';

class Tool {
  /// 计算时长
  static String getElapsedTime(int elapsed, {
    formatter,
}) {
    int hours = elapsed ~/ (60 * 60);
    elapsed = elapsed % (60 * 60);
    int minutes = elapsed ~/ 60;
    int seconds = elapsed % 60;

    if (formatter != null) {
      return formatter(
        hours,
        minutes,
        seconds,
      );
    }

    List<String> times = [];

    if (hours != 0) {
      times.add(hours.toString().padLeft(2, '0'));
    }

    times.add(minutes.toString().padLeft(2, '0'));

    times.add(seconds.toString().padLeft(2, '0'));

    return times.join(":");
  }



  static String getComputedCount(int count) {
    return count > 99 ? '99+' : count.toString();
  }

  static String getPlayTime(int millisecond) {
    int min = ((millisecond / 1000) / 60).toInt();
    int sec = ((millisecond / 1000) % 60).toInt();

    return min.toString().padLeft(2, '0') + ':' + sec.toString().padLeft(2, '0');
  }

  /*
 时间：根据聊天产生的时间区分展示形式
  1. 当天：展示对应时间，24小时制如“19：00”
  2. 跨天：展示月、日，如“11/02”
  3. 跨年：展示年、月、日，如“2020/11/2”
  *
  * */

  static String getFormatTime(int timestamp) {
    final DateTime now = DateTime.now();
    final DateTime ts = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final int elapsedTime = now.millisecondsSinceEpoch - timestamp;
    final bool isToday = elapsedTime <= (1000 * 60 * 60 * 24);
    final bool isThisYear = (ts.year == now.year);

    if (isToday) {
      return "${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}";
    } else if (isThisYear) {
      return "${ts.month.toString().padLeft(2, '0')}/${ts.day.toString().padLeft(2, '0')}";
    } else {
      return "${ts.year}/${ts.month.toString().padLeft(2, '0')}/${ts.day.toString().padLeft(2, '0')}";
    }
  }
}

class ImMessageType {
  static const UnKnown = -2;    /// 未知类型消息
  static const Draft = -1;      /// 草稿消息
  static const System = 0;      /// 系统消息
  static const Text = 1;        /// 文本消息
  static const Voice = 2;       /// 语音消息
  static const Image = 3;       /// 图片消息
  static const Video = 4;       /// 视频消息
  static const VoiceCall = 5;   /// 语音通话
  static const VideoCall = 6;   /// 视频通话
  static const Time = 7;        /// 时间消息
}

class ImMessageStatus {
  static const Sending = 0;        /// 发送中
  static const SendSuccess = 1;   /// 发送成功
  static const SendFailed = 2;    /// 发送失败
}

enum BottomPanelState {
  NOTHING,
  PLACE_HOLDER,
  KEYBOARD,
  AUDIO_RECORD,
  EMOJI,
  MORE,
}

typedef BuilderType = Widget Function(BuildContext context);

class LRUCache<T> {
  Map<String, T> _cache = Map<String, T>();
  int capacity;
  LRUCache({this.capacity = 50});

  T? get(String key) {
    if (_cache.containsKey(key) && _cache[key] != null) {
      T temp = _cache[key]!;
      _cache.remove(key);
      _cache.putIfAbsent(key, () => temp);
      return temp;
    } else {
      return null;
    }
  }

  void put(String key, T value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.toList().first);
    }

    _cache.putIfAbsent(key, () => value);
  }

  List<T> toList() {
    return _cache.values.toList();
  }

  void remove(String key) {
    _cache.remove(key);
  }
}
