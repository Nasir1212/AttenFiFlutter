import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 👈 অ্যাডমোব ব্যবহার করলে এটি আনকমেন্ট করবেন

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
        child: _buildAdContent(),
      ),
    );
  }

  // 🛠️ অ্যাড ফিল্টার করার লজিক
  Widget _buildAdContent() {
    if (customAdImageUrl != null && customAdImageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: onCustomAdTap,
        child: Stack(
          children: [
            // মূল বিজ্ঞাপন ইমেজ
            Image.network(
              customAdImageUrl!,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text("বিজ্ঞাপন লোড হতে সমস্যা হয়েছে"),
                );
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
                child: const Text(
                  "Ad",
                  style: TextStyle(
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
      return const Center(
        child: Text("এখানে গুগল এডমোব শো করবে"),
      ); // সাময়িক দেখার জন্য
    } else {
      // return const Center(
      //   child: Text(
      //     "বিজ্ঞাপনের জন্য যোগাযোগ করুন",
      //     style: TextStyle(
      //       color: Colors.grey,
      //       fontSize: 12,
      //       fontStyle: FontStyle.italic,
      //     ),

      //   ),
      // );

      return const Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // এটি পুরো কলামটিকে স্ক্রিনের মাঝখানে রাখবে
          children: [
            Text(
              "বিজ্ঞাপনের জন্য যোগাযোগ করুন",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14, // সাইজ আপনার পছন্দমতো পরিবর্তন করতে পারেন
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4), // দুটি টেক্সটের মাঝখানের দূরত্ব
            Text(
              "adds@AttenFi.live",
              style: TextStyle(
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
