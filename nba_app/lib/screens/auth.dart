class AuthService {
  bool _authenticated = false;

  bool isAuthenticated() {
    return _authenticated;
  }

  Future<bool> login() async {
    await Future.delayed(Duration(seconds: 2));

    _authenticated = true;

    return true;
  }

  void logout() {
    _authenticated = false;
  }
}
