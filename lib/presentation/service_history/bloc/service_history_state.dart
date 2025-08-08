abstract class ServiceHistoryState {}

class ServiceHistoryLoading extends ServiceHistoryState {}

class ServiceHistoryLoaded extends ServiceHistoryState {
  final List<ServiceHistoryEntity> serviceHistories;

  ServiceHistoryLoaded({required this.serviceHistories});
}

class ServiceHistoryError extends ServiceHistoryState {
  final String errorMessage;

  ServiceHistoryError({required this.errorMessage});
}

// Entity classes
class ServiceHistoryEntity {
  final int? serviceHistoryId;
  final int? appointmentId;
  final int? serviceType;
  final String? serviceDate;
  final String? paymentMethod;
  final double? amount;
  final String? status;
  final String? createdAt;
  final String? createdBy;
  final String? modifiedAt;
  final String? modifiedBy;
  final bool? isDeleted;
  final CustomerEntity? customer;
  final PetEntity? pet;
  final AppointmentEntity? appointment;

  ServiceHistoryEntity({
    this.serviceHistoryId,
    this.appointmentId,
    this.serviceType,
    this.serviceDate,
    this.paymentMethod,
    this.amount,
    this.status,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
    this.customer,
    this.pet,
    this.appointment,
  });

  String get serviceTypeName {
    switch (serviceType) {
      case 1:
        return 'Vắc xin';
      case 2:
        return 'Cấy microchip';
      case 3:
        return 'Chứng nhận sức khỏe';
      default:
        return 'Không xác định';
    }
  }
}

class CustomerEntity {
  final int? customerId;
  final int? accountId;
  final int? membershipId;
  final String? customerCode;
  final String? fullName;
  final String? userName;
  final String? image;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final int? currentPoints;
  final int? redeemablePoints;
  final double? totalSpent;
  final String? createdAt;
  final String? createdBy;
  final String? modifiedAt;
  final String? modifiedBy;
  final bool? isDeleted;
  final AccountResponseDTO? accountResponseDTO;

  CustomerEntity({
    this.customerId,
    this.accountId,
    this.membershipId,
    this.customerCode,
    this.fullName,
    this.userName,
    this.image,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.currentPoints,
    this.redeemablePoints,
    this.totalSpent,
    this.createdAt,
    this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    this.isDeleted,
    this.accountResponseDTO,
  });
}

class PetEntity {
  final int? petId;
  final int? customerId;
  final String? petCode;
  final String? name;
  final String? species;
  final String? breed;
  final String? gender;
  final String? dateOfBirth;
  final String? placeToLive;
  final String? placeOfBirth;
  final String? image;
  final String? weight;
  final String? color;
  final String? nationality;
  final bool? isSterilized;
  final bool? isDeleted;

  PetEntity({
    this.petId,
    this.customerId,
    this.petCode,
    this.name,
    this.species,
    this.breed,
    this.gender,
    this.dateOfBirth,
    this.placeToLive,
    this.placeOfBirth,
    this.image,
    this.weight,
    this.color,
    this.nationality,
    this.isSterilized,
    this.isDeleted,
  });
}

class AccountResponseDTO {
  final int? accountId;
  final String? email;
  final int? role;
  final int? vetId;

  AccountResponseDTO({
    this.accountId,
    this.email,
    this.role,
    this.vetId,
  });
}

class AppointmentEntity {
  final int? appointmentId;
  final String? appointmentCode;

  AppointmentEntity({
    this.appointmentId,
    this.appointmentCode,
  });
}
