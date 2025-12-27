// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookResponse _$BookResponseFromJson(Map<String, dynamic> json) => BookResponse(
  books: (json['books'] as List<dynamic>?)
      ?.map((e) => Book.fromJson(e as Map<String, dynamic>))
      .toList(),
  book: json['book'] == null
      ? null
      : Book.fromJson(json['book'] as Map<String, dynamic>),
  pagination: json['pagination'] == null
      ? null
      : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookResponseToJson(BookResponse instance) =>
    <String, dynamic>{
      'books': instance.books,
      'book': instance.book,
      'pagination': instance.pagination,
    };

Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: json['_id'] as String,
  title: json['title'] as String?,
  coverImage: json['cover_image'] as String?,
  author: json['author'] == null
      ? null
      : Author.fromJson(json['author'] as Map<String, dynamic>),
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  summary: json['summary'] as String?,
  details: json['details'] == null
      ? null
      : Details.fromJson(json['details'] as Map<String, dynamic>),
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
      .toList(),
  buyLinks: (json['buy_links'] as List<dynamic>?)
      ?.map((e) => BuyLink.fromJson(e as Map<String, dynamic>))
      .toList(),
  publisher: json['publisher'] as String?,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'cover_image': instance.coverImage,
  'author': instance.author,
  'category': instance.category,
  'summary': instance.summary,
  'details': instance.details,
  'tags': instance.tags,
  'buy_links': instance.buyLinks,
  'publisher': instance.publisher,
};

Author _$AuthorFromJson(Map<String, dynamic> json) =>
    Author(name: json['name'] as String?, url: json['url'] as String?);

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

Category _$CategoryFromJson(Map<String, dynamic> json) =>
    Category(name: json['name'] as String?, url: json['url'] as String?);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
  noGm: json['no_gm'] as String?,
  isbn: json['isbn'] as String?,
  price: json['price'] as String?,
  totalPages: json['total_pages'] as String?,
  size: json['size'] as String?,
  publishedDate: json['published_date'] as String?,
  format: json['format'] as String?,
);

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
  'no_gm': instance.noGm,
  'isbn': instance.isbn,
  'price': instance.price,
  'total_pages': instance.totalPages,
  'size': instance.size,
  'published_date': instance.publishedDate,
  'format': instance.format,
};

Tag _$TagFromJson(Map<String, dynamic> json) =>
    Tag(name: json['name'] as String?, url: json['url'] as String?);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

BuyLink _$BuyLinkFromJson(Map<String, dynamic> json) =>
    BuyLink(store: json['store'] as String?, url: json['url'] as String?);

Map<String, dynamic> _$BuyLinkToJson(BuyLink instance) => <String, dynamic>{
  'store': instance.store,
  'url': instance.url,
};

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['currentPage'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  itemsPerPage: (json['itemsPerPage'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  hasPrevPage: json['hasPrevPage'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalItems': instance.totalItems,
      'itemsPerPage': instance.itemsPerPage,
      'hasNextPage': instance.hasNextPage,
      'hasPrevPage': instance.hasPrevPage,
    };
