import 'package:vaxpet/common/enums/location_type_enum.dart';

extension LocationTypeExtension on int {
  LocationTypeEnum? get toLocationType {
    switch (this) {
      case 1:
        return LocationTypeEnum.clinic;
      case 2:
        return LocationTypeEnum.homeVisit;
      default:
        return null;
    }
  }

  String? get toLocationTypeString {
    return toLocationType?.name.toLowerCase() == 'clinic'
        ? 'Trung tâm'
        : 'Tại nhà';
  }
}
