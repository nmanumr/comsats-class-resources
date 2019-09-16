echo "const Map<String, String> version =" > lib/flutter_version.dart
flutter --version --machine >> lib/flutter_version.dart
echo ";" >> lib/flutter_version.dart
