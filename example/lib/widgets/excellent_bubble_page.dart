import 'package:flutter/material.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';

const double kPadding = 20.0;

class ExcellentBubblePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Excellent Bubble',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Excellent Bubble'),
          ),
          body: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: ExcellentBubble(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: ExcellentBubble(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Row(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ExcellentBubble(
                        position: BubblePosition.topLeft,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Text(
                          '上左角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ExcellentBubble(
                        position: BubblePosition.topCenter,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Text(
                          '上中角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ExcellentBubble(
                        position: BubblePosition.topRight,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: Text(
                          '上右角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ExcellentBubble(
                        position: BubblePosition.rightTop,
                        backgroundColor: Colors.brown,
                        child: Text(
                          '右上角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ExcellentBubble(
                        position: BubblePosition.rightCenter,
                        backgroundColor: Colors.brown,
                        child: Text(
                          '右中角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ExcellentBubble(
                        position: BubblePosition.rightBottom,
                        backgroundColor: Colors.brown,
                        child: Text(
                          '右下角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ExcellentBubble(
                        position: BubblePosition.bottomLeft,
                        backgroundColor: Colors.pink,
                        child: Text(
                          '下左角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ExcellentBubble(
                        position: BubblePosition.bottomCenter,
                        backgroundColor: Colors.pink,
                        child: Text(
                          '下中角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ExcellentBubble(
                        position: BubblePosition.bottomRight,
                        backgroundColor: Colors.pink,
                        child: Text(
                          '下右角',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
