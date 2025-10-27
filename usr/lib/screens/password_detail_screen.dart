import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:password_manager_app/models/password.dart';
import 'package:password_manager_app/providers/password_provider.dart';
import 'package:password_manager_app/screens/add_password_screen.dart';

class PasswordDetailScreen extends StatelessWidget {
  final Password password;

  const PasswordDetailScreen({super.key, required this.password});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard')),
    );
  }

  void _editPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPasswordScreen(password: password),
      ),
    );
  }

  void _deletePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Password'),
        content: const Text('Are you sure you want to delete this password?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<PasswordProvider>(context, listen: false)
                  .deletePassword(password.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(password.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editPassword(context),
          ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deletePassword(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Website', password.website, context),
            const SizedBox(height: 16),
            _buildInfoCard('Username/Email', password.username, context),
            const SizedBox(height: 16),
            _buildInfoCard('Password', password.password, context, isPassword: true),
            const SizedBox(height: 16),
            if (password.notes.isNotEmpty)
              _buildInfoCard('Notes', password.notes, context),
            const SizedBox(height: 16),
            Text(
              'Created: ${password.createdAt.toString().split('.')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Updated: ${password.updatedAt.toString().split('.')[0]}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, BuildContext context, {bool isPassword = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(context, value, label),
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isPassword ? '••••••••' : value,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}