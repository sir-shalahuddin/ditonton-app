import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      backdropPath: '/w0eG4lpAigocIZzJYrYp3cCmyUx.jpg',
      firstAirDate: '2002-12-14',
      genreIds: [16, 35],
      id: 2,
      name: 'The Last Episode Ever',
      originalName: 'Clerks: The Animated Series',
      originalLanguage: 'en',
      overview: "Overview",
      popularity: 8.636,
      posterPath: '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
      voteAverage: 6.903,
      voteCount: 72);
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing_tv.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": '/w0eG4lpAigocIZzJYrYp3cCmyUx.jpg',
            "first_air_date": "2002-12-14",
            "genre_ids": [16, 35],
            "id": 2,
            "name": 'The Last Episode Ever',
            "original_language": "en",
            "original_name": "Clerks: The Animated Series",
            "overview": "Overview",
            "popularity": 8.636,
            "poster_path": '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
            "vote_average": 6.903,
            'vote_count': 72,
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
