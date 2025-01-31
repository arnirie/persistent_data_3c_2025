import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  late SharedPreferences prefs;

  final usernameCtrl = TextEditingController();

  void fetchPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    usernameCtrl.text = username ?? '';
    isChecked = prefs.getBool('remember') ?? false;
    print('remember');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPrefs();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
                'https://upload.wikimedia.org/wikipedia/en/7/75/Pangasinan_State_University_logo.png'),
            TextField(
              controller: usernameCtrl,
            ),
            TextField(),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    isChecked = value ?? false;
                    setState(() {});
                  },
                ),
                Text('Remember me'),
              ],
            ),
            ElevatedButton(onPressed: doLogin, child: const Text('Login'))
          ],
        ),
      ),
    );
  }

  void doLogin() {
    if (isChecked) {
      prefs.setString('username', usernameCtrl.text);
      prefs.setBool('remember', isChecked);
    } else {
      prefs.remove('username');
      prefs.remove('remember');
    }
  }
}
