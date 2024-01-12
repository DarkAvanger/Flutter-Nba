class Player {
  final String name;

  Player({required this.name});

  // Método para convertir datos JSON en un objeto Player
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
    );
  }
}
