import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

class RoomService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'rooms';

  Future<List<RoomModel>> getRooms() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => RoomModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting rooms: $e');
      rethrow;
    }
  }

  Future<void> addRoom(RoomModel room) async {
    try {
      await _firestore.collection(_collection).doc(room.id).set(room.toMap());
    } catch (e) {
      print('Error adding room: $e');
      rethrow;
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    try {
      await _firestore.collection(_collection).doc(room.id).update(room.toMap());
    } catch (e) {
      print('Error updating room: $e');
      rethrow;
    }
  }

  Future<void> removeRoom(String roomId) async {
    try {
      await _firestore.collection(_collection).doc(roomId).delete();
    } catch (e) {
      print('Error removing room: $e');
      rethrow;
    }
  }

  Stream<List<RoomModel>> watchRooms() {
    return _firestore.collection(_collection).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => RoomModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }
} 