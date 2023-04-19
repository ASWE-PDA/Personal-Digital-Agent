import "package:tmdb_api/tmdb_api.dart";
import "package:luna/environment.dart";


class MovieService {

  final TMDB tmdb;

  MovieService({TMDB? tmdb})
    : tmdb = tmdb ?? TMDB(ApiKeys(Environment.tmbdApiKey, Environment.tmdbApiReadAccessTokenV4));

  Future<List<dynamic>> getPopularMovies() async {

    // Retrieve a list of popular movies
    final response = await tmdb.v3.movies.getPopular();

    return response["results"];
  }

  Future<int> getMovieLength(int movieId) async {

    final response = await tmdb.v3.movies.getDetails(movieId);
    return response["runtime"];
  }
}
