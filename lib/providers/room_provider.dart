import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';

final roomServiceProvider = Provider<RoomService>((ref) => RoomService());

final roomsProvider = StateNotifierProvider<RoomsNotifier, List<RoomModel>>(
  (ref) => RoomsNotifier(ref.watch(roomServiceProvider)),
);

class RoomsNotifier extends StateNotifier<List<RoomModel>> {
  final RoomService _roomService;

  RoomsNotifier(this._roomService) : super([]) {
    loadRooms();
  }

  Future<void> loadRooms() async {
    try {
      final rooms = await _roomService.getRooms();
      state = rooms;
    } catch (e) {
      print('Error loading rooms: $e');
    }
  }

  Future<void> addRoom(RoomModel room) async {
    try {
      await _roomService.addRoom(room);
      state = [...state, room];
    } catch (e) {
      print('Error adding room: $e');
      rethrow;
    }
  }

  Future<void> updateRoom(RoomModel room) async {
    try {
      await _roomService.updateRoom(room);
      state = [
        for (final r in state)
          if (r.id == room.id) room else r
      ];
    } catch (e) {
      print('Error updating room: $e');
      rethrow;
    }
  }

  Future<void> removeRoom(String roomId) async {
    try {
      await _roomService.removeRoom(roomId);
      state = state.where((r) => r.id != roomId).toList();
    } catch (e) {
      print('Error removing room: $e');
      rethrow;
    }
  }
} 