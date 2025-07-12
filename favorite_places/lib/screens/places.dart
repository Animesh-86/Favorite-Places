import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/screens/statistics.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/gradient_scaffold.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    final theme = Theme.of(context);

    return GradientScaffold(
      title: 'Your Places',
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A1A),
                Color(0xFF2A2A2A),
                Color(0xFF3A3A3A),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.place,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Favorite Places',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${userPlaces.length} places saved',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: theme.colorScheme.onSurface),
                title: Text(
                  'Home',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.analytics, color: theme.colorScheme.onSurface),
                title: Text(
                  'Statistics',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const StatisticsScreen(),
                    ),
                  );
                },
              ),
              Divider(color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ListTile(
                leading: Icon(Icons.file_download, color: theme.colorScheme.onSurface),
                title: Text(
                  'Export Data',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _exportData();
                },
              ),
              ListTile(
                leading: Icon(Icons.file_upload, color: theme.colorScheme.onSurface),
                title: Text(
                  'Import Data',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _importData();
                },
              ),
              ListTile(
                leading: Icon(Icons.info, color: theme.colorScheme.onSurface),
                title: Text(
                  'About',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showAboutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Add Place Button
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (ctx) => const AddPlaceScreen()));
          },
        ),
      ],
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userPlaces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 80,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No places added yet!',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first place',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Statistics Section
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Total',
                      userPlaces.length.toString(),
                      Icons.place,
                      theme,
                    ),
                    _buildStatItem(
                      'Favorites',
                      userPlaces.where((p) => p.isFavorite).length.toString(),
                      Icons.favorite,
                      theme,
                      color: Colors.amber,
                    ),
                    _buildStatItem(
                      'Categories',
                      userPlaces.map((p) => p.category).toSet().length.toString(),
                      Icons.category,
                      theme,
                    ),
                  ],
                ),
              ),
              
              // Places List
              Expanded(
                child: PlacesList(places: userPlaces),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ThemeData theme, {Color? color}) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? theme.colorScheme.onSurface,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _exportData() async {
    try {
      final jsonData = await ref.read(userPlacesProvider.notifier).exportData();
      
      // In a real app, you would save this to a file or share it
      // For now, we'll just show a dialog with the data
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Export Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your data has been exported successfully!'),
              const SizedBox(height: 16),
              const Text(
                'In a real app, this would save to a file or share the data.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to export data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _importData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Import Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This feature would allow you to import data from a file.'),
            SizedBox(height: 16),
            Text(
              'In a real app, this would read from a file or clipboard.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('About Favorite Places'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 2.0.0'),
            SizedBox(height: 8),
            Text('A beautiful app to save and organize your favorite places with photos, locations, ratings, and more.'),
            SizedBox(height: 16),
            Text('Features:'),
            SizedBox(height: 8),
            Text('• Save places with photos and locations'),
            Text('• Rate and categorize your places'),
            Text('• Mark favorites and add notes'),
            Text('• Search and filter functionality'),
            Text('• Dark and light themes'),
            Text('• Detailed statistics and analytics'),
            Text('• Export and import data'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
