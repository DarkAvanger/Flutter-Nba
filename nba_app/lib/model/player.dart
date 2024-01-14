// La API no envia todos los jugadores, los disponibles estan añadidios en la APP
class Player {
  final String name;
  final String team;
  final int heightFeet;
  final int heightInches;
  final String position;

  Player({
    required this.name,
    required this.team,
    required this.heightFeet,
    required this.heightInches,
    required this.position,
  });

  // Método para convertir datos JSON en un objeto Player
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['first_name'] + ' ' + json['last_name'],
      team: json['team']['abbreviation'] ??
          'Unknown', //Si la API no tiene datos lo indica como Unknow
      heightFeet:
          json['height_feet'] ?? 0, //Si la API no tiene datos lo inicia en 0
      heightInches: json['height_inches'] ?? 0,
      position: json['position'] ?? 'Unknown',
    );
  }
}
