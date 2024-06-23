import 'dart:collection';
import 'dart:io';

class Menu {
  Map<String, List<Map<String, dynamic>>> items;

  Menu(this.items);

  Map<String, dynamic>? cariItem(String namaItem) {
    for (var kategori in items.values) {
      for (var item in kategori) {
        if (item["name"].toLowerCase() == namaItem.toLowerCase()) {
          return item;
        }
      }
    }
    return null;
  }
}

class Pelanggan {
  String nama;
  Queue<Map<String, dynamic>> pesanan;

  Pelanggan(this.nama) : pesanan = Queue<Map<String, dynamic>>();

  void tambahPesanan(Map<String, dynamic> item, int jumlah) {
    int totalHarga = item["price"] * jumlah;
    pesanan.add({
      "namaItem": item["name"],
      "jumlah": jumlah,
      "harga": item["price"],
      "totalHarga": totalHarga,
    });
    print(
        "Ditambahkan ke pesanan $nama: ${item["name"]}, Jumlah: $jumlah, Harga: Rp ${item["price"]}, Total: Rp $totalHarga");
  }

  void tampilkanPesanan() {
    if (pesanan.isEmpty) {
      print("Belum ada pesanan.");
    } else {
      var sortedPesanan = pesanan.toList();
      sortedPesanan.sort((a, b) => a["namaItem"].compareTo(b["namaItem"]));

      print("\nPesanan $nama:");
      int totalKeseluruhan = 0;
      for (var itemPesanan in sortedPesanan) {
        int? totalHarga = itemPesanan["totalHarga"];
        if (totalHarga != null) {
          print(
              "- ${itemPesanan["namaItem"]}, Jumlah: ${itemPesanan["jumlah"]}, Total Harga: Rp $totalHarga");
          totalKeseluruhan += totalHarga;
        }
      }
      print("Total Keseluruhan untuk $nama: Rp $totalKeseluruhan");
    }
  }
}

class Restoran {
  Menu menu;
  Map<String, Pelanggan> pelanggan;

  Restoran(this.menu) : pelanggan = {};

  void tambahPesanan(String namaPelanggan, String namaItem, int jumlah) {
    var item = menu.cariItem(namaItem);
    if (item != null) {
      if (!pelanggan.containsKey(namaPelanggan)) {
        pelanggan[namaPelanggan] = Pelanggan(namaPelanggan);
      }
      pelanggan[namaPelanggan]?.tambahPesanan(item, jumlah);
    } else {
      print("Item tidak ditemukan dalam menu!");
    }
  }

  void tampilkanPesanan() {
    if (pelanggan.isEmpty) {
      print("Belum ada pesanan.");
    } else {
      pelanggan.forEach((nama, pelanggan) {
        pelanggan.tampilkanPesanan();
      });
    }
  }

  void mulai() {
    while (true) {
      print("\nMasukkan nama Anda (atau ketik 'selesai' untuk menyelesaikan pesanan):");
      String? namaPelanggan = stdin.readLineSync();
      if (namaPelanggan == null || namaPelanggan.toLowerCase() == 'selesai') {
        break;
      }

      while (true) {
        print("\nMasukkan menu yang ingin dipesan (atau ketik 'done' untuk selesai memesan):");
        String? namaItem = stdin.readLineSync();
        if (namaItem == null || namaItem.toLowerCase() == 'done') {
          break;
        }

        print("Masukkan jumlah:");
        String? inputJumlah = stdin.readLineSync();
        int? jumlah = int.tryParse(inputJumlah ?? '');
        if (jumlah == null || jumlah <= 0) {
          print("Jumlah tidak valid. Silakan masukkan angka yang benar.");
          continue;
        }

        tambahPesanan(namaPelanggan, namaItem, jumlah);
      }
    }

    tampilkanPesanan();
  }
}

Map<String, List<Map<String, dynamic>>> dataMenu = {
  "Makanan": [
    {"name": "Soto Ayam", "price": 18000},
    {"name": "Nasi Goreng", "price": 12000},
    {"name": "Nasi Goreng Seafood", "price": 15000},
    {"name": "Nasi Goreng Kampung", "price": 12000},
    {"name": "Mie Goreng", "price": 10000},
    {"name": "Mie Ayam", "price": 10000},
    {"name": "Ayam Geprek", "price": 10000},
    {"name": "Ayam Geprek Sambal Ijo", "price": 10000},
  ],
  "Minuman": [
    {"name": "Es Teh Manis", "price": 4000},
    {"name": "Es Jeruk", "price": 4000},
    {"name": "Teh Hangat", "price": 4000},
    {"name": "Es Buah", "price": 10000},
    {"name": "Es Campur", "price": 7000},
    {"name": "Air Mineral", "price": 3000},
  ],
  "Jajanan dan Cemilan": [
    {"name": "Pisang Goreng", "price": 5000},
    {"name": "Serabi", "price": 5000},
    {"name": "Bakwan", "price": 5000},
  ]
};

void main() {
  Menu menu = Menu(dataMenu);
  Restoran restoran = Restoran(menu);
  restoran.mulai();
}
