class Video {
  final String name;
  final String videoUrl;
  final String imagePreviewUrl;

  Video({required this.name, required this.videoUrl, required this.imagePreviewUrl});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['tags'] ?? '',
      videoUrl: json['videos']['tiny']['url'] ?? '',
      imagePreviewUrl: json['videos']['tiny']['thumbnail'] ?? '',
    );
  }
}