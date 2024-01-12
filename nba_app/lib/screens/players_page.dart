import 'dart:convert';
import 'package:nba_app/model/team.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/model/player.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
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
            abreviation: eachTeam['abbreviation'],
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
        title: const Text('NBA Teams'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                String name = teams[index].city;
                return GestureDetector(
                  onTap: () {
                    // Navegar a la pantalla de jugadores al hacer clic en un equipo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayersListPage(
                            teamAbbreviation: teams[index].abreviation),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[300],
                    ),
                    child: ListTile(
                      title: Text(teams[index].abreviation),
                      subtitle: Text(teams[index].city),
                      trailing: Image.asset('assets/$name.png'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class PlayersListPage extends StatelessWidget {
  final String teamAbbreviation;

  const PlayersListPage({required this.teamAbbreviation, Key? key})
      : super(key: key);

  Future<List<Player>> getPlayers() async {
//Coger Jugadores de la api
    return [
      Player(name: 'Player 1'),
      Player(name: 'Player 2'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players of $teamAbbreviation'),
      ),
      body: FutureBuilder(
        future: getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading players: ${snapshot.error}'),
            );
          } else {
            List<Player> players = snapshot.data as List<Player>;

            return ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(players[index].name),
                );
              },
            );
          }
        },
      ),
    );
  }
}
