import 'package:flutter/material.dart';

class DobPicker extends StatelessWidget {
  /// তারিখ সম্পূর্ণ হলে "YYYY-MM-DD" দেয়, অসম্পূর্ণ বা ভুল হলে null
  final ValueChanged<String?> onChanged;

  final ValueNotifier<int?> _day;
  final ValueNotifier<int?> _month;
  final ValueNotifier<int?> _year;

  final List<int> _years = List.generate(100, (i) => DateTime.now().year - i);

  /// initialValue: আগের তারিখ দেখাতে (ফরম্যাট "YYYY-MM-DD")
  DobPicker({super.key, required this.onChanged, String? initialValue})
    : _year = ValueNotifier(_part(initialValue, 0)),
      _month = ValueNotifier(_part(initialValue, 1)),
      _day = ValueNotifier(_part(initialValue, 2));

  static int? _part(String? value, int index) {
    final p = value?.split('-');
    if (p == null || p.length != 3) return null;
    return int.tryParse(p[index]);
  }

  void _notify() {
    final d = _day.value;
    final m = _month.value;
    final y = _year.value;

    if (d == null || m == null || y == null) {
      onChanged(null);
      return;
    }
    // ৩১ ফেব্রুয়ারির মতো ভুল তারিখ ধরা
    if (DateTime(y, m, d).day != d) {
      onChanged(null);
      return;
    }
    onChanged(
      '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}',
    );
  }

  Widget _dropdown({
    required String label,
    required ValueNotifier<int?> notifier,
    required List<int> items,
  }) {
    return ValueListenableBuilder<int?>(
      valueListenable: notifier,
      builder: (context, value, _) => InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: value,
            isExpanded: true,
            isDense: true,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                .toList(),
            onChanged: (v) {
              notifier.value = v;
              _notify();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _dropdown(
            label: 'তারিখ',
            notifier: _day,
            items: List.generate(31, (i) => i + 1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dropdown(
            label: 'মাস',
            notifier: _month,
            items: List.generate(12, (i) => i + 1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: _dropdown(label: 'বছর', notifier: _year, items: _years),
        ),
      ],
    );
  }
}
