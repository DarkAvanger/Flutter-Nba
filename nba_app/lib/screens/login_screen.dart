import 'package:flutter/material.dart';
import 'package:nba_app/screens/home_page.dart';
import 'auth.dart';

class LoginScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  void _login(BuildContext context) {
    authService.login().then((success) {
      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed!'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _login(context),
          child: Text('Login'),
        ),
      ),
    );
  }
}
