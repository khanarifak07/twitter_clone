import 'package:flutter/material.dart';
import 'package:twitter_clone/services/database/database_provider.dart';
import 'package:twitter_clone/firebase_options.dart';
import 'package:twitter_clone/services/auth/auth_gate.dart';
import 'package:twitter_clone/services/auth/auth_provider.dart';
import 'package:twitter_clone/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProviders()),
      ChangeNotifierProvider(create: (_) => DatabaseProvider())
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      home: const AuthGate(),
      theme: provider.themeData,
    );
  }
}
