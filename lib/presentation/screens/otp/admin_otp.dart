import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/model/otp_model.dart';
import '../../../core/providers/admin_otp_provider.dart'; // সঠিক পাথ দিন

class AdminOtpDashboard extends StatelessWidget {
  const AdminOtpDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // স্ক্রিন বিল্ড হওয়ার পর প্রথমবার ডাটা নিয়ে আসার জন্য
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOtpProvider>().fetchOtpRequests();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          'Employee OTP Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // প্রোভাইডার ব্যবহার করে রিলোড
              context.read<AdminOtpProvider>().fetchOtpRequests();
            },
          ),
        ],
        backgroundColor: AppColors.primary,
        elevation: 2,
        centerTitle: true,
      ),
      body: Consumer<AdminOtpProvider>(
        builder: (context, provider, child) {
          // যখন ডাটা প্রথমবার লোড হচ্ছে
          if (provider.isLoading && provider.otpRequests.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }

          // যদি কোনো নেটওয়ার্ক বা সার্ভার এরর থাকে
          if (provider.errorMessage != null && provider.otpRequests.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.fetchOtpRequests(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final otpRequests = provider.otpRequests;

          // ডাটা লিস্ট রেন্ডার এবং Pull-to-Refresh মেকানিজম
          return RefreshIndicator(
            onRefresh: () async {
              await provider.fetchOtpRequests();
            },
            color: Colors.indigo,
            backgroundColor: Colors.white,
            child: otpRequests.isEmpty
                ? ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(), // খালি থাকলেও স্ক্রল ইভেন্ট যেন কাজ করে
                    children: const [
                      SizedBox(height: 150),
                      Center(
                        child: Text(
                          'No pending OTP requests.\nPull down to refresh.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    itemCount: otpRequests.length,
                    itemBuilder: (context, index) {
                      final request = otpRequests[index];
                      return _buildOtpCard(context, request);
                    },
                  ),
          );
        },
      ),
    );
  }

  // কার্ড ডিজাইন পার্ট
  Widget _buildOtpCard(BuildContext context, OtpRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ১. এমপ্লয়ীর ছবি
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.indigo.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                child: Image.network(
                  request.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // ২. নাম ও আইডি
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.employeeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${request.employeeId}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        request.time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ৩. ওটিপি কোড (হাইলাইটেড)
            Column(
              children: [
                const Text(
                  'OTP CODE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: request.otpCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('OTP ${request.otpCode} copied!'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.amber.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      request.otpCode,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD35400),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to copy',
                  style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
