import 'package:flutter/material.dart';

class AdminDashboardT extends StatelessWidget {
  const AdminDashboardT({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // হালকা গ্রে ব্যাকগ্রাউন্ড
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        title: const Text(
          "AttenFI Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "আজকের উপস্থিতি",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // উপরের পরিসংখ্যান কার্ডসমূহ
            Row(
              children: [
                _buildStatCard("মোট কর্মচারী", "৫০", Icons.groups, Colors.blue),
                const SizedBox(width: 15),
                _buildStatCard(
                  "উপস্থিত",
                  "৪২",
                  Icons.check_circle,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildStatCard("অনুপস্থিত", "০৫", Icons.cancel, Colors.red),
                const SizedBox(width: 15),
                _buildStatCard(
                  "দেরি (Late)",
                  "০৩",
                  Icons.access_time,
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              "কুইক অ্যাকশন",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // কুইক মেনু গ্রিড
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                  context,
                  "নতুন কর্মচারী",
                  Icons.person_add,
                  Colors.indigo,
                ),
                _buildActionCard(
                  context,
                  "ওয়াইফাই সেটআপ",
                  Icons.wifi,
                  Colors.teal,
                ),
                _buildActionCard(
                  context,
                  "রিপোর্ট দেখুন",
                  Icons.bar_chart,
                  Colors.purple,
                ),
                _buildActionCard(
                  context,
                  "ছুটির আবেদন",
                  Icons.event_note,
                  Colors.brown,
                ),
              ],
            ),
          ],
        ),
      ),

      // নিচের নেভিগেশন বার
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "হোম"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "কর্মচারী"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "সেটিংস"),
        ],
      ),
    );
  }

  // পরিসংখ্যান কার্ড তৈরির ফাংশন
  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // কুইক অ্যাকশন কার্ড তৈরির ফাংশন
  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 35),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
