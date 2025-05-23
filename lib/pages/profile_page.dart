import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String email = "";
  String password = "";
  bool _obscurePassword = true;

  final String fullName = "Luh Putu Dian Satriani";
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  // Memuat data dari SharedPreferences
  _loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('username') ?? ''; // Ambil email
      password = prefs.getString('password') ?? ''; // Ambil password
    });
    _emailController.text = email;
    _passwordController.text = password;
    print("Email: $email");
    print("Password: $password");
  }

  // Menyimpan data yang sudah diperbarui ke SharedPreferences
  _saveUpdatedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'username',
      _emailController.text,
    ); // Simpan email baru
    await prefs.setString(
      'password',
      _passwordController.text,
    ); // Simpan password baru
    setState(() {
      email = _emailController.text;
      password = _passwordController.text;
    });
    print("Updated Email: $email");
    print("Updated Password: $password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F0F9),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Judul di tengah dengan warna putih
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Profile Picture (dalam lingkaran putih)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage('assets/profile.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Full Name
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Full Name"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    initialValue: fullName,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email Address"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Phone Number
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Phone Number"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text("📞"),
                      ),
                      hintText: "083119259318",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Home Address
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Home Address"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Jln Veteran",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password"),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Button Kembali (berwarna putih)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              30,
                              63,
                              232,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Kembali",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
