import 'package:barter_system/login.dart';
import 'package:flutter/material.dart'; 
import 'notification_service.dart';
// Firebase removed: app uses Render + MongoDB backend

// Background messaging handler removed

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Page',
      home: LoginScreen(),
    );
  }
}
