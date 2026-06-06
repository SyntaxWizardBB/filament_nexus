import 'package:filament_nexus/features/profile/data/profile_repository.dart';
import 'package:filament_nexus/features/profile/domain/profile.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  UserService._internal();

  factory UserService() {
    return _instance;
  }

  late Profile _currentUser;
  bool _isInitialized = false;

  Profile get currentUser {
    if (!_isInitialized) {
      initialize();
    }
    return _currentUser;
  }

  String get userId {
    if (!_isInitialized) {
      initialize();
    }
    return _currentUser.id;
  }

  void initialize() {
    if (!_isInitialized) {
      final repo = ProfileRepository();
      _currentUser = repo.getProfile();
      _isInitialized = true;
    }
  }

  void updateProfile(Profile profile) {
    _currentUser = profile;
  }
}
