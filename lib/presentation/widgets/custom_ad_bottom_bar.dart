import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomAdBottomBar extends StatelessWidget {
  final String? customAdImageUrl;
  final VoidCallback? onCustomAdTap;
  final dynamic admobBannerAd;

  const CustomAdBottomBar({
    super.key,
    this.customAdImageUrl,
    this.onCustomAdTap,
    this.admobBannerAd,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[50],
      elevation: 4,
      padding: EdgeInsets.zero,
      child: Container(
        height: 60,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        ),
        child: _buildAdContent(context),
      ),
    );
  }

  // 🛠️ অ্যাড ফিল্টার করার লজিক
  Widget _buildAdContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (customAdImageUrl != null && customAdImageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: onCustomAdTap,
        child: Stack(
          children: [
            Image.network(
              customAdImageUrl!,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text(l10n.cab_ad_load_error));
              },
            ),

            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.cab_ad_badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (admobBannerAd != null) {
      // return AdWidget(ad: admobBannerAd); // 👈 এডমোব প্লাগইন থাকলে এটি একটিভেট করবেন
      return Center(
        child: Text(l10n.cab_admob_placeholder),
      ); // সাময়িক দেখার জন্য
    } else {
      return Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // এটি পুরো কলামটিকে স্ক্রিনের মাঝখানে রাখবে
          children: [
            Text(
              l10n.cab_contact_for_ads,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4), // দুটি টেক্সটের মাঝখানের দূরত্ব
            Text(
              l10n.cab_ad_email,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }
  }
}
