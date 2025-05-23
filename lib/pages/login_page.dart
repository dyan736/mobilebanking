import 'package:flutter/material.dart';
import 'main_menu_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk menyimpan data login ke SharedPreferences
  static Future<void> saveLoginData(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    print("Username and Password saved.");
  }

  // Fungsi untuk mengambil data login dari SharedPreferences
  void loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    print("Loaded Username: $savedUsername");
    print("Loaded Password: $savedPassword");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Kotak biru di atas dengan tulisan "Koperasi Undiksha"
          Container(
            width: double.infinity,
            height: 56,
            color: const Color.fromARGB(255, 17, 52, 142),
            child: Center(
              child: Text(
                'Koperasi Undiksha',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Logo Undiksha
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              'assets/logo-undiksha.png',
              width: 200,
              height: 200,
            ),
          ),

          // Form Login dengan Outline Kotak
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Container(
                  padding: EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 17, 52, 142),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Tulisan Username
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // Input Username
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText:
                                'name@student.undiksha.ac.id', // Hint text
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),

                        // Tulisan Password
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // Input Password
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Tombol Login dengan Shadow
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                // Cek apakah username dan password sesuai
                                if (username ==
                                        'dian.satriani@student.undiksha.ac.id' &&
                                    password == 'admin123') {
                                  // Simpan username dan password ke SharedPreferences
                                  await LoginPage.saveLoginData(
                                    username,
                                    password,
                                  );

                                  // Proses login dan navigasi ke halaman utama
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainMenuPage(),
                                    ),
                                  );
                                } else {
                                  String errorMessage = '';
                                  if (username !=
                                      'dian.satriani@student.undiksha.ac.id') {
                                    errorMessage = 'Username salah';
                                  }
                                  if (password != 'admin123') {
                                    errorMessage =
                                        errorMessage.isEmpty
                                            ? 'Password salah'
                                            : '$errorMessage dan password salah';
                                  }

                                  // Tampilkan pesan error
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Login Gagal'),
                                        content: Text(errorMessage),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                17,
                                52,
                                142,
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              elevation: 5,
                              shadowColor: Colors.blue.withOpacity(0.5),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Daftar Mbanking dan Lupa Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Navigasi ke halaman Daftar Mbanking
                              },
                              child: Text(
                                'Daftar Mbanking',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigasi ke halaman Lupa Password
                              },
                              child: Text(
                                'Lupa Password?',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Kotak biru muda di bawah dengan tulisan copyright
          Container(
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 17, 52, 142).withOpacity(0.2),
            child: Center(
              child: Text(
                'copyright @2025 by Undiksha',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
