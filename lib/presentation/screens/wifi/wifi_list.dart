import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/custom_snackbar.dart';

class WifiListScreen extends StatelessWidget {
  const WifiListScreen({super.key});

  Future<void> _refreshData(BuildContext context) async {
    final String? token = context.read<AuthProvider>().token;
    if (token != null) {
      await context.read<OfficeProvider>().fetchGlobalWifiList(token: token);
    }
  }

  void _showDeleteConfirmation(BuildContext context, dynamic wifi) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 10),
              Text("নিশ্চিতকরণ", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text("'${wifi.ssid}' রাউটারটি ডিলিট করতে চাচ্ছেন?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "না, থাক",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final token = context.read<AuthProvider>().token;
                if (token == null) return;

                Navigator.pop(context); // পপআপ বন্ধ

                final success = await context.read<OfficeProvider>().deleteWifi(
                  token: token,
                  id: wifi.id,
                );

                if (success && context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: "অফিসটি সফলভাবে মুছে ফেলা হয়েছে",
                    isSuccess: true,
                    icon: Icons.delete_sweep,
                  );
                } else if (context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: "মুছে ফেলতে সমস্যা হয়েছে",
                    isSuccess: false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("হ্যাঁ, ডিলিট করুন"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);

    final int? officeId = ModalRoute.of(context)?.settings.arguments as int?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "রাউটারের তালিকা",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/wifi-setup',
                arguments:
                    officeId, // অফিস আইডি (থাকলে পাস হবে, না থাকলে null যাবে)
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: Consumer<OfficeProvider>(
          builder: (context, provider, child) {
            // ১. লোডিং স্টেট চেক
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            List<dynamic> displayWifiList = [];
            displayWifiList = provider.globalWifiList;
            if (displayWifiList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 70,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "রাউটার সেটআপ করা নেই!",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/wifi-setup',
                          arguments: officeId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "এখনই সেটআপ করুন",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            // ৩. ওয়াইফাই লিস্ট ভিউ
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: displayWifiList.length,
              itemBuilder: (context, index) {
                final wifi = displayWifiList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8EAF6),
                      child: Icon(Icons.router_rounded, color: primaryColor),
                    ),
                    title: Text(
                      wifi.ssid, // ওয়াইফাই নাম
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "BSSID: ${wifi.bssid}", // রাউটার ম্যাক এড্রেস
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () => _showDeleteConfirmation(context, wifi),
                      icon: const Icon(Icons.delete, color: AppColors.error),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }
}
