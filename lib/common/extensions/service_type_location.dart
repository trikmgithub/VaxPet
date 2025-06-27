extension ServiceTypeLocation on int {
  String get toServiceTypeLocation {
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

  String get toServiceTypeLocationString {
    return toServiceTypeLocation;
  }
}