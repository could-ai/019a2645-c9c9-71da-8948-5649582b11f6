import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:password_manager_app/providers/password_provider.dart';
import 'package:password_manager_app/models/password.dart';
import 'package:uuid/uuid.dart';
class AddPasswordScreen extends StatefulWidget {
  final Password? password;

  const AddPasswordScreen({super.key, this.password});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _websiteController = TextEditingController();
  final _notesController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.password != null) {
      _titleController.text = widget.password!.title;
      _usernameController.text = widget.password!.username;
      _passwordController.text = widget.password!.password;
      _websiteController.text = widget.password!.website;
      _notesController.text = widget.password!.notes;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<PasswordProvider>(context, listen: false);
      if (widget.password != null) {
        final updatedPassword = widget.password!.copyWith(
          title: _titleController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
          website: _websiteController.text.trim(),
          notes: _notesController.text.trim(),
          updatedAt: DateTime.now(),
        );
        provider.updatePassword(updatedPassword);
      } else {
        final uuid = const Uuid();
        final newPassword = Password(
          id: uuid.v4(),
          title: _titleController.text.trim(),
          username: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
          website: _websiteController.text.trim(),
          notes: _notesController.text.trim(),
        );
        provider.addPassword(newPassword);
      }
      Navigator.pop(context);
    }
  }

  void _generatePassword() {
    // Simple password generation (you can enhance this)
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*';
    final random = Random();
    final password = String.fromCharCodes(
      Iterable.generate(12, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    _passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.password != null ? 'Edit Password' : 'Add Password'),
        actions: [
          TextButton(
            onPressed: _savePassword,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Gmail, Facebook',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website',
                hintText: 'e.g., https://gmail.com',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a website';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username/Email',
                hintText: 'Enter your username or email',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _generatePassword,
                    ),
                  ],
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Additional notes',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}