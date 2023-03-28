import 'package:flutter/material.dart';
import 'package:peliculas/providers/providers.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cines'),
        elevation: 0, // indica la cantidad de sombra sobre el appbar.
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  [
            CardSwiper(movies: moviesProvider.nowPlayingMovies ),
            MovieSlider(
              onNextPage: () => moviesProvider.getPopularMovies(), // se podría agregar una validacion para cada vez que se ejecuta un request
              movies: moviesProvider.popularMovies,
              title: 'Populares'
            ),
          ],
        )
      )
    );
  }
}
