import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/datasources/book_api_service.dart';
import '../../../../data/models/book_model.dart';
import 'book_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BookApiService _bookApiService;
  List<Book> _books = [];
  List<String> _genres = [];
  bool _isLoading = false;
  bool _isLoadingGenres = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String _selectedGenre = '';
  String _searchKeyword = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _bookApiService = BookApiService(dio);
    _loadGenres();
    _loadBooks();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMoreData) {
      _loadMoreBooks();
    }
  }

  Future<void> _loadGenres() async {
    try {
      final response = await _bookApiService.getGenreStats();
      if (!mounted) return;
      setState(() {
        _genres = response.genreStatistics
            .where((stat) => stat.genre != null && stat.genre!.isNotEmpty)
            .take(20)
            .map((stat) => stat.genre!)
            .toList();
        _isLoadingGenres = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        // Fallback ke genre statis kalo API error
        _genres = [
          'Self-Improvement',
          'Picture Books',
          'Activity Books',
          'Culinary',
          'Literary',
          'Romance',
          'Mysteries & Thrillers',
          'Science Fiction & Fantasy',
        ];
        _isLoadingGenres = false;
      });
    }
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });
    try {
      final response = await _bookApiService.getBooks(
        page: _currentPage,
        genre: _selectedGenre.isEmpty ? null : _selectedGenre,
        keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
      );
      if (!mounted) return;
      setState(() {
        _books = response.books ?? [];
        _isLoading = false;
        if (response.pagination != null) {
          _hasMoreData = response.pagination!.hasNextPage;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  Future<void> _loadMoreBooks() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    try {
      final response = await _bookApiService.getBooks(
        page: _currentPage,
        genre: _selectedGenre.isEmpty ? null : _selectedGenre,
        keyword: _searchKeyword.isEmpty ? null : _searchKeyword,
      );
      if (!mounted) return;
      setState(() {
        _books.addAll(response.books ?? []);
        _isLoadingMore = false;
        if (response.pagination != null) {
          _hasMoreData = response.pagination!.hasNextPage;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingMore = false;
        _currentPage--; // Rollback page number on error
      });
    }
  }

  void _onGenreSelected(String genre) {
    setState(() {
      _selectedGenre = _selectedGenre == genre ? '' : genre;
    });
    _loadBooks();
  }

  void _onSearch(String keyword) {
    setState(() {
      _searchKeyword = keyword;
    });
    _loadBooks();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.menu_book, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Nama App',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Cari buku...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                _isLoadingGenres
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: SizedBox(
                            height: 40,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _genres.length,
                          itemBuilder: (context, index) {
                            final genre = _genres[index];
                            final isSelected = _selectedGenre == genre;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(genre),
                                selected: isSelected,
                                onSelected: (_) => _onGenreSelected(genre),
                                backgroundColor: Colors.grey[200],
                                selectedColor: Colors.blue[100],
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.blue[900]
                                      : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                const SizedBox(height: 16),

                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _books.isEmpty
                      ? const Center(child: Text('No books found'))
                      : GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: _isLoadingMore ? 80 : 16,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.55,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: _books.length,
                          itemBuilder: (context, index) {
                            final book = _books[index];
                            return _buildBookCard(book);
                          },
                        ),
                ),
              ],
            ),
            if (_isLoadingMore)
              const Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(bookId: book.id),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  book.coverImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.book, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ),

            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Sewa
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF91C8E4),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Sewa',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: SizedBox(
                            height: 28,
                            child: ElevatedButton(
                              onPressed: () {
                                if (book.buyLinks.isNotEmpty) {
                                  _launchURL(book.buyLinks.first.url);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Link pembelian tidak tersedia',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF4682A9),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Beli',
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
