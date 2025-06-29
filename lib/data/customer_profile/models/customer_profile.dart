class CustomerProfileModel {
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

  CustomerProfileModel({
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
    this.currentPoints
  });

  factory CustomerProfileModel.fromJson(Map<dynamic, dynamic> json) {
    final accountResponse = json['accountResponseDTO'] ?? {};

    return CustomerProfileModel(
      customerId: json['customerId'],
      accountId: json['accountId'],
      membershipId: json['membershipId'],
      customerCode: json['customerCode'],
      fullName: json['fullName'],
      userName: json['userName'],
      image: json['image'],
      email: accountResponse['email'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      address: json['address'],
      currentPoints: json['currentPoints'],
    );
  }

}