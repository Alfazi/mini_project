# RakSaku - Aplikasi Rental Buku Digital

<p align="center">
  <img src="assets/images/rak_saku_logo.png" alt="RakSaku Logo" width="200"/>
</p>

RakSaku adalah aplikasi mobile untuk menyewa buku digital secara online. Aplikasi ini memungkinkan pengguna untuk menjelajahi koleksi buku, menyewa buku favorit, melacak status peminjaman, dan mengelola profil mereka.

## 📱 Fitur Utama

### Autentikasi
- **Login & Register**: Pendaftaran dengan email/password dan Google Sign-In
- **Validasi Password**: Minimal 8 karakter dengan kombinasi huruf dan angka
- **Manajemen Sesi**: Persistent login dengan shared preferences

### Katalog Buku
- **Browsing Buku**: Jelajahi koleksi buku dengan infinite scroll pagination
- **Search**: Pencarian buku berdasarkan judul atau penulis
- **Filter Kategori**: Filter buku berdasarkan kategori (Fiction, Non-Fiction, Science, History, dll)
- **Detail Buku**: Informasi lengkap tentang buku, rating, dan deskripsi

### Rental Management
- **Sewa Buku**: Pilih durasi sewa (1-7 hari)
- **Library**: Lihat semua buku yang pernah disewa
- **Status Tracking**: Monitor status peminjaman (aktif/dikembalikan) dengan countdown hari tersisa
- **Return Book**: Kembalikan buku yang sudah selesai dibaca
- **Re-rent**: Sewa ulang buku yang sudah dikembalikan atau expired
- **History**: Riwayat lengkap semua peminjaman dengan status

### Profil & Settings
- **Edit Profile**: Update username dan foto profil
- **Upload Foto**: Integrasi dengan Cloudinary CDN untuk penyimpanan foto
- **Ganti Password**: Ubah password dengan validasi keamanan
- **FAQ**: Halaman bantuan dengan pertanyaan umum
- **Logout**: Keluar dari akun dengan aman

## 🛠️ Tech Stack

### Framework & Language
- **Flutter SDK**: 3.10.0
- **Dart**: Null safety enabled

### State Management
- **flutter_bloc**: ^9.1.1 - BLoC pattern untuk authentication
- **StreamBuilder**: Real-time data dari Firestore

### Backend & Database
- **Firebase Core**: ^4.3.0
- **Firebase Auth**: ^6.1.3 - Authentication
- **Cloud Firestore**: ^6.1.1 - Database NoSQL
- **Google Sign-In**: ^6.2.2

### Networking & API
- **Dio**: ^5.4.0 - HTTP client
- **Retrofit**: ^4.9.0 - REST API integration
- **retrofit_generator**: ^8.2.1

### External API
- **Buku Acak API**: https://bukuacak.vercel.app/api - Sumber data katalog buku
  - Free public API tanpa authentication
  - Menyediakan koleksi buku dengan cover, deskripsi, rating, dan kategori

### Cloud Storage
- **Cloudinary Flutter**: ^1.3.0 - CDN untuk foto profil
- **Cloudinary URL Gen**: ^1.0.0

### UI & Forms
- **flutter_form_builder**: ^10.2.0
- **form_builder_validators**: ^11.0.0
- **infinite_scroll_pagination**: ^5.1.1

### Utilities
- **image_picker**: ^1.0.7 - Upload foto
- **intl**: ^0.20.2 - Format tanggal
- **url_launcher**: ^6.2.3 - Buka link eksternal
- **shared_preferences**: ^2.2.2 - Local storage

## 📋 Prerequisites

Sebelum memulai, pastikan Anda telah menginstall:

- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.1.0)
- Android Studio / Xcode (untuk emulator)
- Firebase account
- Cloudinary account

**Note**: API Buku Acak (https://bukuacak.vercel.app/api) sudah terintegrasi dan tidak memerlukan setup tambahan.

## 🚀 Installation

### 1. Clone Repository

```bash
git clone <repository-url>
cd mini_project
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Firebase Configuration

#### Android
1. Download `google-services.json` dari Firebase Console
2. Letakkan di `android/app/google-services.json`

#### iOS
1. Download `GoogleService-Info.plist` dari Firebase Console
2. Letakkan di `ios/Runner/GoogleService-Info.plist`

### 5. Cloudinary Configuration

Edit `lib/data/services/cloudinary_service.dart`:

```dart
static const String cloudName = 'YOUR_CLOUD_NAME';
static const String uploadPreset = 'YOUR_UPLOAD_PRESET';
```

### 6. Run Application

```bash
flutter run
```

## 📂 Project Structure

```
lib/
├── core/                        # Core utilities dan constants
│   ├── constants/
│   │   └── app_constants.dart   # API endpoints, app constants
│   ├── themes/
│   │   └── app_theme.dart       # Theme configuration
│   └── utils/
│       └── validators.dart      # Form validators
│
├── data/                        # Data layer
│   ├── models/                  # Data models
│   │   ├── book_model.dart
│   │   ├── rental_model.dart
│   │   └── user_model.dart
│   └── services/                # Firebase & API services
│       ├── auth_service.dart
│       ├── book_service.dart
│       ├── rental_service.dart
│       ├── user_service.dart
│       └── cloudinary_service.dart
│
└── features/                    # Feature modules
    ├── auth/                    # Authentication feature
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── bloc/
    │       └── pages/
    │
    ├── home/                    # Home/Browse books feature
    │   └── presentation/
    │       └── pages/
    │
    ├── library/                 # Library/Rental feature
    │   └── presentation/
    │       └── pages/
    │
    └── profile/                 # Profile feature
        └── presentation/
            └── pages/
```

## 🎯 Penggunaan Aplikasi

### 1. Registrasi & Login
- Buka aplikasi dan pilih "Sign Up" untuk membuat akun baru
- Atau gunakan "Sign in with Google" untuk login cepat
- Password harus minimal 8 karakter dengan kombinasi huruf dan angka

### 2. Browse Buku
- Jelajahi koleksi buku di halaman Home
- Gunakan search bar untuk mencari buku tertentu
- Filter berdasarkan kategori untuk mempersempit pencarian

### 3. Sewa Buku
- Tap buku untuk melihat detail
- Pilih "Sewa Sekarang"
- Pilih durasi sewa (1-7 hari)
- Konfirmasi pembayaran

### 4. Kelola Rental
- Buka tab "Library" untuk melihat buku yang disewa
- Monitor hari tersisa peminjaman
- Tap "Kembalikan" untuk mengembalikan buku
- Tap "Sewa Lagi" untuk menyewa ulang buku yang expired

### 5. Edit Profile
- Buka tab "Profile"
- Tap ikon edit untuk mengubah username atau foto
- Gunakan "Ubah Password" untuk keamanan akun

## 🔥 Firebase Collections

### users
```
{
  userId: string,
  username: string,
  photoUrl: string,
  updatedAt: timestamp
}
```

### rentals
```
{
  rentalId: string,
  userId: string,
  bookId: string,
  bookTitle: string,
  bookCoverImage: string,
  authorName: string,
  category: string,
  rentalDays: number,
  totalPrice: number,
  startDate: timestamp,
  endDate: timestamp,
  status: string,        // 'active' | 'returned'
  createdAt: timestamp
}
```

## 🎨 Design System

### Colors
- **Primary**: #91C8E4 (Light Blue)
- **Secondary**: #4682A9 (Steel Blue)
- **Accent**: #749BC2 (Slate Blue)
- **Background**: #F1F6F9 (Light Gray)

### Typography
- Font Family: Default (Roboto on Android, SF Pro on iOS)
- Headlines: Bold
- Body: Regular

## 🔐 Security Features

### Password Validation
- Minimal 8 karakter
- Harus mengandung huruf (a-z, A-Z)
- Harus mengandung angka (0-9)
- Validasi di sign up dan edit profile

### Authentication
- Firebase Authentication dengan email/password
- Google OAuth integration
- Re-authentication untuk perubahan password
- Session management dengan auto-logout

## 🐛 Known Issues & Limitations

### Current Limitations
- Fitur "Baca" (read) belum terintegrasi dengan PDF viewer
- Tidak ada notifikasi push untuk reminder jatuh tempo
- Sistem denda keterlambatan belum diimplementasi
- Tidak ada fitur perpanjang sewa

### Future Enhancements
- [ ] Integrasi PDF viewer untuk membaca buku
- [ ] Push notification untuk reminder
- [ ] Sistem denda otomatis
- [ ] Fitur perpanjang masa sewa
- [ ] Wishlist/favorite books
- [ ] Review & rating buku
- [ ] Payment gateway integration

## Contributing

Contributions, issues, and feature requests are welcome!

## 📄 License

This project is for educational purposes as part of Dibimbing Mobile Apps Development Bootcamp.

## Acknowledgments

- **Buku Acak API** (https://bukuacak.vercel.app/api) - Terima kasih atas penyediaan API gratis untuk katalog buku
- **Dibimbing Bootcamp** - Guidance dan mentoring selama pengembangan project

## 👨‍💻 Developer

Developed by Zidane Alfatih (Alfazi) as a mini project for Dibimbing Bootcamp.

## 📞 Support

Untuk bantuan atau pertanyaan:
- Email: zidanealfatih14@gmail.com

---

**RakSaku** - Baca Buku, Pinjam Mudah! 📚

---
## Link Presentasi
https://www.canva.com/design/DAG8DmblYps/2HgnorEcYYbHvfoAZhhT5g/edit?utm_content=DAG8DmblYps&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton
