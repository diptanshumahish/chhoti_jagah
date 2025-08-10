import 'package:flutter_test/flutter_test.dart';
import 'package:chhoti_jagah/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create user with default values', () {
      final user = UserModel(
        id: 'test_id',
        username: 'testuser',
        createdAt: DateTime(2024, 1, 1),
        modifiedAt: DateTime(2024, 1, 1),
        points: 0,
        fullName: 'Test User',
        emailId: 'test@example.com',
        contributions: [],
        accountType: AccountType.normal,
        premium: false,
        verified: false,
      );

      expect(user.id, 'test_id');
      expect(user.username, 'testuser');
      expect(user.fullName, 'Test User');
      expect(user.emailId, 'test@example.com');
      expect(user.accountType, AccountType.normal);
      expect(user.premium, false);
      expect(user.verified, false);
      expect(user.ageGroup, null);
      expect(user.placeOfLiving, null);
    });

    test('should create user with all values', () {
      final user = UserModel(
        id: 'test_id',
        username: 'testuser',
        createdAt: DateTime(2024, 1, 1),
        modifiedAt: DateTime(2024, 1, 1),
        points: 100,
        ageGroup: AgeGroup.age18To30,
        placeOfLiving: 'New York',
        fullName: 'Test User',
        emailId: 'test@example.com',
        contributions: ['contribution1', 'contribution2'],
        recentActivity: {'action': 'login'},
        accountType: AccountType.admin,
        premium: true,
        verified: true,
      );

      expect(user.ageGroup, AgeGroup.age18To30);
      expect(user.placeOfLiving, 'New York');
      expect(user.points, 100);
      expect(user.contributions, ['contribution1', 'contribution2']);
      expect(user.recentActivity, {'action': 'login'});
      expect(user.accountType, AccountType.admin);
      expect(user.premium, true);
      expect(user.verified, true);
    });

    test('should get age group display names', () {
      expect(UserModel.getAgeGroupDisplayName(AgeGroup.lessThan13), 'Less than 13');
      expect(UserModel.getAgeGroupDisplayName(AgeGroup.age13To18), '13-18');
      expect(UserModel.getAgeGroupDisplayName(AgeGroup.age18To30), '18-30');
      expect(UserModel.getAgeGroupDisplayName(AgeGroup.age30To45), '30-45');
      expect(UserModel.getAgeGroupDisplayName(AgeGroup.age45Plus), '45+');
    });

    test('should get all age groups', () {
      final ageGroups = UserModel.getAllAgeGroups();
      expect(ageGroups.length, 5);
      expect(ageGroups.contains(AgeGroup.lessThan13), true);
      expect(ageGroups.contains(AgeGroup.age13To18), true);
      expect(ageGroups.contains(AgeGroup.age18To30), true);
      expect(ageGroups.contains(AgeGroup.age30To45), true);
      expect(ageGroups.contains(AgeGroup.age45Plus), true);
    });

    test('should copy with new values', () {
      final user = UserModel(
        id: 'test_id',
        username: 'testuser',
        createdAt: DateTime(2024, 1, 1),
        modifiedAt: DateTime(2024, 1, 1),
        points: 0,
        fullName: 'Test User',
        emailId: 'test@example.com',
        contributions: [],
        accountType: AccountType.normal,
        premium: false,
        verified: false,
      );

      final updatedUser = user.copyWith(
        username: 'newuser',
        points: 100,
        premium: true,
      );

      expect(updatedUser.username, 'newuser');
      expect(updatedUser.points, 100);
      expect(updatedUser.premium, true);
      expect(updatedUser.fullName, 'Test User'); // Should remain unchanged
      expect(updatedUser.emailId, 'test@example.com'); // Should remain unchanged
    });
  });
}
