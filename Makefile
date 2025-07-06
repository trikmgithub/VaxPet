# Flutter Development Scripts for VaxPet

# Analyze code quality
flutter_analyze:
	flutter analyze

# Format all Dart files
flutter_format:
	dart format lib/ test/ --line-length=80

# Run tests
flutter_test:
	flutter test

# Check Flutter environment
flutter_health:
	flutter doctor -v

# Update dependencies
flutter_deps:
	flutter pub get
	flutter pub upgrade

# Build for different platforms
flutter_build_android:
	flutter build apk --release

flutter_build_ios:
	flutter build ios --release

# Clean and rebuild
flutter_clean:
	flutter clean
	flutter pub get

# Generate code (if using build_runner)
flutter_generate:
	flutter packages pub run build_runner build

.PHONY: flutter_analyze flutter_format flutter_test flutter_health flutter_deps flutter_build_android flutter_build_ios flutter_clean flutter_generate
