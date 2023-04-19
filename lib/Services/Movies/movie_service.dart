import "package:tmdb_api/tmdb_api.dart";
import "package:luna/environment.dart";

/// Gets a list of popular movies.
///
/// Returns a list of popular movies.
Future<List<dynamic>> getPopularMovies() async {
  // Initialize a new instance of the Tmdb class with API key
  final tmdb = TMDB(
      ApiKeys(Environment.tmbdApiKey, Environment.tmdbApiReadAccessTokenV4));

  // Retrieve a list of popular movies
  final response = await tmdb.v3.movies.getPopular();
  return response["results"];
}

/// Gets the length of a movie with the given [movieId].
///
/// Returns the length of the movie in minutes.
Future<int> getMovieLength(int movieId) async {
  final tmdb = TMDB(
      ApiKeys(Environment.tmbdApiKey, Environment.tmdbApiReadAccessTokenV4));

  final response = await tmdb.v3.movies.getDetails(movieId);
  return response["runtime"];
}
