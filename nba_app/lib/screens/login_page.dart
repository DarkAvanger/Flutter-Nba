import 'package:flutter/material.dart';
import 'package:nba_app/screens/home_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool loginButtonPressed = false;

  @override
  void initState() {
    super.initState();
    Provider.of<UserData>(context, listen: false)
        .setUsername('TestUser'); //Check code if Username is not empty
    String savedUsername =
        Provider.of<UserData>(context, listen: false).username;
    if (savedUsername.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 0), () {
        setState(() {
          loginButtonPressed = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<UserData>(context, listen: false).username.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/user.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 16.0),
                    if (Provider.of<UserData>(context).username.isNotEmpty)
                      Text(
                        'Welcome back, ${Provider.of<UserData>(context).username}!',
                        style: const TextStyle(fontSize: 18),
                      ),
                    const SizedBox(height: 16.0),
                    if (!loginButtonPressed)
                      Column(
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Username',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1.25,
                                ),
                              ),
                            ),
                            cursorColor: Colors.black,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              saveUsername(_usernameController.text, context);
                              setState(() {
                                loginButtonPressed = true;
                              });
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  _showConfigurationModal(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.settings,
                    size: 40.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigurationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Configuration Options',
                style: TextStyle(fontSize: 18),
              ),
              // Add your configuration options here
            ],
          ),
        );
      },
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
