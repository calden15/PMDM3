import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = "api.themoviedb.org";
  //La meva clau de l'API
  String _apiKey = "41c06768c42d8a25663476cca18dd582";
  String _language = "es-ES";
  String _page = "1";

  List<Movie> onDisplayMovie = [];
  List<Movie> onPopularMovie = [];

  Map<int, List<Cast>> casting = {};

  MoviesProvider() {
    //Inicialitzam les pelis populars i en cartellera
    this.getOnDisplayMovies();
    this.getOnPopularMovies();
  }

  getOnDisplayMovies() async {
    //print("getOnDisplayMovies");
    var url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': _page,
    });

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final nowPlayingResponse = NowPlayingResponse.fromJson(result.body);

    onDisplayMovie = nowPlayingResponse.results;

    notifyListeners();
  }

  getOnPopularMovies() async {
    var url = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _page,
    });

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final popularResponse = PopularResponse.fromJson(result.body);

    onPopularMovie = popularResponse.results;

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int idMovie) async {
    var url = Uri.https(_baseUrl, '3/movie/$idMovie/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final creditsResponse = CreditsResponse.fromJson(result.body);

    casting[idMovie] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  /*Passam per paràmetre el text que se vol cercar a la TMDB i retornam el
  resultat de la cerca. És un Future perque ho anam actualtizant cada vegada*/
  Future<List<Movie>> getOnSearchMovie(String cerca) async {
    var url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': cerca,
    });

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final searchResponse = SearchResponse.fromJson(result.body);

    return searchResponse.results;
  }
}
