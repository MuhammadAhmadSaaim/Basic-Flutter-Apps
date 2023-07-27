// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCeGigAaijpZrlIk5gKKvZls5eRA13jsGs',
    appId: '1:854062257800:android:55ae9b8139608a788db13d',
    messagingSenderId: '854062257800',
    projectId: 'ticket-booking-app-9bc5b',
    storageBucket: 'ticket-booking-app-9bc5b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXeXU5b4evE_MpZ2q5hDQQot-I8Wbo1bs',
    appId: '1:854062257800:ios:4f4c0b6b407bb8808db13d',
    messagingSenderId: '854062257800',
    projectId: 'ticket-booking-app-9bc5b',
    storageBucket: 'ticket-booking-app-9bc5b.appspot.com',
    androidClientId: '854062257800-t9gc4m6gbflgtaqel79c07039ioc2sbs.apps.googleusercontent.com',
    iosClientId: '854062257800-oe0ij8cgjafr8o1qucvkisj2fh991676.apps.googleusercontent.com',
    iosBundleId: 'com.example.ticketBookingApp',
  );
}
