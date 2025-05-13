import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:video_gallery/video_gallery/data/video_dto.dart';
import 'package:video_gallery/video_gallery/data/video_repository.dart';

void main() {
  const mockJson = '''
      {
        "total":1,
        "totalHits":1,
        "hits":[
          {
            "tags":"sea, beach, sunset",
            "videos":{
              "tiny":{
                "url":"https://cdn.pixabay.com/video/2025/04/29/275633_tiny.mp4",
                "thumbnail":"https://cdn.pixabay.com/video/2025/04/29/275633_tiny.jpg"
              }
            },
            "duration": 12
          }
        ]
      }
      ''';

  test('returns list of videos if the http call completes successfully', () async {
    // GIVEN
    final client = MockClient((request) async {
      return http.Response(mockJson, 200);
    });

    final service = VideoRepository(httpClient: client); // on injecte le client
    final videos = await service.getVideos();

    expect(videos, isA<List<VideoDto>>());
    expect(videos.length, 1);
    expect(videos[0].tags, contains("sea"));
    expect(videos[0].videoUrl, startsWith("https://cdn.pixabay.com"));
    expect(videos[0].imagePreviewUrl, endsWith(".jpg"));
  });

  test('returns list of videos if the http call completes successfully when call with input', () async {
    // GIVEN
    final client = MockClient((request) async {
      return http.Response(mockJson, 200);
    });

    final service = VideoRepository(httpClient: client); // on injecte le client
    final videos = await service.getVideos(input: 'rabbit cute');

    expect(videos, isA<List<VideoDto>>());
    expect(videos.length, 1);
  });

  test('if result code != 200 throw an exception', () async {
    // GIVEN
    final client = MockClient((request) async {
      return http.Response('Not Found', 404);
    });

    final repository = VideoRepository(httpClient: client);

    // WHEN & THEN :
    expect(() async => await repository.getVideos(), throwsException);
  });
}
