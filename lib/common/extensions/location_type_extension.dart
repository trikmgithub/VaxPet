import 'package:vaxpet/common/enums/location_type_enum.dart';

extension LocationTypeExtension on int {
  LocationTypeEnum? get toLocationType {
    switch (this) {
      case 1:
        return LocationTypeEnum.Clinic;
      case 2:
        return LocationTypeEnum.HomeVisit;
      default:
        return null;
    }
  }

  String? get toLocationTypeString {
    return toLocationType?.name == 'Clinic' ? 'Trung tâm' : 'Tại nhà';
  }
}