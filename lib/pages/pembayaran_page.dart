import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PembayaranPage extends StatefulWidget {
  final double saldo;
  final Function(double) onPembayaran;

  const PembayaranPage({
    super.key,
    required this.saldo,
    required this.onPembayaran,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  String? _selectedJenisPembayaran;

  @override
  void initState() {
    super.initState();
    _jumlahController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {}); // trigger tombol aktif/tidak
  }

  bool get isButtonEnabled {
    return _selectedJenisPembayaran != null &&
        _jumlahController.text.isNotEmpty;
  }

  void _showConfirmationDialog(double jumlah) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Pembayaran',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jenis Pembayaran: $_selectedJenisPembayaran'),
              Text('Jumlah: Rp ${jumlah.toStringAsFixed(0)}'),
              if (_catatanController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Catatan: ${_catatanController.text}'),
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
                widget.onPembayaran(jumlah);
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
          title: Text('Pembayaran Berhasil'),
          content: Text('Pembayaran telah berhasil dilakukan.'),
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
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
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
              DropdownButtonFormField<String>(
                value: _selectedJenisPembayaran,
                decoration: const InputDecoration(
                  labelText: 'Jenis Pembayaran',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Uang Kuliah Tunggal',
                    child: Text('Uang Kuliah Tunggal'),
                  ),
                  DropdownMenuItem(value: 'Listrik', child: Text('Listrik')),
                  DropdownMenuItem(value: 'KOS', child: Text('KOS')),
                  DropdownMenuItem(
                    value: 'Paket Internet',
                    child: Text('Paket Internet'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedJenisPembayaran = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Jumlah Pembayaran',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed:
                    isButtonEnabled
                        ? () {
                          final jumlah = double.parse(_jumlahController.text);
                          _showConfirmationDialog(jumlah);
                        }
                        : null,
                child: const Text('Bayar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
