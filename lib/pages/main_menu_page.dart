import 'package:flutter/material.dart';

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Menu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Internet Banking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to other pages or perform actions
              },
              child: Text('Check Balance'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to other pages or perform actions
              },
              child: Text('Transfer Funds'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to other pages or perform actions
              },
              child: Text('Transaction History'),
            ),
          ],
        ),
      ),
    );
  }
}
