# Infinite Shop

This project is a web-based Flutter application created as a technical assignment for Burning Bros.

## Setup & Running Instructions

### Prerequisites
- Flutter SDK (^3.7.2)
- Dart SDK (^3.7.2)
- A modern web browser (Chrome recommended for best development experience)
- Git
- Python 3 (for serving the release build locally)

### Environment Setup
1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd infinite_shop
   ```

2. Create a `.env` file in the project root with the following content:
   ```
   API_HOST=https://dummyjson.com
   ```
   
   Note: This step is **required** as the application depends on this API endpoint.

3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

#### Development Mode
To run the application in development mode:

```bash
flutter run -d chrome
```

This will launch the application in Chrome with hot reload enabled.

### Building and Running the Release Version

Follow these steps to build and run the release version of the application:

1. Build the application for release:
   ```bash
   flutter build web --release
   ```

2. Navigate to the build output directory:
   ```bash
   cd build/web
   ```

3. Start a simple HTTP server using Python:
   ```bash
   python3 -m http.server 8000
   ```

4. Open your browser and visit:
   ```
   http://localhost:8000
   ```

5. To stop the server, press `Ctrl+C` in the terminal.

This process will build an optimized version of the application and serve it locally, simulating a production environment.


## Project Structure

- `lib/` - Contains the main source code
  - `app/` - Application specific code
    - `common/` - Shared resources (UI constants, themes, etc.)
    - `core_impl/` - Core implementations
    - `layers/` - Implementation of the clean architecture layers
  - `core/` - Core abstractions and utilities
  - `main.dart` - Entry point of the application
  - `flavors.dart` - Application flavor configuration

## Technical Notes

- This project follows clean architecture principles
- State management: Combination of MobX, Provider and GetX
- Dependency injection using GetIt
- Environment configuration via flutter_dotenv
- HTTP client using Dio
- Local storage using Hive

## Contact

For any questions regarding this submission, please contact:
bqhuynh171@gmail.com

---

Thank you for reviewing this technical assignment.
