import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../services/firebase_config.dart';
import 'auth_screen.dart';
import 'campaign_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([AppState.instance, AuthService.instance]),
      builder: (context, _) {
        final user = AuthService.instance.currentUser;
        final isFirebaseLive = FirebaseConfig.isInitialized;
        final bookmarkedCampaigns = AppState.instance.allCampaigns
            .where((c) => user?.bookmarkedCampaignIds.contains(c.id) ?? false)
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F7),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A6B3C),
            elevation: 0,
            title: const Text('My Profile & Impact',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (user != null)
                IconButton(
                  tooltip: 'Sign Out',
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await AuthService.instance.signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out successfully')),
                      );
                    }
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── User Header Card ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1A6B3C), Color(0xFF2E9B5B)],
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (user != null && user.avatarUrl.isNotEmpty)
                            ? Image.network(
                                user.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.person, size: 44, color: Color(0xFF1A6B3C)),
                              )
                            : const Icon(Icons.person, size: 44, color: Color(0xFF1A6B3C)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.displayName ?? 'Guest Contributor',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'Sign in to sync your impact across devices',
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      if (user == null || user.isAnonymous)
                        ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                          ),
                          icon: const Icon(Icons.login, size: 16),
                          label: const Text('Sign In or Create Account'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1A6B3C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified, size: 15, color: Colors.white),
                              SizedBox(width: 6),
                              Text('Verified Citizen Activist',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Impact Metric Grid ──
                      const Text(
                        'Civic Impact Record',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1B2D1F)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _ImpactStatTile(
                              title: 'Total Donated',
                              value: '₹${user?.donationsTotal ?? 0}',
                              icon: Icons.volunteer_activism,
                              color: const Color(0xFF1A6B3C),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ImpactStatTile(
                              title: 'Volunteered',
                              value: '${user?.joinedCampaignsCount ?? 0} drives',
                              icon: Icons.group,
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ImpactStatTile(
                              title: 'Issues Reported',
                              value: '${user?.reportedIssuesCount ?? 0}',
                              icon: Icons.report_problem,
                              color: const Color(0xFFE53935),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Firebase Backend Status Card ──
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isFirebaseLive ? Colors.green.shade300 : Colors.blue.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: (isFirebaseLive ? Colors.green : Colors.blue).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isFirebaseLive ? Icons.cloud_done : Icons.dns_outlined,
                                    color: isFirebaseLive ? Colors.green : Colors.blue,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isFirebaseLive ? 'Firebase Backend: Live' : 'Backend: Local Demo Bridge',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                      Text(
                                        isFirebaseLive
                                            ? 'Connected to Firebase Authentication & Firestore'
                                            : 'Seamless mock engine active with real-time UI updates',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () => _showFirebaseGuideDialog(context),
                              icon: const Icon(Icons.help_outline, size: 16),
                              label: const Text('View Firebase Setup Guide & Config Instructions'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                                foregroundColor: const Color(0xFF1A6B3C),
                                side: const BorderSide(color: Color(0xFF1A6B3C)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Bookmarked Campaigns ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bookmarked Campaigns',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B2D1F),
                            ),
                          ),
                          Text(
                            '${bookmarkedCampaigns.length} saved',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (bookmarkedCampaigns.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.bookmark_border, size: 36, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('No saved campaigns yet',
                                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                              SizedBox(height: 4),
                              Text('Tap the bookmark icon on any campaign to save it here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bookmarkedCampaigns.length,
                          itemBuilder: (ctx, i) {
                            final campaign = bookmarkedCampaigns[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              color: Colors.white,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    campaign.imageUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.campaign, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                title: Text(campaign.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                subtitle: Text(
                                  '${campaign.category} • ${campaign.organizationName}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.bookmark, color: Color(0xFF1A6B3C)),
                                  onPressed: () => AppState.instance.toggleBookmarkCampaign(campaign.id),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CampaignDetailScreen(campaign: campaign),
                                  ),
                                ),
                              ),
                            );
                          },
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
  }

  void _showFirebaseGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('Firebase Connection', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To connect your live Firebase project:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              SizedBox(height: 10),
              Text(
                '1. Run in your terminal:\n'
                '   npm install -g firebase-tools\n'
                '   dart pub global activate flutterfire_cli\n'
                '   flutterfire configure\n\n'
                '2. In Firebase Console:\n'
                '   • Authentication > Sign-in method > Enable Email/Password & Anonymous\n'
                '   • Firestore Database > Create Database in test mode\n\n'
                '3. The app is already fully wired with Firebase Auth & Firestore services and will automatically activate live mode once configured!',
                style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF1A6B3C), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _ImpactStatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ImpactStatTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
