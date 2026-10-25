import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jadwal_kuliah/main.dart';
import 'package:jadwal_kuliah/model/matakuliah.dart';
import 'package:jadwal_kuliah/viewmodel/jadwal_service.dart';

/// Data dummy untuk pengujian widget (diinjeksi langsung,
/// pemuatan aset JSON diuji terpisah pada unit test di atas).
DataJadwal _dataUji() => DataJadwal(
      mahasiswa: const Mahasiswa(
        nama: 'Ryan Pratama',
        nim: '2210511023',
        kelas: '5A',
        prodi: 'Teknik Informatika',
        semester: 5,
        universitas: 'Universitas Nusantara',
      ),
      daftarMataKuliah: const [
        MataKuliah(
          kode: 'MKB511',
          nama: 'Mobile Programming',
          dosen: 'Rina Wulandari, S.T., M.T.',
          sks: 3,
          hari: 'Senin',
          jamMulai: '08:00',
          jamSelesai: '09:40',
          ruangan: 'Lab Android 1',
          semester: 5,
          warna: 0xFF3F51B5,
          deskripsi: 'Pengembangan aplikasi mobile dengan Flutter.',
        ),
        MataKuliah(
          kode: 'MKB513',
          nama: 'Basis Data Lanjut',
          dosen: 'Dewi Lestari, S.T., M.T.',
          sks: 3,
          hari: 'Selasa',
          jamMulai: '08:00',
          jamSelesai: '09:40',
          ruangan: 'R. 302',
          semester: 5,
          warna: 0xFFFF7043,
          deskripsi: 'Optimasi query dan transaksi basis data.',
        ),
      ],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Parsing data dummy JSON', () {
    test('loadJadwal membaca assets/json/jadwal.json dengan benar', () async {
      final data = await JadwalService.loadJadwal();

      expect(data.mahasiswa.nama, isNotEmpty);
      expect(data.mahasiswa.semester, 5);
      expect(data.daftarMataKuliah, isNotEmpty);

      final mk = data.daftarMataKuliah.first;
      expect(mk.kode, isNotEmpty);
      expect(mk.sks, greaterThan(0));
      expect(JadwalService.hariDalamMinggu, contains(mk.hari));
    });

    test('MataKuliah round-trip toJson -> fromJson', () async {
      final data = await JadwalService.loadJadwal();
      final asli = data.daftarMataKuliah.first;
      final salinan = MataKuliah.fromJson(asli.toJson());

      expect(salinan.kode, asli.kode);
      expect(salinan.nama, asli.nama);
      expect(salinan.jamMulai, asli.jamMulai);
      expect(salinan.warna, asli.warna);
    });

    test('filter hari dan total SKS bekerja', () async {
      final data = await JadwalService.loadJadwal();
      final senin = JadwalService.perHari(data.daftarMataKuliah, 'Senin');

      expect(senin, isNotEmpty);
      expect(senin.every((m) => m.hari == 'Senin'), isTrue);
      expect(JadwalService.totalSks(data.daftarMataKuliah), greaterThan(0));
    });
  });

  group('UI aplikasi', () {
    testWidgets('Beranda menampilkan jadwal dan bisa berpindah tab',
        (tester) async {
      await tester.pumpWidget(JadwalKuliahApp(loader: () async => _dataUji()));
      await tester.pumpAndSettle();

      // Beranda tampil
      expect(find.textContaining('Halo,'), findsOneWidget);

      // Pindah ke tab Mata Kuliah
      await tester.tap(find.text('Mata Kuliah'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      // Pindah ke tab Profil
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();
      expect(find.text('Data Akademik'), findsOneWidget);
    });

    testWidgets('Menampilkan detail saat item jadwal ditekan',
        (tester) async {
      await tester.pumpWidget(JadwalKuliahApp(loader: () async => _dataUji()));
      await tester.pumpAndSettle();

      // Buka tab daftar mata kuliah, lalu tekan item pertama
      await tester.tap(find.text('Mata Kuliah'));
      await tester.pumpAndSettle();
      final target = find.byType(ListTile).first;
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();

      expect(find.text('Informasi Kelas'), findsOneWidget);
      expect(find.text('Kembali ke Jadwal'), findsOneWidget);

      // Kembali (tombol di bawah lipatan, scroll dulu), lalu pastikan beranda masih tampil
      final tombolKembali = find.text('Kembali ke Jadwal');
      await tester.ensureVisible(tombolKembali);
      await tester.pumpAndSettle();
      await tester.tap(tombolKembali);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Halo,'), findsOneWidget);
    });

    testWidgets('Daftar mata kuliah bisa dicari dan difilter',
        (tester) async {
      await tester.pumpWidget(JadwalKuliahApp(loader: () async => _dataUji()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mata Kuliah'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Basis Data');
      await tester.pumpAndSettle();
      expect(find.text('Basis Data Lanjut'), findsOneWidget);
      expect(find.text('Mobile Programming'), findsNothing);

      // Filter chip "Selasa"
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilterChip, 'Selasa'));
      await tester.pumpAndSettle();
      expect(find.text('Basis Data Lanjut'), findsOneWidget);
      expect(find.text('Mobile Programming'), findsNothing);
    });
  });
}
