import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Bantuan & FAQ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFaqItem(
            question: 'Bagaimana cara menyewa buku?',
            answer:
                'Untuk menyewa buku:\n1. Cari buku yang Anda inginkan di halaman Home\n2. Tap kartu buku atau gunakan fitur pencarian\n3. Di halaman detail buku, tap tombol "Sewa"\n4. Pilih durasi sewa (1-7 hari)\n5. Tap tombol "Sewa Sekarang" untuk mengkonfirmasi\n6. Buku yang disewa akan muncul di halaman Library',
          ),
          const SizedBox(height: 12),
          _buildFaqItem(
            question: 'Bagaimana cara mengembalikan buku?',
            answer:
                'Untuk mengembalikan buku:\n1. Buka halaman Library\n2. Tap kartu buku yang ingin dikembalikan\n3. Di halaman detail sewa, tap tombol "Kembalikan Buku" di bagian bawah\n4. Konfirmasi pengembalian\n5. Buku akan hilang dari Library dan statusnya akan berubah menjadi "Selesai" di Riwayat Peminjaman',
          ),
          const SizedBox(height: 12),
          _buildFaqItem(
            question: 'Berapa lama durasi maksimal peminjaman?',
            answer:
                'Durasi peminjaman buku:\n• Minimal: 1 hari\n• Maksimal: 7 hari\n\nAnda dapat memilih durasi sesuai kebutuhan saat menyewa buku. Pastikan mengembalikan buku sebelum tanggal berakhir sewa.',
          ),
          const SizedBox(height: 12),
          _buildFaqItem(
            question: 'Berapa biaya sewa per hari?',
            answer:
                'Biaya sewa buku adalah Rp 5.000 per hari.\n\nTotal biaya akan dihitung otomatis berdasarkan durasi yang Anda pilih.\n\nContoh:\n• 1 hari = Rp 5.000\n• 3 hari = Rp 15.000\n• 7 hari = Rp 35.000',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Masih ada pertanyaan? Hubungi kami melalui email zidanealfatih14@gmail.com',
                    style: TextStyle(fontSize: 13, color: Colors.blue[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.blue[50],
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          iconColor: const Color(0xFF4682A9),
          collapsedIconColor: Colors.grey[600],
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
