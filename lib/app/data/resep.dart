class Resep {
  String? id;
  final String? nama;
  final String? bahan;
  final String? langkah;
  final String? gambar;
  final String? deskripsi;

  Resep(
      {required this.id,
      required this.nama,
      required this.bahan,
      required this.langkah,
      required this.gambar,
      required this.deskripsi});

  factory Resep.fromJson(Map<String, dynamic> json) {
    return Resep(
      id: json['id'] as String,
      nama: json['nama'] as String,
      bahan: json['bahan'] as String,
      langkah: json['langkah'] as String,
      gambar: json['gambar'] as String,
      deskripsi: json['deskripsi'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'bahan': bahan,
      'langkah': langkah,
      'gambar': gambar,
      'deskripsi': deskripsi,
    };
  }
}
