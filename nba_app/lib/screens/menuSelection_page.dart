import 'package:flutter/material.dart';
import 'package:nba_app/screens/home_page.dart';
import 'package:nba_app/screens/login_page.dart'; // Import the LoginPage

class MenuSelection extends StatelessWidget {
  const MenuSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(buttonNumber: 1)),
                );
              },
              child: const Text('Teams'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(buttonNumber: 2)),
                );
              },
              child: const Text('Players'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(buttonNumber: 3)),
                );
              },
              child: const Text('Matches'),
            ),
          ],
        ),
      ),
    );
  }
}
