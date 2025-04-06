# Kleio - Vinyl Collection Manager

Kleio is a Flutter application designed to help vinyl collectors manage their record collections, track play history, monitor stylus usage, and analyze listening habits.

## Features

- Connect with your Discogs account to sync your vinyl collection
- Log play history with details about stylus used and notes
- Track record cleaning history
- Manage styluses and monitor their lifespan
- View analytics about your listening habits
- Filter and search your collection

## Project Structure

The project follows a feature-based structure with separation of concerns:

```
lib/
├── core/               # Core functionality used across the app
│   ├── di/             # Dependency injection
│   ├── routing/        # Navigation using Go Router
│   ├── theme/          # App theme and styling
│   ├── utils/          # Utility functions
│   └── widgets/        # Reusable widgets
├── data/               # Data layer
│   ├── models/         # Data models
│   ├── repositories/   # Repository classes
│   └── services/       # Services for API communication
├── features/           # App features
│   ├── analytics/      # Listening analytics
│   ├── auth/           # Authentication with Discogs
│   ├── collection/     # Vinyl collection management
│   ├── play_history/   # Play history tracking
│   ├── stylus/         # Stylus management
│   └── record_detail/  # Record detail view
└── main.dart           # Application entry point
```

## Technology Stack

- **Framework**: Flutter
- **State Management**: Riverpod with Code Generation
- **Navigation**: Go Router
- **HTTP Client**: Dio
- **Local Storage**: Shared Preferences + Hive
- **Dependency Injection**: Provider pattern with Riverpod
- **Charts**: fl_chart + syncfusion_flutter_charts

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or later)
- Dart SDK (version 3.0.0 or later)
- Android Studio or Visual Studio Code with Flutter extensions

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/kleio.git
   cd kleio
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Generate code (required for Riverpod and JSON serialization):

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Setting Up a Discogs API Token

To use Kleio, you'll need a Discogs API token:

1. Create an account on [Discogs](https://www.discogs.com/)
2. Go to Settings > Developer
3. Generate a personal access token
4. Use this token to log in to the Kleio app

## Architecture

Kleio follows a feature-based clean architecture approach:

### Data Layer

- **Models**: Data classes that represent the domain entities
- **Repositories**: Abstract the data sources and provide methods to interact with them
- **Services**: Handle external communication (API, databases)

### Application Layer

- **Providers**: Riverpod providers that expose state and business logic
- **Notifiers**: Handle state updates and business logic

### Presentation Layer

- **Screens**: UI components that display information to the user
- **Widgets**: Reusable UI components
- **Controllers**: Handle user interactions and update the UI

## State Management with Riverpod

Kleio uses Riverpod with code generation for efficient state management:

- **Providers**: Define dependencies and state
- **StateNotifierProvider**: Manage mutable state
- **FutureProvider**: Handle asynchronous data
- **Family Providers**: Parameterized providers for specific instances

## Navigation with Go Router

The app uses Go Router for declarative routing:

- **Routes**: Defined in `lib/core/routing/app_router.dart`
- **Shell Routes**: Used for persistent UI elements (bottom navigation)
- **Guards**: Authentication protection for routes

## Development Guidelines

### Code Style

- Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Write documentation for public APIs

### Commits

- Use descriptive commit messages
- Follow conventional commits format when possible

### Testing

- Write unit tests for repositories and providers
- Write widget tests for UI components
- Use integration tests for critical user flows

## License

This project is licensed under the MIT License - see the LICENSE file for details.
