
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