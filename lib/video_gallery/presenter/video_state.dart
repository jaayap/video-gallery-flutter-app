import 'package:equatable/equatable.dart';
import 'package:video_gallery/video_gallery/presenter/video_displayable.dart';

enum StateStatus { initial, loading, loaded, error }

class VideosState extends Equatable {
  final StateStatus status;
  final List<VideoDisplayable>? videos;

  const VideosState({this.status = StateStatus.initial, this.videos});

  @override
  List<Object?> get props => [status, videos];
}
