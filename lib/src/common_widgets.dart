import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_im_kit/src/style.dart';

class RRectBox extends StatelessWidget {
  const RRectBox({
    Key? key,
    this.color = Colors.black26,
    this.borderRadius = 4.0,
    this.width = 30,
    this.height = 30,
  }) : super(key: key);
  final Color? color;
  final double? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
    );
  }
}

class ImAvatar extends StatelessWidget {
  const ImAvatar({
    Key? key,
    this.avatarUrl,
    this.avatarSize = 44.0,
    this.avatarShape = BoxShape.circle,
    this.avatarBorderRadius = 44.0 / 8.0,
    this.fit = BoxFit.cover,
    required this.placeholderText,
    this.placeholderTextStyle = const TextStyle(
        color: Style.TEXT_TITLE, fontWeight: FontWeight.bold, fontSize: 16.0),
    this.backgroundColor = Colors.lightBlue,
    this.color = Colors.white,
  }) : super(key: key);
  final String? avatarUrl;
  final double? avatarSize;
  final BoxShape? avatarShape;
  final double avatarBorderRadius;
  final BoxFit? fit;
  final TextStyle placeholderTextStyle;
  final String placeholderText;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return avatarShape == BoxShape.circle
        ? avatarUrl != null
            ? ClipOval(
                child: Image.network(
                  avatarUrl!,
                  width: avatarSize,
                  height: avatarSize,
                  fit: fit,
                ),
              )
            : Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(avatarSize! / 2.0),
                ),
                child: Center(
                  child: Text(
                    placeholderText.characters.first.toUpperCase(),
                    style: placeholderTextStyle
                        .merge(TextStyle(color: Colors.white)),
                  ),
                ),
              )
        : Container(
            child: avatarUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(avatarBorderRadius),
                    child: Image.network(
                      avatarUrl!,
                      width: avatarSize,
                      height: avatarSize,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(avatarBorderRadius),
                    ),
                    child: Center(
                      child: Text(
                        placeholderText.characters.first.toUpperCase(),
                        style: placeholderTextStyle
                            .merge(TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
          );
  }
}

class ImImage extends StatelessWidget {
  const ImImage({
    Key? key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);
  final String imageUrl;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return imageUrl.startsWith('http')
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder:
                placeholder ?? (context, url) => CupertinoActivityIndicator(),
            errorWidget: errorWidget ??
                (context, url, error) => Icon(Icons.error_outline),
          )
        : Image.file(
            File(imageUrl),
            width: width,
            height: height,
            fit: fit,
          );
  }
}
