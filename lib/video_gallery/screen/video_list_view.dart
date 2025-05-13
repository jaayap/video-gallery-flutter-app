import 'package:flutter/material.dart';
import 'package:video_gallery/video_gallery/video.dart';
import 'package:video_gallery/video_gallery/screen/play_button.dart';
import 'package:video_gallery/video_player/video_player_page.dart';

class VideoListView extends StatelessWidget {
  final List<Video> videos;

  const VideoListView({super.key, required this.videos});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 8,
        children:
            videos.map((video) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(videoUrl: video.videoUrl),
                    ),
                  );
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        PlayButton(),
                        SizedBox(width: 8),
                        Expanded(child: Text(video.name)),
                        Text('00:${video.duration}'),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
