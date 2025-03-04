import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';  // Add this import for ImageFilter
import '../services/auth_service.dart';
import '../models/device_model.dart';
import '../models/room_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/device_provider.dart';
import '../providers/room_provider.dart';
import 'package:flutter/rendering.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _deviceNameController = TextEditingController();
  final _roomNameController = TextEditingController();
  DeviceType _selectedDeviceType = DeviceType.light;
  String? _selectedRoomId;

  List<DeviceModel> get cameras => ref.read(devicesProvider)
      .where((device) => device.type == DeviceType.camera)
      .toList();

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(devicesProvider);
    final rooms = ref.watch(roomsProvider);
    
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/image3.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black54, // Add a dark overlay to improve contrast
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: const AppDrawer(),
        appBar: _buildGlassAppBar(),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
            child: _buildDashboard(),
          ),
        ),
      ),
    );
  }

  AppBar _buildGlassAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.1),
      elevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      title: Text(
        'AuraHome',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // TODO: Implement notifications
          },
        ),
      ],
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildRoomsOverview(),
          const SizedBox(height: 24),
          _buildDevicesOverview(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickActionCard(
                'All Lights',
                Icons.lightbulb_outline,
                Colors.amber,
                () => _toggleAllLights(),
              ),
              _buildQuickActionCard(
                'Security',
                Icons.security,
                Colors.red,
                () => _toggleSecurity(),
              ),
              _buildQuickActionCard(
                'Climate',
                Icons.thermostat,
                Colors.blue,
                () => _adjustClimate(),
              ),
              _buildQuickActionCard(
                'Cameras',
                Icons.videocam_outlined,
                Colors.green,
                () => _viewAllCameras(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accentColor.withOpacity(0.3),
                  accentColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomsOverview() {
    final rooms = ref.watch(roomsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rooms',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: _showAddRoomDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Add Room',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (rooms.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.room_preferences_outlined,
                  size: 48,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No rooms added yet',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final room = rooms[index];
              return _buildRoomOverviewCard(room);
            },
          ),
      ],
    );
  }

  Widget _buildRoomOverviewCard(RoomModel room) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Container(
        constraints: BoxConstraints(maxHeight: 120),  // Add height constraint
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(room.icon, color: Colors.blue),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,  // Use minimum space needed
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${room.deviceIds.length} devices',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesOverview() {
    final devices = ref.watch(devicesProvider);
    return devices.isEmpty
        ? Center(
            child: Text(
              'No devices added yet',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return _buildDeviceCard(device);
            },
          );
  }

  Widget _buildDeviceCard(DeviceModel device) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showDeviceDetails(device),
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getDeviceIcon(device.type),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          color: Colors.blue[900]?.withOpacity(0.9),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text(
                                'Edit',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              onTap: () => _editDevice(device),
                            ),
                            PopupMenuItem(
                              child: Text(
                                'Remove',
                                style: GoogleFonts.poppins(color: Colors.red),
                              ),
                              onTap: () => _removeDevice(device),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      device.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(device.status).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        device.status.toString().split('.').last.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCameraFeed(DeviceModel camera) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraFeedScreen(camera: camera),
      ),
    );
  }

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Add New Device',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<DeviceType>(
              value: _selectedDeviceType,
              dropdownColor: Colors.blue[900],
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Device Type',
                labelStyle: GoogleFonts.poppins(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: DeviceType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedDeviceType = value!);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deviceNameController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Device Name',
                labelStyle: GoogleFonts.poppins(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: _addDevice,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.poppins(color: Colors.blue[900]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRoomDialog() {
    final TextEditingController nameController = TextEditingController();
    RoomType selectedType = RoomType.livingRoom;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.blue[900]?.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'Add New Room',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Room Name',
                  labelStyle: GoogleFonts.poppins(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Room Type',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(8),
                  children: RoomType.values.map((type) {
                    return _buildRoomTypeOption(setState, selectedType, type);
                  }).toList(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () => _createRoom(nameController.text, selectedType),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Create',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomTypeOption(
    StateSetter setState,
    RoomType currentSelected,
    RoomType type,
  ) {
    final isSelected = currentSelected == type;
    return InkWell(
      onTap: () => setState(() => currentSelected = type),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              RoomModel(
                id: '',
                name: '',
                type: type,
                deviceIds: [],
                createdAt: DateTime.now(),
                lastUpdated: DateTime.now(),
              ).icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              type.toString().split('.').last,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createRoom(String name, RoomType type) async {
    if (name.isEmpty) return;

    final room = RoomModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      type: type,
      deviceIds: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    try {
      await ref.read(roomsProvider.notifier).addRoom(room);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Room "$name" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating room: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToRooms() {
    // TODO: Implement navigation to rooms screen
    // For now, we'll just show the rooms section
    // You can create a separate RoomsScreen if needed
  }

  Future<void> _handleLogout() async {
    // TODO: Implement logout functionality
  }

  void _showRoomDetails(RoomModel room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailScreen(room: room),
      ),
    );
  }

  void _showDeviceDetails(DeviceModel device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeviceDetailScreen(device: device),
      ),
    );
  }

  Future<void> _addDevice() async {
    if (_deviceNameController.text.isEmpty) return;

    final device = DeviceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _deviceNameController.text,
      type: _selectedDeviceType,
      status: DeviceStatus.off,
      roomId: _selectedRoomId ?? '',
      iconName: _getDefaultIconName(_selectedDeviceType),
      settings: {},
      addedAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    try {
      await ref.read(devicesProvider.notifier).addDevice(device);
      if (mounted) {
        Navigator.pop(context);
        _deviceNameController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding device: $e')),
        );
      }
    }
  }

  String _getDefaultIconName(DeviceType type) {
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

  Color _getStatusColor(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.active:
        return Colors.green;
      case DeviceStatus.offline:
        return Colors.grey;
      case DeviceStatus.on:
        return Colors.blue;
      case DeviceStatus.off:
        return Colors.red;
      case DeviceStatus.error:
        return Colors.orange;
    }
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_outline;
      case DeviceType.camera:
        return Icons.videocam_outlined;
      case DeviceType.airPurifier:
        return Icons.air;
      case DeviceType.motionSensor:
        return Icons.motion_photos_on_outlined;
      case DeviceType.thermostat:
        return Icons.thermostat_outlined;
      case DeviceType.securitySystem:
        return Icons.security;
      case DeviceType.other:
        return Icons.devices_other;
    }
  }

  void _editDevice(DeviceModel device) {
    // Implement edit device logic
  }

  void _removeDevice(DeviceModel device) {
    // Implement remove device logic
  }

  // Add these methods for quick actions
  void _toggleAllLights() {
    // Implement toggle all lights functionality
  }

  void _toggleSecurity() {
    // Implement security system toggle
  }

  void _adjustClimate() {
    // Implement climate control
  }

  void _viewAllCameras() {
    // Implement camera view
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }
}

class RoomDetailScreen extends StatelessWidget {
  final RoomModel room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: Center(
        child: Text('Room Details Coming Soon'),
      ),
    );
  }
}

class DeviceDetailScreen extends StatelessWidget {
  final DeviceModel device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
      ),
      body: Center(
        child: Text('Device Details Coming Soon'),
      ),
    );
  }
}

class CameraFeedScreen extends StatelessWidget {
  final DeviceModel camera;

  const CameraFeedScreen({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(camera.name),
      ),
      body: Center(
        child: Text('Camera Feed Coming Soon'),
      ),
    );
  }
} 