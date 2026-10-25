import 'package:flutter/material.dart';

import '../model/matakuliah.dart';
import '../viewmodel/jadwal_service.dart';
import 'detail_matakuliah.dart';

/// Halaman Beranda (tab pertama BottomNavigationBar).
///
/// Menampilkan sapaan + identitas mahasiswa, ringkasan semester,
/// dan daftar jadwal kuliah hari ini.
class BerandaScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;

  const BerandaScreen({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
  });

  @override
  Widget build(BuildContext context) {
    final hariIni = JadwalService.hariIni();
    final jadwalHariIni = JadwalService.perHari(daftarMataKuliah, hariIni);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Kartu sapaan mahasiswa
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF3F51B5), Color(0xFF7E57C2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${mahasiswa.nama.split(' ').first} 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${mahasiswa.prodi} • Semester ${mahasiswa.semester} • Kelas ${mahasiswa.kelas}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _StatChip(
                    label: '${daftarMataKuliah.length} Mata Kuliah',
                    icon: Icons.menu_book_rounded,
                  ),
                  const SizedBox(width: 12),
                  _StatChip(
                    label: '${JadwalService.totalSks(daftarMataKuliah)} SKS',
                    icon: Icons.school_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Ringkasan hari ini
        Text(
          'Jadwal Hari Ini ($hariIni)',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        if (jadwalHariIni.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.beach_access_rounded,
                      size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Tidak ada kelas hari ini. Selamat beristirahat!'),
                ],
              ),
            ),
          )
        else
          ...jadwalHariIni.map(
            (mk) => _JadwalHariIniCard(
              mataKuliah: mk,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailMataKuliahScreen(mataKuliah: mk),
                ),
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Pratinjau besok / hari lain
        if (jadwalHariIni.isNotEmpty) ...[
          Text(
            'Selanjutnya',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._jadwalBesok(daftarMataKuliah, hariIni).map(
            (mk) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(mk.warna).withValues(alpha: 0.15),
                child: Text(
                  mk.kode.substring(mk.kode.length - 2),
                  style: TextStyle(
                    color: Color(mk.warna),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(mk.nama,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${mk.hari}, ${mk.jamMulai} • ${mk.ruangan}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailMataKuliahScreen(mataKuliah: mk),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Jadwal hari berikutnya setelah hari ini (maks. 3 item).
  static List<MataKuliah> _jadwalBesok(
      List<MataKuliah> semua, String hariIni) {
    final indexHari = JadwalService.hariDalamMinggu.indexOf(hariIni);
    final hasil = <MataKuliah>[];
    for (var i = 1; i <= 7 && hasil.length < 3; i++) {
      final hariBerikut =
          JadwalService.hariDalamMinggu[(indexHari + i) % 7];
      hasil.addAll(JadwalService.perHari(semua, hariBerikut));
    }
    return hasil;
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _JadwalHariIniCard extends StatelessWidget {
  final MataKuliah mataKuliah;
  final VoidCallback onTap;

  const _JadwalHariIniCard({required this.mataKuliah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final warna = Color(mataKuliah.warna);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Blok jam
              Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      mataKuliah.jamMulai,
                      style: TextStyle(
                        color: warna,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Text('–',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(
                      mataKuliah.jamSelesai,
                      style: TextStyle(color: warna, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Info mata kuliah
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mataKuliah.nama,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mataKuliah.dosen,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _MiniTag(
                            icon: Icons.place_outlined,
                            text: mataKuliah.ruangan),
                        const SizedBox(width: 10),
                        _MiniTag(
                            icon: Icons.analytics_outlined,
                            text: '${mataKuliah.sks} SKS'),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey[600]),
        const SizedBox(width: 3),
        Text(text,
            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
