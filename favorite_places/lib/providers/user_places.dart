import 'dart:io';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import 'package:favorite_places/models/place.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT, category TEXT, is_favorite INTEGER, rating REAL, notes TEXT, visit_date TEXT)');
    },
    version: 2,
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE user_places ADD COLUMN category TEXT DEFAULT "General"');
        await db.execute('ALTER TABLE user_places ADD COLUMN is_favorite INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE user_places ADD COLUMN rating REAL DEFAULT 0.0');
        await db.execute('ALTER TABLE user_places ADD COLUMN notes TEXT DEFAULT ""');
        await db.execute('ALTER TABLE user_places ADD COLUMN visit_date TEXT');
      }
    },
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
            category: row['category'] as String? ?? 'General',
            isFavorite: (row['is_favorite'] as int?) == 1,
            rating: (row['rating'] as double?) ?? 0.0,
            notes: row['notes'] as String? ?? '',
            visitDate: row['visit_date'] != null 
                ? DateTime.parse(row['visit_date'] as String)
                : null,
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location, {
    String category = 'General',
    bool isFavorite = false,
    double rating = 0.0,
    String notes = '',
    DateTime? visitDate,
  }) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      title: title, 
      image: copiedImage, 
      location: location,
      category: category,
      isFavorite: isFavorite,
      rating: rating,
      notes: notes,
      visitDate: visitDate,
    );

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
      'category': newPlace.category,
      'is_favorite': newPlace.isFavorite ? 1 : 0,
      'rating': newPlace.rating,
      'notes': newPlace.notes,
      'visit_date': newPlace.visitDate?.toIso8601String(),
    });

    state = [newPlace, ...state];
  }

  void updatePlace(Place place) async {
    final db = await _getDatabase();
    await db.update(
      'user_places',
      {
        'title': place.title,
        'image': place.image.path,
        'lat': place.location.latitude,
        'lng': place.location.longitude,
        'address': place.location.address,
        'category': place.category,
        'is_favorite': place.isFavorite ? 1 : 0,
        'rating': place.rating,
        'notes': place.notes,
        'visit_date': place.visitDate?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );

    state = state.map((p) => p.id == place.id ? place : p).toList();
  }

  void toggleFavorite(String placeId) {
    final placeIndex = state.indexWhere((place) => place.id == placeId);
    if (placeIndex != -1) {
      final place = state[placeIndex];
      final updatedPlace = place.copyWith(isFavorite: !place.isFavorite);
      updatePlace(updatedPlace);
    }
  }

  void deletePlace(String placeId) async {
    final db = await _getDatabase();
    await db.delete(
      'user_places',
      where: 'id = ?',
      whereArgs: [placeId],
    );

    state = state.where((place) => place.id != placeId).toList();
  }

  List<Place> getFavorites() {
    return state.where((place) => place.isFavorite).toList();
  }

  List<Place> getPlacesByCategory(String category) {
    return state.where((place) => place.category == category).toList();
  }

  List<String> getCategories() {
    final categories = state.map((place) => place.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Export functionality
  Future<String> exportData() async {
    final exportData = {
      'version': '2.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'places': state.map((place) => {
        'id': place.id,
        'title': place.title,
        'imagePath': place.image.path,
        'latitude': place.location.latitude,
        'longitude': place.location.longitude,
        'address': place.location.address,
        'category': place.category,
        'isFavorite': place.isFavorite,
        'rating': place.rating,
        'notes': place.notes,
        'visitDate': place.visitDate?.toIso8601String(),
      }).toList(),
    };

    return jsonEncode(exportData);
  }

  // Import functionality
  Future<bool> importData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;
      final places = data['places'] as List<dynamic>;

      final db = await _getDatabase();
      
      // Clear existing data
      await db.delete('user_places');
      
      // Import new data
      for (final placeData in places) {
        final place = placeData as Map<String, dynamic>;
        
        // Copy image to app directory
        final originalImage = File(place['imagePath'] as String);
        final appDir = await syspaths.getApplicationDocumentsDirectory();
        final filename = path.basename(originalImage.path);
        final copiedImage = await originalImage.copy('${appDir.path}/$filename');

        await db.insert('user_places', {
          'id': place['id'] as String,
          'title': place['title'] as String,
          'image': copiedImage.path,
          'lat': place['latitude'] as double,
          'lng': place['longitude'] as double,
          'address': place['address'] as String,
          'category': place['category'] as String? ?? 'General',
          'is_favorite': (place['isFavorite'] as bool?) == true ? 1 : 0,
          'rating': (place['rating'] as double?) ?? 0.0,
          'notes': place['notes'] as String? ?? '',
          'visit_date': place['visitDate'] as String?,
        });
      }

      // Reload places
      await loadPlaces();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);