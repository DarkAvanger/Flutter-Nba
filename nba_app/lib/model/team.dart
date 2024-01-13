import 'package:nba_app/model/player.dart';

class Team {
  final String abreviation;
  final String city;
  List<Player>
      players; // Nueva propiedad para almacenar la lista de jugadores del equipo

  Team({
    required this.abreviation,
    required this.city,
    List<Player>? players, // Añadido: acepta una lista opcional de jugadores
  }) : players = players ??
            []; // Añadido: inicializa la lista de jugadores o usa una lista vacía por defecto
}
