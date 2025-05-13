import 'package:flutter/material.dart';
import 'package:video_gallery/video_gallery/video.dart';
import 'package:video_gallery/video_gallery/screen/play_button.dart';

class VideosGridView extends StatelessWidget {
  final List<Video> videos;

  const VideosGridView({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 16,
      childAspectRatio: 16 / 12,
      children:
          videos.map((video) {
            return VideoItem(
              videoUrl: video.videoUrl,
              imagePreviewUrl: video.imagePreviewUrl,
              title: video.name,
              duration: video.duration,
            );
          }).toList(),
    );
  }
}

class VideoItem extends StatelessWidget {
  final String videoUrl;
  final String imagePreviewUrl;
  final String title;
  final int duration;

  const VideoItem({
    super.key,
    required this.videoUrl,
    required this.imagePreviewUrl,
    required this.title,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(imagePreviewUrl, fit: BoxFit.cover),
              ),
              PlayButton(),
              Align(alignment: Alignment.bottomRight, child: Duration(duration: duration)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Titre
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, height: 1.0),
        ),
      ],
    );
  }
}

class Duration extends StatelessWidget {
  const Duration({super.key, required this.duration});

  final int duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)),
        child: Text('00:$duration', style: const TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }
}
