import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/book_model.dart';
import '../models/genre_stats_model.dart';
import '../../core/constants/api_constants.dart';

part 'book_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class BookApiService {
  factory BookApiService(Dio dio, {String baseUrl}) = _BookApiService;

  @GET(ApiConstants.books)
  Future<BookResponse> getBooks({
    @Query('page') int? page,
    @Query('sort') String? sort,
    @Query('year') String? year,
    @Query('genre') String? genre,
    @Query('keyword') String? keyword,
  });

  @GET('${ApiConstants.books}/{id}')
  Future<Book> getBookById(@Path('id') String id);

  @GET('/stats/genre')
  Future<GenreStatsResponse> getGenreStats();
}
