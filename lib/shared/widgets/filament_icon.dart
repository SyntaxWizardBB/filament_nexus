import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget filamentIcon({
  Color? color,
  bool active = false,
  double size = 24,
}) {
  final resolved =
      color ?? (active ? AppColors.primary : AppColors.secondary);
  return SvgPicture.asset(
    'assets/icons/filament.svg',
    width: size,
    height: size,
    colorFilter: ColorFilter.mode(resolved, BlendMode.srcIn),
  );
}
