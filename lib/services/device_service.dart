import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';

class DeviceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'devices';

  Future<List<DeviceModel>> getDevices() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => DeviceModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting devices: $e');
      rethrow;
    }
  }

  Future<void> addDevice(DeviceModel device) async {
    try {
      await _firestore.collection(_collection).doc(device.id).set(device.toMap());
    } catch (e) {
      print('Error adding device: $e');
      rethrow;
    }
  }

  Future<void> updateDevice(DeviceModel device) async {
    try {
      await _firestore.collection(_collection).doc(device.id).update(device.toMap());
    } catch (e) {
      print('Error updating device: $e');
      rethrow;
    }
  }

  Future<void> removeDevice(String deviceId) async {
    try {
      await _firestore.collection(_collection).doc(deviceId).delete();
    } catch (e) {
      print('Error removing device: $e');
      rethrow;
    }
  }

  Stream<List<DeviceModel>> watchDevices() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => DeviceModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
} 