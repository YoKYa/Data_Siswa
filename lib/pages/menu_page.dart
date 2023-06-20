import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KELOLA DATA SISWA',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sign in As', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(user.email!, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.arrow_back, size: 32),
              label: const Text('Sign Out', style: TextStyle(fontSize: 24)),
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
