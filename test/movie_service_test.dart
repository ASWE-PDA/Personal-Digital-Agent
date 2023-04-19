import 'package:flutter_test/flutter_test.dart';
import 'package:luna/Services/Movies/movie_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tmdb_api/tmdb_api.dart';

import 'movie_service_test.mocks.dart';

final movieData = {
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

final movieDetails = {
  "adult": false,
  "backdrop_path": "/nxxuWC32Y6TULj4VnVwMPUFLIpK.jpg",
  "belongs_to_collection": null,
  "budget": 5000000,
  "genres": [
    {
      "id": 18,
      "name": "Drama"
    },
    {
      "id": 80,
      "name": "Crime"
    }
  ],
  "homepage": "",
  "id": 12345,
  "imdb_id": "tt0111161",
  "original_language": "en",
  "original_title": "The Shawshank Redemption",
  "overview": "Framed in the 1940s for the double murder of his wife...",
  "popularity": 38.906,
  "poster_path": "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
  "production_companies": [
    {
      "id": 97,
      "logo_path": "/7znWcbDd4PcJzJUlJxYqAlPPykp.png",
      "name": "Castle Rock Entertainment",
      "origin_country": "US"
    },
    {
      "id": 174,
      "logo_path": "/ky0xOc5OrhzkZ1N6KyUxacfQsCk.png",
      "name": "Warner Bros. Pictures",
      "origin_country": "US"
    }
  ],
  "production_countries": [
    {
      "iso_3166_1": "US",
      "name": "United States of America"
    }
  ],
  "release_date": "1994-09-23",
  "revenue": 28341469,
  "runtime": 142,
  "spoken_languages": [
    {
      "english_name": "English",
      "iso_639_1": "en",
      "name": "English"
    }
  ],
  "status": "Released",
  "tagline": "Fear can hold you prisoner. Hope can set you free.",
  "title": "The Shawshank Redemption",
  "video": false,
  "vote_average": 8.7,
  "vote_count": 21072
};

final mockTMDB = MockTMDB();
final mockV3 = MockV3();
final mockMovies = MockMovies();
final mockMoviesService = MockMovieService();
final movieService = MovieService(tmdb: mockTMDB);

@GenerateMocks([TMDB, MovieService, V3, Movies])
void main() {
  group('getPopularMovies', () {
    test('returns a list of movies that is greater than 0', () async {
      when(mockTMDB.v3).thenReturn(mockV3);
      when(mockV3.movies).thenReturn(mockMovies);
      when(mockMovies.getPopular()).thenAnswer((_) async => movieData);

      final result = await movieService.getPopularMovies(); 
      expect(result, isA<List<dynamic>>());
      expect(result.length, greaterThan(0));
    });
  });

  test('getMovieLength returns the correct movie length', () async {
    final movieId = 12345;
    final expectedLength = 142; // replace this with the expected length in minutes

    // Set up the mock response for the API call
    when(mockTMDB.v3).thenReturn(mockV3);
    when(mockV3.movies).thenReturn(mockMovies);
    when(mockMovies.getDetails(movieId)).thenAnswer((_) async => movieDetails);

    // Call the method being tested
    final result = await movieService.getMovieLength(movieId);

    // Make assertions about the result
    expect(result, equals(expectedLength));
  });
}