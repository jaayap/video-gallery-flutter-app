class VideoDto {
  final String tags;
  final String user;
  final String videoUrl;
  final String imagePreviewUrl;
  final int duration;

  const VideoDto({
    required this.tags,
    required this.user,
    required this.videoUrl,
    required this.imagePreviewUrl,
    required this.duration,
  });

  factory VideoDto.fromJson(Map<String, dynamic> json) {
    return VideoDto(
      tags: json['tags'] ?? '',
      user: json['user'] ?? '',
      videoUrl: json['videos']['tiny']['url'] ?? '',
      imagePreviewUrl: json['videos']['tiny']['thumbnail'] ?? '',
      duration: json['duration'] ?? 0,
    );
  }
}
