class VideoDto {
  final String name;
  final String author;
  final String videoUrl;
  final String imagePreviewUrl;
  final int duration;

  const VideoDto({
    required this.name,
    required this.author,
    required this.videoUrl,
    required this.imagePreviewUrl,
    required this.duration,
  });

  factory VideoDto.fromJson(Map<String, dynamic> json) {
    return VideoDto(
      name: json['tags'] ?? '',
      author: json['user'] ?? '',
      videoUrl: json['videos']['tiny']['url'] ?? '',
      imagePreviewUrl: json['videos']['tiny']['thumbnail'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}
