# flutter_im_kit

[![pub package](https://img.shields.io/pub/v/flutter_im_kit.svg)](https://pub.dartlang.org/packages/flutter_im_kit) [![GitHub stars](https://img.shields.io/github/stars/TerenYeung/flutter_im_kit)](https://github.com/TerenYeung/flutter_im_kit/stargazers) [![GitHub forks](https://img.shields.io/github/forks/TerenYeung/flutter_im_kit)](https://github.com/TerenYeung/flutter_im_kit/network)  [![GitHub license](https://img.shields.io/github/license/TerenYeung/flutter_im_kit)](https://github.com/fluttercandies/extended_text_field/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/TerenYeung/flutter_im_kit)](https://github.com/fluttercandies/extended_text_field/issues)

## 概述

**flutter_im_kit** 是一套基于 Flutter 的 IM 组件库，提供 IM 业务场景下的常用 UI 组件和解决方案。

## 组件集合

**flutter_excellent_badge**

常用于消息提醒的红点展示。

![](https://upload-images.jianshu.io/upload_images/1993435-f9a5b7c84a9e31a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**BadgePosition**

用于设置 flutter_excellent_badge 位置的类

**BadgePosition.topLeft**

![](https://upload-images.jianshu.io/upload_images/1993435-ec13ecab350eb2a2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**BadgePosition.topRight**

![](https://upload-images.jianshu.io/upload_images/1993435-056a28bb4825dfb8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**BadgePosition.bottomRight**

![](https://upload-images.jianshu.io/upload_images/1993435-d823b52d3ac38c8b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**BadgePosition.bottomLeft**

![](https://upload-images.jianshu.io/upload_images/1993435-d848c89f7af909ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**flutter_excellent_badge 示例**

**设置 badge 位置**

![](https://upload-images.jianshu.io/upload_images/1993435-7689079d64d37443.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ExcellentBadge(
      position: BadgePosition.topLeft(),
      count: 1,
      showBadge: true,
      child: RRectBox(),
    ),
    ExcellentBadge(
      count: 1,
      showBadge: true,
      child: RRectBox(),
    ),
    ExcellentBadge(
      position: BadgePosition.bottomLeft(),
      count: 1,
      showBadge: true,
      child: RRectBox(),
    ),
    ExcellentBadge(
      position: BadgePosition.bottomRight(),
      count: 1,
      showBadge: true,
      child: RRectBox(),
    ),
  ],
)
```

**自定义红点数量转换器**

设置超过 500 条消息展示 500+

![](https://upload-images.jianshu.io/upload_images/1993435-5b1492c9446705e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ExcellentBadge(
  count: 600,
  badgeCountConvertor: (int count) {
    if (count <= 500) {
      return count.toString();
    }
    return '500+';
  },
  showBadge: true,
  child: Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
    color: Colors.black26,
    borderRadius: BorderRadius.circular(4.0),),
  ),
)
```

**使用红点**

![](https://upload-images.jianshu.io/upload_images/1993435-4aa5fe1eb0b50eac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ExcellentBadge(
        useRedDot: true,
        showBadge: true,
        size: 10,
        position: BadgePosition.topRight(top: -5.0, right: -5.0),
        child: Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
    color: Colors.black26,
    borderRadius: BorderRadius.circular(4.0),),),
)
```

**自定义样式**

![](https://upload-images.jianshu.io/upload_images/1993435-35ebb86b49c12188.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ExcellentBadge(
  count: 99,
  showBadge: true,
  badgeDecoration: BoxDecoration(
      color:  Colors.lightGreen,
      borderRadius: BorderRadius.all(Radius.circular(9.0)),
      border: Border.all(width: 1, color: Colors.white),
  ),
  child: Container(    width: 30,    height: 30,    decoration: BoxDecoration(    color: Colors.black26,    borderRadius: BorderRadius.circular(4.0),)),
)
```

**自定义 widget builder**

![](https://upload-images.jianshu.io/upload_images/1993435-493d001a3edf51cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ExcellentBadge(
  showBadge: true,
  count: 12,
  size: 10,
  position: BadgePosition.topRight(top: -12.0, right: -4.0),
  builder: (BuildContext context, int count) {
    return Container(
      height: 18.0,
      width: 18.0,
      child: Icon(
        Icons.star,
        color: Colors.amber,
      ),
    );
  },
  child: Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
    color: Colors.black26,
    borderRadius: BorderRadius.circular(4.0),),),
)
```

**flutter_excellent_bubble**

气泡组件，常用于 IM 消息背景

![](https://upload-images.jianshu.io/upload_images/1993435-ee7fac7174d40cc7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**BubblePosition**

用于设置带箭头气泡的箭头位置

```dart
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
```

**BubbleType**

气泡类型

```dart
enum BubbleType {
  Normal,     /// 带箭头的气泡
  RoundRect,      /// 圆角矩形气泡
}dart
```

**flutter_excellent_bubble 示例**

**圆角矩形气泡**

![](https://upload-images.jianshu.io/upload_images/1993435-048cd50091a41d80.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ExcellentBubble(
  child: Container(
      alignment: Alignment.center,
      width: 180,
      // height: 36.0,
      child: Text(
        '圆角矩形',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      )),
  bubbleType: BubbleType.RoundRect,
)
```

**设置单脚弧度数**

![](https://upload-images.jianshu.io/upload_images/1993435-c5074e71bf29243d?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ExcellentBubble(
  child: Container(
      alignment: Alignment.center,
      width: 180,
      // height: 36.0,
      child: Text(
        '绿色-左上角修改',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      )),
  bubbleType: BubbleType.RoundRect,
  topLeft: 16.0,
  backgroundColor: Colors.green,
)
```

**设置气泡箭头位置**

![](https://upload-images.jianshu.io/upload_images/1993435-11db02df959bc169?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ExcellentBubble(
      child: Text(
        '左上角',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: Colors.deepOrange,
    ),
    ExcellentBubble(
      position: BubblePosition.leftCenter,
      backgroundColor: Colors.deepOrange,
      child: Text(
        '左中角',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    ),
    ExcellentBubble(
      position: BubblePosition.leftBottom,
      backgroundColor: Colors.deepOrange,
      child: Text(
        '左下角',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    ),
  ],
)
```

**im_text_message**

Im 文本消息组件，用于展示文本消息，可支持展示自定义的 emoji 表情，支持字数限制的展开/缩放按钮。

![](https://upload-images.jianshu.io/upload_images/1993435-4cd04d6738db5659.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**im_text_message 示例**

**普通文本消息**

![](https://upload-images.jianshu.io/upload_images/1993435-349a9ac663ef12f0?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ImTextMessage(
  content: '这是文本消息',
  isMe: true,
)
```

**设置消息来源并支持 emoji 表情**

![](https://upload-images.jianshu.io/upload_images/1993435-1d45e7c11c10ee1b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ImTextMessage(
  content: '设置消息来源 [流泪]',
  isMe: false,
)
```

**设置长文本**

![](https://upload-images.jianshu.io/upload_images/1993435-81132e5ecb2f80f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ImTextMessage(
  content: '这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息这是一段长文本消息',
  isMe: true,
)
```

**设置背景色和文本样式**

![](https://upload-images.jianshu.io/upload_images/1993435-d0b23ca8f78500fe?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ImTextMessage(
  content: '设置背景色-设置文本样式',
  isMe: true,
  selfBackgroundColor: Colors.teal,
  selfTextStyle: TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.bold,
  )
)
```

**设置圆角矩形气泡类型**

![](https://upload-images.jianshu.io/upload_images/1993435-10964f8a9fb38931.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ImTextMessage(
  content: '设置「圆角矩形」气泡类型',
  isMe: true,
  bubbleType: BubbleType.RoundRect,
)
```

**重建 expandBuilder**

![](https://upload-images.jianshu.io/upload_images/1993435-afd122bd3e77847a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
ImTextMessage(
  content: '重建「展开」按钮重建「展开」按钮重建「展开」按钮重建「展开」按钮重建「展开」按钮',
  isMe: true,
  limit: 20,
  expandBuilder: (BuildContext context, bool isExpanded) {
    return Text( isExpanded ? '↑' : '↓', style: TextStyle(color: Colors.white,
      fontSize: 16.0
    ),);
  },
)
```

**im_image_message**

Im 图片组件，支持点击预览、下载和编辑功能。

![](https://upload-images.jianshu.io/upload_images/1993435-766dc0f8ad2a95e7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**im_image_message 示例**

支持图片预览和编辑

![](https://upload-images.jianshu.io/upload_images/1993435-4347f2abf332d9b1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

支持视频预览和播放


```dart
const String kLink = "https://source.unsplash.com/1900x3600/?camera,paper";
Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Container(
      padding: const EdgeInsets.all(kPadding),
      child: ImImageMessage(
        imageId: '5',
        imageUrl: kLink,
      ),
    ),
    Text(
      '默认样式',
      style: TextStyle(
        color: Colors.black87,
      ),
    ),
    Container(
      padding: const EdgeInsets.all(kPadding),
      child: ImImageMessage(
        imageId: '5',
        imageUrl: kLink,
        thumbWidth: 120,
        thumbHeight: 200,
        galleryImages: galleryImages,
      ),
    ),
    Text(
      '根据预览图宽度设置宽高',
      style: TextStyle(
        color: Colors.black87,
      ),
    ),
    Container(
      padding: const EdgeInsets.all(kPadding),
      child: ImImageMessage(
        imageId: '5',
        imageUrl: kLink,
        fit: BoxFit.cover,
      ),
    ),
    Text(
      '预览图填充模式',
      style: TextStyle(
        color: Colors.black87,
      ),
    )
  ],
)
```

**PhotoViewRouteWrapper**

图片预览页面级组件，支持下载、编辑和滑动等功能

![](https://upload-images.jianshu.io/upload_images/1993435-516aef37bbc02617?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1993435-c8f53c4ae26623fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**PhotoEditorRouteWrapper**

图片编辑器页面级组件，支持涂鸦、画笔粗细、画笔颜色选择等

![](https://upload-images.jianshu.io/upload_images/1993435-cd582d72686472fb?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1993435-638f22cbffca383e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**VideoPlayerRouteWrapper**

视频播放器页面级组件，支持拖动设置进度和下载功能

![](https://upload-images.jianshu.io/upload_images/1993435-942a7f267f48220f?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1993435-b56851f614520874.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**im_voice_message**

Im 语音组件

![](https://upload-images.jianshu.io/upload_images/1993435-afb73cac19b068ea?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1993435-3a35b6c99588488d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
const String kAudioLink = "https://www.runoob.com/try/demo_source/horse.mp3";
Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Container(
      width: 200,
      padding: const EdgeInsets.all(kPadding),
      child: ImVoiceMessage(
        isMe: true,
        duration: 145,
        remoteUrl: kAudioLink,
      ),
    ),
    Text(
      '默认样式-我',
      style: TextStyle(
        color: Colors.black87,
      ),
    ),
    Container(
      width: 200,
      padding: const EdgeInsets.all(kPadding),
      child: ImVoiceMessage(
        isMe: false,
        duration: 145,
        remoteUrl: kAudioLink,
      ),
    ),
    Text(
      '默认样式-对方',
      style: TextStyle(
        color: Colors.black87,
      ),
    ),
    Container(
      width: 200,
      padding: const EdgeInsets.all(kPadding),
      child: ImVoiceMessage(
        isMe: false,
        duration: 145,
        remoteUrl: kAudioLink,
        contentBuilder: (BuildContext context, AudioPlayer player) {
          return Row(
            children: [
              Icon(Icons.record_voice_over_rounded),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(Tool.getElapsedTime(123),),
              ),
            ],
          );
        },
      ),
    ),
    Text(
      '自定义样式',
      style: TextStyle(
        color: Colors.black87,
      ),
    ),
  ],
)
```

**im_conversation**

Im 会话消息，支持设置头像形状和滑动删除功能等，提供默认头像

![](https://upload-images.jianshu.io/upload_images/1993435-fafbaf545a9313ad?imageMogr2/auto-orient/strip)

![](https://upload-images.jianshu.io/upload_images/1993435-d972e45c9f4c7010.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**im_message**

im_message 组件是对各种消息类型组件的封装，增加头像 + 消息和发送状态

![](https://upload-images.jianshu.io/upload_images/1993435-169fe4eb1e219d72?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](https://upload-images.jianshu.io/upload_images/1993435-31d89cbe57c3cc30.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**im_sending_handler**

Im 消息发送控件，支持语音、文本框、emoji 表情、图片、拍摄等功能

![](https://upload-images.jianshu.io/upload_images/1993435-5a707fd0a16c9d5d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**[注] 关于 emoji 表情包**

需要把库 assets/emoji 和 assets/icon 目录下的文件加入项目中才能使用表情面板

## 其他

**GalleryImageInfo**

预览图类，用于 im_image_message 的预览图展示的数据

![](https://upload-images.jianshu.io/upload_images/1993435-3ad81602bb9e968c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```dart
class GalleryImageInfo {
  GalleryImageInfo({
    required this.id,
    required this.imageUrl,
    this.videoUrl,
    this.thumbWidth,
    this.thumbHeight,
    this.previewWidth,
    this.previewHeight,
    this.duration,
    this.type,
  });
  String id;
  String imageUrl;
  String? videoUrl;
  int? duration;
  int? type;
  double? thumbWidth;
  double? thumbHeight;
  double? previewWidth;
  double? previewHeight;
}
```

**PanelConfig**

面板配置类，用于自定义 im_sending_handler 的控件组

```dart
class PanelConfig {
  PanelConfig({
    required this.id,
    required this.title,
    required this.icon,
    this.callback,
  });
  String id;
  String title;
  IconData icon;
  void Function(BuildContext context)? callback;
}
```

**ImMessageType**

Im 消息类型

```dart
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
```

[注] 如何扩展消息类型

可以自定义一个 ImCustomMessageType，添加上述类的静态属性

**ImMessageStatus**

Im 消息发送状态

```dart
class ImMessageStatus {
  static const Sending = 0;        /// 发送中
  static const SendSuccess = 1;   /// 发送成功
  static const SendFailed = 2;    /// 发送失败
}
```