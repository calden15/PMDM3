import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class SearchMovieDelegate extends SearchDelegate {
  /*Lista de pel·lícules populars que es mostraran per defecte si no hi ha cap
  cerca*/
  final List<Movie> movies;

  //Constructor
  SearchMovieDelegate(this.movies);

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          //Borra el text
          query = "";
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        //Tanca la pantalla de cerca
        close(context, Movie);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Si hi ha una cerca
    if (query != "") {
      final moviesProvider =
          Provider.of<MoviesProvider>(context, listen: false);
      return FutureBuilder(
          future: moviesProvider.getOnSearchMovie(query),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final searchMovies = snapshot.data!;
            int lon = 15;
            if (searchMovies.length < 15) {
              lon = searchMovies.length;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              height: double.infinity,
              // color: Colors.red,
              child: ListView.builder(
                  itemCount: lon,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                      MovieCard(movie: searchMovies[index])),
            );
          });
    }
    //Si no hi ha cap cerca no es mostra res
    return Center();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Si hi ha una cerca s'envia el text i es retorna una llista amb el resultats
    if (query != "") {
      final moviesProvider =
          Provider.of<MoviesProvider>(context, listen: false);
      return FutureBuilder(
          future: moviesProvider.getOnSearchMovie(query),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final searchMovies = snapshot.data!;
            int lon = 15;
            if (searchMovies.length < 15) {
              lon = searchMovies.length;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              height: double.infinity,
              // color: Colors.red,
              child: ListView.builder(
                  itemCount: lon,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                      MovieCard(movie: searchMovies[index])),
            );
          });
    }
    //Si no hi ha cerca es mostren les pelis populars
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: double.infinity,
      height: double.infinity,
      // color: Colors.red,
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) =>
              MovieCard(movie: movies[index])),
    );
  }
}
