import 'package:filament_nexus/features/profile/data/user_mock.dart';
import 'package:filament_nexus/features/profile/domain/profile.dart';

class ProfileRepository {
  static Profile _currentProfile = mockProfile;

  Profile getProfile() => _currentProfile;

  void updateProfile(Profile profile) {
    _currentProfile = profile;
  }
}
