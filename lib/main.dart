import 'package:flutter/material.dart';

import 'model/matakuliah.dart';
import 'view/beranda.dart';
import 'view/matakuliah.dart';
import 'view/profil.dart';
import 'viewmodel/jadwal_service.dart';

void main() {
  runApp(const JadwalKuliahApp());
}

/// Aplikasi Jadwal Kuliah — UTS Mobile Programming.
///
/// Menggunakan [BottomNavigationBar] untuk berpindah antar tiga halaman
/// utama (Beranda, Mata Kuliah, Profil) dan `Navigator.push`
/// untuk membuka halaman detail mata kuliah.
class JadwalKuliahApp extends StatelessWidget {
  /// Loader data jadwal; dapat dioverride pada pengujian widget
  /// sehingga tidak bergantung pada platform asset messenger.
  final Future<DataJadwal> Function()? loader;

  const JadwalKuliahApp({super.key, this.loader});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          surfaceTintColor: Colors.white,
          color: Colors.white,
        ),
      ),
      home: HomeShell(loader: loader),
    );
  }
}

/// Shell utama: memuat data dummy JSON sekali, lalu menyajikan
/// tiga halaman melalui [BottomNavigationBar].
class HomeShell extends StatefulWidget {
  final Future<DataJadwal> Function()? loader;

  const HomeShell({super.key, this.loader});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late final Future<DataJadwal> _data;
  int _indeksTab = 0;

  @override
  void initState() {
    super.initState();
    _data = (widget.loader ?? JadwalService.loadJadwal)();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataJadwal>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Gagal memuat data: ${snapshot.error}')),
          );
        }

        final data = snapshot.data!;
        final halaman = [
          BerandaScreen(
            mahasiswa: data.mahasiswa,
            daftarMataKuliah: data.daftarMataKuliah,
          ),
          MataKuliahScreen(daftarMataKuliah: data.daftarMataKuliah),
          ProfilScreen(
            mahasiswa: data.mahasiswa,
            daftarMataKuliah: data.daftarMataKuliah,
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text([
              'Jadwal Kuliah',
              'Daftar Mata Kuliah',
              'Profil Mahasiswa',
            ][_indeksTab]),
          ),
          body: IndexedStack(index: _indeksTab, children: halaman),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _indeksTab,
            onTap: (i) => setState(() => _indeksTab = i),
            selectedItemColor: const Color(0xFF3F51B5),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book),
                label: 'Mata Kuliah',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}
