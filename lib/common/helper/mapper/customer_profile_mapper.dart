import '../../../data/customer_profile/models/customer_profile.dart';
import '../../../domain/customer_profile/entities/customer_profile.dart';

class CustomerProfileMapper {
  static CustomerProfileEntity toEntity(CustomerProfileModel customer) {
    return CustomerProfileEntity(
      customerId: customer.customerId,
      accountId: customer.accountId,
      membershipId: customer.membershipId,
      customerCode: customer.customerCode,
      fullName: customer.fullName,
      userName: customer.userName,
      image: customer.image,
      email: customer.email,
      phoneNumber: customer.phoneNumber,
      dateOfBirth: customer.dateOfBirth,
      gender: customer.gender,
      address: customer.address,
      currentPoints: customer.currentPoints
    );
  }
}