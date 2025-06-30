# task_master

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
Flutter version 3.27.4

## Generate Icons for All Flavors

flutter pub run flutter_launcher_icons:main

## Run Different Flavors of Flutter
Android:
flutter run --flavor speedup -t lib/main.dart
flutter run --flavor fortunecloud -t lib/main.dart
flutter run --flavor fortunecloudpcmc -t lib/main.dart

Ios:
flutter run --flavor speedup -t lib/main.dart
# Or select the scheme in Xcode and run

With dotenv:
flutter run --flavor speedup --dart-define=FLAVOR=speedup -t lib/main.dart

## USE THIS INSTEAD OF ABOVE COMMANDS

flutter run --flavor speedup --dart-define=FLAVOR=speedup -t lib/main.dart
flutter run --flavor fortunecloud --dart-define=FLAVOR=fortunecloud -t lib/main.dart
flutter run --flavor fortunecloudpcmc --dart-define=FLAVOR=fortunecloudpcmc -t lib/main.dart

## Create Release builds

Android APK Release

flutter build apk --flavor speedup -t lib/main.dart --dart-define=FLAVOR=speedup
flutter build apk --flavor fortunecloud -t lib/main.dart --dart-define=FLAVOR=fortunecloud
flutter build apk --flavor fortunecloudpcmc -t lib/main.dart --dart-define=FLAVOR=fortunecloudpcmc


Android App Bundle (AAB) Release

flutter build appbundle --flavor speedup -t lib/main.dart --dart-define=FLAVOR=speedup
flutter build appbundle --flavor fortunecloud -t lib/main.dart --dart-define=FLAVOR=fortunecloud
flutter build appbundle --flavor fortunecloudpcmc -t lib/main.dart --dart-define=FLAVOR=fortunecloudpcmc


iOS Release

flutter build ios --flavor speedup -t lib/main.dart --dart-define=FLAVOR=speedup
flutter build ios --flavor fortunecloud -t lib/main.dart --dart-define=FLAVOR=fortunecloud
flutter build ios --flavor fortunecloudpcmc -t lib/main.dart --dart-define=FLAVOR=fortunecloudpcmc