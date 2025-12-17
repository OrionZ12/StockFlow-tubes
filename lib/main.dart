import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/routes.dart';
import 'data/notif_remote_source.dart';
import 'provider/app_state_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/notif_provider.dart';
import 'screen/notif_directory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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

        // ✅ NOTIFICATION PROVIDER (BENAR)
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(
            NotificationRepository(
              NotificationRemoteSource(),
            ),
          ),
        ),
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
