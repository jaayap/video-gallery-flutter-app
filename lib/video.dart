class Video {
  final String name;
  final String videoUrl;
  final String imagePreviewUrl;
  final int duration;

  Video({required this.name, required this.videoUrl, required this.imagePreviewUrl, required this.duration});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['tags'] ?? '',
      videoUrl: json['videos']['tiny']['url'] ?? '',
      imagePreviewUrl: json['videos']['tiny']['thumbnail'] ?? '',
      duration: json['duration'] ?? '',
    );
  }
}