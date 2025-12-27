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
  String _selectedSort = '';
  String _selectedYear = '';
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
        sort: _selectedSort.isEmpty ? null : _selectedSort,
        year: _selectedYear.isEmpty ? null : _selectedYear,
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
        sort: _selectedSort.isEmpty ? null : _selectedSort,
        year: _selectedYear.isEmpty ? null : _selectedYear,
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

  void _showFilterBottomSheet() {
    String tempSort = _selectedSort;
    String tempYear = _selectedYear;
    String tempGenre = _selectedGenre;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter & Sort',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Urutkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildFilterChip('Terbaru', 'newest', tempSort, (value) {
                      setModalState(() => tempSort = value);
                    }),
                    _buildFilterChip('Terlama', 'oldest', tempSort, (value) {
                      setModalState(() => tempSort = value);
                    }),
                    _buildFilterChip('Judul A-Z', 'titleAZ', tempSort, (value) {
                      setModalState(() => tempSort = value);
                    }),
                    _buildFilterChip('Judul Z-A', 'titleZA', tempSort, (value) {
                      setModalState(() => tempSort = value);
                    }),
                    _buildFilterChip(
                      'Harga: Rendah-Tinggi',
                      'priceLowHigh',
                      tempSort,
                      (value) {
                        setModalState(() => tempSort = value);
                      },
                    ),
                    _buildFilterChip(
                      'Harga: Tinggi-Rendah',
                      'priceHighLow',
                      tempSort,
                      (value) {
                        setModalState(() => tempSort = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Tahun',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Masukkan tahun (contoh: 2020)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: tempYear),
                  onChanged: (value) {
                    tempYear = value;
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Genre',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (_isLoadingGenres)
                  const Center(child: CircularProgressIndicator())
                else
                  Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _genres.map((genre) {
                          return _buildFilterChip(genre, genre, tempGenre, (
                            value,
                          ) {
                            setModalState(() => tempGenre = value);
                          });
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = '';
                            _selectedYear = '';
                            _selectedGenre = '';
                          });
                          Navigator.pop(context);
                          _loadBooks();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = tempSort;
                            _selectedYear = tempYear;
                            _selectedGenre = tempGenre;
                          });
                          Navigator.pop(context);
                          _loadBooks();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4682A9),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Terapkan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String selectedValue,
    Function(String) onSelected,
  ) {
    final isSelected = selectedValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        onSelected(isSelected ? '' : value);
      },
      backgroundColor: Colors.grey[300],
      selectedColor: Colors.grey[500],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
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
                  child: Row(
                    children: [
                      Expanded(
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color:
                                (_selectedSort.isNotEmpty ||
                                    _selectedYear.isNotEmpty ||
                                    _selectedGenre.isNotEmpty)
                                ? Colors.blue[700]
                                : Colors.grey[700],
                          ),
                          onPressed: _showFilterBottomSheet,
                        ),
                      ),
                    ],
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
                child: book.coverImage != null
                    ? Image.network(
                        book.coverImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.book,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.book, size: 50, color: Colors.grey),
                        ),
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
                      book.title ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author?.name ?? 'Unknown Author',
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
                                if (book.buyLinks != null &&
                                    book.buyLinks!.isNotEmpty &&
                                    book.buyLinks!.first.url != null) {
                                  _launchURL(book.buyLinks!.first.url!);
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
