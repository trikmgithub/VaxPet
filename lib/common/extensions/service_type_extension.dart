extension ServiceTypeExtension on int {
  String get toServiceTypeExtension {
    switch (this) {
      case 1:
        return 'Vắc xin';
      case 2:
        return 'Microchip';
      case 3:
        return 'Chứng nhận sức khỏe';
      default:
        return 'Không xác định';
    }
  }

  String get toServiceTypeExtensionString {
    return toServiceTypeExtension;
  }
}