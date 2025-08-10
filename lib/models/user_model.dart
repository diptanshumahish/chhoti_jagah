import 'package:cloud_firestore/cloud_firestore.dart';

enum AgeGroup {
  lessThan13,
  age13To18,
  age18To30,
  age30To45,
  age45Plus,
}

enum AccountType {
  normal,
  admin,
  dev,
  superAdmin,
}

class UserModel {
  final String id;
  final String username;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int points;
  final AgeGroup? ageGroup;
  final String? placeOfLiving;
  final String fullName;
  final String emailId;
  final String? userBio;
  final List<String> contributions;
  final Map<String, dynamic>? recentActivity;
  final AccountType accountType;
  final bool premium;
  final bool verified;

  UserModel({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.modifiedAt,
    required this.points,
    this.ageGroup,
    this.placeOfLiving,
    required this.fullName,
    required this.emailId,
    this.userBio,
    required this.contributions,
    this.recentActivity,
    required this.accountType,
    required this.premium,
    required this.verified,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
      points: data['points'] ?? 0,
      ageGroup: _parseAgeGroup(data['ageGroup']),
      placeOfLiving: data['placeOfLiving'],
      fullName: data['fullName'] ?? '',
      emailId: data['emailId'] ?? '',
      userBio: data['userBio'],
      contributions: List<String>.from(data['contributions'] ?? []),
      recentActivity: data['recentActivity'],
      accountType: _parseAccountType(data['accountType']),
      premium: data['premium'] ?? false,
      verified: data['verified'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
      'points': points,
      'ageGroup': ageGroup?.name,
      'placeOfLiving': placeOfLiving,
      'fullName': fullName,
      'emailId': emailId,
      'userBio': userBio,
      'contributions': contributions,
      'recentActivity': recentActivity,
      'accountType': accountType.name,
      'premium': premium,
      'verified': verified,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    DateTime? createdAt,
    DateTime? modifiedAt,
    int? points,
    AgeGroup? ageGroup,
    String? placeOfLiving,
    String? fullName,
    String? emailId,
    String? userBio,
    List<String>? contributions,
    Map<String, dynamic>? recentActivity,
    AccountType? accountType,
    bool? premium,
    bool? verified,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      points: points ?? this.points,
      ageGroup: ageGroup ?? this.ageGroup,
      placeOfLiving: placeOfLiving ?? this.placeOfLiving,
      fullName: fullName ?? this.fullName,
      emailId: emailId ?? this.emailId,
      userBio: userBio ?? this.userBio,
      contributions: contributions ?? this.contributions,
      recentActivity: recentActivity ?? this.recentActivity,
      accountType: accountType ?? this.accountType,
      premium: premium ?? this.premium,
      verified: verified ?? this.verified,
    );
  }

  static AgeGroup? _parseAgeGroup(String? ageGroupStr) {
    if (ageGroupStr == null) return null;
    
    switch (ageGroupStr) {
      case 'lessThan13':
        return AgeGroup.lessThan13;
      case 'age13To18':
        return AgeGroup.age13To18;
      case 'age18To30':
        return AgeGroup.age18To30;
      case 'age30To45':
        return AgeGroup.age30To45;
      case 'age45Plus':
        return AgeGroup.age45Plus;
      default:
        return null;
    }
  }

  static AccountType _parseAccountType(String? accountTypeStr) {
    if (accountTypeStr == null) return AccountType.normal;
    
    switch (accountTypeStr) {
      case 'admin':
        return AccountType.admin;
      case 'dev':
        return AccountType.dev;
      case 'superAdmin':
        return AccountType.superAdmin;
      default:
        return AccountType.normal;
    }
  }

  static String getAgeGroupDisplayName(AgeGroup ageGroup) {
    switch (ageGroup) {
      case AgeGroup.lessThan13:
        return 'Less than 13';
      case AgeGroup.age13To18:
        return '13-18';
      case AgeGroup.age18To30:
        return '18-30';
      case AgeGroup.age30To45:
        return '30-45';
      case AgeGroup.age45Plus:
        return '45+';
    }
  }

  static List<AgeGroup> getAllAgeGroups() {
    return AgeGroup.values;
  }
}
