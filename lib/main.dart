import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:support_desk/providers/auth_provider.dart';
import 'package:support_desk/views/SplashScreen/splash_screen.dart';
import 'package:support_desk/views/DashboardScreen/dashboard_screen.dart';
import 'package:support_desk/views/auth/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Add a named 'key' parameter

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Support Ticket System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/login': (ctx) => const LoginView(),
          '/dashboard': (ctx) => const DashboardScreen(),
        },
      ),
    );
  }
}
