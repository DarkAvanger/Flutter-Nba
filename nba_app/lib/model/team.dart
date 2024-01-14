import 'package:nba_app/model/player.dart';

class Team {
  final String abreviation;
  final String city;
  List<Player> players;

  Team({
    required this.abreviation,
    required this.city,
    List<Player>? players,
  }) : players = players ?? [];
}
