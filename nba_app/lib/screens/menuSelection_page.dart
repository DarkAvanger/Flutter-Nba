import 'package:flutter/material.dart';
import 'package:nba_app/screens/home_page.dart';
import 'package:nba_app/screens/matches_page.dart';
import 'package:nba_app/screens/login_page.dart';
import 'package:nba_app/screens/players_page.dart';

class MenuSelection extends StatelessWidget {
  const MenuSelection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main Menu',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 8, 207, 74),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo_pelotas.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuButton(
                context,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                label: 'Teams',
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlayersPage()),
                  );
                },
                label: 'Players',
              ),
              const SizedBox(height: 20),
              _buildMenuButton(
                context,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MatchesScreen()),
                  );
                },
                label: 'Matches',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required VoidCallback onPressed, required String label}) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
              fontSize: 16, color: Colors.black), // Cambia a color negro
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200),
          ),
          primary: Color.fromARGB(255, 8, 207, 74),
          side: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
    );
  }
}
