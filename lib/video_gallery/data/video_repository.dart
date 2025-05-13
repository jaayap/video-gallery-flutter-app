import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:video_gallery/keys/key.dart';
import 'package:video_gallery/video_gallery/data/video_dto.dart';

abstract class IVideoRepository {
  Future<List<VideoDto>> getVideos({String? input});
}

class VideoRepository extends IVideoRepository {
  final http.Client httpClient;

  VideoRepository({required this.httpClient});

  @override
  Future<List<VideoDto>> getVideos({String? input}) async {
    final formattedInput = input?.trim().replaceAll(RegExp(r'\s+'), '+') ?? '';

    final uri = Uri.parse("https://pixabay.com/api/videos/?key=$pixabeyApiKey&q=$formattedInput&lang=fr");

    try {
      http.Response response = await httpClient.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> hits = data['hits'] ?? [];
        List<VideoDto> videos = hits.map((json) => VideoDto.fromJson(json)).toList();
        return videos;
      } else {
        throw Exception("Error, status code != 200");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
