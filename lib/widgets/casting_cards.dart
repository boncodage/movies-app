import 'package:flutter/cupertino.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards({super.key, required this.movieId});
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: provider.getActorsMovie(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot){
        final cast = snapshot.data;
        final hasCast = snapshot.hasData;
        if (!hasCast){
          return const SizedBox(
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemBuilder: (context, index) => _CastCard(cast[index]),
            itemCount: cast!.length,
            scrollDirection: Axis.horizontal,
          ),
        );
      });
  }
}

class _CastCard extends StatelessWidget {
  final Cast castPerson;
  const _CastCard(this.castPerson);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(castPerson.fullProfilePath),
              height: 130,
              width: 90,
              fit: BoxFit.cover
            ),
          ),
          const SizedBox(height: 5),
          Text(castPerson.name ?? '',
          maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)

        ]),
    );
  }
}