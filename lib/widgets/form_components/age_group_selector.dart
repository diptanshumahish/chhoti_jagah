import 'package:flutter/material.dart';
import '../../config/app_text.dart';
import '../../models/user_model.dart';

class AgeGroupSelector extends StatelessWidget {
  final AgeGroup? selectedAgeGroup;
  final ValueChanged<AgeGroup> onAgeGroupSelected;
  final String label;
  final String validationError;

  const AgeGroupSelector({
    super.key,
    required this.selectedAgeGroup,
    required this.onAgeGroupSelected,
    required this.label,
    required this.validationError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppText.withColor(AppText.titleLarge, Colors.white.withValues(alpha: 0.9)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: AgeGroup.values.map((ageGroup) {
            final isSelected = selectedAgeGroup == ageGroup;
            return GestureDetector(
              onTap: () => onAgeGroupSelected(ageGroup),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                      ? Colors.white 
                      : Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Text(
                  UserModel.getAgeGroupDisplayName(ageGroup),
                  style: AppText.withColor(
                    isSelected ? AppText.withWeight(AppText.titleMedium, FontWeight.w600) : AppText.titleMedium,
                    isSelected ? Colors.black87 : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selectedAgeGroup == null) ...[
          const SizedBox(height: 8),
          Text(
            validationError,
            style: AppText.withColor(AppText.caption, Colors.red.withValues(alpha: 0.8)),
          ),
        ],
      ],
    );
  }
}
