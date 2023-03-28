import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class CardSwiper  extends StatelessWidget {

  final List<Movie> movies;

  const CardSwiper({
    super.key, 
    required this.movies
  }); 
  
  @override
  Widget build(BuildContext context) {
    // MediaQuery un objeto de esta clase nos devuelve información sobre las 
    // dimensiones de la pantalla, plataforma, etc.
    final size = MediaQuery.of(context).size;

    if (movies.isEmpty){
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5, // 50 %de la altura de la pantalla
    
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, index) {
          final movie = movies[index];
          movie.heroAnimationId = 'swiper-${movie.id}';
          return GestureDetector( // permite configurar el onTab
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroAnimationId!,
              child: ClipRRect( // permite aplicarle un borde personalizado a una imagen.
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(movie.fullPosterPath ?? 'https://via.placeholder.com/300x300'),
                  fit: BoxFit.cover
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}