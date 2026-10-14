import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import '../widgets/campaign_card.dart';
import '../widgets/category_chip.dart';
import '../main_shell.dart';
import 'campaign_detail_screen.dart';
import 'profile_screen.dart';
import 'notifications_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([AppState.instance, AuthService.instance]),
      builder: (context, _) {
        final state = AppState.instance;
        final user = AuthService.instance.currentUser;
        final campaigns = state.filteredCampaigns;
        final unreadCount = state.unreadNotificationsCount;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F7),
          body: CustomScrollView(
            slivers: [
              // ── Sliver App Bar ─────────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                stretch: true,
                backgroundColor: const Color(0xFF1A6B3C),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF0D3D26), Color(0xFF2E9B5B)],
                          ),
                        ),
                      ),
                      // Decorative pattern
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -40,
                        bottom: -20,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      // Header content
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.volunteer_activism,
                                        color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'CivicSpark',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const Spacer(),

                                  // Notifications button with badge
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      GestureDetector(
                                        onTap: () => NotificationsSheet.show(context),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.notifications_outlined,
                                              color: Colors.white, size: 20),
                                        ),
                                      ),
                                      if (unreadCount > 0)
                                        Positioned(
                                          right: -2,
                                          top: -2,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFE53935),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '$unreadCount',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),

                                  // Profile / Auth Avatar
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                                    ),
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: (user != null && user.avatarUrl.isNotEmpty)
                                          ? Image.network(
                                              user.avatarUrl,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.person, color: Colors.white, size: 18),
                                            )
                                          : const Icon(Icons.person, color: Colors.white, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Good Morning, ${user != null ? user.displayName.split(' ').first : 'Citizen'}! 👋',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Make a difference today',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Collapsed title
                  title: const Row(
                    children: [
                      Icon(Icons.volunteer_activism, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('CivicSpark',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),

              // ── Search Bar ────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => state.setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'Search campaigns, issues, orgs...',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF1A6B3C)),
                        suffixIcon: state.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  state.setSearchQuery('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Stats Row ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      _StatBadge(
                        icon: Icons.campaign,
                        label: 'Campaigns',
                        value: '${state.allCampaigns.length}',
                        color: const Color(0xFF1A6B3C),
                        onTap: () => MainShell.switchTab(context, 1),
                      ),
                      const SizedBox(width: 10),
                      _StatBadge(
                        icon: Icons.business,
                        label: 'Orgs',
                        value: '${state.allOrganizations.length}',
                        color: const Color(0xFF1565C0),
                        onTap: () => MainShell.switchTab(context, 2),
                      ),
                      const SizedBox(width: 10),
                      _StatBadge(
                        icon: Icons.report_problem,
                        label: 'Issues',
                        value: '${state.allIssues.length}',
                        color: const Color(0xFFE53935),
                        onTap: () => MainShell.switchTab(context, 3),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Categories ────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Browse by Category',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B2D1F))),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CategoryChip(
                              label: 'All',
                              icon: Icons.apps,
                              isSelected: state.selectedCategory == 'All',
                              onTap: () => state.setSelectedCategory('All'),
                            ),
                            const SizedBox(width: 8),
                            CategoryChip(
                              label: 'Education',
                              icon: Icons.school,
                              isSelected: state.selectedCategory == 'Education',
                              onTap: () => state.setSelectedCategory('Education'),
                            ),
                            const SizedBox(width: 8),
                            CategoryChip(
                              label: 'Healthcare',
                              icon: Icons.local_hospital,
                              isSelected: state.selectedCategory == 'Healthcare',
                              onTap: () => state.setSelectedCategory('Healthcare'),
                            ),
                            const SizedBox(width: 8),
                            CategoryChip(
                              label: 'Environment',
                              icon: Icons.eco,
                              isSelected: state.selectedCategory == 'Environment',
                              onTap: () => state.setSelectedCategory('Environment'),
                            ),
                            const SizedBox(width: 8),
                            CategoryChip(
                              label: 'Food',
                              icon: Icons.restaurant,
                              isSelected: state.selectedCategory == 'Food',
                              onTap: () => state.setSelectedCategory('Food'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Section Header: Featured Campaigns ────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Featured Campaigns',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1B2D1F)),
                      ),
                      TextButton(
                        onPressed: () => MainShell.switchTab(context, 1),
                        child: const Text('See all',
                            style: TextStyle(
                                color: Color(0xFF1A6B3C),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Campaign Cards or Empty State ──────────────────────────────────
              if (campaigns.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off, size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'No campaigns found for "${state.selectedCategory != 'All' ? state.selectedCategory : state.searchQuery}"',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              state.setSearchQuery('');
                              state.setSelectedCategory('All');
                            },
                            child: const Text('Reset filters'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      final c = campaigns[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: CampaignCard(
                          campaign: c,
                          onTap: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => CampaignDetailScreen(campaign: c),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: campaigns.length,
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }
}

// ── Stat Badge ────────────────────────────────────────────────────────────────
class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatBadge({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: color)),
                  Text(label,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
