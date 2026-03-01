# RiSTOCK — Stock Market Mobile Application

**RiSTOCK** adalah aplikasi mobile fintech yang dirancang untuk menampilkan data pasar saham secara semi *real-time*. Aplikasi ini dikembangkan menggunakan **Flutter** dengan pendekatan **Clean Architecture** untuk memastikan struktur kode yang scalable, maintainable, dan siap dikembangkan lebih lanjut.

---

## Fitur

- **Market Overview (Home Page)**  
  Menampilkan daftar saham utama seperti *Top Gainers* dan *Most Actively Traded*.

- **Stock Detail**  
  Informasi lengkap setiap saham, termasuk data harga historis *(OHLCV)*.

- **Profile**  
Halaman **Profile** menampilkan informasi saya serta fitur personalisasi aplikasi. Tautan sosial (Gmail, LinkedIn, dan GitHub) menggunakan *deep linking / URL launcher* untuk membuka aplikasi atau browser terkait. Profile Page juga menyediakan pengaturan tema (**Light/Dark Mode**) dengan manajemen state global dan *local persistence* untuk memastikan perubahan tampilan tersimpan secara real-time.

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

Selama proses pengembangan **RiSTOCK** ini, saya belajar banyak konsep penting baru yang antara lain:

- Implementasi **Clean Architecture** dengan pemisahan yang jelas antara *presentation layer*, *domain layer*, dan *data layer* : big thanks saya berikan kepada academy online saya waktu kemarin libur semester 😅, saya banyak belajar preferensi industri", bahkan sempat belajar atomic design yang sayangnya belum saya terapkan disini karena memang aplikasi ini tidak termasuk kriteria scale sebesar itu.
- Implementasi navigasi  **GoRouter**, termasuk pengelolaan *individual tab navigation stack* pada *bottom navigation* sehingga setiap tab mempertahankan *navigation history*-nya secara independen. Disini saya jujur belajar banyak juga dari Academy saya.
- Implementasi **Theme Manager / App Configuration Layer** untuk mengambil alih kontrol tampilan UI, memungkinkan *runtime theme switching* (**Light Mode / Dark Mode**) dengan state global serta penyimpanan preferensi secara persisten.
- Penggunaan **BLoC/Cubit** untuk manajemen state yang terstruktur dan terprediksi.
- Implementasi **GetIt** sebagai *service locator* untuk mendukung *dependency injection*, sehingga arsitektur tetap bersih, modular, dan mudah dikembangkan untuk fitur masa depan.
- Pembelajaran implementasi **deep linking** menggunakan **URL Launcher** untuk membuka aplikasi eksternal atau browser secara langsung dari dalam aplikasi, tentunya untuk fitur Profile Page saya.
- Pengembangan **Networking** yang mempertimbangkan berbagai kemungkinan *API response* (success, empty data, error, rate limit, dan failure state).
- Penerapan **cache-first pattern** menggunakan mekanisme **TTL (Time-To-Live)** untuk meningkatkan efisiensi penggunaan API, mengingat adanya batasan jumlah *API call*.
- Penerapan strategi **request throttling** untuk menghindari limit API AlphaVantage *(5 request/menit)*. Proyek ini menggunakan mekanisme interval berdasarkan jumlah request yang telah digunakan dalam satu menit, sehingga request berikutnya akan mengembalikan *loading state* hingga batas waktu terpenuhi.
- Integrasi **Hive** sebagai solusi caching data yang sensitif terhadap waktu, dengan pendekatan sederhana berupa parsing JSON yang cukup untuk menangani penyimpanan data pada disk klien.
