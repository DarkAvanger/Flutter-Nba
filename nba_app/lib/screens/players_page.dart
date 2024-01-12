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
          final abbreviation = eachTeam['abbreviation'];
          final city = eachTeam['city'];

          // Check if 'abbreviation' and 'city' are not null
          if (abbreviation != null && city != null) {
            final team = Team(
              abreviation: abbreviation,
              city: city,
            );
            teams.add(team);
          } else {
            print('Team data is incomplete: $eachTeam');
          }
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
    List<Player> players = [];
    try {
      var responsePlayers =
          await http.get(Uri.https('www.balldontlie.io', '/api/v1/players'));
      var responseTeams =
          await http.get(Uri.https('www.balldontlie.io', '/api/v1/teams'));

      if (responsePlayers.statusCode == 200 &&
          responseTeams.statusCode == 200) {
        var jsonPlayers = jsonDecode(responsePlayers.body);
        var jsonTeams = jsonDecode(responseTeams.body);

        // Create a map of team abbreviations to team names
        Map<String, String> teamAbbreviationsToNames = {};
        for (var team in jsonTeams['data']) {
          teamAbbreviationsToNames[team['abbreviation']] = team['city'];
        }

        for (var eachPlayer in jsonPlayers['data']) {
          final player = Player(
            name: eachPlayer['first_name'] + ' ' + eachPlayer['last_name'],
            team:
                teamAbbreviationsToNames[eachPlayer['team']['abbreviation']] ??
                    'Unknown',
          );
          players.add(player);
        }
      } else {
        print('Failed to load players: ${responsePlayers.statusCode}');
      }
    } catch (error) {
      print('Error loading players: $error');
    }
    return players;
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
                  // Agrega más detalles del jugador según tu modelo de datos
                );
              },
            );
          }
        },
      ),
    );
  }
}
