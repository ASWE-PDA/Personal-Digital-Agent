import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/Movies/movie_service.dart';
import 'package:luna/environment.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'movie_service_test.mocks.dart';

@GenerateMocks([TMDB, MovieService, V3])
void main() {
  final tmdb = MockTMDB();
  MovieService movieService = MovieService();
  test('getPopularMovies returns a list of movies that is greater than 5', () async {
    final mockTMDB = MockTMDB();
    final mockMovies = {
      "page": 1,
      "total_results": 10000,
      "total_pages": 500,
      "results": [
        {
          "popularity": 1426.789,
          "vote_count": 118,
          "video": false,
          "poster_path": "/fNG7i7RqMErkcqhohV2a6cV1Ehy.jpg",
          "id": 337404,
          "adult": false,
          "backdrop_path": "/wk58aoyWpMTVkKkdjw889XfWGdL.jpg",
          "original_language": "en",
          "original_title": "Cruella",
          "genre_ids": [35, 80],
          "title": "Cruella",
          "vote_average": 8.5,
          "overview":
              "In 1970s London amidst the punk rock revolution...",
          "release_date": "2021-05-26"
        },
      ]
    };
    final mockV3 = MockV3();
    final mockMoviesService = MockMovieService();
    when(mockTMDB.v3).thenReturn(mockV3);
    when(mockV3.movies.getPopular()).thenAnswer((_) async => mockMovies);

    final result = await mockMoviesService.getPopularMovies();
    expect(result, isA<int>());
    expect(result.length, greaterThan(0));  
  });

  group('getMovieLength tests', () {
    test('returns a valid movie length', () async {

      when(tmdb.v3.movies.getDetails(123456))
      .thenAnswer((_) async=> 
        {
          "adult": false,
          "backdrop_path": "/path/to/backdrop.jpg",
          "genres": [
            {
              "id": 18,
              "name": "Drama"
            },
            {
              "id": 10749,
              "name": "Romance"
            }
          ],
          "id": 123456,
          "original_language": "en",
          "original_title": "Example Movie",
          "overview": "This is a sample movie overview.",
          "popularity": 25.678,
          "poster_path": "/path/to/poster.jpg",
          "release_date": "2022-01-01",
          "runtime": 120,
          "status": "Released",
          "tagline": "This is a sample tagline.",
          "title": "Example Movie",
          "video": false,
          "vote_average": 7.5,
          "vote_count": 100
        }
      );

      // get length of movie
      final result = await movieService.getMovieLength(123456);

      // Assert
      expect(result, isA<int>());
      expect(result, greaterThan(0));
    });

    test('returns 0 for invalid movie ID', () async {
      when(tmdb.v3.movies.getDetails(0))
      .thenAnswer((_) async=> 
        {
          "status_code": 34,
          "status_message": "The resource you requested could not be found."
        }
      );

      // Act
      final result = await movieService.getMovieLength(0);

      // Assert
      expect(result, 0);
    });
  });
}

