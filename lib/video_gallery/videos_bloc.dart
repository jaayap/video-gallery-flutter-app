import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_gallery/video_gallery/video.dart';
import 'package:video_gallery/video_gallery/video_event.dart';
import 'package:video_gallery/video_gallery/video_repository.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final IVideoRepository repository;

  VideosBloc({required this.repository}) : super(VideosState()) {
    on<FetchVideosEvent>(_onFetchVideos);
    on<SearchVideosEvent>(_onSearchVideos);
  }

  Future<void> _onFetchVideos(FetchVideosEvent event, Emitter<VideosState> emit) async {
    emit(const VideosState(status: StateStatus.loading));
    try {
      final response = await repository.getVideos();
      emit(VideosState(status: StateStatus.loaded, videos: response));
    } catch (e) {
      emit(const VideosState(status: StateStatus.error));
    }
  }

  Future<void> _onSearchVideos(SearchVideosEvent event, Emitter<VideosState> emit) async {
    emit(const VideosState(status: StateStatus.loading));
    try {
      final response = await repository.getVideos(input: event.input);
      emit(VideosState(status: StateStatus.loaded, videos: response));
    } catch (e) {
      emit(const VideosState(status: StateStatus.error));
    }
  }
}

enum StateStatus { initial, loading, loaded, error }

class VideosState extends Equatable {
  final StateStatus status;
  final List<Video>? videos;

  const VideosState({this.status = StateStatus.initial, this.videos});

  @override
  List<Object?> get props => [status, videos];
}
