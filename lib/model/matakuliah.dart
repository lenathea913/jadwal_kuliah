/// Model data untuk item mata kuliah pada jadwal.
///
/// Dihasilkan dari file JSON lokal `assets/json/jadwal.json`
/// sehingga strukturnya mudah disesuaikan dengan respons API
/// pada pengembangan berikutnya.
class MataKuliah {
  final String kode;
  final String nama;
  final String dosen;
  final int sks;
  final String hari;
  final String jamMulai;
  final String jamSelesai;
  final String ruangan;
  final int semester;
  final int warna;
  final String deskripsi;

  const MataKuliah({
    required this.kode,
    required this.nama,
    required this.dosen,
    required this.sks,
    required this.hari,
    required this.jamMulai,
    required this.jamSelesai,
    required this.ruangan,
    required this.semester,
    required this.warna,
    required this.deskripsi,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) => MataKuliah(
        kode: json['kode'] as String,
        nama: json['nama'] as String,
        dosen: json['dosen'] as String,
        sks: json['sks'] as int,
        hari: json['hari'] as String,
        jamMulai: json['jamMulai'] as String,
        jamSelesai: json['jamSelesai'] as String,
        ruangan: json['ruangan'] as String,
        semester: json['semester'] as int,
        warna: _parseWarna(json['warna']),
        deskripsi: json['deskripsi'] as String,
      );

  /// Nilai warna pada JSON ditulis sebagai string heksadesimal
  /// (mis. `"0xFF3F51B5"`) agar valid JSON; bisa juga berupa int.
  static int _parseWarna(dynamic value) =>
      value is int ? value : int.parse(value as String);

  Map<String, dynamic> toJson() => {
        'kode': kode,
        'nama': nama,
        'dosen': dosen,
        'sks': sks,
        'hari': hari,
        'jamMulai': jamMulai,
        'jamSelesai': jamSelesai,
        'ruangan': ruangan,
        'semester': semester,
        'warna': warna,
        'deskripsi': deskripsi,
      };
}

/// Model data identitas mahasiswa (data dummy).
class Mahasiswa {
  final String nama;
  final String nim;
  final String kelas;
  final String prodi;
  final int semester;
  final String universitas;

  const Mahasiswa({
    required this.nama,
    required this.nim,
    required this.kelas,
    required this.prodi,
    required this.semester,
    required this.universitas,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
        nama: json['nama'] as String,
        nim: json['nim'] as String,
        kelas: json['kelas'] as String,
        prodi: json['prodi'] as String,
        semester: json['semester'] as int,
        universitas: json['universitas'] as String,
      );
}

/// Wrapper untuk seluruh isi file JSON jadwal.
class DataJadwal {
  final Mahasiswa mahasiswa;
  final List<MataKuliah> daftarMataKuliah;

  const DataJadwal({required this.mahasiswa, required this.daftarMataKuliah});

  factory DataJadwal.fromJson(Map<String, dynamic> json) => DataJadwal(
        mahasiswa: Mahasiswa.fromJson(json['mahasiswa'] as Map<String, dynamic>),
        daftarMataKuliah: (json['mataKuliah'] as List<dynamic>)
            .map((e) => MataKuliah.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
