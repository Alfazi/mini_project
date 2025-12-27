import 'package:json_annotation/json_annotation.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookResponse {
  final List<Book>? books;
  final Book? book;
  final Pagination? pagination;

  BookResponse({this.books, this.book, this.pagination});

  factory BookResponse.fromJson(Map<String, dynamic> json) =>
      _$BookResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookResponseToJson(this);
}

@JsonSerializable()
class Book {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  @JsonKey(name: 'cover_image')
  final String coverImage;
  final Author author;
  final Category? category;
  final String summary;
  final Details details;
  final List<Tag> tags;
  @JsonKey(name: 'buy_links')
  final List<BuyLink> buyLinks;
  final String publisher;

  Book({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.author,
    this.category,
    required this.summary,
    required this.details,
    required this.tags,
    required this.buyLinks,
    required this.publisher,
  });

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  Map<String, dynamic> toJson() => _$BookToJson(this);
}

@JsonSerializable()
class Author {
  final String name;
  final String url;

  Author({required this.name, required this.url});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class Category {
  final String? name;
  final String? url;

  Category({this.name, this.url});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Details {
  @JsonKey(name: 'no_gm')
  final String noGm;
  final String isbn;
  final String price;
  @JsonKey(name: 'total_pages')
  final String totalPages;
  final String size;
  @JsonKey(name: 'published_date')
  final String publishedDate;
  final String format;

  Details({
    required this.noGm,
    required this.isbn,
    required this.price,
    required this.totalPages,
    required this.size,
    required this.publishedDate,
    required this.format,
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class Tag {
  final String name;
  final String url;

  Tag({required this.name, required this.url});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@JsonSerializable()
class BuyLink {
  final String store;
  final String url;

  BuyLink({required this.store, required this.url});

  factory BuyLink.fromJson(Map<String, dynamic> json) =>
      _$BuyLinkFromJson(json);

  Map<String, dynamic> toJson() => _$BuyLinkToJson(this);
}

@JsonSerializable()
class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
