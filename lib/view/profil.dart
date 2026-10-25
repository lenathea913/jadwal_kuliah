import 'package:flutter/material.dart';

import '../model/matakuliah.dart';

/// Halaman profil mahasiswa (tab ketiga BottomNavigationBar).
///
/// Menampilkan identitas mahasiswa, ringkasan semester,
/// dan sebaran jumlah mata kuliah per hari.
class ProfilScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;

  const ProfilScreen({
    super.key,
    required this.mahasiswa,
    required this.daftarMataKuliah,
  });

  @override
  Widget build(BuildContext context) {
    final totalSks = daftarMataKuliah.fold<int>(0, (s, m) => s + m.sks);

    // Sebaran kelas per hari
    final sebaran = <String, int>{};
    for (final mk in daftarMataKuliah) {
      sebaran[mk.hari] = (sebaran[mk.hari] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        // Kartu identitas
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF3F51B5).withValues(alpha: 0.12),
                child: Text(
                  mahasiswa.nama
                      .split(' ')
                      .map((w) => w[0])
                      .take(2)
                      .join()
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F51B5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                mahasiswa.nama,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'NIM ${mahasiswa.nim}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoBox(
                      label: 'Semester',
                      value: '${mahasiswa.semester}'),
                  _InfoBox(label: 'Kelas', value: mahasiswa.kelas),
                  _InfoBox(label: 'SKS', value: '$totalSks'),
                  _InfoBox(
                      label: 'Matkul',
                      value: '${daftarMataKuliah.length}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('Data Akademik',
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              _DataRow(icon: Icons.school_outlined, label: 'Program Studi', value: mahasiswa.prodi),
              _DataRow(icon: Icons.apartment_outlined, label: 'Institusi', value: mahasiswa.universitas),
              _DataRow(icon: Icons.calendar_month_outlined, label: 'Tahun Akademik', value: '2025/2026 Ganjil'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('Sebaran Kelas per Hari',
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: sebaran.entries
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 60,
                              child: Text(e.key,
                                  style: const TextStyle(fontSize: 13))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: e.value / daftarMataKuliah.length,
                                minHeight: 8,
                                backgroundColor: Colors.grey.shade200,
                                color: const Color(0xFF3F51B5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('${e.value} kelas',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F51B5))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: const Color(0xFF3F51B5)),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }
}
