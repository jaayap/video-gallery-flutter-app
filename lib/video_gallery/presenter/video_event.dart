import 'package:equatable/equatable.dart';

abstract class VideosEvent extends Equatable {}

class FetchVideosEvent extends VideosEvent {
  @override
  List<Object?> get props => [];
}

class SearchVideosEvent extends VideosEvent {
  final String input;

  SearchVideosEvent(this.input);

  @override
  List<Object?> get props => [input];
}
