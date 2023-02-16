import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/search_movie_delegate.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartellera'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                //Afegim la funcionalitat del botó de cerca com a Serch Delegate
                showSearch(
                  context: context,
                  //Enviam una llista de pelis populars per mostrar per defecte
                  delegate: SearchMovieDelegate(moviesProvider.onPopularMovie),
                );
              },
              icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Targetes principals
              //Enviam una llista de pelis en cartellera
              CardSwiper(movies: moviesProvider.onDisplayMovie),
              // Slider de pel·licules
              //Enviam una llista de pelis populars
              MovieSlider(movies: moviesProvider.onPopularMovie),
            ],
          ),
        ),
      ),
    );
  }
}
