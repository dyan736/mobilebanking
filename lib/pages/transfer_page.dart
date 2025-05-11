import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransferPage extends StatefulWidget {
  final double saldo;
  final Function(double) onTransfer;

  const TransferPage({
    super.key,
    required this.saldo,
    required this.onTransfer,
  });

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  String? jumlahError;

  @override
  void initState() {
    super.initState();
    _jumlahController.addListener(_updateButtonState);
    _rekeningController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    final jumlahText = _jumlahController.text;
    final rekeningText = _rekeningController.text;
    final jumlah = double.tryParse(jumlahText) ?? 0;

    setState(() {
      // Validasi jumlah transfer
      if (jumlahText.isNotEmpty && jumlah < 10000) {
        jumlahError = 'Minimal transfer adalah Rp 10.000';
      } else if (jumlah > widget.saldo) {
        jumlahError = 'Saldo tidak mencukupi';
      } else {
        jumlahError = null;
      }
    });
  }

  bool get isButtonEnabled {
    final jumlah = double.tryParse(_jumlahController.text) ?? 0;
    return _rekeningController.text.isNotEmpty &&
        _jumlahController.text.isNotEmpty &&
        jumlah >= 10000 &&
        jumlah <= widget.saldo;
  }

  void _showConfirmationDialog(double jumlah, String rekening) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Transfer', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Transfer ke: $rekening'),
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
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Ya'),
              onPressed: () {
                widget.onTransfer(jumlah);
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
        return AlertDialog(
          title: Text('Transfer Berhasil'),
          content: Text('Transfer telah berhasil dilakukan.'),
          actions: [],
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _rekeningController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
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
              TextFormField(
                controller: _rekeningController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Nomor Rekening Tujuan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Jumlah Transfer',
                  border: OutlineInputBorder(),
                  errorText: jumlahError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(
                  labelText: 'Catatan (Opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed:
                    isButtonEnabled
                        ? () {
                          final jumlah = double.parse(_jumlahController.text);
                          final rekening = _rekeningController.text;
                          _showConfirmationDialog(jumlah, rekening);
                        }
                        : null,
                child: Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
