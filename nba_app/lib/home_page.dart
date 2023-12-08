import 'dart:convert';
import 'package:nba_app/model/team.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];

  bool isLoading = true;

  Future<void> getTeams() async {
    try {
      var response =
          await http.get(Uri.https('www.balldontlie.io', '/api/v1/teams'));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        for (var eachTeam in jsonData['data']) {
          final team = Team(
            shortName: eachTeam['abbreviation'],
            city: eachTeam['city'],
          );
          teams.add(team);
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('Failed to load teams: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading teams: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NBA Teams'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(teams[index].shortName),
                  subtitle: Text(teams[index].city),
                );
              },
            ),
    );
  }
}
