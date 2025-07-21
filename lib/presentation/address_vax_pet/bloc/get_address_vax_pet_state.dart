import 'package:equatable/equatable.dart';

abstract class GetAddressVaxPetState extends Equatable {
  const GetAddressVaxPetState();

  @override
  List<Object?> get props => [];
}

class GetAddressVaxPetInitial extends GetAddressVaxPetState {}

class GetAddressVaxPetLoading extends GetAddressVaxPetState {}

class GetAddressVaxPetSuccess extends GetAddressVaxPetState {
  final Map<String, dynamic> addressData;

  const GetAddressVaxPetSuccess(this.addressData);

  @override
  List<Object?> get props => [addressData];

  // Helper getters để lấy dữ liệu dễ dàng hơn
  double get latitude => (addressData['latitude'] as num?)?.toDouble() ?? 10.840846;
  double get longitude => (addressData['longitude'] as num?)?.toDouble() ?? 106.777707;
  String get clinicName => addressData['clinicName'] as String? ?? 'VaxPet Veterinary Center';
  String get address => addressData['address'] as String? ?? '123 Nguyễn Văn Linh, Phường Tân Phong, Quận 7, TP.HCM';
  String get phone => addressData['phone'] as String? ?? '028 3888 9999';
  String get openingHours => addressData['openingHours'] as String? ?? '8:00 - 12:00 & 13:00-17:00 (Thứ 2 - Chủ nhật)';
}

class GetAddressVaxPetFailure extends GetAddressVaxPetState {
  final String message;

  const GetAddressVaxPetFailure(this.message);

  @override
  List<Object?> get props => [message];
}
