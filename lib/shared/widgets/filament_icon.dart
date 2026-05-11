import 'package:filament_nexus/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget filamentIcon({required bool active}) {
  return SvgPicture.asset(
    'assets/icons/filament.svg',
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(
      active ? AppColors.primary : AppColors.secondary,
      BlendMode.srcIn,
    ),
  );
}