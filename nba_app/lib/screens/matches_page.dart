import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MatchesScreen extends StatefulWidget {
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> upcomingMatches = [];
  List<dynamic> pastMatches = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    final upcomingResponse = await http.get(
      Uri.parse(
          'https://www.balldontlie.io/api/v1/games?start_date=${_formattedDate()}'),
    );

    if (upcomingResponse.statusCode == 200) {
      setState(() {
        upcomingMatches = json.decode(upcomingResponse.body)['data'];
      });
    }

    final pastResponse = await http.get(
      Uri.parse(
          'https://www.balldontlie.io/api/v1/games?end_date=${_formattedDate()}'),
    );

    if (pastResponse.statusCode == 200) {
      setState(() {
        pastMatches = json.decode(pastResponse.body)['data'];
      });
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final twentyFourHoursAgo = now.subtract(const Duration(hours: 24));
    return twentyFourHoursAgo.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Upcoming Matches:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildMatchesList(upcomingMatches),
          const SizedBox(height: 16),
          const Text(
            'Past Matches (last 24 hours):',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          _buildMatchesList(pastMatches),
        ],
      ),
    );
  }

  Widget _buildMatchesList(List<dynamic> matches) {
    return Expanded(
      child: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return ListTile(
            title: Text('Game ID: ${match['id']}'),
            subtitle: Text('Date: ${match['date']}'),
          );
        },
      ),
    );
  }
}
