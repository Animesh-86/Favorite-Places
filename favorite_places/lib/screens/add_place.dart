import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:favorite_places/widgets/gradient_scaffold.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  String _selectedCategory = 'General';
  double _rating = 0.0;
  DateTime? _visitDate;
  bool _isFavorite = false;

  final List<String> _categories = [
    'General',
    'Restaurant',
    'Cafe',
    'Park',
    'Museum',
    'Shopping',
    'Entertainment',
    'Hotel',
    'Beach',
    'Mountain',
    'City',
    'Historical',
    'Nature',
    'Sports',
    'Other',
  ];

  void _savePlace() {
    final title = _titleController.text;
    if (title.isEmpty || _selectedImage == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref.read(userPlacesProvider.notifier).addPlace(
      title,
      _selectedImage!,
      _selectedLocation!,
      category: _selectedCategory,
      isFavorite: _isFavorite,
      rating: _rating,
      notes: _notesController.text,
      visitDate: _visitDate,
    );
    
    Navigator.of(context).pop();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _visitDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GradientScaffold(
      title: 'Add New Place',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
              cursorColor: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              dropdownColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
              style: TextStyle(color: theme.colorScheme.onSurface),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Rating
            Card(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rating',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                            });
                          },
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    if (_rating > 0)
                      Center(
                        child: Text(
                          '${_rating.toStringAsFixed(1)} stars',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Visit Date
            Card(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: theme.colorScheme.onSurface),
                title: Text(
                  _visitDate == null ? 'Add Visit Date' : 'Visit Date',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                subtitle: _visitDate == null
                    ? Text(
                        'Optional',
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      )
                    : Text(
                        '${_visitDate!.day.toString().padLeft(2, '0')}/${_visitDate!.month.toString().padLeft(2, '0')}/${_visitDate!.year}',
                        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      ),
                trailing: _visitDate != null
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _visitDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear, color: Colors.red),
                      )
                    : null,
                onTap: _selectDate,
              ),
            ),
            const SizedBox(height: 16),

            // Favorite Toggle
            Card(
              color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              child: SwitchListTile(
                title: Text(
                  'Mark as Favorite',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                subtitle: Text(
                  'Add to favorites',
                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                value: _isFavorite,
                onChanged: (value) {
                  setState(() {
                    _isFavorite = value;
                  });
                },
                activeColor: Colors.amber,
              ),
            ),
            const SizedBox(height: 16),

            // Image Input
            ImageInput(onPickImage: (image) => _selectedImage = image),
            const SizedBox(height: 16),

            // Location Input
            LocationInput(
              onSelectLocation: (location) => _selectedLocation = location,
            ),
            const SizedBox(height: 16),

            // Notes Field
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Add any additional notes about this place...',
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
              cursorColor: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
