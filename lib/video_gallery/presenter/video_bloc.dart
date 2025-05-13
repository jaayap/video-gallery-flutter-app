import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_gallery/video_gallery/data/video_dto.dart';
import 'package:video_gallery/video_gallery/presenter/video_displayable.dart';
import 'package:video_gallery/video_gallery/presenter/video_event.dart';
import 'package:video_gallery/video_gallery/data/video_repository.dart';
import 'package:video_gallery/video_gallery/presenter/video_state.dart';

class VideoBloc extends Bloc<VideosEvent, VideosState> {
  final IVideoRepository repository;

  VideoBloc({required this.repository}) : super(VideosState()) {
    on<FetchVideosEvent>(_onFetchVideos);
    on<SearchVideosEvent>(_onSearchVideos);
  }

  Future<void> _onFetchVideos(FetchVideosEvent event, Emitter<VideosState> emit) async {
    emit(const VideosState(status: StateStatus.loading));
    try {
      final response = await repository.getVideos();

      emit(VideosState(status: StateStatus.loaded, videos: _getDisplayableVideo(response)));
    } catch (e) {
      emit(const VideosState(status: StateStatus.error));
    }
  }

  Future<void> _onSearchVideos(SearchVideosEvent event, Emitter<VideosState> emit) async {
    emit(const VideosState(status: StateStatus.loading));
    try {
      final response = await repository.getVideos(input: event.input);
      emit(VideosState(status: StateStatus.loaded, videos: _getDisplayableVideo(response)));
    } catch (e) {
      emit(const VideosState(status: StateStatus.error));
    }
  }

  List<VideoDisplayable> _getDisplayableVideo(List<VideoDto> response) {
    return response.map((video) {
      return VideoDisplayable(
        name: video.tags,
        author: video.user,
        videoUrl: video.videoUrl,
        imagePreviewUrl: video.imagePreviewUrl,
        duration: '00:${video.duration < 10 ? '0' : ''}${video.duration}',
      );
    }).toList();
  }
}
