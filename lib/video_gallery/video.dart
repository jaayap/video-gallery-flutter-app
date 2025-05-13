class Video {
  final String name;
  final String author;
  final String videoUrl;
  final String imagePreviewUrl;
  final int duration;

  const Video({
    required this.name,
    required this.author,
    required this.videoUrl,
    required this.imagePreviewUrl,
    required this.duration,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['tags'] ?? '',
      author: json['user'] ?? '',
      videoUrl: json['videos']['tiny']['url'] ?? '',
      imagePreviewUrl: json['videos']['tiny']['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}
