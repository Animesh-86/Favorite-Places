# Favorite Places

A modern Flutter application to mark and save your favorite places with a beautiful dark theme. Take pictures, select locations on the map, add ratings, notes, and track your visits with comprehensive statistics.

## ✨ Features

### 📍 Core Functionality
- **Add Places**: Capture photos and select locations for your favorite places
- **Location Services**: Use Google Maps for precise location selection or fetch current location
- **Persistent Storage**: All data stored locally using SQLite database
- **Dark Theme**: Beautiful, consistent dark theme with purple accent colors

### 📊 Advanced Features
- **Statistics Dashboard**: View comprehensive analytics about your places
  - Total places count
  - Favorite places tracking
  - Rating statistics and averages
  - Category breakdown
  - Recent activity timeline
- **Data Management**: Export and import your places data
- **Place Details**: Add ratings, notes, categories, and visit dates
- **Favorites System**: Mark and filter your favorite places
- **Category Organization**: Organize places by categories

### 🎨 User Experience
- **Modern UI**: Clean, professional interface with gradient backgrounds
- **Responsive Design**: Works seamlessly across different screen sizes
- **Intuitive Navigation**: Easy-to-use drawer menu and navigation
- **Visual Feedback**: Loading states and empty state messages

## 🛠️ Tech Stack

- **Flutter** - Cross-platform UI framework
- **Riverpod** - State management
- **Google Maps Flutter** - Location services and mapping
- **SQLite** - Local database storage (sqflite package)
- **Path Provider** - File system access
- **Image Picker** - Camera and gallery integration
- **Google Fonts** - Typography
- **UUID** - Unique identifier generation

## 📱 Screenshots

The app features a beautiful dark theme with:
- Gradient backgrounds and cards
- Purple accent color scheme
- Professional typography
- Intuitive navigation drawer
- Statistics dashboard with charts
- Map integration for location selection

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Android Studio / VS Code
- Google Maps API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Animesh-86/favorite-places.git
   cd favorite-places
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Google Maps API**
   
   **For Android:**
   - Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add your API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE" />
   ```

   **For iOS:**
   - Add your API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📖 Usage Guide

### Adding a New Place
1. Tap the "+" button in the app bar
2. Take a photo or select from gallery
3. Choose a location on the map or use current location
4. Add title, category, rating, and notes
5. Set visit date (optional)
6. Tap "Add Place" to save

### Managing Your Places
- **View All Places**: Browse your saved places in the main list
- **Place Details**: Tap any place to view full details and location on map
- **Edit Places**: Modify ratings, notes, and other details
- **Favorites**: Mark places as favorites for quick access
- **Categories**: Organize places by categories

### Statistics & Analytics
- Access the Statistics screen from the drawer menu
- View overview cards with key metrics
- See category breakdown and rating distribution
- Track recent activity and trends

### Data Management
- **Export Data**: Save your places data to a file
- **Import Data**: Restore places from a previously exported file
- All data is stored locally on your device

## 🧪 Testing

1. **Basic Functionality**
   - Add a new place using the "+" button
   - Capture a photo using the camera
   - Select a location on the map
   - Add details and save the place

2. **Advanced Features**
   - Test the statistics dashboard
   - Try exporting and importing data
   - Mark places as favorites
   - Add ratings and notes to places

3. **Navigation**
   - Use the drawer menu to access different features
   - Navigate between screens
   - Test the map integration

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point and theme configuration
├── models/
│   └── place.dart         # Place data model
├── providers/
│   └── user_places.dart   # State management with Riverpod
├── screens/
│   ├── places.dart        # Main places list screen
│   ├── add_place.dart     # Add new place screen
│   ├── place_detail.dart  # Place details screen
│   ├── map.dart          # Map selection screen
│   └── statistics.dart    # Statistics dashboard
└── widgets/
    ├── gradient_scaffold.dart  # Custom scaffold with gradients
    ├── places_list.dart        # Places list widget
    ├── image_input.dart        # Image capture widget
    └── location_input.dart     # Location selection widget
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Maps for location services
- The open-source community for various packages used in this project

---

**Note**: This app requires a Google Maps API key for location services to work properly. Make sure to configure your API key before running the app.
