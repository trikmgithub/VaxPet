abstract class PointHistoryState {}

class PointHistoryLoading extends PointHistoryState {}

class PointHistoryLoaded extends PointHistoryState {
  final List<PointTransaction> transactions;

  PointHistoryLoaded({required this.transactions});
}

class PointHistoryFailure extends PointHistoryState {
  final String message;

  PointHistoryFailure({required this.message});
}

class PointTransaction {
  final int transactionId;
  final int customerId;
  final int? paymentId;
  final int? voucherId;
  final String change;
  final String transactionType;
  final String description;
  final String transactionDate;
  final Customer customer;
  final Payment? payment;
  final Voucher? voucher;

  PointTransaction({
    required this.transactionId,
    required this.customerId,
    this.paymentId,
    this.voucherId,
    required this.change,
    required this.transactionType,
    required this.description,
    required this.transactionDate,
    required this.customer,
    this.payment,
    this.voucher,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      transactionId: json['transactionId'] ?? 0,
      customerId: json['customerId'] ?? 0,
      paymentId: json['paymentId'],
      voucherId: json['voucherId'],
      change: json['change'] ?? '0',
      transactionType: json['transactionType'] ?? '',
      description: json['description'] ?? '',
      transactionDate: json['transactionDate'] ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}),
      payment: json['payment'] != null ? Payment.fromJson(json['payment']) : null,
      voucher: json['voucher'] != null ? Voucher.fromJson(json['voucher']) : null,
    );
  }
}

class Customer {
  final int customerId;
  final String fullName;
  final String phoneNumber;
  final int currentPoints;
  final int redeemablePoints;
  final Membership membershipResponseDTO;

  Customer({
    required this.customerId,
    required this.fullName,
    required this.phoneNumber,
    required this.currentPoints,
    required this.redeemablePoints,
    required this.membershipResponseDTO,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'] ?? 0,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      currentPoints: json['currentPoints'] ?? 0,
      redeemablePoints: json['redeemablePoints'] ?? 0,
      membershipResponseDTO: Membership.fromJson(json['membershipResponseDTO'] ?? {}),
    );
  }
}

class Membership {
  final String name;
  final String rank;
  final String benefits;

  Membership({
    required this.name,
    required this.rank,
    required this.benefits,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      name: json['name'] ?? '',
      rank: json['rank'] ?? '',
      benefits: json['benefits'] ?? '',
    );
  }
}

class Payment {
  final int appointmentDetailId;
  final String serviceName;

  Payment({
    required this.appointmentDetailId,
    required this.serviceName,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      appointmentDetailId: json['appointmentDetailId'] ?? 0,
      serviceName: json['serviceName'] ?? '',
    );
  }
}

class Voucher {
  final String voucherCode;
  final String voucherName;

  Voucher({
    required this.voucherCode,
    required this.voucherName,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      voucherCode: json['voucherCode'] ?? '',
      voucherName: json['voucherName'] ?? '',
    );
  }
}
