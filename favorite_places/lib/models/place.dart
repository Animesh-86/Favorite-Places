import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({
    required this.title,
    required this.image,
    required this.location,
    this.category = 'General',
    this.isFavorite = false,
    this.rating = 0.0,
    this.notes = '',
    this.visitDate,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
  final String category;
  final bool isFavorite;
  final double rating;
  final String notes;
  final DateTime? visitDate;

  Place copyWith({
    String? title,
    File? image,
    PlaceLocation? location,
    String? category,
    bool? isFavorite,
    double? rating,
    String? notes,
    DateTime? visitDate,
  }) {
    return Place(
      id: id,
      title: title ?? this.title,
      image: image ?? this.image,
      location: location ?? this.location,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      notes: notes ?? this.notes,
      visitDate: visitDate ?? this.visitDate,
    );
  }
}