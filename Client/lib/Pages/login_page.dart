
import 'package:client/Pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import "package:client/globals.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static String _username = "";
  static String _password = "";
  static String _tenant = "";
  bool _obscuredPassword = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                        )
                      ]),
                  child: Form(
                    key: _globalFormKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Benvenuto",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.person),
                              onPressed: () => {},
                            ),
                            hintText: "Username",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                          ),
                          onSaved: (value) => _username = value.toString(),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obscuredPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: _togglePasswordObscured,
                            ),
                            hintText: "Password",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                          ),
                          onSaved: (value) => _password = value.toString(),
                          obscureText: _obscuredPassword,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Tenat",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                            )),
                          ),
                          onSaved: (value) => _tenant = value.toString(),
                        ),
                        const SizedBox(width: 10, height: 40),
                        ElevatedButton(
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: () {
                              if (validateAndSave()) {
                                attemptLogin().then((isLoggedIn) {
                                  if (isLoggedIn) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SettingsPage()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Impossibile effettuare il login!")));
                                  }
                                });
                              }
                            }),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _togglePasswordObscured() {
    setState(() {
      _obscuredPassword = !_obscuredPassword;
    });
  }

  static Future<bool> attemptLogin() async {
    Response response =
        await post(Uri.parse('https://students.measurify.org/v1/login'), body: {
      "username": _username, //"body-monitor-username",
      "password": _password, //"body-monitor-password",
      "tenant": _tenant, //"body-monitor"
    });

    if (response.statusCode != 200) {
      return false;
    }

    Map body = jsonDecode(response.body);
    Globals.measurifyToken = body["token"];

    return true;
  }

  bool validateAndSave() {
    final form = _globalFormKey.currentState;
    form?.save();
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
