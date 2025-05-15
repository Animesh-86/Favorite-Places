# Favorite-Places

A Flutter application to mark and save your favorite places, take pictures, select locations on the map, and view them later.

# Features

1. 📷 Image Input — Take or choose a picture of your favorite place.

2. 📍 Location Input — Select your location on a map or fetch current location.

3. 💾 Persistent Storage — Save your places locally using SQLite.

4. 🗂️ Places List — View all your saved favorite places.

5. 🗺️ Map Preview — View selected locations on Google Maps.

6. 🌈 Gradient Theming — Custom gradient for app background and AppBar.

# Tech Stack

1. Flutter (UI)

2. Riverpod (State Management)

3. Google Maps (Location Services)

4. Path Provider & Image Picker

5. SQLite (Local DB with sqflite package)

# Setup Instructions

1. Clone the repository: git clone https://github.com/Animesh-86/favorite-places.git

2. Navigate into the project: cd favorite-places

3. Get dependencies: flutter pub get

4. Enable Google Maps API: Add your API key to android/app/src/main/AndroidManifest.xml

5. Run the app: flutter run

# Testing

1. Try adding a new place using the "+" button.

2. Capture a photo.

3. Select or fetch a location.

4. Tap “Add Place” to save.

5. View it on the list and tap to see the location on the map.
