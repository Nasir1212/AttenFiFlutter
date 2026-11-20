import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // নমুনা তথ্য (পরে API থেকে আসবে)
  static const List<Map<String, dynamic>> _items = [
    {
      'title': 'হাজিরা সফল হয়েছে',
      'body': 'আজ সকাল ৯:০২ মিনিটে আপনার হাজিরা নেওয়া হয়েছে।',
      'time': '২ মিনিট আগে',
      'icon': Icons.check_circle_outline,
      'color': Colors.green,
      'unread': true,
    },
    {
      'title': 'নতুন OTP অনুরোধ',
      'body': 'একজন কর্মী লগইনের জন্য OTP চেয়েছেন।',
      'time': '১ ঘণ্টা আগে',
      'icon': Icons.pin_outlined,
      'color': Colors.indigo,
      'unread': true,
    },
    {
      'title': 'ছুটির ঘোষণা',
      'body': 'আগামী শুক্রবার অফিস বন্ধ থাকবে।',
      'time': 'গতকাল',
      'icon': Icons.calendar_month_outlined,
      'color': Colors.orange,
      'unread': false,
    },
    {
      'title': 'দেরিতে উপস্থিতি',
      'body': 'আজ ৩ জন কর্মী নির্ধারিত সময়ের পরে হাজিরা দিয়েছেন।',
      'time': '২ দিন আগে',
      'icon': Icons.access_time_rounded,
      'color': Colors.redAccent,
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('নোটিফিকেশন'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'কোনো নোটিফিকেশন নেই',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = _items[index];
                final Color color = item['color'] as Color;
                final bool unread = item['unread'] as bool;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: unread ? color.withOpacity(0.06) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: unread
                          ? color.withOpacity(0.3)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: unread
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (unread)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['body'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item['time'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
