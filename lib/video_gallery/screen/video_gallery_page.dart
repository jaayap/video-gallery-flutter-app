import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:video_gallery/video_gallery/screen/custom_search_bar.dart';
import 'package:video_gallery/video_gallery/screen/video_grid_view.dart';
import 'package:video_gallery/video_gallery/screen/video_list_view.dart';
import 'package:video_gallery/video_gallery/video_event.dart';
import 'package:video_gallery/video_gallery/video_repository.dart';
import 'package:video_gallery/video_gallery/videos_bloc.dart';

class VideoGalleryPage extends StatefulWidget {
  const VideoGalleryPage({super.key});

  @override
  State<VideoGalleryPage> createState() => _VideoGalleryPageState();
}

class _VideoGalleryPageState extends State<VideoGalleryPage> {
  bool isGridView = true;
  final TextEditingController _searchController = TextEditingController();

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
            Expanded(
              child: BlocProvider(
                create:
                    (context) =>
                        VideosBloc(repository: VideoRepository(httpClient: http.Client()))..add(FetchVideosEvent()),
                child: BlocBuilder<VideosBloc, VideosState>(
                  builder: (context, state) {
                    return Column(
                      spacing: 16,
                      children: [
                        CustomSearchBar(
                          controller: _searchController,
                          onEditingComplete: () {
                            context.read<VideosBloc>().add(SearchVideosEvent(_searchController.text));
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        ViewToggle(
                          isGrid: isGridView,
                          onChanged: (value) {
                            setState(() => isGridView = value);
                          },
                        ),
                        (state.status != StateStatus.loaded)
                            ? const Center(child: CircularProgressIndicator())
                            : Expanded(
                              child:
                                  state.videos != null
                                      ? isGridView
                                          ? VideosGridView(videos: state.videos!)
                                          : VideoListView(videos: state.videos!)
                                      : SizedBox(),
                            ),
                      ],
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
