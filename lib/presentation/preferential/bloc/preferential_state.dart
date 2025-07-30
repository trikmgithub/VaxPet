import 'package:equatable/equatable.dart';

abstract class PreferentialState extends Equatable {
  const PreferentialState();

  @override
  List<Object?> get props => [];
}

class PreferentialInitial extends PreferentialState {}

class PreferentialLoading extends PreferentialState {}

class PreferentialLoaded extends PreferentialState {
  final CustomerRankingInfo customerRankingInfo;

  const PreferentialLoaded({required this.customerRankingInfo});

  @override
  List<Object?> get props => [customerRankingInfo];
}

class PreferentialError extends PreferentialState {
  final String message;

  const PreferentialError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CustomerRankingInfo {
  final int customerId;
  final int membershipId;
  final String customerCode;
  final String fullName;
  final int currentPoints;
  final String currentRank;
  final int minPointsCurrentRank;
  final int maxPointsCurrentRank;
  final String nextRank;
  final int pointsToNextRank;
  final int redeemablePoints;
  final double totalSpent;

  CustomerRankingInfo({
    required this.customerId,
    required this.membershipId,
    required this.customerCode,
    required this.fullName,
    required this.currentPoints,
    required this.currentRank,
    required this.minPointsCurrentRank,
    required this.maxPointsCurrentRank,
    required this.nextRank,
    required this.pointsToNextRank,
    required this.redeemablePoints,
    required this.totalSpent,
  });

  factory CustomerRankingInfo.fromJson(Map<String, dynamic> json) {
    return CustomerRankingInfo(
      customerId: json['customerId'] ?? 0,
      membershipId: json['membershipId'] ?? 0,
      customerCode: json['customerCode'] ?? '',
      fullName: json['fullName'] ?? '',
      currentPoints: json['currentPoints'] ?? 0,
      currentRank: json['currentRank'] ?? 'bronze',
      minPointsCurrentRank: json['minPointsCurrentRank'] ?? 0,
      maxPointsCurrentRank: json['maxPointsCurrentRank'] ?? 0,
      nextRank: json['nextRank'] ?? '',
      pointsToNextRank: json['pointsToNextRank'] ?? 0,
      redeemablePoints: json['redeemablePoints'] ?? 0,
      totalSpent: (json['totalSpent'] ?? 0).toDouble(),
    );
  }

  String get currentRankDisplayName {
    switch (currentRank.toLowerCase()) {
      case 'bronze':
        return 'Hạng Đồng';
      case 'silver':
        return 'Hạng Bạc';
      case 'gold':
        return 'Hạng Vàng';
      case 'platinum':
        return 'Hạng Bạch Kim';
      default:
        return 'Hạng Đồng';
    }
  }

  String get nextRankDisplayName {
    switch (nextRank.toLowerCase()) {
      case 'bronze':
        return 'Hạng Đồng';
      case 'silver':
        return 'Hạng Bạc';
      case 'gold':
        return 'Hạng Vàng';
      case 'platinum':
        return 'Hạng Bạch Kim';
      default:
        return '';
    }
  }

  double get progressPercentage {
    if (maxPointsCurrentRank <= minPointsCurrentRank) return 0.0;
    final progress = (currentPoints - minPointsCurrentRank) / (maxPointsCurrentRank - minPointsCurrentRank);
    return progress.clamp(0.0, 1.0);
  }
}
