import 'package:flutter/material.dart';

import '../model/matakuliah.dart';

/// Halaman detail mata kuliah.
///
/// Dibuka melalui `Navigator.push` dari Beranda maupun daftar mata kuliah.
/// Menampilkan deskripsi, informasi dosen/ruangan/waktu,
/// dan statistik singkat mata kuliah.
class DetailMataKuliahScreen extends StatelessWidget {
  final MataKuliah mataKuliah;

  const DetailMataKuliahScreen({super.key, required this.mataKuliah});

  @override
  Widget build(BuildContext context) {
    final warna = Color(mataKuliah.warna);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header gradasi dengan tombol kembali
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: warna,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mataKuliah.nama,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [warna, warna.withValues(alpha: 0.65)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris chip informasi cepat
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Chip(label: 'Kode: ${mataKuliah.kode}', icon: Icons.tag),
                      _Chip(
                          label: '${mataKuliah.sks} SKS',
                          icon: Icons.analytics_outlined),
                      _Chip(
                          label: 'Semester ${mataKuliah.semester}',
                          icon: Icons.calendar_today_outlined),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Deskripsi',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mataKuliah.deskripsi,
                    style: const TextStyle(
                        fontSize: 14, height: 1.5, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Informasi Kelas',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Dosen Pengampu',
                          value: mataKuliah.dosen,
                        ),
                        _InfoRow(
                          icon: Icons.schedule_outlined,
                          label: 'Waktu',
                          value:
                              '${mataKuliah.hari}, ${mataKuliah.jamMulai} – ${mataKuliah.jamSelesai} WIB',
                        ),
                        _InfoRow(
                          icon: Icons.place_outlined,
                          label: 'Ruangan',
                          value: mataKuliah.ruangan,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: warna,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali ke Jadwal'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Chip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF3F51B5)),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }
}
