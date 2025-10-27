import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:password_manager_app/providers/password_provider.dart';
import 'package:password_manager_app/screens/add_password_screen.dart';
import 'package:password_manager_app/screens/password_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPasswordScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<PasswordProvider>(
        builder: (context, provider, child) {
          if (provider.passwords.isEmpty) {
            return const Center(
              child: Text(
                'No passwords saved yet.\nTap + to add your first password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.passwords.length,
            itemBuilder: (context, index) {
              final password = provider.passwords[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(password.title),
                  subtitle: Text(password.website),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordDetailScreen(password: password),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}