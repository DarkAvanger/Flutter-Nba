import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> allMatches = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    final now = DateTime.now();
    final startDateTime = now.subtract(const Duration(days: 7));
    final endDateTime = now.add(const Duration(days: 7));

    final response = await http.get(
      Uri.parse(
        'https://www.balldontlie.io/api/v1/games?start_date=${startDateTime.toIso8601String()}&end_date=${endDateTime.toIso8601String()}',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        allMatches = json.decode(response.body)['data'];
        allMatches.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
      });
    }
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
          _buildMatchesList(allMatches),
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
          final team1City = match['home_team']['city'];
          final team2City = match['visitor_team']['city'];
          final team1Logo = 'assets/$team1City.png';
          final team2Logo = 'assets/$team2City.png';

          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.grey,
            ),
            child: ListTile(
              leading: Image.asset(team1Logo, width: 75, height: 75),
              title: const Center(
                child: Text('vs', style: TextStyle(fontSize: 20)),
              ),
              trailing: Image.asset(team2Logo, width: 75, height: 75),
              subtitle: Text('${_formatTime(match['date'])}'),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(String date) {
    final parsedDate = DateTime.parse(date);
    final formattedTime = DateFormat('MMMM dd - hh:mm a').format(parsedDate);
    return formattedTime;
  }
}
