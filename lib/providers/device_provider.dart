import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/device_model.dart';
import '../services/device_service.dart';

final deviceServiceProvider = Provider<DeviceService>((ref) => DeviceService());

final devicesProvider = StateNotifierProvider<DevicesNotifier, List<DeviceModel>>(
  (ref) => DevicesNotifier(ref.watch(deviceServiceProvider)),
);

class DevicesNotifier extends StateNotifier<List<DeviceModel>> {
  final DeviceService _deviceService;

  DevicesNotifier(this._deviceService) : super([]) {
    loadDevices();
  }

  Future<void> loadDevices() async {
    try {
      final devices = await _deviceService.getDevices();
      state = devices;
    } catch (e) {
      print('Error loading devices: $e');
    }
  }

  Future<void> addDevice(DeviceModel device) async {
    try {
      await _deviceService.addDevice(device);
      state = [...state, device];
    } catch (e) {
      print('Error adding device: $e');
      rethrow;
    }
  }

  Future<void> updateDevice(DeviceModel device) async {
    try {
      await _deviceService.updateDevice(device);
      state = [
        for (final d in state)
          if (d.id == device.id) device else d
      ];
    } catch (e) {
      print('Error updating device: $e');
      rethrow;
    }
  }

  Future<void> removeDevice(String deviceId) async {
    try {
      await _deviceService.removeDevice(deviceId);
      state = state.where((d) => d.id != deviceId).toList();
    } catch (e) {
      print('Error removing device: $e');
      rethrow;
    }
  }
} 