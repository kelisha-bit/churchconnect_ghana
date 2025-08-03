import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class AlphabeticalIndexWidget extends StatelessWidget {
  final ValueChanged<String> onLetterTap;
  final String? selectedLetter;

  const AlphabeticalIndexWidget({
    super.key,
    required this.onLetterTap,
    this.selectedLetter,
  });

  static const List<String> _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 8.w,
      margin: EdgeInsets.only(right: 1.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _alphabet.map((letter) {
          final isSelected = selectedLetter == letter;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onLetterTap(letter);
            },
            child: Container(
              width: 6.w,
              height: 3.h,
              margin: EdgeInsets.symmetric(vertical: 0.2.h),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  letter,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
