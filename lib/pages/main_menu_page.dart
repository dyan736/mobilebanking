import 'package:flutter/material.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'mutasi_page.dart';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  double balance = 1000000.0;
  List<Map<String, dynamic>> mutasiList = [];

  final TextEditingController _paymentController = TextEditingController();

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  void _showLoanDialog() {
    _paymentController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pinjaman'),
          content: TextField(
            controller: _paymentController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Masukkan Jumlah Pinjaman',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                double loanAmount =
                    double.tryParse(_paymentController.text) ?? 0;
                if (loanAmount <= 0) {
                  _showSnackbar('Jumlah pinjaman tidak valid');
                } else {
                  setState(() {
                    balance += loanAmount;
                    mutasiList.add({
                      'deskripsi': 'Pinjaman',
                      'jumlah': loanAmount,
                      'waktu': DateTime.now().toString(),
                      'kategori': 'Pinjaman',
                    });
                  });
                  Navigator.of(context).pop();
                  _showSnackbar('Pinjaman berhasil ditambahkan ke saldo!');
                }
              },
              child: Text('Ajukan'),
            ),
          ],
        );
      },
    );
  }

  void _showTransactionDialog(String title, String kategori) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Masukkan Jumlah $title',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                double amount = double.tryParse(_controller.text) ?? 0;
                if (amount <= 0) {
                  _showSnackbar('Jumlah tidak valid');
                } else if (amount > balance) {
                  _showSnackbar('Saldo tidak cukup');
                } else {
                  setState(() {
                    balance -= amount;
                    mutasiList.add({
                      'deskripsi': title,
                      'jumlah': amount,
                      'waktu': DateTime.now().toString(),
                      'kategori': kategori,
                    });
                  });
                  Navigator.of(context).pop();
                  _showSnackbar('$title berhasil!');
                }
              },
              child: Text('Proses'),
            ),
          ],
        );
      },
    );
  }

  void _showCekSaldoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informasi Saldo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Nasabah: Luh Putu Dian Satriani'),
              SizedBox(height: 8),
              Text('Saldo Anda: Rp. ${balance.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Koperasi Undiksha',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 17, 52, 142),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              SizedBox(height: 20),
              _buildMenuFeatures(),
              SizedBox(height: 15),
              _buildHelpCard(),
              SizedBox(height: 15),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: AssetImage('assets/profile.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoBox('Nasabah', 'Luh Putu Dian Satriani'),
                SizedBox(height: 8),
                _buildInfoBox(
                  'Total Saldo Anda',
                  'Rp. ${balance.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(value, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildMenuFeatures() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _showCekSaldoDialog,
                child: _buildFeatureItem(
                  Icons.account_balance_wallet,
                  'Cek Saldo',
                ),
              ),
              GestureDetector(
                onTap: () => _showTransactionDialog('Transfer', 'Transfer'),
                child: _buildFeatureItem(Icons.compare_arrows, 'Transfer'),
              ),
              GestureDetector(
                onTap: () => _showTransactionDialog('Deposito', 'Deposit'),
                child: _buildFeatureItem(Icons.account_balance, 'Deposito'),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _showTransactionDialog('Pembayaran', 'Pembayaran'),
                child: _buildFeatureItem(Icons.payment, 'Pembayaran'),
              ),
              GestureDetector(
                onTap: () => _showLoanDialog(),
                child: _buildFeatureItem(Icons.money, 'Pinjaman'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MutasiPage(mutasiList: mutasiList),
                    ),
                  );
                },
                child: _buildFeatureItem(Icons.history, 'Mutasi'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh Bantuan?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '0878-1234-1024',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.phone, color: Colors.blue, size: 40),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(Icons.settings, color: Colors.blue),
              Text('Settings', style: TextStyle(color: Colors.blue)),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.qr_code_scanner, color: Colors.white),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Column(
              children: [
                Icon(Icons.person, color: Colors.blue),
                Text('Profile', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue, size: 40),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
