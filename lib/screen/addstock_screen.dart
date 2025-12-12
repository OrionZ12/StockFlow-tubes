import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController supplierCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();


  int jumlah = 1;
  List<String> kategoriList = [];
  String? kategoriDipilih;

  @override
  void initState() {
    super.initState();
    dateCtrl.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _loadCategories();
  }
  Future<void> _saveItem() async {
    try {
      final name = nameCtrl.text.trim();
      final desc = descCtrl.text.trim();
      final supplier = supplierCtrl.text.trim();
      final date = dateCtrl.text.trim();

      if (name.isEmpty || kategoriDipilih == null || supplier.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pastikan semua field wajib terisi!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = FirebaseAuth.instance.currentUser!;

      // Ambil username dari Firestore (lebih rapih daripada email)
      final userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      final username = userDoc.data()?["username"] ?? "unknown";

      await FirebaseFirestore.instance.collection("items").add({
        "name": name,
        "desc": desc,
        "stok": jumlah,
        "category": kategoriDipilih,
        "supplier": supplier,
        "date": date,

        // Field metadata
        "created_by": uid,
        "created_by_name": username,
        "last_updated": FieldValue.serverTimestamp(),
        "last_updated_by": uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item berhasil disimpan!"),
          backgroundColor: Colors.green,
        ),
      );

      context.go('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    }
  }



  // =====================================================
  // LOAD KATEGORI
  // =====================================================
  Future<void> _loadCategories() async {
    final snap = await FirebaseFirestore.instance
        .collection("categories")
        .orderBy("name")
        .get();

    kategoriList = snap.docs.map((d) => d["name"] as String).toList();
    setState(() {});
  }


  // =====================================================
  // TAMBAH KATEGORI
  // =====================================================
  Future<void> _tambahKategoriBaru() async {
    final TextEditingController catCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.pageBackground,
        title: const Text("Tambah Kategori Baru"),
        content: TextField(
          controller: catCtrl,
          decoration: const InputDecoration(hintText: "Nama kategori..."),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.blueTitle,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Simpan"),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.blueTitle,
              backgroundColor: Color.fromARGB(255, 108, 227, 112),
            ),
            onPressed: () async {
              final newCat = catCtrl.text.trim();
              if (newCat.isEmpty) return;

              // CEK DUPLIKAT LIST LOKAL
              if (kategoriList.contains(newCat)) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kategori sudah ada!"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              // TAMBAH KE LIST
              kategoriList.add(newCat);
              kategoriList.sort(
                    (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
              );

              // SIMPAN KE FIRESTORE
              await FirebaseFirestore.instance
                  .collection("categories")
                  .add({"name": newCat});

              // AGAR DROPDOWN OTOMATIS PINDAH KE KATEGORI TERBARU
              setState(() {
                kategoriDipilih = newCat;
              });

              Navigator.pop(context); // Tutup popup
            },
          ),
        ],
      ),
    );
  }


  // =====================================================
  // HAPUS KATEGORI
  // =====================================================
  Future<void> _hapusKategori(String category) async {
    // Hapus dari lokal list
    kategoriList.remove(category);
    kategoriList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    // Hapus dari Firestore (cari dokumen dengan nama yg cocok)
    final snap = await FirebaseFirestore.instance
        .collection("categories")
        .where("name", isEqualTo: category)
        .get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }

    // Reset dropdown jika kategori yg dipilih barusan dihapus
    if (kategoriDipilih == category) kategoriDipilih = null;

    setState(() {});
  }


  // =====================================================
  // POPUP KONFIRMASI DELETE
  // =====================================================
  Future<void> _confirmDeleteCategory(String category) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.pageBackground,
        title: const Text("Hapus Kategori"),
        content:
            Text("Apakah Anda yakin ingin menghapus kategori \"$category\"?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.blueMain,
            ),
          ),
          ElevatedButton(
            child: const Text("Hapus"),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // tutup dialog delete
              Navigator.pop(context); // tutup bottom sheet → FIX ERROR Range
              await _hapusKategori(category);
            },
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BOTTOM SHEET PILIH KATEGORI (TANPA ERROR)
  // =====================================================
  void _showKategoriSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 360,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 12),
              const Text("Pilih Kategori",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("categories")
                      .orderBy("name")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final nama = docs[index]["name"];

                        return ListTile(
                          title: Text(nama),
                          onTap: () {
                            setState(() => kategoriDipilih = nama);
                            Navigator.pop(context);
                          },

                          onLongPress: () =>
                              _confirmDeleteCategory(nama),
                        );
                      },
                    );
                  },
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text("+ Tambah Kategori",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                    _tambahKategoriBaru();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // =====================================================
  // UI DROPDOWN
  // =====================================================
  Widget _dropdownKategori() {
    return GestureDetector(
      onTap: _showKategoriSelector,
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                kategoriDipilih ?? "Pilih kategori...",
                style: TextStyle(
                    color:
                        kategoriDipilih == null ? Colors.grey : Colors.black),
              ),
            ),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  // =====================================================
  // BUILD UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6EDFE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color(0xFF5A6ACF),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text("Stock",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("Flow",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF5A6ACF),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20),
              _title("Nama Produk"),
              _inputField(nameCtrl, placeholder: "Nama Produk"),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Tanggal Masuk"),
                        _dateField(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title("Jumlah"),
                        _jumlahField(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _title("Kategori"),
              _dropdownKategori(),
              const SizedBox(height: 15),
              _title("Pemasok"),
              _inputField(supplierCtrl),
              const SizedBox(height: 15),
              _title("Deskripsi"),
              _inputField(descCtrl, maxLines: 3),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A6ACF),
                      padding: EdgeInsets.symmetric(
                          horizontal: w * 0.25, vertical: 14)),
                  onPressed: _saveItem,
                  child: const Text("Masukkan",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // WIDGETS
  // =====================================================
  Widget _title(String text) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600));

  Widget _inputField(TextEditingController c,
          {String? placeholder, int maxLines = 1}) =>
      Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          decoration:
              InputDecoration(hintText: placeholder, border: InputBorder.none),
        ),
      );

  Widget _dateField() {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          dateCtrl.text = DateFormat("dd-MM-yyyy").format(picked);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Expanded(child: Text(dateCtrl.text)),
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _jumlahField() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                if (jumlah > 1) setState(() => jumlah--);
              },
              icon: const Icon(Icons.remove)),
          Text("$jumlah", style: const TextStyle(fontSize: 16)),
          IconButton(
              onPressed: () => setState(() => jumlah++),
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}