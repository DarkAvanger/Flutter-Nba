import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/model/player.dart';
import 'package:nba_app/model/team.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/pelotas_fondo.jpg"), // Ruta de la imagen
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

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

          if (teamAbbreviationToPlayers.containsKey(player.team)) {
            teamAbbreviationToPlayers[player.team]!.add(player);
          } else {
            teamAbbreviationToPlayers[player.team] = [player];
          }
        }

        teams.clear();
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
            //print('Team data is incomplete: $eachTeam');
          }
        }

        setState(() {
          isLoading = false;
        });
      } else {
        //print('Failed to load teams and players');
      }
    } catch (error) {
      //print('Error loading teams and players: $error');
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
        title: const Text(
          'NBA TEAM LINEUPS',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 169, 151),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fondo_pelotas.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
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
                        title: Text(
                          teams[index].abreviation,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(teams[index].city),
                        trailing: Image.asset(
                          'assets/${teams[index].city}.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  );
                },
              ),
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
        title: Text(
          'Players of ${team.abreviation}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 39, 169, 151),
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
      title: Text(
        player.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStat('Team', teamName),
          _buildStat(
              'Height', '${player.heightFeet}\' ${player.heightInches}\"'),
          _buildStat('Position', player.position),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
