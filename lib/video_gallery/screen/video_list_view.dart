import 'package:flutter/material.dart';
import 'package:video_gallery/video_gallery/presenter/video_displayable.dart';
import 'package:video_gallery/video_gallery/screen/play_button.dart';
import 'package:video_gallery/video_player/video_player_page.dart';

class VideoListView extends StatelessWidget {
  final List<VideoDisplayable> videos;

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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerPage(videoUrl: video.videoUrl)));
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
                      spacing: 8,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(video.imagePreviewUrl, fit: BoxFit.cover, height: 30),
                            ),
                            Text(
                              video.duration,
                              style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('tags: ${video.name}', maxLines: 3, overflow: TextOverflow.ellipsis),
                              Text(
                                'auteur: ${video.author}',
                                style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        PlayButton(),
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
