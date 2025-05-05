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

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  _loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('username')!;
      password = prefs.getString('password')!;
    });
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
                  // Profile Picture
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color.fromARGB(255, 0, 37, 150),
                        child: Icon(Icons.add, size: 18, color: Colors.white),
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
                    initialValue: email,
                    enabled: false,
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
                      hintText: "1234 5678 9101",
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
                      hintText: "",
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
                    initialValue: password,
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

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              0,
                              55,
                              150,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            // Tambahkan aksi update profile di sini
                          },
                          child: Text("Update Profile"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
