// ignore_for_file: use_key_in_widget_constructors
// Las horas de los partidos pueden variar ya que la API envia las horas como 00:00:00 atraves de otros datos se han conseguido las horas mas proximas a las reales

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo_pelotas.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const MatchesScreen(),
      ),
    );
  }
}

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({Key? key});

  @override
  // ignore: library_private_types_in_public_api
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<dynamic> allMatches = [];
  bool isAscendingOrder = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    final now = DateTime.now();
    final startDateTime = now.subtract(const Duration(days: 30));
    final endDateTime = now.add(const Duration(days: 30));

    final response = await http.get(
      Uri.parse(
        'https://www.balldontlie.io/api/v1/games?start_date=${startDateTime.toIso8601String()}&end_date=${endDateTime.toIso8601String()}',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        allMatches = json.decode(response.body)['data'];
        _sortMatches();
      });
    }
  }

  void _sortMatches() {
    allMatches.sort((a, b) =>
        DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    if (!isAscendingOrder) {
      allMatches = allMatches.reversed.toList();
    }
  }

  String _extractTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final formattedTime = DateFormat('HH:mm').format(dateTime);
      return formattedTime;
    } catch (e) {
      return dateTimeString;
    }
  }

  void _toggleOrder() {
    setState(() {
      isAscendingOrder = !isAscendingOrder;
      _sortMatches();
    });
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

          final formattedDate = _formatTime(match['date']);
          final statusAndDate =
              '$formattedDate, ${_extractTime(match['status'])}';

          return GestureDetector(
            onTap: () => _showMatchDetails(match),
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Image.asset(team1Logo, width: 75, height: 75),
                title: const Center(
                  child: Text(
                    'vs',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                trailing: Image.asset(team2Logo, width: 75, height: 75),
                subtitle: Center(
                  child: Text(
                    statusAndDate,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMatchDetails(dynamic match) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return MatchDetailsTab(match: match, extractTime: _extractTime);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NEXT MATCHES',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 169, 151),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _toggleOrder,
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondo_pelotas.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMatchesList(allMatches),
          ],
        ),
      ),
    );
  }
}

String _formatTime(String date) {
  final parsedDate = DateTime.parse(date);
  final formattedTime = DateFormat('MMMM dd').format(parsedDate);
  return formattedTime;
}

String _formatTimeForDetails(String dateTimeString) {
  try {
    // ignore: unused_local_variable
    final dateTime = DateTime.parse(dateTimeString);
    return "Game not started";
  } catch (e) {
    return dateTimeString;
  }
}

class MatchDetailsTab extends StatelessWidget {
  final Map<String, dynamic> match;
  final String Function(String) extractTime;

  const MatchDetailsTab({required this.match, required this.extractTime});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Match Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Image.asset('assets/${match['home_team']['city']}.png',
                          width: 125, height: 125),
                      Text('Score: ${match['home_team_score']}'),
                    ],
                  ),
                ),
                const Text('vs', style: TextStyle(fontSize: 20)),
                Expanded(
                  child: Column(
                    children: [
                      Image.asset('assets/${match['visitor_team']['city']}.png',
                          width: 125, height: 125),
                      Text('Score: ${match['visitor_team_score']}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text('Status: ${_formatTimeForDetails(match['status'])}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 8.0),
            Text('Period: ${match['period']}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
