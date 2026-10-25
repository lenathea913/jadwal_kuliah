# Jadwal Kuliah: Aplikasi Mobile Flutter

Aplikasi mobile untuk memantau **jadwal kuliah harian** mahasiswa: jadwal hari ini,
daftar seluruh mata kuliah per hari, detail mata kuliah, dan profil akademik.
Dikembangkan untuk UTS mata kuliah **Mobile Programming** (Semester Ganjil 2025/2026).

## Tema dan Tujuan

- **Tema:** Manajemen jadwal kuliah mahasiswa dengan antarmuka bersih dan responsif.
- **Tujuan:**
  1. Menerapkan konsep **layout, widget, dan navigasi** antar halaman Flutter.
  2. Mengolah **data dummy berupa file JSON lokal** (`assets/json/jadwal.json`)
     yang strukturnya disiapkan agar mudah diganti dengan permintaan **API** pada
     tahap pengembangan berikutnya.
  3. Menampilkan jadwal yang informatif dan mudah dibaca dengan desain yang konsisten.

## Daftar Halaman dan Fungsinya

| Halaman | Berkas | Fungsi |
|---|---|---|
| **Beranda** (tab 1) | `lib/view/beranda.dart` | Sapaan + identitas mahasiswa, ringkasan jumlah mata kuliah & SKS, daftar **jadwal hari ini**, dan pratinjau jadwal selanjutnya. |
| **Mata Kuliah** (tab 2) | `lib/view/matakuliah.dart` | Daftar seluruh mata kuliah yang dikelompokkan per hari, dilengkapi **pencarian** (nama/kode/dosen) dan **filter chip per hari**. |
| **Profil** (tab 3) | `lib/view/profil.dart` | Identitas dan data akademik mahasiswa serta sebaran jumlah kelas per hari. |
| **Detail Mata Kuliah** (route terpush) | `lib/view/detail_matakuliah.dart` | Deskripsi mata kuliah, dosen pengampu, waktu, ruangan, dan SKS — dibuka dari Beranda maupun daftar mata kuliah. |

**Navigasi:** perpindahan halaman utama memakai `BottomNavigationBar` (3 tab),
pembukaan halaman detail memakai `Navigator.push` / `Navigator.pop`.

**Struktur pola MVVM:**

```
lib/
├── model/matakuliah.dart        # Model Mahasiswa, MataKuliah, DataJadwal (fromJson/toJson)
├── viewmodel/jadwal_service.dart# Pemuatan & pengolahan data JSON (siap diganti API)
├── view/                        # Empat halaman UI (beranda, matakuliah, profil, detail)
└── main.dart                    # MaterialApp, tema, BottomNavigationBar
assets/json/jadwal.json          # Data dummy jadwal
```

## Menjalankan Aplikasi

Prasyarat: Flutter SDK terpasang dan satu perangkat/emulator Android.

```bash
cd jadwal_kuliah
flutter pub get
flutter run          # pilih emulator atau perangkat yang tersambung
```

Menjalankan pengujian:

```bash
flutter analyze      # pemeriksaan statis
flutter test         # 6 pengujian: parsing JSON + interaksi UI/navigasi
```

## Data Dummy

Seluruh data berada di [`assets/json/jadwal.json`](assets/json/jadwal.json)
berisi identitas `mahasiswa` dan array `mataKuliah`
(kode, nama, dosen, SKS, hari, jam, ruangan, warna, deskripsi).
Untuk integrasi API kelak, cukup ganti isi `JadwalService.loadJadwal()`
dengan permintaan HTTP — struktur model dan tampilan tidak berubah.
