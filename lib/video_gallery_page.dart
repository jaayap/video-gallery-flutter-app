import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:video_gallery/video_repository.dart';
import 'package:video_gallery/videos_bloc.dart';

class VideoGalleryPage extends StatefulWidget {
  const VideoGalleryPage({super.key});

  @override
  State<VideoGalleryPage> createState() => _VideoGalleryPageState();
}

class _VideoGalleryPageState extends State<VideoGalleryPage> {
  bool isGridView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Pixabay Video Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ViewToggle(
              isGrid: isGridView,
              onChanged: (value) {
                setState(() => isGridView = value);
              },
            ),
            Expanded(
              child: BlocProvider(
                create:
                    (context) =>
                        VideosBloc(repository: VideoRepository(httpClient: http.Client()))..add(FetchVideosEvent()),
                child: BlocBuilder<VideosBloc, VideosState>(
                  builder: (context, state) {
                    if (state.status != StateStatus.loaded) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return isGridView
                        ? GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 16,
                          childAspectRatio: 16 / 12,
                          children:
                              state.videos?.map((video) {
                                return VideoItem(
                                  videoUrl: video.videoUrl,
                                  imagePreviewUrl: video.imagePreviewUrl,
                                  title: video.name,
                                  duration: video.duration,
                                );
                              }).toList() ??
                              [],
                        )
                        : SingleChildScrollView(
                          child: Column(
                            spacing: 8,
                            children:
                                state.videos?.map((video) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.rectangle),
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
                                  );
                                }).toList() ??
                                [],
                          ),
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
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

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
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

class ViewToggle extends StatelessWidget {
  final bool isGrid;
  final void Function(bool) onChanged;

  const ViewToggle({super.key, required this.isGrid, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(value: true, icon: Icon(Icons.grid_view), label: Text('Grille')),
        ButtonSegment(value: false, icon: Icon(Icons.view_list), label: Text('Liste')),
      ],
      selected: {isGrid},
      onSelectionChanged: (newSelection) {
        onChanged(newSelection.first);
      },
      showSelectedIcon: false,
    );
  }
}
