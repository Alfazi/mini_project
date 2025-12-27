import 'package:json_annotation/json_annotation.dart';

part 'genre_stats_model.g.dart';

@JsonSerializable()
class GenreStatsResponse {
  @JsonKey(name: 'genre_statistics')
  final List<GenreStatistic> genreStatistics;
  @JsonKey(name: 'total_genres')
  final int totalGenres;

  GenreStatsResponse({
    required this.genreStatistics,
    required this.totalGenres,
  });

  factory GenreStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$GenreStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenreStatsResponseToJson(this);
}

@JsonSerializable()
class GenreStatistic {
  final int count;
  final String? genre;

  GenreStatistic({required this.count, this.genre});

  factory GenreStatistic.fromJson(Map<String, dynamic> json) =>
      _$GenreStatisticFromJson(json);

  Map<String, dynamic> toJson() => _$GenreStatisticToJson(this);
}
