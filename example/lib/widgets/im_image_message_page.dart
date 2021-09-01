import 'package:flutter/material.dart';
import 'package:example/widgets/mock_data.dart';
import 'package:flutter_im_kit/flutter_im_kit.dart';

const double kPadding = 20.0;

class ImImageMessagePage extends StatelessWidget {
  List<GalleryImageInfo> get galleryImages {
    return messages
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Im Image Message',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Im Image Message'),
          ),
          body: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(kPadding),
                  child: ImImageMessage(
                    imageId: '5',
                    imageUrl: kLink,
                    galleryImages: galleryImages,
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
                    galleryImages: galleryImages,

                  ),
                ),
                Text(
                  '预览图填充模式',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
