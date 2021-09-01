import 'package:flutter/material.dart';

class ImVoiceMsgAnimView extends StatelessWidget {
  const ImVoiceMsgAnimView({
    this.doAnim = false,
    this.color = Colors.white,
  });
  final bool doAnim;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          VoiceMsgAnimatedItem(
            color: color,
            doAnim: doAnim,
            idleHeight: 8,
            isForward: false,
          ),
          VoiceMsgAnimatedItem(
            color: color,
            doAnim: doAnim,
            idleHeight: 12,
            isForward: false,
          ),
          VoiceMsgAnimatedItem(
            color: color,
            doAnim: doAnim,
            idleHeight: 5,
            isForward: false,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class VoiceMsgAnimatedItem extends StatefulWidget {
  VoiceMsgAnimatedItem(
      {Key? key,
      required this.color,
      required this.doAnim,
      required this.idleHeight,
      required this.isForward}) {
    this.from = (idleHeight - MIN_HEIGHT) / (MAX_HEIGHT - MIN_HEIGHT);
  }
  final Color color;
  final bool doAnim;
  final double idleHeight;
  final bool isForward;
  static const double MIN_HEIGHT = 4;
  static const double MAX_HEIGHT = 12;
  static const int DURATION = 300;
  double? from;

  @override
  State<StatefulWidget> createState() {
    return VoiceMsgAnimateItemState();
  }
}

class VoiceMsgAnimateItemState extends State<VoiceMsgAnimatedItem>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    print("VoiceMsgAnimateItemState initState ${widget.doAnim}");
    controller = new AnimationController(
        duration: Duration(milliseconds: VoiceMsgAnimatedItem.DURATION),
        vsync: this);
    Animation<double> curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = new Tween(
            begin: VoiceMsgAnimatedItem.MIN_HEIGHT,
            end: VoiceMsgAnimatedItem.MAX_HEIGHT)
        .animate(curve)
          ..addListener(() {
            setState(() => {});
          });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画执行结束时反向执行动画
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //动画恢复到初始状态时执行动画（正向）
        controller.forward();
      }
    });
    if (widget.doAnim) {
      if (widget.isForward) {
        controller.forward(from: widget.from);
      } else {
        controller.reverse(from: widget.from);
      }
    }
  }

  @override
  void didUpdateWidget(VoiceMsgAnimatedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.doAnim && widget.doAnim) {
      if (widget.isForward) {
        controller.forward(from: widget.from);
      } else {
        controller.reverse(from: widget.from);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: widget.doAnim ? animation.value : widget.idleHeight,
      decoration: BoxDecoration(
          color: widget.color, borderRadius: BorderRadius.circular(1.0)),
      margin: EdgeInsets.only(left: 1.5, right: 1.5),
    );
  }

  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}
