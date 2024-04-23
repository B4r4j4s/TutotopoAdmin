import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/UserProvider.dart';
import 'views/Login.dart';
//import 'views/AppBarNavegador.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
          /*ChangeNotifierProvider<CitaProvider>(
      create: (_) => CitaProvider(),
    ),*/
        ],
        child: MaterialApp(
          title: 'ADMIN',
          theme: ThemeData(
            // This is the theme of your application.

            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
          ),
          home: const Login(),
        ));
  }
}
