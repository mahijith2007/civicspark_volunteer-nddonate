import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/campaign_card.dart';
import 'campaign_detail_screen.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final all = AppState.instance.allCampaigns;
        final donationCampaigns = all.where((c) => c.isDonation).toList();
        final volunteerCampaigns = all.where((c) => !c.isDonation).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F7),
          body: NestedScrollView(
            headerSliverBuilder: (ctx, innerBoxScrolled) => [
              // ── Sliver App Bar ───────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                floating: true,
                snap: true,
                backgroundColor: const Color(0xFF1A6B3C),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0D3D26), Color(0xFF2E9B5B)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Campaigns',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${all.length} active campaigns near you',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: const Text('Campaigns',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                  collapseMode: CollapseMode.pin,
                ),
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: [
                    Tab(text: 'Donate (${donationCampaigns.length})'),
                    Tab(text: 'Volunteer (${volunteerCampaigns.length})'),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _CampaignList(campaigns: donationCampaigns),
                _CampaignList(campaigns: volunteerCampaigns),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CampaignList extends StatelessWidget {
  final List<Campaign> campaigns;
  const _CampaignList({required this.campaigns});

  @override
  Widget build(BuildContext context) {
    if (campaigns.isEmpty) {
      return const Center(
        child: Text('No campaigns available',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
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
      ],
    );
  }
}
