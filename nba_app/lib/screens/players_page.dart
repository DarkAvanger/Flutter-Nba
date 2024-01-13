import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/model/player.dart';
import 'package:nba_app/model/team.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  List<Team> teams = [];
  bool isLoading = true;

  Future<void> getTeamsAndPlayers() async {
    try {
      var teamsResponse =
          await http.get(Uri.https('www.balldontlie.io', '/api/v1/teams'));
      var playersResponse =
          await http.get(Uri.https('www.balldontlie.io', '/api/v1/players'));

      if (teamsResponse.statusCode == 200 &&
          playersResponse.statusCode == 200) {
        var jsonTeams = jsonDecode(teamsResponse.body);
        var jsonPlayers = jsonDecode(playersResponse.body);

        Map<String, List<Player>> teamAbbreviationToPlayers = {};

        for (var eachPlayer in jsonPlayers['data']) {
          final player = Player.fromJson(eachPlayer);

          // Asocia cada jugador con su equipo
          if (teamAbbreviationToPlayers.containsKey(player.team)) {
            teamAbbreviationToPlayers[player.team]!.add(player);
          } else {
            teamAbbreviationToPlayers[player.team] = [player];
          }
        }

        teams.clear(); // Limpia la lista de equipos antes de agregar nuevos
        for (var eachTeam in jsonTeams['data']) {
          final abbreviation = eachTeam['abbreviation'];
          final city = eachTeam['city'];

          if (abbreviation != null && city != null) {
            final team = Team(
              abreviation: abbreviation,
              city: city,
              players: teamAbbreviationToPlayers[abbreviation] ?? [],
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
        print('Failed to load teams and players');
      }
    } catch (error) {
      print('Error loading teams and players: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getTeamsAndPlayers();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayersListPage(
                          team: teams[index],
                        ),
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
  final Team team;

  const PlayersListPage({
    required this.team,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players of ${team.abreviation}'),
      ),
      body: ListView.builder(
        itemCount: team.players.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: GestureDetector(
              onTap: () {
                _showPlayerStatsPopup(context, team.players[index]);
              },
              child: Text(team.players[index].name),
            ),
          );
        },
      ),
    );
  }

  void _showPlayerStatsPopup(BuildContext context, Player player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayerStatsPopup(
          player: player,
          teamName: team.city,
        );
      },
    );
  }
}

class PlayerStatsPopup extends StatelessWidget {
  final Player player;
  final String teamName;

  const PlayerStatsPopup({
    required this.player,
    required this.teamName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(player.name),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Team: $teamName'),
          Text('Height: ${player.heightFeet}\' ${player.heightInches}\"'),
          Text('Position: ${player.position}'),
          // Agregar estadísticas restantes
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el pop up
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
