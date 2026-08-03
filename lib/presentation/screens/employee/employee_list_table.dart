import 'package:atten_fi/core/constants/app_colors.dart';
import 'package:atten_fi/core/model/employee_model.dart';
import 'package:atten_fi/core/providers/auth_provider.dart';
import 'package:atten_fi/core/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../l10n/app_localizations.dart';
import '../../widgets/custom_ad_bottom_bar.dart';
import '../../widgets/custom_snackbar.dart';

class EmployeeListTable extends StatelessWidget {
  EmployeeListTable({super.key});

  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final TextEditingController _searchController = TextEditingController();

  void _showDeleteDialog({
    required BuildContext context,
    required int employeeId,
    required String employeeName,
    required String userToken,
  }) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                l10n.confirmTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(l10n.deleteEmployeeConfirmation(employeeName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // ডায়ালগ বন্ধ করা

                // প্রোগ্রেস লোডিং দেখানো
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                // এপিআই রিকোয়েস্ট ট্রিগার
                final result = await context
                    .read<EmployeeProvider>()
                    .deleteEmployee(id: employeeId, userToken: userToken);

                if (context.mounted) Navigator.pop(context); // লোডিং বন্ধ করা

                if (result == true) {
                  if (context.mounted) {
                    CustomSnackBar.show(
                      context,
                      message: l10n.deletedSuccessfully,
                      isSuccess: true,
                      icon: Icons.delete_outline,
                    );
                  }
                } else {
                  if (context.mounted) {
                    CustomSnackBar.show(
                      context,
                      message: l10n.tryAgain,
                      isSuccess: false,
                      icon: Icons.error_outline,
                    );
                  }
                }
              },
              child: Text(
                l10n.delete,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String? userToken = context.read<AuthProvider>().token;

    if (userToken != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<EmployeeProvider>().fetchEmployees(userToken);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          l10n.allEmployeesList,
          style: const TextStyle(color: AppColors.background),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.background),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.employeeList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.employeeList.isEmpty) {
            return Center(child: Text(l10n.noEmployeeDataFound));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // সার্চ বার
                TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      _searchNotifier.value = value.trim().toLowerCase(),
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    suffixIcon: ValueListenableBuilder<String>(
                      valueListenable: _searchNotifier,
                      builder: (context, text, child) {
                        return text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchNotifier.value = '';
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // লাইভ সার্চ ফিল্টারিং টেবিল
                ValueListenableBuilder<String>(
                  valueListenable: _searchNotifier,
                  builder: (context, searchQuery, child) {
                    final filteredList = provider.employeeList.where((
                      employee,
                    ) {
                      final name = employee.name.toLowerCase();
                      final empId = (employee.employeeId ?? '').toLowerCase();
                      return name.contains(searchQuery) ||
                          empId.contains(searchQuery);
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(l10n.notFound),
                      );
                    }

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: DataTable(
                        columnSpacing: 10,
                        dataRowMinHeight: 60,
                        dataRowMaxHeight: 65,
                        headingRowColor: WidgetStateProperty.all(
                          const Color(0xFFF8F9FA),
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              l10n.image,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              l10n.details,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              l10n.action,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: filteredList.map((employee) {
                          return _buildEmployeeRow(
                            context: context,
                            employee: employee,
                            userToken: userToken ?? '',
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-employee'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text(
          l10n.addEmployee,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: CustomAdBottomBar(),
    );
  }

  DataRow _buildEmployeeRow({
    required BuildContext context,
    required EmployeeModel employee,
    required String userToken,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return DataRow(
      cells: [
        // ১. ছবি কলাম
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage:
                  employee.imageUrl != null && employee.imageUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(
                      employee.imageUrl!,
                      headers: {
                        'ngrok-skip-browser-warning': 'true',
                        'Authorization': 'Bearer $userToken',
                      },
                    )
                  : null,
              child: employee.imageUrl == null || employee.imageUrl!.isEmpty
                  ? const Icon(Icons.person, size: 22, color: AppColors.primary)
                  : null,
            ),
          ),
        ),

        // ২. নাম এবং আইডি বিবরণ কলাম
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                employee.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                employee.employeeId != null && employee.employeeId!.isNotEmpty
                    ? employee.employeeId!
                    : l10n.noId,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // ৩. অ্যাকশন কলাম
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: const Icon(
                  Icons.visibility_outlined,
                  color: Colors.blue,
                  size: 18,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/employee-details',
                    arguments: employee,
                  );
                },
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed: () {
                  if (employee.id != null) {
                    _showDeleteDialog(
                      context: context,
                      employeeId: employee.id!,
                      employeeName: employee.name,
                      userToken: userToken,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
