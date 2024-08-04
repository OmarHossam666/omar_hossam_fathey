# Photo Upload App

This Flutter application allows users to upload photos to Firebase Storage, view a list of uploaded photos with metadata, search, paginate, and delete photos. The project uses GetX for state management and Firebase for authentication and storage.

## Features
- **GetX Implementation**: State management with GetX.
- **Firebase Authentication**: User login and authentication setup.
- **Photo Upload**: Select and upload photos to Firebase Storage.
- **Display Photo and Metadata**: View uploaded photos and their metadata (upload date and file name).
- **List View**: Display all uploaded photos and metadata.
- **Search**: Search for photos by file name in the list view.
- **Pagination**: Navigate through photos in the list view with next and previous buttons.
- **Delete Photo**: Delete photos from Firebase Storage and the list view.
- **Dark Mode**: This feature need some fix and it will be updated soon!

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- [Firebase account](https://firebase.google.com/).

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/photo-upload-app.git
   cd photo-upload-app
   ```

2. Install dependencies:
   ```sh
   flutter pub get
   ```

3. Set up Firebase:
   - Create a new Firebase project.
   - Add your Android and iOS app to the Firebase project.
   - Download the `google-services.json` and `GoogleService-Info.plist` files and place them in the respective directories.
   - Enable Firebase Authentication (Email/Password).
   - Enable Firebase Storage.
   - Enable Firebase Firestore.

### Configuration

1. Update `android/app/build.gradle`:
   ```gradle
   dependencies {
       classpath 'com.google.gms:google-services:4.3.3'
   }
   ```

2. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

3. Initialize Firebase in your Flutter project:
   ```dart
   void main() async
   {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(MyApp());
   }
   ```

## Usage

1. **Login**: Authenticate using Firebase Authentication.
2. **Upload Photo**: Navigate to the upload page, select a photo from your device, and upload it to Firebase Storage.
3. **View Photos**: View a list of all uploaded photos with metadata.
4. **Search Photos**: Use the search bar to find photos by file name.
5. **Paginate**: Navigate between pages of photos using next and previous buttons.
6. **Delete Photo**: Delete a photo from Firebase Storage and the list view.

## Screenshots
### Login Screen:
![Login Screen](Screenshots/Login%20Screen.jpg)
### Home Screen:
![Home Screen](Screenshots/Home%20Screen.jpg)
### Upload Photo Screen:
![Photo Upload](Screenshots/Upload%20Photo%20Screen.jpg)
### Photo Uploaded Successfully Screen:
![Photo Uploaded Successfully](Screenshots/Photo%20Uploaded%20Successfully%20Screen.jpg)
### Uploaded Photos Screen (Light Mode):
![Uploaded Photos (Light Mode)](Screenshots/Uploaded%20Photos%20Screen%20(Light%20Mode).jpg)
### Uploaded Photos Screen (Dark Mode):
![Uploaded Photos (Dark Mode)](Screenshots/Uploaded%20Photos%20Screen%20(Dark%20Mode).jpg)
### Photo Details Screen:
![Photo Details](Screenshots/Photo%20Details%20Screen.jpg)

## Dependencies

- [GetX](https://pub.dev/packages/get)
- [Firebase](https://pub.dev/packages/firebase_core)
- [Firebase Authentication](https://pub.dev/packages/firebase_auth)
- [Firebase Storage](https://pub.dev/packages/firebase_storage)
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore)
- [Google Fonts](https://pub.dev/packages/google_fonts)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
