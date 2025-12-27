// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenreStatsResponse _$GenreStatsResponseFromJson(Map<String, dynamic> json) =>
    GenreStatsResponse(
      genreStatistics: (json['genre_statistics'] as List<dynamic>)
          .map((e) => GenreStatistic.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalGenres: (json['total_genres'] as num).toInt(),
    );

Map<String, dynamic> _$GenreStatsResponseToJson(GenreStatsResponse instance) =>
    <String, dynamic>{
      'genre_statistics': instance.genreStatistics,
      'total_genres': instance.totalGenres,
    };

GenreStatistic _$GenreStatisticFromJson(Map<String, dynamic> json) =>
    GenreStatistic(
      count: (json['count'] as num).toInt(),
      genre: json['genre'] as String?,
    );

Map<String, dynamic> _$GenreStatisticToJson(GenreStatistic instance) =>
    <String, dynamic>{'count': instance.count, 'genre': instance.genre};
