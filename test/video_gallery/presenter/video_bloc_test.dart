import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_gallery/video_gallery/data/video_dto.dart';
import 'package:video_gallery/video_gallery/presenter/video_displayable.dart';
import 'package:video_gallery/video_gallery/presenter/video_event.dart';
import 'package:video_gallery/video_gallery/data/video_repository.dart';
import 'package:video_gallery/video_gallery/presenter/video_bloc.dart';
import 'package:video_gallery/video_gallery/presenter/video_state.dart';

class MockVideoRepository extends Mock implements IVideoRepository {}

void main() {
  late MockVideoRepository mockRepository;
  late List<VideoDto> fakeVideosDto;
  late List<VideoDisplayable> fakeVideosDisplayable;

  setUp(() {
    mockRepository = MockVideoRepository();
    fakeVideosDto = [
      const VideoDto(
        name: 'sea, beach, sunset',
        author: 'author',
        videoUrl: 'http://example.com/1.mp4',
        imagePreviewUrl: 'http://example.com/1.jpg',
        duration: 10,
      ),
      const VideoDto(
        name: 'sea, beach, sunset',
        author: 'author',
        videoUrl: 'http://example.com/2.mp4',
        imagePreviewUrl: 'http://example.com/2.jpg',
        duration: 20,
      ),
    ];
    fakeVideosDisplayable = [
      const VideoDisplayable(
        name: 'sea, beach, sunset',
        author: 'author',
        videoUrl: 'http://example.com/1.mp4',
        imagePreviewUrl: 'http://example.com/1.jpg',
        duration: '00:10',
      ),
      const VideoDisplayable(
        name: 'sea, beach, sunset',
        author: 'author',
        videoUrl: 'http://example.com/2.mp4',
        imagePreviewUrl: 'http://example.com/2.jpg',
        duration: '00:20',
      ),
    ];
  });

  group('VideosBloc', () {
    blocTest<VideoBloc, VideosState>(
      'emits [loading, loaded] when FetchVideosEvent is added and repository succeeds',
      build: () {
        when(() => mockRepository.getVideos()).thenAnswer((_) async => fakeVideosDto);
        return VideoBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(FetchVideosEvent()),
      expect:
          () => [
            const VideosState(status: StateStatus.loading),
            VideosState(status: StateStatus.loaded, videos: fakeVideosDisplayable),
          ],
      verify: (_) {
        verify(() => mockRepository.getVideos()).called(1);
      },
    );

    blocTest<VideoBloc, VideosState>(
      'emits [loading, error] when FetchVideosEvent fails',
      build: () {
        when(() => mockRepository.getVideos()).thenThrow(Exception('fetch error'));
        return VideoBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(FetchVideosEvent()),
      expect: () => const [VideosState(status: StateStatus.loading), VideosState(status: StateStatus.error)],
    );

    blocTest<VideoBloc, VideosState>(
      'emits [loading, loaded] when SearchVideosEvent is added and repository succeeds',
      build: () {
        when(() => mockRepository.getVideos(input: 'test')).thenAnswer((_) async => fakeVideosDto);
        return VideoBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(SearchVideosEvent('test')),
      expect:
          () => [
            const VideosState(status: StateStatus.loading),
            VideosState(status: StateStatus.loaded, videos: fakeVideosDisplayable),
          ],
      verify: (_) {
        verify(() => mockRepository.getVideos(input: 'test')).called(1);
      },
    );

    blocTest<VideoBloc, VideosState>(
      'emits [loading, error] when SearchVideosEvent fails',
      build: () {
        when(() => mockRepository.getVideos(input: 'fail')).thenThrow(Exception('search error'));
        return VideoBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(SearchVideosEvent('fail')),
      expect: () => const [VideosState(status: StateStatus.loading), VideosState(status: StateStatus.error)],
    );
  });
}
