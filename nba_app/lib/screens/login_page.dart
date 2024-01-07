import 'package:flutter/material.dart';
import 'package:nba_app/screens/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  bool loginButtonPressed = false;

  @override
  void initState() {
    super.initState();
    //Provider.of<UserData>(context, listen: false).setUsername('TestUser'); //Check code if Username is not empty
    String savedUsername =
        Provider.of<UserData>(context, listen: false).username;
    if (savedUsername.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          loginButtonPressed = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (Provider.of<UserData>(context).username.isNotEmpty)
              Text(
                'Welcome back, ${Provider.of<UserData>(context).username}!',
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 16.0),
            if (!loginButtonPressed)
              Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Username',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      saveUsername(_usernameController.text, context);
                      setState(() {
                        loginButtonPressed = true;
                      });
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            if (Provider.of<UserData>(context).username.isNotEmpty ||
                loginButtonPressed)
              ElevatedButton(
                onPressed: () {
                  if (Provider.of<UserData>(context, listen: false)
                      .username
                      .isNotEmpty) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  }
                },
                child: Text('Go to Next Screen'),
              ),
          ],
        ),
      ),
    );
  }

  void saveUsername(String username, BuildContext context) {
    Provider.of<UserData>(context, listen: false).setUsername(username);
  }
}

class UserData with ChangeNotifier {
  String _username = "";

  String get username => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}