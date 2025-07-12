import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/screens/map.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/config/api_keys.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=${ApiKeys.googleMapsApiKey}';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    if (ApiKeys.googleMapsApiKey == 'YOUR_API_KEY_HERE') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please configure your Google Maps API key in lib/config/api_keys.dart'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${ApiKeys.googleMapsApiKey}',
    );
    
    try {
      final response = await http.get(url);
      final resData = json.decode(response.body);

      if (resData['results'] == null || resData['results'].isEmpty) {
        setState(() {
          _isGettingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No address found for the selected location.'),
          ),
        );
        return;
      }

      final address = resData['results'][0]['formatted_address'];

      setState(() {
        _pickedLocation = PlaceLocation(
          latitude: latitude,
          longitude: longitude,
          address: address,
        );
        _isGettingLocation = false;
      });

      widget.onSelectLocation(_pickedLocation!);
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting address: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    try {
      locationData = await location.getLocation();
      final lat = locationData.latitude;
      final lng = locationData.longitude;

      if (lat == null || lng == null) {
        setState(() {
          _isGettingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not get current location'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _savePlace(lat, lng);
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectOnMap() async {
    if (ApiKeys.googleMapsApiKey == 'YOUR_API_KEY_HERE') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please configure your Google Maps API key in lib/config/api_keys.dart'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final pickedLocation = await Navigator.of(
      context,
    ).push<LatLng>(MaterialPageRoute(builder: (ctx) => const MapScreen()));

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: isDark 
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            child: Icon(
              Icons.location_on,
              size: 48,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          );
        },
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
