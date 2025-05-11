import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinjamanPage extends StatefulWidget {
  final double saldo;
  final Function(double) onPinjaman;

  const PinjamanPage({
    super.key,
    required this.saldo,
    required this.onPinjaman,
  });

  @override
  State<PinjamanPage> createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _alasanController = TextEditingController();

  String? _selectedJumlahPinjaman;
  String? _selectedJangkaWaktu;

  final List<String> _jumlahPinjamanOptions = [
    'Rp. 1.000.000',
    'Rp. 3.000.000',
    'Rp. 5.000.000',
  ];

  final List<String> _jangkaWaktuOptions = ['1 bulan', '3 bulan', '5 bulan'];

  @override
  void initState() {
    super.initState();
    _jumlahController.addListener(_updateButtonState);
    _alasanController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {}); // trigger tombol aktif/tidak
  }

  bool get isButtonEnabled {
    return _selectedJumlahPinjaman != null &&
        _selectedJangkaWaktu != null &&
        _alasanController.text.isNotEmpty;
  }

  void _showConfirmationDialog(double jumlah, String jangkaWaktu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Pinjaman', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jumlah: Rp ${jumlah.toStringAsFixed(0)}'),
              Text('Jangka Waktu: $jangkaWaktu'),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Alasan: ${_alasanController.text}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
              ),
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ya'),
              onPressed: () {
                widget.onPinjaman(jumlah);
                Navigator.of(context).pop();
                _showSuccessDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Pinjaman Berhasil'),
          content: Text('Pinjaman telah berhasil dilakukan.'),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinjaman', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Saldo Anda: Rp ${widget.saldo.toStringAsFixed(0)}'),
              const SizedBox(height: 20),
              // Dropdown untuk jumlah pinjaman
              DropdownButtonFormField<String>(
                value: _selectedJumlahPinjaman,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Pinjaman',
                  border: OutlineInputBorder(),
                ),
                items:
                    _jumlahPinjamanOptions.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJumlahPinjaman = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Dropdown untuk jangka waktu pengembalian
              DropdownButtonFormField<String>(
                value: _selectedJangkaWaktu,
                decoration: const InputDecoration(
                  labelText: 'Jangka Waktu Pengembalian',
                  border: OutlineInputBorder(),
                ),
                items:
                    _jangkaWaktuOptions.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJangkaWaktu = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Alasan Peminjaman (wajib diisi)
              TextFormField(
                controller: _alasanController,
                decoration: const InputDecoration(
                  labelText: 'Alasan Peminjaman',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alasan peminjaman wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Tombol Pinjam
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed:
                    isButtonEnabled
                        ? () {
                          final jumlah = double.parse(
                            _selectedJumlahPinjaman!.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            ),
                          );
                          final jangkaWaktu = _selectedJangkaWaktu!;
                          _showConfirmationDialog(jumlah, jangkaWaktu);
                        }
                        : null,
                child: const Text('Pinjam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
