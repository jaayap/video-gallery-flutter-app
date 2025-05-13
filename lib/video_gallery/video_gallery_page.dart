import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:video_gallery/video_gallery/video_grid_view.dart';
import 'package:video_gallery/video_gallery/video_list_view.dart';
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
          spacing: 16,
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
                    return state.videos != null
                        ? isGridView
                            ? VideosGridView(videos: state.videos!)
                            : VideoListView(videos: state.videos!)
                        : SizedBox();
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
