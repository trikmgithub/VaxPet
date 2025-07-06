class CustomerProfileEntity {
  final int? customerId;
  final int? accountId;
  final int? membershipId;
  final String? customerCode;
  final String? fullName;
  final String? userName;
  final String? image;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? currentPoints;

  CustomerProfileEntity({
    this.customerId,
    this.accountId,
    this.membershipId,
    this.customerCode,
    this.fullName,
    this.userName,
    this.image,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.currentPoints,
  });
}
