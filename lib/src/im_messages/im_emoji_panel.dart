import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/im_emoji/emoji.dart';

typedef OnSystemEmojiClick = void Function(Emoji emoji);
typedef OnSystemEmojiDelete = void Function();
typedef OnSystemEmojiSend = void Function();
// typedef OnCustomEmojiClick = void Function(Emoticon emoji);

class ImEmojiPanel extends StatefulWidget {
  const ImEmojiPanel({
    Key? key,
    required this.systemEmojis,
    // this.customEmojis,
    this.onSystemEmojiClick,
    this.onSystemEmojiDelete,
    this.onSystemEmojiSend,
    // this.onCustomEmojiClick
  }) : super(key: key);

  final List<Emoji> systemEmojis;
  // final List<Emoticon> customEmojis;
  final OnSystemEmojiClick? onSystemEmojiClick;
  final OnSystemEmojiDelete? onSystemEmojiDelete;
  final OnSystemEmojiSend? onSystemEmojiSend;
  // final OnCustomEmojiClick onCustomEmojiClick;

  @override
  _ImEmojiPanelState createState() => _ImEmojiPanelState();
}

class _ImEmojiPanelState extends State<ImEmojiPanel> {
  bool isSelectSystemEmoji = true;

  @override
  Widget build(BuildContext context) {
    Function onMenuSelected = () {
      setState(() {
        isSelectSystemEmoji = !isSelectSystemEmoji;
      });
    };
    return SizedBox(
      height: 293,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(8, 0, 12, 0),
            child: Row(
              children: <Widget>[
                EmojiSelection(type: EmojiType.system, isSelected: isSelectSystemEmoji,
                  onSelected: onMenuSelected,),
                // EmojiSelection(type: EmojiType.custom, isSelected: !isSelectSystemEmoji,
                //   onSelected: onMenuSelected,),
                Spacer(),
                Visibility(
                  visible: isSelectSystemEmoji,
                  child: GestureDetector(
                    child: Image.asset('assets/icon/icon_delete_emoji.png', width: 32, height: 32,),
                    onTap: ()  {
                      if (widget.onSystemEmojiDelete != null) {
                        widget.onSystemEmojiDelete!();
                      }
                    },
                  ),
                ),
                Visibility(
                  visible: isSelectSystemEmoji,
                  child: GestureDetector(
                    child: Container(
                      height: 28,
                      constraints: BoxConstraints.tightForFinite(width: 60),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFF165DFF)
                      ),
                      margin: EdgeInsets.only(left: 16),
                      alignment: Alignment.center,
                      child: Text('发送', style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),),
                    ),
                    onTap: () {
                      if (widget.onSystemEmojiSend != null) {
                        widget.onSystemEmojiSend!();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Color(0xFFE6EBF0),
          ),
          Offstage(
            offstage: !isSelectSystemEmoji,
            child: Container(
              height: 32,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Text('表情', style: TextStyle(
                  color: Color(0xFF969BA5),
                  fontSize: 11
              ),),
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildEmojiGrid(),
          )
        ],
      ),
    );
  }

  Widget _buildEmojiGrid() {
    if(isSelectSystemEmoji) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, mainAxisSpacing: 2,
              crossAxisSpacing: 2, childAspectRatio: 1.0),
          itemCount: widget.systemEmojis.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  if (widget.onSystemEmojiClick != null) {
                    widget.onSystemEmojiClick!(widget.systemEmojis[index]);
                  }
                },
                child: Image.asset(widget.systemEmojis[index].path, width: 48, height: 48,),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
      // return Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 6),
      //   child: CustomScrollView(
      //     slivers: <Widget>[
      //       SliverPadding(
      //         padding: EdgeInsets.fromLTRB(18, 16, 18, 24),
      //         sliver: SliverGrid(
      //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 4, mainAxisSpacing: 16,
      //               crossAxisSpacing: 24, childAspectRatio: 1.0),
      //           delegate: new SliverChildBuilderDelegate(
      //                 (BuildContext context, int index) {
      //               return GestureDetector(
      //                 onTap: () {
      //                   widget.onCustomEmojiClick(widget.customEmojis[index]);
      //                 },
      //                 child: Image.network(UriHelper.getEmojiUrl(widget.customEmojis[index].staticImgUri),
      //                   width: 60, height: 60,),
      //               );
      //             },
      //             childCount: widget.customEmojis.length,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }
  }
}

enum EmojiType {
  system, custom
}

class EmojiSelection extends StatelessWidget {
  const EmojiSelection({Key? key, this.type = EmojiType.system,
    this.isSelected = false, this.onSelected}) : super(key: key);

  final EmojiType type;
  final bool isSelected;
  final Function? onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.all(8),
        decoration: isSelected? BoxDecoration(
          color: Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
        ): null,
        child: Image.asset(
          'assets/icon/icon_${type == EmojiType.system? 'system': 'custom'}_emoji.png',
          width: 24, height: 24,
        ),
      ),
      onTap: () {
        if (onSelected != null) {
          onSelected!();
        }
      }
    );
  }
}
