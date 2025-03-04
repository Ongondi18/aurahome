enum DeviceType {
  light,
  camera,
  airPurifier,
  motionSensor,
  thermostat,
  securitySystem,
  other
}

enum DeviceStatus {
  active,
  offline,
  on,
  off,
  error
}

class DeviceModel {
  final String id;
  final String name;
  final DeviceType type;
  DeviceStatus status;
  final String roomId;
  final String iconName;
  final Map<String, dynamic> settings;
  final DateTime addedAt;
  final DateTime lastUpdated;

  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.roomId,
    required this.settings,
    required this.addedAt,
    required this.lastUpdated,
    this.iconName = 'devices_other',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'status': status.toString(),
      'roomId': roomId,
      'iconName': iconName,
      'settings': settings,
      'addedAt': addedAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'],
      name: map['name'],
      type: DeviceType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => DeviceType.other,
      ),
      status: DeviceStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => DeviceStatus.offline,
      ),
      roomId: map['roomId'],
      iconName: map['iconName'] ?? 'devices_other',
      settings: Map<String, dynamic>.from(map['settings']),
      addedAt: DateTime.parse(map['addedAt']),
      lastUpdated: DateTime.parse(map['lastUpdated']),
    );
  }

  String getDefaultIconName() {
    switch (type) {
      case DeviceType.light:
        return 'lightbulb_outline';
      case DeviceType.camera:
        return 'videocam_outlined';
      case DeviceType.airPurifier:
        return 'air';
      case DeviceType.motionSensor:
        return 'motion_photos_on_outlined';
      case DeviceType.thermostat:
        return 'thermostat_outlined';
      case DeviceType.securitySystem:
        return 'security';
      case DeviceType.other:
        return 'devices_other';
    }
  }

  DeviceModel copyWith({
    String? id,
    String? name,
    DeviceType? type,
    DeviceStatus? status,
    String? roomId,
    String? iconName,
    Map<String, dynamic>? settings,
    DateTime? addedAt,
    DateTime? lastUpdated,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      roomId: roomId ?? this.roomId,
      iconName: iconName ?? this.iconName,
      settings: settings ?? this.settings,
      addedAt: addedAt ?? this.addedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
} 