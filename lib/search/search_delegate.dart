import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class MovieSearchDelegate extends SearchDelegate {

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: ()  => query = '',
      )];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null) ,
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if( query.isEmpty ){
      return const _EmptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery( query );
    
    return StreamBuilder(
      stream: moviesProvider.suggestionsStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        final movies = snapshot.data;
        final haveFoundMovies = snapshot.hasData;
        if (!haveFoundMovies){
          return const _EmptyContainer();
        }
        return ListView.builder(
          itemCount: movies!.length,
          itemBuilder: ((context, index) => _MovieFoundItem(movies[index]))
        
        );
      });
  }

}

class _MovieFoundItem extends StatelessWidget {
  final Movie movie;
  const _MovieFoundItem(this.movie);

  @override
  Widget build(BuildContext context) {
    movie.heroAnimationId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroAnimationId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage( movie.fullPosterPath ),
          width: 50,
          fit: BoxFit.cover
        ),
      ),
      title: Text( movie.title ?? '' ),
      subtitle: Text( movie.originalTitle ?? '' ),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}

class _EmptyContainer extends StatelessWidget {
  const _EmptyContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon( Icons.movie_creation_outlined, color: Colors.black38, size: 100) 
    );
  }
}