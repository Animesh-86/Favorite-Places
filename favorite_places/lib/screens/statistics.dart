import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/gradient_scaffold.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(userPlacesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (places.isEmpty) {
      return GradientScaffold(
        title: 'Statistics',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 80,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No data to analyze',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some places to see statistics',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final totalPlaces = places.length;
    final favoritePlaces = places.where((p) => p.isFavorite).length;
    final ratedPlaces = places.where((p) => p.rating > 0).length;
    final averageRating = places.where((p) => p.rating > 0).isEmpty 
        ? 0.0 
        : places.where((p) => p.rating > 0).map((p) => p.rating).reduce((a, b) => a + b) / 
          places.where((p) => p.rating > 0).length;

    // Category statistics
    final categoryStats = <String, int>{};
    for (final place in places) {
      categoryStats[place.category] = (categoryStats[place.category] ?? 0) + 1;
    }

    return GradientScaffold(
      title: 'Statistics',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewCards(totalPlaces, favoritePlaces, ratedPlaces, averageRating, theme),
            const SizedBox(height: 24),
            
            // Category Breakdown
            _buildCategoryBreakdown(categoryStats, theme),
            const SizedBox(height: 24),
            
            // Rating Distribution
            _buildRatingDistribution(places, theme),
            const SizedBox(height: 24),
            
            // Recent Activity
            _buildRecentActivity(places, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(int total, int favorites, int rated, double avgRating, ThemeData theme) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Places',
          total.toString(),
          Icons.place,
          Colors.blue,
          theme,
        ),
        _buildStatCard(
          'Favorites',
          favorites.toString(),
          Icons.favorite,
          Colors.amber,
          theme,
        ),
        _buildStatCard(
          'Rated Places',
          rated.toString(),
          Icons.star,
          Colors.orange,
          theme,
        ),
        _buildStatCard(
          'Avg Rating',
          avgRating.toStringAsFixed(1),
          Icons.analytics,
          Colors.green,
          theme,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(Map<String, int> categoryStats, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Breakdown',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...categoryStats.entries.map((entry) {
            final percentage = (entry.value / categoryStats.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${entry.value} (${percentage}%)',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: entry.value / categoryStats.values.reduce((a, b) => a + b),
                    backgroundColor: theme.colorScheme.onSurface.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.primaries[categoryStats.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(List<dynamic> places, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final ratingCounts = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      ratingCounts[i] = places.where((p) => p.rating == i.toDouble()).length;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rating Distribution',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...ratingCounts.entries.map((entry) {
            final totalRated = places.where((p) => p.rating > 0).length;
            final percentage = totalRated > 0 ? (entry.value / totalRated * 100).toStringAsFixed(1) : '0.0';
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < entry.key ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: totalRated > 0 ? entry.value / totalRated : 0,
                      backgroundColor: theme.colorScheme.onSurface.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${entry.value} (${percentage}%)',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<dynamic> places, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final recentPlaces = places.where((p) => p.visitDate != null).toList()
      ..sort((a, b) => b.visitDate!.compareTo(a.visitDate!));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Visits',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (recentPlaces.isEmpty)
            Text(
              'No recent visits recorded',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            )
          else
            ...recentPlaces.take(5).map((place) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          place.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.title,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${place.visitDate!.day.toString().padLeft(2, '0')}/${place.visitDate!.month.toString().padLeft(2, '0')}/${place.visitDate!.year}',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (place.rating > 0)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
} 