import 'package:data_siswa/pages/auth/auth_page.dart';
import 'package:data_siswa/pages/menu_page.dart';
import 'package:data_siswa/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'AUTH',
        theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue)
                .copyWith(secondary: Colors.blueAccent)),
        home: const MainPage(),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went Wrong'),
                );
              } else if (snapshot.hasData) {
                return const MenuPage();
              } else {
                return const AuthPage();
              }
            }),
      );
}
