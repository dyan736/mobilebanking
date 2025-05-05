import 'package:flutter/material.dart';

class MutasiPage extends StatefulWidget {
  final List<Map<String, dynamic>> mutasiList;

  MutasiPage({required this.mutasiList});

  @override
  _MutasiPageState createState() => _MutasiPageState();
}

class _MutasiPageState extends State<MutasiPage> {
  String selectedCategory = 'Semua';

  List<String> categories = [
    'Semua',
    'Transfer',
    'Pembayaran',
    'Deposit',
    'Pinjaman',
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList =
        selectedCategory == 'Semua'
            ? widget.mutasiList
            : widget.mutasiList
                .where((item) => item['kategori'] == selectedCategory)
                .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 239, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 52, 142),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Mutasi Rekening', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol filter kategori
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      final bool isSelected = category == selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 16),
            // Daftar Mutasi
            Expanded(
              child:
                  filteredList.isEmpty
                      ? Center(child: Text('Belum ada mutasi.'))
                      : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          final bool isPositive =
                              item['kategori'] == 'Pinjaman';
                          return Card(
                            child: ListTile(
                              title: Text(item['deskripsi']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: isPositive ? '+ ' : '- ',
                                      style: TextStyle(
                                        color:
                                            isPositive
                                                ? Colors.green
                                                : Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              'Rp. ${item['jumlah'].toStringAsFixed(2)}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(item['waktu']),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
