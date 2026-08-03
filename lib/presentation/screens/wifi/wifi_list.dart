import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 10),
              Text(
                l10n.deleteConfirmationTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(l10n.deleteRouterConfirmMessage(wifi.ssid.toString())),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancelButton,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final token = context.read<AuthProvider>().token;
                if (token == null) return;

                Navigator.pop(dialogContext); // পপআপ বন্ধ

                final success = await context.read<OfficeProvider>().deleteWifi(
                  token: token,
                  id: wifi.id,
                );

                if (success && context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: l10n.officeDeletedSuccess,
                    isSuccess: true,
                    icon: Icons.delete_sweep,
                  );
                } else if (context.mounted) {
                  CustomSnackBar.show(
                    context,
                    message: l10n.deleteFailed,
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
              child: Text(l10n.deleteButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);
    final l10n = AppLocalizations.of(context)!;

    final int? officeId = ModalRoute.of(context)?.settings.arguments as int?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          l10n.routerListTitle,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              Navigator.pushNamed(context, '/wifi-setup', arguments: officeId);
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

            List<dynamic> displayWifiList = provider.globalWifiList;

            // ২. খালি লিস্টের মেসেজ
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
                      l10n.noRouterSetupText,
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
                      label: Text(
                        l10n.setupNowButton,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            // ৩. ওয়াইফাই লিস্ট ভিউ
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
                      wifi.ssid.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        l10n.bssidLabel(wifi.bssid.toString()),
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
      bottomNavigationBar: const CustomAdBottomBar(),
    );
  }
}
