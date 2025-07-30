abstract class MembershipState {}

class MembershipLoading extends MembershipState {}

class MembershipLoaded extends MembershipState {
  final MembershipStatusResponse membershipStatus;

  MembershipLoaded({required this.membershipStatus});
}

class MembershipFailure extends MembershipState {
  final String errorMessage;

  MembershipFailure({required this.errorMessage});
}

// Models based on the API response
class MembershipStatusResponse {
  final int code;
  final bool success;
  final String message;
  final MembershipData data;

  MembershipStatusResponse({
    required this.code,
    required this.success,
    required this.message,
    required this.data,
  });

  factory MembershipStatusResponse.fromJson(Map<String, dynamic> json) {
    return MembershipStatusResponse(
      code: json['code'],
      success: json['success'],
      message: json['message'],
      data: MembershipData.fromJson(json['data']),
    );
  }
}

class MembershipData {
  final MembershipRankingResponse membershipRankingResponseDTO;
  final List<Membership> memberships;

  MembershipData({
    required this.membershipRankingResponseDTO,
    required this.memberships,
  });

  factory MembershipData.fromJson(Map<String, dynamic> json) {
    return MembershipData(
      membershipRankingResponseDTO: MembershipRankingResponse.fromJson(
        json['membershipRankingResponseDTO'],
      ),
      memberships: (json['memberships'] as List)
          .map((membership) => Membership.fromJson(membership))
          .toList(),
    );
  }
}

class MembershipRankingResponse {
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
  final int totalSpent;

  MembershipRankingResponse({
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

  factory MembershipRankingResponse.fromJson(Map<String, dynamic> json) {
    return MembershipRankingResponse(
      customerId: json['customerId'],
      membershipId: json['membershipId'],
      customerCode: json['customerCode'],
      fullName: json['fullName'],
      currentPoints: json['currentPoints'],
      currentRank: json['currentRank'],
      minPointsCurrentRank: json['minPointsCurrentRank'],
      maxPointsCurrentRank: json['maxPointsCurrentRank'],
      nextRank: json['nextRank'],
      pointsToNextRank: json['pointsToNextRank'],
      redeemablePoints: json['redeemablePoints'],
      totalSpent: json['totalSpent'],
    );
  }
}

class Membership {
  final int membershipId;
  final String membershipCode;
  final String name;
  final String description;
  final int minPoints;
  final String benefits;
  final String rank;
  final String createdAt;
  final String createdBy;
  final String? modifiedAt;
  final String? modifiedBy;
  final bool isDeleted;

  Membership({
    required this.membershipId,
    required this.membershipCode,
    required this.name,
    required this.description,
    required this.minPoints,
    required this.benefits,
    required this.rank,
    required this.createdAt,
    required this.createdBy,
    this.modifiedAt,
    this.modifiedBy,
    required this.isDeleted,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      membershipId: json['membershipId'],
      membershipCode: json['membershipCode'],
      name: json['name'],
      description: json['description'],
      minPoints: json['minPoints'],
      benefits: json['benefits'],
      rank: json['rank'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      modifiedAt: json['modifiedAt'],
      modifiedBy: json['modifiedBy'],
      isDeleted: json['isDeleted'],
    );
  }
}
