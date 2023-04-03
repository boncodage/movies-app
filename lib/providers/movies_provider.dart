import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  
  final String _baseUrl = 'api.themoviedb.org';
  final String _token = '';
  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCasts = {};


  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 250),
  );

  final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionsStream => _suggestionsStreamController.stream; 

  int _page = 0;
  
  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  getNowPlayingMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
     'language': 'es-ES',
     'page': '1'
    });

    var httpResponse = await http.get(url, headers: { 'Authorization': _token });
    var response = NowPlayingMoviesResponse.fromRawJson(httpResponse.body);
    nowPlayingMovies = response.results ?? [];
    notifyListeners();
  }

  getPopularMovies() async {
    _page++;
    var url = Uri.https(_baseUrl, '3/movie/popular', {
     'language': 'es-ES',
     'page': '$_page'
    });

    var httpResponse = await http.get(url, headers: { 'Authorization': _token });
    var response = PopularMoviesResponse.fromRawJson(httpResponse.body);
    popularMovies = [ ...popularMovies, ...response.results ?? [] ];
    notifyListeners();
  }

  Future<List<Cast>> getActorsMovie(int movieId) async {
    var url = Uri.https(_baseUrl, '3/movie/$movieId/credits');
    if (movieCasts.containsKey(movieId)) {
      return movieCasts[movieId]!;
    }

    var httpResponse = await http.get(url, headers: { 'Authorization': _token });
    var response = ActorsMovieResponse.fromRawJson(httpResponse.body);
    movieCasts[movieId] = response.cast;
    return response.cast;
  }


  Future<List<Movie>> searchMovies(String query) async {
    var url = Uri.https(_baseUrl, '3/search/movie', { 'query': query });
    var httpResponse = await http.get(url, headers: { 'Authorization': _token });
    var response = SearchResponse.fromRawJson(httpResponse.body);
    return response.results ?? <Movie>[];
  }

  void getSuggestionsByQuery( String query ){
    debouncer.value = '';
    debouncer.onValue = ( value ) async {
      final results = await searchMovies(value);
      _suggestionsStreamController.add(results);

    };
    final timer = Timer(const Duration(milliseconds: 300), () {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then(( _ ) => timer.cancel());
  }
}
