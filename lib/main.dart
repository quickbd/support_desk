import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:support_desk/providers/auth_provider.dart';
import 'package:support_desk/providers/department_provider.dart';
import 'package:support_desk/providers/priority_provider.dart';
import 'package:support_desk/providers/services_provider.dart';
import 'package:support_desk/providers/tickets_provider.dart';
import 'package:support_desk/views/SplashScreen/splash_screen.dart';
import 'package:support_desk/views/DashboardScreen/dashboard_screen.dart';
import 'package:support_desk/views/auth/login/login.dart';
import 'package:support_desk/views/auth/register/register.dart';
import 'package:support_desk/views/auth/forget_password/forget_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => TicketsProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => PriorityProvider()),
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
          '/register': (ctx) => const RegisterView(),
          '/dashboard': (ctx) => const DashboardScreen(),
          '/forget-password': (ctx) => const ForgetPassword(),
        },
      ),
    );
  }
}
