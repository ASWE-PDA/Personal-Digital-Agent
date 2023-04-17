import "package:tmdb_api/tmdb_api.dart";
import "package:luna/environment.dart";

Future<List<dynamic>> getPopularMovies() async {
  // Initialize a new instance of the Tmdb class with API key
  final tmdb = TMDB(ApiKeys(Environment.tmbdApiKey, Environment.tmdbApiReadAccessTokenV4));


  // Retrieve a list of popular movies
  final response = await tmdb.v3.movies.getPopular();

  return response["results"];
}

Future<int> getMovieLength(int movieId) async {
  final tmdb = TMDB(ApiKeys(Environment.tmbdApiKey, Environment.tmdbApiReadAccessTokenV4));

  final response = await tmdb.v3.movies.getDetails(movieId);
  return response["runtime"];
}
