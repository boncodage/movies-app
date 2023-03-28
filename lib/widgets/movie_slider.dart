import 'package:flutter/material.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget {
  final String? title;
  final List<Movie> movies;
  final Function onNextPage;
  const MovieSlider({
    super.key, 
    this.title, 
    required this.movies, 
    required this.onNextPage, 
  });

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();
  @override
  void initState(){
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500)
      {
        widget.onNextPage();
      }
    });
  }
  
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => _MoviePoster(movie: widget.movies[index]),
              itemCount: widget.movies.length)
          )
        ],
      )
    );
  }
}

class _MoviePoster extends StatelessWidget {
  
  final Movie movie;
  
  const _MoviePoster({required this.movie});
    
  @override
  Widget build(BuildContext context) {
    movie.heroAnimationId = 'movie-slider-${movie.id}';
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap:() => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroAnimationId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage("assets/no-image.jpg"),
                  image: NetworkImage(movie.fullPosterPath ?? 'https://via.placeholder.com/300x400'),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          
          Text(movie.title!,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center)

        ]
      )
    );
  }
}