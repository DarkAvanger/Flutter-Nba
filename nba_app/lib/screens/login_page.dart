import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nba_app/model/userData.dart';
import 'package:nba_app/screens/home_page.dart';
import 'package:nba_app/screens/menuSelection_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool loginButtonPressed = false;
  File? _userImage;

  @override
  void initState() {
    super.initState();
    //Provider.of<UserData>(context, listen: false)
    //.setUsername('TestUser'); //Check code if Username is not empty
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String savedUsername = prefs.getString('username') ?? '';
    if (savedUsername.isNotEmpty) {
      Provider.of<UserData>(context, listen: false).setUsername(savedUsername);
      setState(() {
        loginButtonPressed = true;
      });
    }

    String? imagePath = prefs.getString('userImagePath');
    if (imagePath != null && imagePath.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        _userImage = File(imagePath);
      });
    }
  }

  void saveUserData(String username, String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('username', username);

    prefs.setString('userImagePath', imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<UserData>(context, listen: false).username.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuSelection()),
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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _userImage != null
                          ? FileImage(_userImage!)
                          : const AssetImage("assets/User.png")
                              as ImageProvider,
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
                            child: const Text('Create Username'),
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

  void _pickUserImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _userImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
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
                GestureDetector(
                  onTap: () {
                    _pickUserImage();
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _userImage != null
                        ? FileImage(_userImage!)
                        : const AssetImage("assets/User.png") as ImageProvider,
                  ),
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
                    SystemNavigator.pop();
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
    String imagePath = _userImage?.path ?? '';
    Provider.of<UserData>(context, listen: false).setUsername(username);
    saveUserData(username, imagePath);
    _loadUserData();
  }
}
