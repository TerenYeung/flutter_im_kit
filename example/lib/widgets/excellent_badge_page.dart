import 'package:flutter/material.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';

const double kPadding = 20.0;

class ExcellentBadgePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Excellent Badge',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Excellent Badge'),
        ),
        body: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Row(
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
                ),
              ),
              Text('badge position', style: TextStyle(
                color: Colors.black87,
              ),),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: ExcellentBadge(
                  count: 0,
                  showBadge: true,
                  child: RRectBox(),
                ),
              ),
              Text('badge with zero', style: TextStyle(
                color: Colors.black87,
              ),),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: ExcellentBadge(
                  count: 99,
                  showBadge: true,
                  badgeDecoration: BoxDecoration(
                      color:  Colors.lightGreen,
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: RRectBox(),
                ),
              ),
              Text('badge with customize decoration', style: TextStyle(
                color: Colors.black87,
              ),),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: ExcellentBadge(
                  count: 101,
                  showBadge: true,
                  child: RRectBox(),
                ),
              ),
              Text('badge exceeds specific count', style: TextStyle(
                color: Colors.black87,
              ),),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: ExcellentBadge(
                  count: 600,
                  badgeCountConvertor: (int count) {
                    if (count <= 500) {
                      return count.toString();
                    }
                    return '500+';
                  },
                  showBadge: true,
                  child: RRectBox(),
                ),
              ),
              Text('badge with custom badgeCountConvertor', style: TextStyle(
                color: Colors.black87,
              ),),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: ExcellentBadge(
                  useRedDot: true,
                  showBadge: true,
                  size: 10,
                  position: BadgePosition.topRight(top: -5.0, right: -5.0),
                  child: RRectBox(),
                ),
              ),
              Text('badge with red dot', style: TextStyle(
                color: Colors.black87,
              ),),
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: ExcellentBadge(
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
                  child: RRectBox(),
                ),
              ),
              Text('badge with customization', style: TextStyle(
                color: Colors.black87,
              ),),
            ],
          ),
        )
      ),
    );
  }
}