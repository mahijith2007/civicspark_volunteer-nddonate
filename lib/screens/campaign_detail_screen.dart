import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Campaign campaign;
  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([AppState.instance, AuthService.instance]),
      builder: (context, _) {
        final c = AppState.instance.allCampaigns.firstWhere(
          (item) => item.id == widget.campaign.id,
          orElse: () => widget.campaign,
        );
        final user = AuthService.instance.currentUser;
        final isBookmarked = user?.bookmarkedCampaignIds.contains(c.id) ?? false;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F7),
          body: CustomScrollView(
            slivers: [
              // ── Image Sliver App Bar ─────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: const Color(0xFF1A6B3C),
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
                actions: [
                  // Bookmark button
                  GestureDetector(
                    onTap: () {
                      AppState.instance.toggleBookmarkCampaign(c.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isBookmarked
                              ? 'Removed from bookmarks'
                              : 'Saved to your bookmarked campaigns!'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.amberAccent : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  // Share button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Campaign link copied: civicspark.org/c/${c.id}'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xFF1A6B3C),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        c.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.campaign,
                              size: 80, color: Colors.grey),
                        ),
                      ),
                      // Dark overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Category badge
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A6B3C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(c.category,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),

              // ── Content ──────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(c.title,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1B2D1F))),
                      const SizedBox(height: 10),

                      // Org name & location
                      Row(
                        children: [
                          const Icon(Icons.business,
                              size: 16, color: Color(0xFF1A6B3C)),
                          const SizedBox(width: 6),
                          Text(c.organizationName,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A6B3C))),
                          const Spacer(),
                          const Icon(Icons.location_on_outlined,
                              size: 15, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(c.location,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  c.isDonation
                                      ? '₹${c.raisedAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                                      : '${c.volunteersJoined} Joined',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A6B3C)),
                                ),
                                Text(
                                  c.isDonation
                                      ? 'Goal: ₹${c.goalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                                      : 'Needed: ${c.volunteersNeeded}',
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: c.progressPercent,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: const AlwaysStoppedAnimation(
                                    Color(0xFF1A6B3C)),
                                minHeight: 10,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${(c.progressPercent * 100).toInt()}% Complete',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A6B3C)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Key details row
                      Row(
                        children: [
                          _DetailPill(
                              icon: Icons.calendar_today_outlined,
                              label: c.date),
                          const SizedBox(width: 10),
                          _DetailPill(
                              icon: c.isDonation
                                  ? Icons.monetization_on_outlined
                                  : Icons.group_outlined,
                              label: c.isDonation ? 'Donation' : 'Volunteering'),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Description
                      const Text('About this Campaign',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B2D1F))),
                      const SizedBox(height: 8),
                      Text(c.description,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.6)),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom CTA ────────────────────────────────────────────────────────
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: c.isDonation
                ? _DonateButton(onTap: () => _showDonateBottomSheet(context, c))
                : _VolunteerButton(
                    joined: _joined,
                    onTap: () {
                      setState(() => _joined = !_joined);
                      if (_joined) {
                        AppState.instance.volunteerForCampaign(c.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF1A6B3C),
                            behavior: SnackBarBehavior.floating,
                            content: Text('Registered for ${c.title}! See you there.'),
                          ),
                        );
                      }
                    },
                  ),
          ),
        );
      },
    );
  }

  void _showDonateBottomSheet(BuildContext context, Campaign campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonateSheet(campaign: campaign),
    );
  }
}

// ── Detail Pill ───────────────────────────────────────────────────────────────
class _DetailPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF1A6B3C)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B2D1F))),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Donate Button ─────────────────────────────────────────────────────────────
class _DonateButton extends StatelessWidget {
  final VoidCallback onTap;
  const _DonateButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.favorite, color: Colors.white),
      label: const Text('Donate Now',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A6B3C),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    );
  }
}

// ── Volunteer Button ──────────────────────────────────────────────────────────
class _VolunteerButton extends StatelessWidget {
  final bool joined;
  final VoidCallback onTap;
  const _VolunteerButton({required this.joined, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(joined ? Icons.check_circle : Icons.volunteer_activism,
            color: Colors.white),
        label: Text(
          joined ? 'You\'re In! 🎉' : 'Join as Volunteer',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: joined ? Colors.green.shade700 : const Color(0xFF1A6B3C),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}

// ── Donate Bottom Sheet ───────────────────────────────────────────────────────
class _DonateSheet extends StatefulWidget {
  final Campaign campaign;
  const _DonateSheet({required this.campaign});

  @override
  State<_DonateSheet> createState() => _DonateSheetState();
}

class _DonateSheetState extends State<_DonateSheet> {
  double _amount = 500;
  bool _donated = false;

  final _presets = [200.0, 500.0, 1000.0, 2000.0];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Make a Donation',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B2D1F))),
          const SizedBox(height: 4),
          Text('Supporting: ${widget.campaign.organizationName}',
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 24),

          // Amount presets
          Row(
            children: _presets
                .map(
                  (a) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _amount = a),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _amount == a
                                ? const Color(0xFF1A6B3C)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _amount == a
                                  ? const Color(0xFF1A6B3C)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '₹${a.toInt()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: _amount == a
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),

          // Slider
          Slider(
            value: _amount,
            min: 100,
            max: 5000,
            divisions: 49,
            activeColor: const Color(0xFF1A6B3C),
            label: '₹${_amount.toInt()}',
            onChanged: (v) => setState(() => _amount = v),
          ),
          Text('₹${_amount.toInt()}',
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A6B3C))),
          const SizedBox(height: 20),

          // Donate CTA
          if (!_donated)
            ElevatedButton(
              onPressed: () {
                AppState.instance.donateToCampaign(
                    widget.campaign.id, _amount.toInt());
                setState(() => _donated = true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6B3C),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                'Donate ₹${_amount.toInt()}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle,
                      color: Color(0xFF1A6B3C), size: 32),
                  const SizedBox(height: 6),
                  Text(
                    'Thank you for donating ₹${_amount.toInt()}!',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A6B3C)),
                  ),
                  const SizedBox(height: 2),
                  const Text('Your contribution makes a difference ❤️',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
