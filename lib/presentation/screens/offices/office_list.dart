import 'package:atten_fi/presentation/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atten_fi/core/providers/office_provider.dart';
import 'package:atten_fi/presentation/widgets/input_field.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/model/office_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/custom_snackbar.dart';

class OfficeListScreen extends StatelessWidget {
  const OfficeListScreen({super.key});

  // ডাটা রিফ্রেশ করা
  Future<void> _unassignWifiFromOffice(
    BuildContext context,
    int wifiId,
    int officeId,
  ) async {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      await context.read<OfficeProvider>().unassignWifiFromOffice(
        token: token,
        wifiId: wifiId,
        officeId: officeId,
      );

      if (!context.mounted) return;
      CustomSnackBar.show(
        context,
        icon: Icons.check,
        message: "রাউটারটি সফলভাবে রিমুভ করা হয়েছে",
        isSuccess: true,
      );
    }
  }

  Future<void> _refreshOffices(BuildContext context) async {
    final String? token = context.read<AuthProvider>().token;
    if (token != null) {
      await context.read<OfficeProvider>().fetchOfficesList(token: token);
    }
  }

  void _showEditOfficeModal(BuildContext context, OfficeModel office) {
    const Color primaryColor = Color(0xFF1A237E);
    final formKey = GlobalKey<FormState>();

    final TextEditingController officeDBID = TextEditingController(
      text: office.id.toString(),
    );
    final TextEditingController nameController = TextEditingController(
      text: office.name,
    );

    final TextEditingController addressController = TextEditingController(
      text: office.address,
    );
    final TextEditingController startTimeController = TextEditingController(
      text: office.startTime,
    );

    final TextEditingController graceTimeController = TextEditingController(
      text: office.graceTime,
    );
    final TextEditingController endTimeController = TextEditingController(
      text: office.endTime,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ), // কিবোর্ডের জন্য স্পেস
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "অফিস তথ্য সংশোধন",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: "অফিসের নাম",
                      controller: nameController,
                      icon: Icons.business,
                      hint: "উদা: প্রধান কার্যালয়",
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "নাম আবশ্যক"
                          : null,
                    ),

                    const SizedBox(height: 15),
                    InputField(
                      label: "অফিসের ঠিকানা",
                      controller: addressController,
                      icon: Icons.location_on,
                      hint: "উদা: আগ্রাবাদ, চট্টগ্রাম",
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "ঠিকানা আবশ্যক"
                          : null,
                    ),
                    const SizedBox(height: 25),
                    InputField(
                      label: "অফিসের শুরুর সময়",
                      controller: startTimeController,
                      icon: Icons.access_time_filled_rounded,
                      hint: "উদা: 09:00:00",
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "অফিসের শুরুর সময় আবশ্যক"
                          : null,
                    ),
                    const SizedBox(height: 25),
                    InputField(
                      label: "লেট ট্র্যাকিং কত মিনিট ?",
                      controller: graceTimeController,
                      icon: Icons.running_with_errors_rounded,
                      hint: "উদা: 09:15:00",
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "লেট ট্র্যাকিং সময় আবশ্যক"
                          : null,
                    ),
                    const SizedBox(height: 25),
                    InputField(
                      label: "অফিসের ছুটির সময়",
                      controller: endTimeController,
                      icon: Icons.access_time_filled_rounded,
                      hint: "17:00:00",
                      validator: (val) => val == null || val.trim().isEmpty
                          ? "অফিসের ছুটির সময় আবশ্যক"
                          : null,
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: PrimaryButton(
                        label: "তথ্য আপডেট করুন",
                        icon: Icons.update,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;

                          final token = context.read<AuthProvider>().token;
                          if (token == null) return;
                          final updatedOffice = OfficeModel(
                            id: int.parse(officeDBID.text.trim()),
                            name: nameController.text,
                            address: addressController.text,
                            startTime: startTimeController.text.trim(),
                            graceTime: graceTimeController.text.trim(),
                            endTime: endTimeController.text.trim(),
                          );

                          final success = await context
                              .read<OfficeProvider>()
                              .updateOffice(
                                token: token,
                                office: updatedOffice,
                              );

                          if (context.mounted) {
                            Navigator.pop(context);
                          }

                          if (success && context.mounted) {
                            CustomSnackBar.show(
                              context,
                              message: "অফিস সফলভাবে আপডেট হয়েছে!",
                              isSuccess: true,
                            );
                          } else if (context.mounted) {
                            CustomSnackBar.show(
                              context,
                              message: "আপডেট করতে সমস্যা হয়েছে",
                              isSuccess: false,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, OfficeModel office) {
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
          content: Text(
            "'${office.name}' অফিসটি ডিলিট করতে চান? এর সাথে যুক্ত সকল ওয়াইফাই ডাটাও মুছে যেতে পারে।",
          ),
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

                final success = await context
                    .read<OfficeProvider>()
                    .deleteOffice(token: token, id: office.id);

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

  void _showAssignWifiListModal(BuildContext context, OfficeModel office) {
    const Color primaryColor = Color(0xFF1A237E);
    final String? token = context.read<AuthProvider>().token;

    if (token != null) {
      context.read<OfficeProvider>().assignedWifis(
        token: token,
        officeId: office.id,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${office.name} - সেটকৃত রাউটার",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: primaryColor),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/wifi-setup',
                          arguments: office.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Consumer<OfficeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final wifiList = provider.assignedWifisList;

                    if (wifiList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "এই অফিসের জন্য কোনো রাউটার সেটআপ করা নেই!",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    '/wifi-setup',
                                    arguments: office.id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: primaryColor,
                                ),
                                label: const Text(
                                  "নতুন ওয়াইফাই যুক্ত করুন",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: wifiList.length,
                      itemBuilder: (context, index) {
                        final wifi = wifiList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            onTap: () {
                              _unassignWifiFromOffice(
                                context,
                                wifi.id,
                                office.id,
                              );
                            },
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8EAF6),
                              child: Icon(
                                Icons.router_rounded,
                                color: primaryColor,
                              ),
                            ),
                            title: Text(
                              wifi.ssid,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              "BSSID: ${wifi.bssid}",
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                            trailing: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWifiListModal(BuildContext context, OfficeModel office) {
    const Color primaryColor = Color(0xFF1A237E);
    final String? token = context.read<AuthProvider>().token;

    if (token != null) {
      context.read<OfficeProvider>().unassignedWifis(token: token);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${office.name} -তে রাউটার সেট করুন",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: primaryColor),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/wifi-setup',
                          arguments: office.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Consumer<OfficeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final wifiList = provider.unassignedWifisList;

                    if (wifiList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "এই অফিসের জন্য কোনো রাউটার সেটআপ করা নেই!",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    '/wifi-setup',
                                    arguments: office.id,
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: primaryColor,
                                ),
                                label: const Text(
                                  "নতুন ওয়াইফাই যুক্ত করুন",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: wifiList.length,
                      itemBuilder: (context, index) {
                        final wifi = wifiList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            onTap: () {
                              _setRouter(context, wifi.id, office.id);
                            },
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8EAF6),
                              child: Icon(
                                Icons.router_rounded,
                                color: primaryColor,
                              ),
                            ),
                            title: Text(
                              wifi.ssid,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              "BSSID: ${wifi.bssid}",
                              style: const TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                              ),
                            ),
                            trailing: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1A237E);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshOffices(context);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "অফিস সমূহের তালিকা",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/office-add');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshOffices(context),
        child: Consumer<OfficeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.officesList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final offices = provider.officesList;

            if (offices.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 70,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "কোনো অফিস যুক্ত করা হয়নি!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: offices.length,
              itemBuilder: (context, index) {
                final office = offices[index];

                return Card(
                  color: AppColors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.maps_home_work,
                                    color: primaryColor,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      office.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditOfficeModal(context, office);
                                } else if (value == 'delete') {
                                  _showDeleteConfirmation(context, office);
                                } else if (value == 'setR') {
                                  _showWifiListModal(context, office);
                                } else if (value == 'getR') {
                                  _showAssignWifiListModal(context, office);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('সংশোধন '),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('মুছে ফেলুন'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'setR',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.router,
                                        color: AppColors.accent,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('রাউটার সেট করুন'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'getR',
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.router_sharp,
                                        color: AppColors.secondary,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('রাউটার লিস্ট '),
                                    ],
                                  ),
                                ),
                              ],
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 15),

                        // 📍 ঠিকানা রো
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                office.address ?? "ঠিকানা দেওয়া হয়নি",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[50], // হালকা গ্রে ব্যাকগ্রাউন্ড
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[100]!),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // অফিস শুরুর সময়
                              _buildTimeColumn(
                                icon: Icons.access_time_filled_rounded,
                                iconColor: Colors.green,
                                label: "শুরু",
                                time:
                                    office.startTime ??
                                    "09:00:00", // ডাটাবেজ থেকে আসা ভ্যালু
                              ),

                              // গ্রেস পিরিয়ড বা লেট কাউন্ট
                              _buildTimeColumn(
                                icon: Icons.running_with_errors_rounded,
                                iconColor: Colors.orange,
                                label: "লেট ট্র্যাকিং",
                                time: office.graceTime ?? "09:15:00",
                              ),

                              // অফিস শেষের সময়
                              _buildTimeColumn(
                                icon: Icons.logout_rounded,
                                iconColor: Colors.red,
                                label: "ছুটি",
                                time: office.endTime ?? "17:00:00",
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _setRouter(BuildContext context, int wID, int offId) async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    final success = await context.read<OfficeProvider>().assignWifiToOffice(
      token: token,
      wifiId: wID,
      officeId: offId,
    );

    if (success && context.mounted) {
      CustomSnackBar.show(
        context,
        message: "অফিসে রাউটারটি সফলভাবে সেট করা হয়েছে!",
        isSuccess: true,
      );
    } else if (context.mounted) {
      CustomSnackBar.show(
        context,
        message: "রাউটার সেট করতে সমস্যা হয়েছে",
        isSuccess: false,
      );
    }
  }

  Widget _buildTimeColumn({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String time,
  }) {
    String formattedTime = time.length > 5 ? time.substring(0, 5) : time;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          formattedTime,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
