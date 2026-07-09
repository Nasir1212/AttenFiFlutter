import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/holiday_provider.dart';

class HolidayUploadCalendarScreen extends StatelessWidget {
  HolidayUploadCalendarScreen({super.key});

  final ValueNotifier<DateTime> _focusedDayNotifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );
  final ValueNotifier<DateTime?> _rangeStartNotifier = ValueNotifier<DateTime?>(
    null,
  );
  final ValueNotifier<DateTime?> _rangeEndNotifier = ValueNotifier<DateTime?>(
    null,
  );
  final TextEditingController _holidayTitleController = TextEditingController();

  // 🔔 ছুটির নাম ইনপুট নেওয়ার পপ-আপ ডায়ালগ
  void _showAddHolidayDialog(
    BuildContext context,
    DateTime start,
    DateTime end,
    HolidayProvider provider,
  ) {
    _holidayTitleController.clear();

    // ১ দিন নাকি একাধিক দিন তা চেক করা
    final isSingleDay =
        start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    final dateSelectionText = isSingleDay
        ? 'তারিখ: ${DateFormat('dd MMMM, yyyy').format(start)}'
        : 'মেয়াদ: ${DateFormat('dd MMMM').format(start)} থেকে ${DateFormat('dd MMMM, yyyy').format(end)}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isSingleDay
                  ? Icons.calendar_today_rounded
                  : Icons.date_range_rounded,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              isSingleDay ? '১ দিনের ছুটি যোগ করুন' : 'টানা ছুটি যোগ করুন',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateSelectionText,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _holidayTitleController,
              decoration: InputDecoration(
                hintText: 'উদা: ঈদের ছুটি, স্বাধীনতা দিবস',
                labelText: 'ছুটি বা উৎসবের নাম',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _rangeStartNotifier.value = null;
              _rangeEndNotifier.value = null;
              Navigator.pop(context);
            },
            child: const Text('বাতিল', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final title = _holidayTitleController.text.trim();

              if (title.isNotEmpty) {
                Navigator.pop(context);

                bool success = await provider.uploadHolidayRangeToApi(
                  title,
                  start,
                  end,
                );

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"$title" সফলভাবে যুক্ত হয়েছে! 🎉'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }

                _rangeStartNotifier.value = null;
                _rangeEndNotifier.value = null;
              }
            },
            child: const Text('সংরক্ষণ করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final holidayProvider = Provider.of<HolidayProvider>(context);
    final Map<String, String> uploadedHolidays = holidayProvider.holidayMap;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ছুটির দিন আপলোড স্ক্রিন',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: holidayProvider.isLoading && uploadedHolidays.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  _focusedDayNotifier,
                  _rangeStartNotifier,
                  _rangeEndNotifier,
                ]),
                builder: (context, child) {
                  return Column(
                    children: [
                      // ℹ️ সহজ গাইডলাইন ব্যানার
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: primaryColor.withOpacity(0.06),
                        child: const Column(
                          children: [
                            Text(
                              '👉 ১ দিনের ছুটি: যেকোনো একটি তারিখ সিলেক্ট করে নিচের বাটনে চাপুন।',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '👉 একাধিক দিনের ছুটি: প্রথম ও শেষ তারিখ সিলেক্ট করে নিচের বাটনে চাপুন।',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 📅 ক্যালেন্ডার কার্ড
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TableCalendar(
                            firstDay: DateTime(2020),
                            lastDay: DateTime(2030),
                            focusedDay: _focusedDayNotifier.value,
                            calendarFormat: CalendarFormat.month,

                            rangeStartDay: _rangeStartNotifier.value,
                            rangeEndDay: _rangeEndNotifier.value,
                            rangeSelectionMode: RangeSelectionMode.enforced,

                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              titleTextStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            calendarStyle: CalendarStyle(
                              rangeHighlightColor: primaryColor.withOpacity(
                                0.12,
                              ),
                              rangeStartDecoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              rangeEndDecoration: BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              outsideDaysVisible: false,
                            ),

                            eventLoader: (day) {
                              final dateStr = DateFormat(
                                'yyyy-MM-dd',
                              ).format(day);
                              if (uploadedHolidays.containsKey(dateStr)) {
                                return [uploadedHolidays[dateStr]];
                              }
                              return [];
                            },

                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                if (events.isNotEmpty) {
                                  return Positioned(
                                    bottom: 2,
                                    child: Container(
                                      width: 45,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        events.first.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),

                            // 👆 সিলেকশন লজিক (শুধুমাত্র সিলেক্ট করে রাখবে, পপ-আপ অটোমেটিক আসবে না)
                            onRangeSelected: (start, end, focusedDayTarget) {
                              _focusedDayNotifier.value = focusedDayTarget;
                              _rangeStartNotifier.value = start;
                              _rangeEndNotifier.value = end;
                            },

                            onPageChanged: (focusedDayTarget) {
                              _focusedDayNotifier.value = focusedDayTarget;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

      // 🚀 আকর্ষনীয় Floating Action Button (নিচে যুক্ত করা হয়েছে)
      bottomNavigationBar: AnimatedBuilder(
        animation: Listenable.merge([_rangeStartNotifier, _rangeEndNotifier]),
        builder: (context, child) {
          // যখন কোনো দিন সিলেক্ট করা থাকবে তখনই শুধু বাটনটি সক্রিয় বা দৃশ্যমান হবে
          final hasSelection = _rangeStartNotifier.value != null;

          return Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 24.0,
              top: 8.0,
            ),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasSelection
                      ? primaryColor
                      : Colors.grey.shade300,
                  foregroundColor: hasSelection
                      ? Colors.white
                      : Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: hasSelection ? 4 : 0,
                ),
                onPressed: hasSelection
                    ? () {
                        final start = _rangeStartNotifier.value!;
                        // যদি এন্ড ডেট নাল থাকে তার মানে ১ দিনের ছুটি সিলেক্ট করেছে (start-ই এন্ড ডেট)
                        final end = _rangeEndNotifier.value ?? start;

                        _showAddHolidayDialog(
                          context,
                          start,
                          end,
                          holidayProvider,
                        );
                      }
                    : null, // সিলেক্ট না থাকলে বাটন ডিজেবল থাকবে
                icon: const Icon(Icons.add_circle_outline_rounded),
                label: Text(
                  _rangeEndNotifier.value == null
                      ? 'ছুটি যোগ করুন'
                      : 'টানা ছুটি যোগ করুন',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
