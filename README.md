# RiSTOCK — Stock Market Mobile Application

**RiSTOCK** adalah aplikasi mobile fintech yang dirancang untuk menampilkan data pasar saham secara semi *real-time*. Aplikasi ini dikembangkan menggunakan **Flutter** dengan pendekatan **Clean Architecture** untuk memastikan struktur kode yang scalable, maintainable, dan siap dikembangkan lebih lanjut.

---

## Fitur

- **Market Overview (Home Page)**  
  Menampilkan daftar saham utama seperti *Top Gainers* dan *Most Actively Traded*.

- **Stock Detail**  
  Informasi lengkap setiap saham, termasuk data harga historis *(OHLCV)*.

- **Profile**  
  Halaman profil pengguna dengan tautan sosial serta pengaturan preferensi tema *(light/dark mode)*.

- **Search**  
  Pencarian saham berdasarkan simbol maupun nama perusahaan.

- **Caching System**  
  Penyimpanan data secara lokal menggunakan **Hive** untuk meningkatkan performa dan mendukung akses offline.

- **Theme Support**  
  Mendukung *light* dan *dark theme* dengan tampilan modern dan konsisten.

---

## Packages

| Package | Fungsi |
|---|---|
| `flutter_bloc` | State management berbasis Cubit |
| `get_it` | Dependency Injection |
| `go_router` | Routing dan navigasi aplikasi |
| `hive_flutter` | Local storage & caching |
| `http` | HTTP client untuk integrasi API |
| `flutter_dotenv` | Manajemen environment variables |
| `google_fonts` | Implementasi font Poppins |
| `equatable` | Value equality untuk model data |

---

## Pembelajaran

Selama proses pengembangan RiSTOCK, beberapa konsep penting yang dipelajari antara lain:

- Implementasi **Clean Architecture** dengan pemisahan *presentation*, *domain*, dan *data layer*.
- Penerapan **cache-first pattern** menggunakan mekanisme **TTL (Time-To-Live)** untuk meningkatkan efisiensi penggunaan API.
- Strategi **request throttling** untuk menghindari batasan API AlphaVantage *(5 request/menit, 25 request/hari)*.
- Integrasi **Hive** sebagai solusi caching data yang sensitif terhadap waktu.
- Penggunaan **BLoC/Cubit** untuk manajemen state yang terstruktur.
- Implementasi **GetIt** sebagai *service locator* guna menjaga dependency tetap bersih dan modular.

---

---

## Tujuan Pengembangan

Aplikasi ini dikembangkan sebagai sarana pembelajaran sekaligus proyek portofolio untuk mendemonstrasikan kemampuan pengembangan aplikasi mobile dengan standar arsitektur yang baik dan praktik pengembangan modern.