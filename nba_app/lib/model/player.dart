class Player {
  final String name;
  final String team;

  Player({required this.name, required this.team});

  // Método para convertir datos JSON en un objeto Player
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      team: json['team'],
    );
  }
}
