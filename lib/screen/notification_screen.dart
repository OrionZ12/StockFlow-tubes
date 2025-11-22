import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widget/bottom_nav_bar.dart';

class NotificationStaffPage extends StatefulWidget {
  const NotificationStaffPage({super.key});

  @override
  State<NotificationStaffPage> createState() => _NotificationStaffPageState();
}

class _NotificationStaffPageState extends State<NotificationStaffPage> {
  int _selectedIndex = 0; 

  final List<NotificationData> notifications = [
    NotificationData(
      title: '🎉 Xiaomi Mouse telah disetujui!',
      description: 'Barangmu telah disetujui manager.',
      date: 'Rab',
      status: 'approved',
    ),
    NotificationData(
      title: '❌ Keyboard Gaming telah ditolak',
      description: 'Yahh, barangmu ditolak.',
      date: 'Sel',
      status: 'rejected',
    ),
  ];

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/notification');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double titleSize = MediaQuery.of(context).size.width * 0.055;

    return Scaffold(
      backgroundColor: const Color(0xffe3efff),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Back button + StockFlow title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/home'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xff5a78c9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Stock",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const Text(
                    "Flow",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff5a78c9),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Notifikasi",
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return NotificationCard(notification: notifications[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationData notification;
  // ignore: use_key_in_widget_constructors
  const NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    Color statusColor = notification.status == 'approved'
        ? const Color(0xff0E7A44)
        : const Color(0xffD23737);
    IconData statusIcon = notification.status == 'approved'
        ? Icons.check_circle_outline
        : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffd3dbed), width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff474747),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                notification.date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff929292),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                notification.status == 'approved'
                    ? Icons.check_circle
                    : Icons.cancel,
                color: statusColor,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationData {
  final String title;
  final String description;
  final String date;
  final String status; // 'approved' or 'rejected'

  NotificationData({
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });
}
