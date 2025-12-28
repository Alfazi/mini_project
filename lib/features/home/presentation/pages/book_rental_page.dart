import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../data/datasources/book_api_service.dart';
import '../../../../data/models/book_model.dart';
import '../../../../data/models/rental_model.dart';
import '../../../../data/services/rental_service.dart';

class BookRentalPage extends StatefulWidget {
  final String bookId;

  const BookRentalPage({super.key, required this.bookId});

  @override
  State<BookRentalPage> createState() => _BookRentalPageState();
}

class _BookRentalPageState extends State<BookRentalPage> {
  late BookApiService _bookApiService;
  final RentalService _rentalService = RentalService();
  Book? _book;
  bool _isLoading = true;
  bool _isRenting = false;
  int _rentalDays = 1;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _bookApiService = BookApiService(dio);
    _loadBookDetail();
  }

  Future<void> _loadBookDetail() async {
    try {
      final book = await _bookApiService.getBookById(widget.bookId);
      if (!mounted) return;
      setState(() {
        _book = book;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading book: ${e.toString()}')),
        );
      }
    }
  }

  int get totalPrice => 5000 * _rentalDays;

  Future<void> _rentBook() async {
    if (_book == null || _isRenting) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda harus login terlebih dahulu')),
        );
      }
      return;
    }

    setState(() {
      _isRenting = true;
    });

    try {
      final now = DateTime.now();
      final rental = RentalModel(
        id: '',
        userId: user.uid,
        bookId: _book!.id,
        bookTitle: _book!.title ?? 'No Title',
        bookCoverImage: _book!.coverImage,
        authorName: _book!.author?.name,
        category: _book!.category?.name,
        rentalDays: _rentalDays,
        totalPrice: totalPrice,
        startDate: now,
        endDate: now.add(Duration(days: _rentalDays)),
        createdAt: now,
      );

      await _rentalService.addRental(rental);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil menyewa buku untuk $_rentalDays hari'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyewa buku: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRenting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sewa Buku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _book == null
          ? const Center(child: Text('Buku tidak ditemukan'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _book!.coverImage != null
                              ? Image.network(
                                  _book!.coverImage!,
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120,
                                      height: 180,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.book,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 120,
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.book,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _book!.title ?? 'No Title',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _book!.author?.name ?? 'Unknown Author',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (_book!.category?.name != null)
                                Text(
                                  _book!.category!.name!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Sinopsis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _book!.summary ?? 'No summary available',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Harga Sewa',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Rp 5.000/Hari',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Durasi Sewa (Hari)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _rentalDays > 1
                                    ? () {
                                        setState(() {
                                          _rentalDays--;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.remove_circle),
                                color: const Color(0xFF4682A9),
                                disabledColor: Colors.grey[300],
                                iconSize: 32,
                              ),
                              Container(
                                width: 80,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$_rentalDays',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _rentalDays < 7
                                    ? () {
                                        setState(() {
                                          _rentalDays++;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.add_circle),
                                color: const Color(0xFF4682A9),
                                disabledColor: Colors.grey[300],
                                iconSize: 32,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Minimal 1 hari, maksimal 7 hari',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF91C8E4).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4682A9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _book == null
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isRenting ? null : _rentBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF91C8E4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
                child: _isRenting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Sewa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
    );
  }
}
