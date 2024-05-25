import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './homePage.dart';
import '../main.dart';
import '../model/login_model.dart';
import './register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  late SharedPreferences loginData;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLoggedIn();
  }

  void checkIfAlreadyLoggedIn() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);
    print("new user = $newUser");
    if (!newUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LOGIN MENU",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 117, 60, 60),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 217, 217, 231),
              Color.fromARGB(255, 176, 175, 248)
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Icon(Icons.login, size: 100, color: Colors.white),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: userController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: passController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      String user = userController.text;
                      String pass = passController.text;
                      var box = Hive.box<LoginModel>(loginBox);

                      for (var item in box.values) {
                        if (item.username == user && item.password == pass) {
                          print("LOGIN SUCCESSFUL");
                          loginData.setBool('login', false);
                          loginData.setString('username', user);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          return;
                        }
                      }

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('Incorrect username or password.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Register dahulu jika belum ada akun !",
                    style: TextStyle(color: Colors.white70),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
