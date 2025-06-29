extension SpeciesTypeExtension on String {
  String get toSpeciesTypeExtension {
    switch (this) {
      case 'cat':
        return 'Mèo';
      case 'Cat':
        return 'Mèo';
      case 'dog':
        return 'Chó';
      case 'Dog':
        return 'Chó';
      default:
        return 'Không xác định';
    }
  }

  String get toSpeciesTypeExtensionString {
    return toSpeciesTypeExtension;
  }
}