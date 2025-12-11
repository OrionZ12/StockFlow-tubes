import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() => _AddStokPageState();
}

class _AddStokPageState extends State<AddStockPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController supplierCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  int jumlah = 1;
  String kategori = "Mouse";

  @override
  void initState() {
    super.initState();
    dateCtrl.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
  }

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
              // 🔙 Back Button + Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A6ACF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text("Stock",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text("Flow",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A6ACF))),
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
                      horizontal: w * 0.2,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Ajukan",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  //  WIDGET KOMPONEN
  // ---------------------------------------------------------------

  Widget _title(String text) {
    return Text(text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600));
  }

  Widget _inputField(TextEditingController c,
      {String? placeholder, int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: placeholder,
          border: InputBorder.none,
        ),
      ),
    );
  }

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: Text(dateCtrl.text)),
            const Icon(Icons.calendar_today, size: 18, color: Colors.grey)
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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

  Widget _dropdownKategori() {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: kategori,
        isExpanded: true,
        underline: const SizedBox(),
        items: ["Mouse", "Keyboard", "Monitor", "Storage"]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => kategori = v!),
      ),
    );
  }
}
