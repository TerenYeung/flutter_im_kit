import 'package:flutter/material.dart';
import 'package:example/widgets/mock_data.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';


class ImMessagePage extends StatefulWidget {
  const ImMessagePage({
    Key? key,
    required this.conversationId,
  }) : super(key: key);
  final String conversationId;

  @override
  _ImMessagePageState createState() => _ImMessagePageState();
}

class _ImMessagePageState extends State<ImMessagePage> {
  List<MockImMessage> _messages = messages;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  GlobalKey<ImSendingHandlerState> _sendingKey = GlobalKey();

  List<GalleryImageInfo> get galleryImages {
    return _messages
        .where((MockImMessage item) => (item.msgType == ImMessageType.Image ||
            item.msgType == ImMessageType.Video))
        .map((MockImMessage item) {
      GalleryImageInfo info = GalleryImageInfo(
        id: item.id,
        imageUrl: item.imageUrl!,
        videoUrl: item.remoteUrl,
        duration: item.duration?.toInt(),
        type: item.msgType,
        thumbWidth: item.thumbWidth,
        thumbHeight: item.thumbHeight,
        previewWidth: item.previewWidth,
        previewHeight: item.previewHeight,
      );

      return info;
    }).toList();
  }

  Widget get messageContent {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onPanDown: _resetController,
        child: NotificationListener(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels <=
                  notification.metrics.minScrollExtent) {
                /// 上拉到顶部实现刷新逻辑
                _onRefresh();
              }
            }
            return false;
          },
          child: ScrollablePositionedList.builder(
            itemCount: _messages.length,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            addAutomaticKeepAlives: true,
            initialScrollIndex: getInitialScrollIndex(_messages),
            itemBuilder: (BuildContext context, int index) {
              MockImMessage msg = _messages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ImMessage(
                  conversationId: widget.conversationId,
                  msgId: msg.id,
                  isMe: msg.isMe,
                  name: msg.name,
                  avatarUrl: msg.avatarUrl,
                  thumbWidth: msg.thumbWidth,
                  thumbHeight: msg.thumbHeight,
                  imageUrl: msg.imageUrl,
                  duration: msg.duration,
                  remoteUrl: msg.remoteUrl,
                  content: msg.content,
                  createdAt: msg.createdAt,
                  msgType: msg.msgType,
                  msgStatus: msg.msgStatus,
                  galleryImages: galleryImages,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // jumpToEnd();
    super.initState();
  }

  void jumpToEnd({bool animated = true}) {
    if (animated) {
      _itemScrollController.scrollTo(
          index: _messages.length - 1, duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } else {
      _itemScrollController.jumpTo(index: _messages.length - 1);
    }
  }

  int getInitialScrollIndex(List<MockImMessage> list) {
    return list.length - 1;
  }

  void _onRefresh() {
    /// 实现上拉刷新列表逻辑

  }

  void _resetController(DragDownDetails details) {
    if (_sendingKey.currentState?.resetController != null) {
      _sendingKey.currentState!.resetController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Im Message',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Im Message'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(flex: 1, child: messageContent),
              ImSendingHandler(
                key: _sendingKey,
                onGalleryAssetsPicked: (context, List<AssetEntity> assets) {
                  setState(() {
                    assets.forEach((element) async {
                      _messages.add(
                          MockImMessage(
                          isMe: true,
                          avatarUrl: kLink,
                          imageUrl: kLink,
                          name: element.id,
                          id: element.id,
                          conversationId: '1',
                          msgType: element.type == AssetType.image ? ImMessageType.Image : ImMessageType.Video,
                          createdAt: 123,
                        )
                      );
                    });
                  });
                  jumpToEnd();
                },
                onSendMessage: (String value, TextEditingController controller) async {
                  setState(() {
                    _messages.add(MockImMessage(
                        isMe: true,
                        avatarUrl: kLink,
                        name: '111',
                        id: '99', conversationId: '1', msgType: ImMessageType.Text, createdAt: 1231, content: value));
                    controller.clear();
                    jumpToEnd();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
