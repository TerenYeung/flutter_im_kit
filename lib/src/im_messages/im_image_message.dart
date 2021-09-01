import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/common_widgets.dart';
import 'package:flutter_im_kit/src/model/gallery_image_info.dart';
import 'package:flutter_im_kit/src/route_wrapper/photo_view_route_wrapper.dart';
import 'package:flutter_im_kit/src/style.dart';
import 'package:flutter_im_kit/src/utils.dart';
import 'package:photo_view/photo_view.dart';

class ImImageMessage extends StatefulWidget {
  const ImImageMessage({
    Key? key,
    required this.imageId,
    required this.imageUrl,
    this.thumbWidth = 100,
    this.thumbHeight = 100,
    this.previewWidth = 500,
    this.previewHeight = 500,
    this.fit = BoxFit.contain,
    this.type = ImMessageType.Image,
    this.duration,
    this.videoUrl,
    this.borderRadius = 4.0,
    this.galleryImages = const [],
    this.initialScale = PhotoViewComputedScale.covered,
    this.minScale,
    this.maxScale,
    this.scrollDirection = Axis.horizontal,
    this.loadingBuilder,
    this.onPageSlide,
    this.onDownloadTap,
    this.builder,
  }) : super(key: key);
  final String imageId;
  final String imageUrl;
  final double? thumbWidth;
  final double? thumbHeight;
  final double? previewWidth;
  final double? previewHeight;
  final BoxFit? fit;
  final int? type;
  final int? duration;
  final String? videoUrl;
  final double borderRadius;
  final List<GalleryImageInfo> galleryImages;
  final Axis scrollDirection;
  final LoadingBuilder? loadingBuilder;
  final void Function(int currentIndex)? onPageSlide;
  final void Function(Uint8List bytes, GalleryImageInfo imageInfo)?
      onDownloadTap;
  final PhotoViewComputedScale? minScale;
  final PhotoViewComputedScale? maxScale;
  final PhotoViewComputedScale? initialScale;
  final BuilderType? builder;

  @override
  _ImImageMessageState createState() => _ImImageMessageState();
}

class _ImImageMessageState extends State<ImImageMessage> {
  double get maxWidth => MediaQueryData.fromWindow(window).size.width * .62;

  double get maxHeight =>
      maxWidth / ((widget.thumbWidth ?? 100) / (widget.thumbHeight ?? 100));

  Widget get _imageView {
    return ImImage(
      imageUrl: widget.imageUrl,
      width: widget.thumbWidth,
      height: widget.thumbHeight,
      fit: widget.fit,
    );
  }

  Widget get _videoView {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImImage(
          imageUrl: widget.imageUrl,
          width: widget.thumbWidth,
          height: widget.thumbHeight,
          fit: widget.fit,
        ),
        Positioned.fill(
          child: Container(
            // width: widget.thumbWidth,
            // height: widget.thumbHeight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(.3), Colors.black.withOpacity(.3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
            ),
          ),
        ),
        Icon(
          Icons.play_arrow_rounded,
          size: 36,
          color: Colors.white,
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Text(
              widget.duration != null
                  ? Tool.getElapsedTime(widget.duration!)
                  : "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              )),
        ),
      ],
    );
  }

  void _onImageItemTap() {
    int index = widget.galleryImages
        .indexWhere((GalleryImageInfo info) => info.id == widget.imageId);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PhotoViewRouteWrapper(
        initialIndex: index,
        initialScale: widget.initialScale,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        scrollDirection: widget.scrollDirection,
        loadingBuilder: widget.loadingBuilder,
        galleryImages: widget.galleryImages,
        onPageSlide: widget.onPageSlide,
        onDownloadTap: widget.onDownloadTap,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context);
    }

    return GestureDetector(
      onTap: _onImageItemTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Style.IMAGE_PLACEHOLDER_BG,
        ),
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: widget.type == ImMessageType.Image ? _imageView : _videoView,
      ),
    );
  }
}
