import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';

class Settingsholly extends StatelessWidget {
  const Settingsholly({super.key});

  // 📅 ডার্ট ক্যালেন্ডার বার (৫ = শুক্রবার, ৬ = শনিবার)
  final Map<String, String> _weekdays = const {
    "5": "শুক্রবার",
    "6": "শনিবার",
    "7": "রবিবার",
    "1": "সোমবার",
    "2": "মঙ্গলবার",
    "3": "বুধবার",
    "4": "বৃহস্পতিবার",
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
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    // 🔄 প্রোভাইডার লিসেনার চালু করা
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' সেটিংস',
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
                  const Expanded(
                    child: Text(
                      ' এখান থেকে কনফিগার করুন।',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 📅 সেকশন ১: সাপ্তাহিক ছুটি (FilterChips)
            _buildSectionTitle(
              Icons.calendar_month_rounded,
              "সাপ্তাহিক ছুটি সিলেক্ট করুন",
              primaryColor,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _weekdays.entries.map((entry) {
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

            // 🕒 সেকশন ২: অফিসের সময়সূচী
            // _buildSectionTitle(
            //   Icons.access_time_filled_rounded,
            //   "অফিসের সময়সূচী ও নিয়ম",
            //   primaryColor,
            // ),
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     // অফিস ইন-টাইম বক্স
            //     Expanded(
            //       child: InkWell(
            //         onTap: () => _selectTime(context, settingsProvider, true),
            //         child: Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             border: Border.all(color: Colors.grey.shade300),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 'অফিস শুরু (In Time)',
            //                 style: TextStyle(fontSize: 12, color: Colors.grey),
            //               ),
            //               const SizedBox(height: 4),
            //               Text(
            //                 settingsProvider.inTime,
            //                 style: const TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     // অফিস আউট-টাইম বক্স
            //     Expanded(
            //       child: InkWell(
            //         onTap: () => _selectTime(context, settingsProvider, false),
            //         child: Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             border: Border.all(color: Colors.grey.shade300),
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               const Text(
            //                 'অফিস শেষ (Out Time)',
            //                 style: TextStyle(fontSize: 12, color: Colors.grey),
            //               ),
            //               const SizedBox(height: 4),
            //               Text(
            //                 settingsProvider.outTime,
            //                 style: const TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 12),

            // // গ্রেস পিরিয়ড ফিল্ড
            // TextFormField(
            //   initialValue: settingsProvider.gracePeriod.toString(),
            //   keyboardType: TextInputType.number,
            //   onChanged: (val) =>
            //       settingsProvider.gracePeriod = int.tryParse(val) ?? 0,
            //   decoration: InputDecoration(
            //     labelText: 'গ্রেস পিরিয়ড (মিনিট)',
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     prefixIcon: const Icon(Icons.timer_outlined),
            //   ),
            // ),
            // const SizedBox(height: 24),

            // // 📍 সেকশন ৩: হাজিরার সিকিউরিটি পলিসি
            // _buildSectionTitle(
            //   Icons.shield_rounded,
            //   "হাজিরা সিকিউরিটি পলিসি",
            //   primaryColor,
            // ),
            // const SizedBox(height: 12),

            // _buildRadioCard(
            //   value: "anywhere",
            //   title: "যেকোনো স্থান থেকে (Remote/Open)",
            //   subtitle:
            //       "कर्मীরা মাঠ পর্যায়ে বা যেকোনো জায়গা থেকে হাজিরা দিতে পারবে।",
            //   primaryColor: primaryColor,
            //   currentGroupValue: settingsProvider.attendanceMode,
            //   onChanged: (val) => settingsProvider.updateAttendanceMode(val!),
            // ),
            // const SizedBox(height: 10),

            // _buildRadioCard(
            //   value: "geofencing",
            //   title: "অফিস লোকেশন ট্র্যাকিং (Geofencing)",
            //   subtitle:
            //       "কর্মী অফিসে উপস্থিত থাকলেই কেবল মোবাইল অ্যাপ থেকে হাজিরা দিতে পারবে।",
            //   primaryColor: primaryColor,
            //   currentGroupValue: settingsProvider.attendanceMode,
            //   onChanged: (val) => settingsProvider.updateAttendanceMode(val!),
            // ),

            // // জিপিএস রেডিয়াস (ডাইনামিকালি শো/হাইড হবে প্রোভাইডারের ডাটার ওপর ভিত্তি করে)
            // if (settingsProvider.attendanceMode == "geofencing") ...[
            //   const SizedBox(height: 12),
            //   Padding(
            //     padding: const EdgeInsets.only(left: 8.0),
            //     child: TextFormField(
            //       initialValue: settingsProvider.gpsRadius.toString(),
            //       keyboardType: TextInputType.number,
            //       onChanged: (val) =>
            //           settingsProvider.gpsRadius = int.tryParse(val) ?? 100,
            //       decoration: InputDecoration(
            //         labelText: 'অনুমোদিত ব্যাসার্ধ বা রেডিয়াস (মিটারে)',
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         prefixIcon: const Icon(Icons.radar_rounded),
            //       ),
            //     ),
            //   ),
            // ],
            // const SizedBox(height: 40),

            // // 🚀 সেটিংস সংরক্ষণ বাটন
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
                      const SnackBar(
                        content: Text('সেটিংস সফলভাবে ব্যাকএন্ডে সেভ হয়েছে!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'সেটিংস সংরক্ষণ করুন',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildRadioCard({
    required String value,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required String currentGroupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = currentGroupValue == value;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? primaryColor.withOpacity(0.02)
              : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Radio<String>(
              value: value,
              groupValue: currentGroupValue,
              activeColor: primaryColor,
              onChanged: onChanged,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
