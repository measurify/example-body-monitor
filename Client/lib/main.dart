import 'package:client/Pages/data_monitor_page.dart';
import 'package:client/Pages/login_page.dart';
import 'package:client/Pages/settings_page.dart';
import 'package:flutter/material.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tesi - Login Page',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),

    );
  }
  Map<String, WidgetBuilder> mainRouting(){
    return {
      '/login': (context) => const LoginPage(),
      '/monitorPage': (context) => const DataMonitorPage(),
      '/settings':(context) => const SettingsPage(),
    };
  }
}

