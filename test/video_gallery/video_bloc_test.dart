import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_gallery/video_gallery/video.dart';
import 'package:video_gallery/video_gallery/video_event.dart';
import 'package:video_gallery/video_gallery/video_repository.dart';
import 'package:video_gallery/video_gallery/videos_bloc.dart';

class MockVideoRepository extends Mock implements IVideoRepository {}

void main() {
  late MockVideoRepository mockRepository;
  late List<Video> fakeVideos;

  setUp(() {
    mockRepository = MockVideoRepository();
    fakeVideos = [
      const Video(
        name: 'Video 1',
        author: 'author',
        videoUrl: 'http://example.com/1.mp4',
        imagePreviewUrl: 'http://example.com/1.jpg',
        duration: 10,
      ),
      const Video(
        name: 'Video 2',
        author: 'author',
        videoUrl: 'http://example.com/2.mp4',
        imagePreviewUrl: 'http://example.com/2.jpg',
        duration: 20,
      ),
    ];
  });

  group('VideosBloc', () {
    blocTest<VideosBloc, VideosState>(
      'emits [loading, loaded] when FetchVideosEvent is added and repository succeeds',
      build: () {
        when(() => mockRepository.getVideos()).thenAnswer((_) async => fakeVideos);
        return VideosBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(FetchVideosEvent()),
      expect:
          () => [
            const VideosState(status: StateStatus.loading),
            VideosState(status: StateStatus.loaded, videos: fakeVideos),
          ],
      verify: (_) {
        verify(() => mockRepository.getVideos()).called(1);
      },
    );

    blocTest<VideosBloc, VideosState>(
      'emits [loading, error] when FetchVideosEvent fails',
      build: () {
        when(() => mockRepository.getVideos()).thenThrow(Exception('fetch error'));
        return VideosBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(FetchVideosEvent()),
      expect: () => const [VideosState(status: StateStatus.loading), VideosState(status: StateStatus.error)],
    );

    blocTest<VideosBloc, VideosState>(
      'emits [loading, loaded] when SearchVideosEvent is added and repository succeeds',
      build: () {
        when(() => mockRepository.getVideos(input: 'test')).thenAnswer((_) async => fakeVideos);
        return VideosBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(SearchVideosEvent('test')),
      expect:
          () => [
            const VideosState(status: StateStatus.loading),
            VideosState(status: StateStatus.loaded, videos: fakeVideos),
          ],
      verify: (_) {
        verify(() => mockRepository.getVideos(input: 'test')).called(1);
      },
    );

    blocTest<VideosBloc, VideosState>(
      'emits [loading, error] when SearchVideosEvent fails',
      build: () {
        when(() => mockRepository.getVideos(input: 'fail')).thenThrow(Exception('search error'));
        return VideosBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(SearchVideosEvent('fail')),
      expect: () => const [VideosState(status: StateStatus.loading), VideosState(status: StateStatus.error)],
    );
  });
}
