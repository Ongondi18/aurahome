import 'package:flutter/material.dart';

enum RoomType {
  livingRoom,
  bedroom,
  kitchen,
  bathroom,
  office,
  garage,
  garden,
  gym,
  other
}

class RoomModel {
  final String id;
  final String name;
  final RoomType type;
  final List<String> deviceIds;
  final DateTime createdAt;
  final DateTime lastUpdated;

  IconData get icon {
    switch (type) {
      case RoomType.livingRoom:
        return Icons.weekend;
      case RoomType.bedroom:
        return Icons.bed;
      case RoomType.kitchen:
        return Icons.kitchen;
      case RoomType.bathroom:
        return Icons.bathroom;
      case RoomType.office:
        return Icons.computer;
      case RoomType.garage:
        return Icons.garage;
      case RoomType.garden:
        return Icons.yard;
      case RoomType.gym:
        return Icons.fitness_center;
      case RoomType.other:
        return Icons.room;
    }
  }

  RoomModel({
    required this.id,
    required this.name,
    required this.type,
    required this.deviceIds,
    required this.createdAt,
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'deviceIds': deviceIds,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    // Safely parse the room type
    RoomType parseRoomType(String? typeStr) {
      if (typeStr == null) return RoomType.other;
      try {
        return RoomType.values.firstWhere(
          (e) => e.toString().split('.').last == typeStr,
          orElse: () => RoomType.other,
        );
      } catch (_) {
        return RoomType.other;
      }
    }

    return RoomModel(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unnamed Room',
      type: parseRoomType(map['type']),
      deviceIds: List<String>.from(map['deviceIds'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      lastUpdated: DateTime.tryParse(map['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  RoomModel copyWith({
    String? id,
    String? name,
    RoomType? type,
    List<String>? deviceIds,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      deviceIds: deviceIds ?? this.deviceIds,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
} 