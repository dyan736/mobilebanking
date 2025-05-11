import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositoPage extends StatefulWidget {
  final double saldo;
  final Function(double) onDeposito;

  const DepositoPage({
    super.key,
    required this.saldo,
    required this.onDeposito,
  });

  @override
  State<DepositoPage> createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  String? jumlahError;
  String? selectedTenor;
  double selectedInterestRate = 0.0;

  final List<Map<String, dynamic>> tenorOptions = [
    {'label': '1 bulan - 4,5% p.a.', 'months': 1, 'rate': 4.5},
    {'label': '3 bulan - 5,25% p.a.', 'months': 3, 'rate': 5.25},
    {'label': '6 bulan - 5,75% p.a.', 'months': 6, 'rate': 5.75},
    {'label': '12 bulan - 6% p.a.', 'months': 12, 'rate': 6.0},
  ];

  void _updateState() {
    final jumlah = double.tryParse(_jumlahController.text) ?? 0;
    setState(() {
      if (jumlah < 500000) {
        jumlahError = 'Minimal Deposito adalah Rp 500.000';
      } else if (jumlah > widget.saldo) {
        jumlahError = 'Saldo tidak mencukupi';
      } else {
        jumlahError = null;
      }
    });
  }

  double _calculateBunga() {
    final jumlah = double.tryParse(_jumlahController.text) ?? 0;
    final selected = tenorOptions.firstWhere(
      (item) => item['label'] == selectedTenor,
      orElse: () => {},
    );
    if (jumlah > 0 && selected.isNotEmpty) {
      int months = selected['months'];
      double rate = selected['rate'];
      return jumlah * (rate / 100) * (months / 12);
    }
    return 0;
  }

  bool get isButtonEnabled {
    final jumlah = double.tryParse(_jumlahController.text) ?? 0;
    return jumlah >= 500000 && jumlah <= widget.saldo && selectedTenor != null;
  }

  void _showConfirmationDialog(double jumlah) {
    final bunga = _calculateBunga();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Deposito'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jumlah: Rp ${jumlah.toStringAsFixed(0)}'),
              Text('Jangka Waktu: $selectedTenor'),
              Text('Perkiraan Bunga: Rp ${bunga.toStringAsFixed(0)}'),
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
                widget.onDeposito(jumlah);
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
      builder:
          (_) => AlertDialog(
            title: Text('Deposito Berhasil'),
            content: Text('Deposito telah berhasil dilakukan.'),
          ),
    );

    Future.delayed(Duration(seconds: 2), () {
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
    final bunga = _calculateBunga();

    return Scaffold(
      appBar: AppBar(
        title: Text('Deposito', style: TextStyle(color: Colors.white)),
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
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Jumlah Penempatan Deposito',
                  border: OutlineInputBorder(),
                  errorText: jumlahError,
                ),
                onChanged: (_) => _updateState(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Jangka Waktu & Suku Bunga',
                  border: OutlineInputBorder(),
                ),
                items:
                    tenorOptions
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item['label'],
                            child: Text(item['label']),
                          ),
                        )
                        .toList(),
                value: selectedTenor,
                onChanged: (value) {
                  setState(() {
                    selectedTenor = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset('assets/pot_coin.png', width: 80, height: 80),
                    SizedBox(width: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perkiraan Bunga',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Rp ${bunga.toStringAsFixed(0)}'),
                      ],
                    ),
                  ],
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
                          _showConfirmationDialog(jumlah);
                        }
                        : null,
                child: Text('Deposit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
