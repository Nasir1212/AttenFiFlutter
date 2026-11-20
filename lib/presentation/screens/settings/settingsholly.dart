import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../l10n/app_localizations.dart'; // আপনার l10n.yaml অনুযায়ী পাথ ঠিক করুন

class Settingsholly extends StatelessWidget {
  const Settingsholly({super.key});

  // 📅 ডার্ট ক্যালেন্ডার বার (৫ = শুক্রবার, ৬ = শনিবার)
  Map<String, String> _weekdays(AppLocalizations l10n) => {
    "5": l10n.seHWeekdayFriday,
    "6": l10n.seHWeekdaySaturday,
    "7": l10n.seHWeekdaySunday,
    "1": l10n.seHWeekdayMonday,
    "2": l10n.seHWeekdayTuesday,
    "3": l10n.seHWeekdayWednesday,
    "4": l10n.seHWeekdayThursday,
  };

  // টাইম পিকার দেখানোর ফাংশন
  Future<void> _selectTime(
    BuildContext context,
    SettingsProvider provider,
    bool isInTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isInTime
          ? TimeOfDay(
              hour: int.parse(provider.inTime.split(":")[0]),
              minute: int.parse(provider.inTime.split(":")[1]),
            )
          : TimeOfDay(
              hour: int.parse(provider.outTime.split(":")[0]),
              minute: int.parse(provider.outTime.split(":")[1]),
            ),
    );

    if (picked != null) {
      final formattedTime =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      provider.updateTimes(
        isInTime ? formattedTime : null,
        isInTime ? null : formattedTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    // 🔄 প্রোভাইডার লিসেনার চালু করা
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.seHTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: onPrimaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ℹ️ টপ ইনফো কার্ড
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.seHInfoText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 📅 সেকশন ১: সাপ্তাহিক ছুটি (FilterChips)
            _buildSectionTitle(
              Icons.calendar_month_rounded,
              l10n.seHWeeklyHolidaySection,
              primaryColor,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _weekdays(l10n).entries.map((entry) {
                final isSelected = settingsProvider.weekendDays.contains(
                  entry.key,
                );
                return FilterChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  selectedColor: primaryColor.withOpacity(0.2),
                  checkmarkColor: primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? primaryColor : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onSelected: (bool selected) {
                    // প্রোভাইডার কল করে স্টেট চেঞ্জ করা হচ্ছে
                    settingsProvider.toggleWeekend(entry.key);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 🚀 সেটিংস সংরক্ষণ বাটন
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  bool success = await settingsProvider.saveSettingsToApi();
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.seHSavedSuccess),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save_rounded),
                label: Text(
                  l10n.seHSaveButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
