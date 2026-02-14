import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/reminder_card.dart';
import '../../widgets/stats_events_row.dart';
import 'event_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardProvider>();
    final authUser = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: VictusTheme.backgroundWhite,
      body: dashboard.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: VictusTheme.primaryPink),
            )
          : RefreshIndicator(
              color: VictusTheme.primaryPink,
              onRefresh: () => dashboard.load(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Olá, ${dashboard.user?.name ?? authUser?.name ?? ''}',
                                  style: VictusTheme.heading1.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                _HeaderIcon(
                                  icon: Icons.people_outline,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 8),
                                _HeaderIcon(
                                  icon: Icons.notifications_outlined,
                                  onTap: () {},
                                ),
                                const SizedBox(width: 8),
                                _HeaderIcon(
                                  icon: Icons.chat_bubble_outline,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Banner carousel
                      BannerCarousel(banners: dashboard.banners),

                      const SizedBox(height: 20),

                      // Reminder card
                      if (dashboard.reminder != null)
                        ReminderCard(
                          message: dashboard.reminder!['message'] ?? '',
                        ),

                      const SizedBox(height: 20),

                      // Stats & Events row
                      StatsEventsRow(
                        weightLost: dashboard.user?.weightLost ?? 0,
                        events: dashboard.events,
                        onEventTap: (event) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailScreen(eventId: event.id),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: VictusTheme.textDark,
        size: 24,
      ),
    );
  }
}