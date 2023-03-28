
import 'dart:convert';

import 'package:peliculas/models/models.dart';

class PopularMoviesResponse {
    PopularMoviesResponse({
        this.page,
        this.results,
        this.totalPages,
        this.totalResults,
    });

    int? page;
    List<Movie>? results;
    int? totalPages;
    int? totalResults;

    factory PopularMoviesResponse.fromRawJson(String str) => PopularMoviesResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PopularMoviesResponse.fromJson(Map<String, dynamic> json) => PopularMoviesResponse(
        page: json["page"],
        results: json["results"] == null ? [] : List<Movie>.from(json["results"]!.map((x) => Movie.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}
