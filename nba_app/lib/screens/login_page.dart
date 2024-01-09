import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    //Provider.of<UserData>(context, listen: false)
    //.setUsername('TestUser'); //Check code if Username is not empty
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Configuration Options',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16.0),
                Image.asset(
                  'assets/user.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _showChangeUsernameDialog(context);
                  },
                  child: const Text('Change Username'),
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Quit App'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeUsernameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Enter New Username',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty) {
                  saveUsername(_usernameController.text, context);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
              child: const Text('Cancel'),
            ),
          ],
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
