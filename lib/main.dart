import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'provider/app_state_provider.dart';
import 'provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup a global Flutter error handler to print errors to the console
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  // Initialize Firebase and catch any errors so we can display them
  String? initError;
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    initError = '$e\n$st';
    debugPrint('Initialization error: $e');
    debugPrint('$st');
    // Continue running the app even if Firebase fails to initialize
    // This allows development without full Firebase setup
  }

  if (initError != null) {
    debugPrint(
      'Warning: Firebase initialization failed. App will run without Firebase.',
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'StockFlow',
        theme: ThemeData(fontFamily: 'RobotoSerif'),
        routerConfig: createRouter(),
      ),
    );
  }
}
