//import 'package:skillsocket/login.dart';
import 'package:skillsocket/splashscreen.dart'; // import the new splash page
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style for better appearance
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) { 
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillSocket',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: const Color.fromARGB(255, 177, 66, 116),
        // Add responsive design support
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      // Add builder for responsive design
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child!,
        );
      },
      home: const LoadingPage(), // changed from LoginScreen to LoadingPage
    );
  }
}     
