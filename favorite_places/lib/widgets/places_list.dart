import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showFavoritesOnly = false;

  List<Place> get filteredPlaces {
    return widget.places.where((place) {
      final matchesSearch = place.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.location.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          place.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' || place.category == _selectedCategory;
      
      final matchesFavorites = !_showFavoritesOnly || place.isFavorite;
      
      return matchesSearch && matchesCategory && matchesFavorites;
    }).toList();
  }

  List<String> get categories {
    final categories = widget.places.map((place) => place.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Search and Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search places...',
                  prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  filled: true,
                  fillColor: isDark 
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                style: TextStyle(color: theme.colorScheme.onSurface),
                cursorColor: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              
              // Category Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: isDark 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        selectedColor: theme.colorScheme.primary.withOpacity(0.3),
                        labelStyle: TextStyle(
                          color: isSelected 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              
              // Favorites Toggle
              Row(
                children: [
                  Switch(
                    value: _showFavoritesOnly,
                    onChanged: (value) => setState(() => _showFavoritesOnly = value),
                    activeColor: Colors.amber,
                  ),
                  Text(
                    'Favorites Only',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Results Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${filteredPlaces.length} place${filteredPlaces.length == 1 ? '' : 's'} found',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Places List
        Expanded(
          child: filteredPlaces.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty || _selectedCategory != 'All' || _showFavoritesOnly
                            ? 'No places match your filters'
                            : 'No places added yet!',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPlaces.length,
                  itemBuilder: (ctx, index) {
                    final place = filteredPlaces[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: PlaceCard(place: place),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class PlaceCard extends ConsumerWidget {
  const PlaceCard({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PlaceDetailScreen(place: place),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ]
                  : [
                      Colors.white,
                      Colors.grey.withOpacity(0.05),
                    ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.file(
                      place.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              place.title,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (place.isFavorite)
                            const Icon(
                              Icons.favorite,
                              color: Colors.amber,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place.location.address,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              place.category,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (place.rating > 0) ...[
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  place.rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(userPlacesProvider.notifier).toggleFavorite(place.id);
                      },
                      icon: Icon(
                        place.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: place.isFavorite ? Colors.amber : theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteDialog(context, ref);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Place'),
        content: Text('Are you sure you want to delete "${place.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(userPlacesProvider.notifier).deletePlace(place.id);
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}