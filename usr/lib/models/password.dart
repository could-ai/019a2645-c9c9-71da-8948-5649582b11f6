import 'dart:math';

class Password {
  final String id;
  final String title;
  final String username;
  final String password;
  final String website;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Password({
    required this.id,
    required this.title,
    required this.username,
    required this.password,
    required this.website,
    this.notes = '',
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
      'website': website,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Password.fromJson(Map<String, dynamic> json) {
    return Password(
      id: json['id'],
      title: json['title'],
      username: json['username'],
      password: json['password'],
      website: json['website'],
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Copy with updated fields
  Password copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    String? website,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Password(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      password: password ?? this.password,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}