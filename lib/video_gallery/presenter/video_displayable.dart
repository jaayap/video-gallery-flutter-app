import 'package:equatable/equatable.dart';

class VideoDisplayable extends Equatable {
  final String name;
  final String author;
  final String videoUrl;
  final String imagePreviewUrl;
  final String duration;

  const VideoDisplayable({
    required this.name,
    required this.author,
    required this.videoUrl,
    required this.imagePreviewUrl,
    required this.duration,
  });

  @override
  List<Object?> get props => [name, author, videoUrl, imagePreviewUrl, duration];
}
