# Mingle (In Development..)

Mingle is a mobile application developed using Dart and Flutter. This app provides a platform where users can view events, participate in them, match with other attendees, and communicate with them. Firebase is used for user authentication, database management, and messaging functionalities.

## Features

- **Viewing and Searching Events:** Users can search for events of interest and get details about them.
- **Joining Events and Purchasing Tickets:** Users can join selected events and purchase tickets.
- **Matching Between Participants:** Users can match with other attendees of events.
- **Messaging Between Matched Participants:** Messaging functionality is available for matched users.

## Technologies Used

- **Dart:** The primary programming language for the application.
- **Flutter:** The framework used for developing the mobile application.
- **Firebase:** Used for Auth, Firestore, and Messaging services.
  - **Auth:** User authentication.
  - **Firestore:** Database management.
  - **Messaging:** Messaging functionality.
- **Provider:** Used for state management.

## Firestore Database

### Tickets Collection
![Tickets Collection](https://github.com/eerenyilmazz/mingle/assets/76735938/fa955cd2-c343-499c-b280-3f5edaae579b)

- Description: Collection storing ticket information.

### Events Collection
![Events Collection](https://github.com/eerenyilmazz/mingle/assets/76735938/935fb8d7-4bac-421c-8b52-66cc86db51eb)

- Description: Collection containing event details.

### Chats Collection
![Chats Collection](https://github.com/eerenyilmazz/mingle/assets/76735938/34cf116b-26e6-4d71-95bd-04a7c5900126)

- Description: Collection storing messages between users.

### Users Collection
![Users Collection](https://github.com/eerenyilmazz/mingle/assets/76735938/648fbb97-cfa9-4227-9f02-de31463ece35)

- Description: Collection containing user information.

## Application Screenshots

### Startup Screen
![Startup Screen](https://github.com/eerenyilmazz/mingle/assets/76735938/8a52b48b-99a3-4536-8159-e6717e6e075e)

### Registration Screens
![Registration Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/dcd9a7f9-7aa2-43f9-9eb7-3793636197bc) ![Registration Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/cdc30c8a-94ca-41c2-b811-f2c8051d7309) ![Registration Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/245434f2-c2a1-4fb3-bc71-b200d07dc352) ![Registration Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/374abae8-c497-49bc-8c38-0e050b4c0ccf)

### Login Page
![Login Page](https://github.com/eerenyilmazz/mingle/assets/76735938/412f2f4d-9237-4a8b-9616-e9ff8c5448de)

### Home Screen
![Home Screen](https://github.com/eerenyilmazz/mingle/assets/76735938/64c33c8d-3408-4326-8d87-54a5a846688f)

### Event Detail Page
![Event Detail Page](https://github.com/eerenyilmazz/mingle/assets/76735938/f5a29a6f-a90a-48ff-8e0c-6af5d3d946ea) ![Event Detail Page](https://github.com/eerenyilmazz/mingle/assets/76735938/64ef69a9-53a7-4c0b-bf01-3cea34a07aca)

### Profile and Edit Profile Screens
![Profile Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/502a9231-8d12-4e87-b1a2-bd146e54f798) ![Profile Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/79ae18ee-f327-452d-abea-0bcc9f40d78f) ![Profile Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/c8641aa0-1c89-4d34-b8c3-c361ba14aa27) ![Profile Screens](https://github.com/eerenyilmazz/mingle/assets/76735938/1169ea52-e351-40e5-9ad1-3948902af3e4)

### Scrollable Page
![Scrollable Page](https://github.com/eerenyilmazz/mingle/assets/76735938/cfccd0e4-8577-4df1-822c-8f7a776a6515) ![Scrollable Page](https://github.com/eerenyilmazz/mingle/assets/76735938/87e33fea-edd8-4834-bc4a-bae3673312b4)

### Matches, Messages, and Message Profile Detail Pages
![Matches Page](https://github.com/eerenyilmazz/mingle/assets/76735938/73cbab54-5035-4d84-8a33-b8224001b85e) ![Messages Page](https://github.com/eerenyilmazz/mingle/assets/76735938/bfe87327-2b59-41e5-8a99-b4560fc2a41a) ![Message Profile Detail](https://github.com/eerenyilmazz/mingle/assets/76735938/b5191bf0-d8af-46c5-ba5a-e0ee3a3cc19c)

## Running the Project

### Installing Required Packages

To run the project, first install all the dependencies listed in the `pubspec.yaml` file. You can do this by running the following command:

```bash
flutter pub get
```

### Dependencies in `pubspec.yaml`

Here are the dependencies used in the project:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  font_awesome_flutter: ^10.7.0
  intl: ^0.19.0
  firebase_core: ^2.31.0
  cloud_firestore: ^4.17.3
  url_launcher: ^6.2.6
  firebase_auth: ^4.19.5
  firebase_storage: ^11.7.5
  image_picker: ^1.1.1
  provider: ^6.1.2
  shared_preferences: ^2.2.3
  percent_indicator: ^4.2.3
  numberpicker: ^2.1.2
  qr_flutter: ^4.1.0
  image_gallery_saver: ^2.0.3
```

### Setting Up Firebase

1. **Create a Firebase Project:**
   - Create a new project on the [Firebase Console](https://console.firebase.google.com/).

2. **Download Firebase Config Files:**
   - After creating the project, download `google-services.json` for Android and `GoogleService-Info.plist` for iOS.

3. **Add Config Files to Your Project:**
   - Copy `google-services.json` to the `android/app` directory.
   - Copy `GoogleService-Info.plist` to the `ios/Runner` directory.

4. **Setup Firebase SDK:**
   - For Android, add the following classpath to `android/build.gradle`:
     ```gradle
     classpath 'com.google.gms:google-services:4.3.3'
     ```
   - For Android, apply the Google services plugin in `android/app/build.gradle`:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

Follow these steps to successfully run the project. If you encounter any issues, refer to the [Firebase Documentation](https://firebase.google.com/docs) and [Flutter Documentation](https://flutter.dev/docs) for assistance.
