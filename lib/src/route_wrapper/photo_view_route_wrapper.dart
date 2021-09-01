import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_im_kit/src/common_widgets.dart';
import 'package:flutter_im_kit/src/flutter_excellent_image_painter/flutter_excellent_image_painter.dart';
import 'package:flutter_im_kit/src/model/gallery_image_info.dart';
import 'package:flutter_im_kit/src/route_wrapper/photo_editor_route_wrapper.dart';
import 'package:flutter_im_kit/src/route_wrapper/video_player_route_wrapper.dart';
import 'package:flutter_im_kit/src/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PhotoViewRouteWrapper extends StatefulWidget {
  const PhotoViewRouteWrapper({
    Key? key,
    this.galleryImages = const [],
    this.initialIndex = 0,
    this.initialScale = PhotoViewComputedScale.covered,
    this.minScale,
    this.maxScale,
    this.scrollDirection = Axis.horizontal,
    this.loadingBuilder,
    this.onPageSlide,
    this.onDownloadTap,
    this.onPlayerDownloadTap,
    this.onEditorDownloadTap,
    this.onEditorSendTap,
    this.sliderBuilder,
    this.colorPickerBuilder,
    this.bottomControllerBuilder,
    this.autoPlay = true,
    this.playerPlayIcon,
    this.playerDownloadIcon,
    this.showPlayerDownloadBtn = true,
    this.showPlayerProgress = true,
  }) : super(key: key);

  final List<GalleryImageInfo> galleryImages;
  final int initialIndex;
  final Axis scrollDirection;
  final LoadingBuilder? loadingBuilder;
  final void Function(int currentIndex)? onPageSlide;
  final void Function(Uint8List bytes, GalleryImageInfo imageInfo)?
      onDownloadTap;
  final Function(String videoUrl)? onPlayerDownloadTap;
  final Function(Uint8List bytes)? onEditorDownloadTap;
  final Function(Uint8List bytes)? onEditorSendTap;
  final PhotoViewComputedScale? minScale;
  final PhotoViewComputedScale? maxScale;
  final PhotoViewComputedScale? initialScale;
  final Widget Function(
      BuildContext context, PainterController painterController)? sliderBuilder;
  final Widget Function(
          BuildContext context, PainterController painterController)?
      colorPickerBuilder;
  final Widget Function(
          BuildContext context, PainterController painterController)?
      bottomControllerBuilder;
  final Widget? playerDownloadIcon;
  final Widget? playerPlayIcon;
  final bool? showPlayerDownloadBtn;
  final bool? showPlayerProgress;
  final bool? autoPlay;

  @override
  _PhotoViewRouteWrapperState createState() => _PhotoViewRouteWrapperState();
}

class _PhotoViewRouteWrapperState extends State<PhotoViewRouteWrapper> {
  late int _currentIndex;
  LRUCache<Uint8List> imageCache = LRUCache();
  bool _downloadLocked = false;
  GalleryImageInfo get _galleryItem => widget.galleryImages[_currentIndex];

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    _getImageData(_galleryItem.id, _galleryItem.imageUrl);
    super.initState();
  }

  Widget get _topController {
    return Container(
      height: 80.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16.0,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 32,
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _centerContent {
    return Container(
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.white),
          ),
      child: PhotoViewGallery.builder(
          itemCount: widget.galleryImages.length,
          scrollPhysics: const BouncingScrollPhysics(),
          scrollDirection: widget.scrollDirection,
          onPageChanged: _onPageChanged,
          loadingBuilder: widget.loadingBuilder ??
              (context, event) {
                if (event == null) {
                  return Container(
                      color: Colors.black,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFE8F3FF)),
                            backgroundColor: Colors.black.withOpacity(.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '资源努力加载中...',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ));
                }

                final value = event.cumulativeBytesLoaded /
                    (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

                final percentage = (100 * value).floor();
                return Container(
                  color: Colors.black,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '资源已加载$percentage%',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                );
              },
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions.customChild(
              initialScale: widget.initialScale,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
              child: _galleryItem.type == ImMessageType.Image
                  ? ImImage(imageUrl: _galleryItem.imageUrl)
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        ImImage(
                          imageUrl: _galleryItem.imageUrl,
                        ),
                        Positioned.fill(
                          child: Container(
                            // width: widget.thumbWidth,
                            // height: widget.thumbHeight,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(.3),
                                Colors.black.withOpacity(.3)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return VideoPlayerRouteWrapper(
                                  // imageUrl: _galleryItem.imageUrl,
                                  videoUrl: _galleryItem.videoUrl!,
                                  autoPlay: widget.autoPlay,
                                  downloadIcon: widget.playerDownloadIcon,
                                  playIcon: widget.playerPlayIcon,
                                  showDownloadBtn: widget.showPlayerDownloadBtn,
                                  showProgress: widget.showPlayerProgress,
                                  onCloseTap: (context) {
                                    Navigator.of(context)..pop()..pop();
                                  },
                                  onDownloadTap: (String videoUrl) {
                                    if (widget.onPlayerDownloadTap != null) {
                                      widget.onPlayerDownloadTap!(videoUrl);
                                    }
                                  },
                                );
                              }),
                            );
                          },
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 68,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
            );
          }),
    );
  }

  Widget get _bottomController {
    return Container(
      height: 80.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16.0,
            child: IconButton(
                iconSize: 32,
                onPressed: () async {
                  /// 点击进入图片编辑页
                  EasyLoading.show(status: '图片加载中...');
                  Uint8List data = await _getImageData(
                      _galleryItem.id, _galleryItem.imageUrl);
                  EasyLoading.dismiss();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return PhotoEditorRouteWrapper(
                        data: data,
                        sliderBuilder: widget.sliderBuilder,
                        colorPickerBuilder: widget.colorPickerBuilder,
                        bottomControllerBuilder: widget.bottomControllerBuilder,
                        onDownload: (Uint8List bytes) {
                          if (widget.onEditorDownloadTap != null) {
                            widget.onEditorDownloadTap!(bytes);
                          }
                        },
                        onSend: (Uint8List bytes) {
                          if (widget.onEditorSendTap != null) {
                            widget.onEditorSendTap!(bytes);
                          }
                        },
                      );
                    }),
                  );
                },
                icon: Icon(
                  Icons.apps_rounded,
                  color: Colors.white,
                )),
          ),
          Positioned(
            right: 16.0,
            child: IconButton(
                iconSize: 32,
                onPressed: () async {
                  if (widget.onDownloadTap != null && !_downloadLocked) {
                    _downloadLocked = true;
                    Uint8List bytes = await _getImageData(
                        _galleryItem.id, _galleryItem.imageUrl);
                    widget.onDownloadTap!(bytes, _galleryItem);
                    _downloadLocked = false;
                  }
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _onPageChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });

    await _getImageData(_galleryItem.id, _galleryItem.imageUrl);

    if (widget.onPageSlide != null) {
      widget.onPageSlide!(index);
    }
  }

  Future<Uint8List> _getImageData(String key, String url) async {
    if (imageCache.get(key) != null) {
      return imageCache.get(key)!;
    }

    ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
    Uint8List bytes = imageData.buffer.asUint8List();
    imageCache.put(key, bytes);

    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Positioned(child: _topController),
              Positioned(
                top: 80.0,
                left: 0.0,
                right: 0.0,
                bottom: 80.0,
                child: _centerContent,
              ),
              Visibility(
                visible: ImMessageType.Image == _galleryItem.type,
                child: Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: _bottomController,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
