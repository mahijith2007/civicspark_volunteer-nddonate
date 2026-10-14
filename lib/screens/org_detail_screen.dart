import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../widgets/campaign_card.dart';
import 'campaign_detail_screen.dart';

class OrgDetailScreen extends StatelessWidget {
  final Organization org;
  const OrgDetailScreen({super.key, required this.org});

  Color get _typeColor {
    switch (org.type) {
      case 'Orphanage':
        return const Color(0xFFE53935);
      case 'Community':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF1565C0);
    }
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.contact_support, color: _typeColor),
            const SizedBox(width: 8),
            Expanded(child: Text(org.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone, color: Color(0xFF1A6B3C)),
              title: Text(org.phone, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Tap to copy phone number'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number copied: ${org.phone}'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            const Divider(),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email, color: Color(0xFF1565C0)),
              title: Text(org.email, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Tap to copy email address'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email copied: ${org.email}'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            const Divider(),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on, color: Color(0xFFE53935)),
              title: Text(org.location, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Verified headquarters'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _handleVolunteerWithOrg(BuildContext context) {
    AuthService.instance.recordVolunteered();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1A6B3C),
        behavior: SnackBarBehavior.floating,
        content: Text('Volunteer request submitted to ${org.name}! Their team will contact you soon.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final campaigns = AppState.instance.allCampaigns
            .where((c) => c.organizationName.toLowerCase() == org.name.toLowerCase())
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F7),
          body: CustomScrollView(
            slivers: [
              // ── Image Sliver App Bar ──────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: _typeColor,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 18),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        org.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.business, size: 80, color: Colors.grey),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.75),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _typeColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(org.type,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700)),
                                ),
                                if (org.isVerified) ...[
                                  const SizedBox(width: 8),
                                  const Row(
                                    children: [
                                      Icon(Icons.verified,
                                          color: Colors.lightBlueAccent, size: 16),
                                      SizedBox(width: 4),
                                      Text('Verified Organization',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              org.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 14, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(org.location,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),

              // ── Key Metrics ───────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _StatBox(
                            value: '${org.campaignsCount}',
                            label: 'Campaigns',
                            icon: Icons.campaign_outlined,
                            color: const Color(0xFF1A6B3C),
                          ),
                          const SizedBox(width: 12),
                          _StatBox(
                            value: '${org.volunteersCount}',
                            label: 'Volunteers',
                            icon: Icons.group_outlined,
                            color: const Color(0xFF1565C0),
                          ),
                          const SizedBox(width: 12),
                          _StatBox(
                            value: org.isVerified ? '100%' : 'Pending',
                            label: 'Verification',
                            icon: Icons.shield_outlined,
                            color: org.isVerified ? const Color(0xFF43A047) : Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Action Buttons: Contact & Partner
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showContactDialog(context),
                              icon: const Icon(Icons.contact_mail_outlined, size: 18),
                              label: const Text('Contact Us'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _typeColor,
                                side: BorderSide(color: _typeColor),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _handleVolunteerWithOrg(context),
                              icon: const Icon(Icons.handshake_outlined, size: 18),
                              label: const Text('Partner With Us'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _typeColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // About Section
                      const Text('About the Organization',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B2D1F))),
                      const SizedBox(height: 8),
                      Text(org.description,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.6)),
                      const SizedBox(height: 24),

                      // Contact details snippet
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(org.phone, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                const Spacer(),
                                const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(org.email, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Active Campaigns Heading ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Campaigns by this Org',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B2D1F)),
                      ),
                      Text('${campaigns.length} total',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),

              // ── Org Campaigns List ────────────────────────────────────────────
              if (campaigns.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text('No active campaigns running right now.',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CampaignCard(
                          campaign: campaigns[i],
                          onTap: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CampaignDetailScreen(campaign: campaigns[i]),
                            ),
                          ),
                        ),
                      ),
                      childCount: campaigns.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        );
      },
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: color)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
