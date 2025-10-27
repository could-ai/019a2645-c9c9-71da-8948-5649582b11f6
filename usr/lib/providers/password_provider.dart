import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:password_manager_app/models/password.dart';

class PasswordProvider extends ChangeNotifier {
  final List<Password> _passwords = [];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  List<Password> get passwords => List.unmodifiable(_passwords);

  PasswordProvider() {
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    try {
      final keys = await _storage.readAll();
      _passwords.clear();
      for (final key in keys.keys) {
        if (key.startsWith('password_')) {
          final jsonString = await _storage.read(key: key);
          if (jsonString != null) {
            final password = Password.fromJson(jsonDecode(jsonString));
            _passwords.add(password);
          }
        }
      }
      notifyListeners();
    } catch (e) {
      // Handle error
      print('Error loading passwords: $e');
    }
  }

  Future<void> _savePasswords() async {
    try {
      for (final password in _passwords) {
        await _storage.write(
          key: 'password_${password.id}',
          value: jsonEncode(password.toJson()),
        );
      }
    } catch (e) {
      print('Error saving passwords: $e');
    }
  }

  Future<void> addPassword(Password password) async {
    _passwords.add(password);
    await _savePasswords();
    notifyListeners();
  }

  Future<void> updatePassword(Password updatedPassword) async {
    final index = _passwords.indexWhere((p) => p.id == updatedPassword.id);
    if (index != -1) {
      _passwords[index] = updatedPassword.copyWith(updatedAt: DateTime.now());
      await _savePasswords();
      notifyListeners();
    }
  }

  Future<void> deletePassword(String id) async {
    _passwords.removeWhere((p) => p.id == id);
    await _storage.delete(key: 'password_$id');
    notifyListeners();
  }
}