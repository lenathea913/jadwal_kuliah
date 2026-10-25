import 'package:flutter/material.dart';

import '../model/matakuliah.dart';
import '../viewmodel/jadwal_service.dart';
import 'detail_matakuliah.dart';

/// Halaman daftar mata kuliah (tab kedua BottomNavigationBar).
///
/// Berisi pencarian, filter chip per hari, dan daftar mata kuliah
/// yang dikelompokkan berdasarkan hari.
class MataKuliahScreen extends StatefulWidget {
  final List<MataKuliah> daftarMataKuliah;

  const MataKuliahScreen({super.key, required this.daftarMataKuliah});

  @override
  State<MataKuliahScreen> createState() => _MataKuliahScreenState();
}

class _MataKuliahScreenState extends State<MataKuliahScreen> {
  String _query = '';
  String? _filterHari;

  List<MataKuliah> get _hasilFilter {
    var list = widget.daftarMataKuliah;
    if (_filterHari != null) {
      list = JadwalService.perHari(list, _filterHari!);
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((m) =>
              m.nama.toLowerCase().contains(q) ||
              m.kode.toLowerCase().contains(q) ||
              m.dosen.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasilFilter;

    // Kelompokkan berdasarkan hari sesuai urutan hari.
    final terkelompok = <String, List<MataKuliah>>{};
    for (final hari in JadwalService.hariDalamMinggu) {
      final perHari = hasil.where((m) => m.hari == hari).toList();
      if (perHari.isNotEmpty) terkelompok[hari] = perHari;
    }

    return Column(
      children: [
        // Pencarian
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari mata kuliah / dosen...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),

        // Filter chip per hari
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _filterChip(null),
              ...JadwalService.hariDalamMinggu
                  .where((h) =>
                      widget.daftarMataKuliah.any((m) => m.hari == h))
                  .map(_filterChip),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Daftar hasil
        Expanded(
          child: hasil.isEmpty
              ? const Center(
                  child: Text('Mata kuliah tidak ditemukan.'),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    for (final entry in terkelompok.entries) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${entry.value.length} kelas',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...entry.value.map(_buildCard),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _filterChip(String? hari) {
    final selected = _filterHari == hari;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(hari ?? 'Semua'),
        selected: selected,
        onSelected: (_) => setState(() => _filterHari = hari),
      ),
    );
  }

  Widget _buildCard(MataKuliah mk) {
    final warna = Color(mk.warna);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: warna.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              mk.kode.substring(mk.kode.length - 3),
              style: TextStyle(
                color: warna,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        title: Text(
          mk.nama,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${mk.hari} • ${mk.jamMulai}–${mk.jamSelesai} • ${mk.ruangan}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailMataKuliahScreen(mataKuliah: mk),
          ),
        ),
      ),
    );
  }
}
