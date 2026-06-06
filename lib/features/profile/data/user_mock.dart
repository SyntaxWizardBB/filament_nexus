import 'package:filament_nexus/app/utils/password_hasher.dart';
import 'package:filament_nexus/features/profile/domain/profile.dart';

final Profile mockProfile = Profile(
  id: 'edd369eb-4ed3-4681-ab41-775b2c2df76b',
  name: 'Mr. Nexus',
  email: 'nexus@filament-nexus.local',
  passwordHash: PasswordHasher.hashPassword('password123'),
);