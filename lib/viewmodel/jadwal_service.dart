import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/matakuliah.dart';

/// Viewmodel pengolahan data jadwal.
///
/// Membaca data dummy dari file JSON lokal pada assets.
/// Kelak fungsi [loadJadwal] dapat diganti dengan permintaan HTTP
/// ke server tanpa mengubah struktur model maupun tampilan.
class JadwalService {
  static const String _assetPath = 'assets/json/jadwal.json';

  /// Memuat dan meng-decode seluruh data jadwal dari assets.
  static Future<DataJadwal> loadJadwal() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return DataJadwal.fromJson(decoded);
  }

  /// Hari-hari dalam semur (urut Senin..Minggu) untuk pengelompokan jadwal.
  static const List<String> hariDalamMinggu = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  /// Nama hari hari ini sesuai jam perangkat, dalam format [hariDalamMinggu].
  static String hariIni() {
    final index = DateTime.now().weekday; // 1 = Senin, 7 = Minggu
    return hariDalamMinggu[index - 1];
  }

  /// Filter mata kuliah berdasarkan hari.
  static List<MataKuliah> perHari(List<MataKuliah> list, String hari) =>
      list.where((m) => m.hari == hari).toList();

  /// Total seluruh SKS pada semester berjalan.
  static int totalSks(List<MataKuliah> list) =>
      list.fold(0, (sum, m) => sum + m.sks);
}
