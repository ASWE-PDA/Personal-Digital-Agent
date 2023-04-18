import 'package:tmdb_api/tmdb_api.dart';

Future<List<dynamic>> getPopularMovies() async {
  // Initialize a new instance of the Tmdb class with your API key
  final tmdb = TMDB(ApiKeys('ca88c56934fa161dc9bcada5bfba6448', 
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjYTg4YzU2OTM0ZmExNjFkYzliY2FkYTViZmJhNjQ0OCIsInN1YiI6IjY0M2RiNmJmZWQ5NmJjMDQ4NjU5NzM0ZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VFTL78sWRA6g_ekp1hCXwJ-HG4IOeKMv2gFUaObzGLc'));


  // Retrieve a list of popular movies
  final response = await tmdb.v3.movies.getPopular();

  return response["results"];
}