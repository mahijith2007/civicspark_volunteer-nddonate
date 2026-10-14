import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/auth_service.dart';
import 'report_issue_dialog.dart';

class IssuesScreen extends StatelessWidget {
  const IssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([AppState.instance, AuthService.instance]),
      builder: (context, _) {
        final state = AppState.instance;
        final issues = state.filteredIssues;
        final selectedUrgency = state.selectedIssueUrgency;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9F7),
          body: CustomScrollView(
            slivers: [
              // ── Sliver App Bar ───────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: const Color(0xFFC62828),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF7F0000), Color(0xFFE53935)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Civic Issues',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${issues.length} issues reported near you',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            // Urgency legend & clickable filters
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _UrgencyFilterChip(
                                    label: 'All',
                                    color: Colors.white,
                                    isSelected: selectedUrgency == 'All',
                                    onTap: () => state.setSelectedIssueUrgency('All'),
                                  ),
                                  const SizedBox(width: 8),
                                  _UrgencyFilterChip(
                                    label: 'High',
                                    color: const Color(0xFFE53935),
                                    isSelected: selectedUrgency == 'High',
                                    onTap: () => state.setSelectedIssueUrgency('High'),
                                  ),
                                  const SizedBox(width: 8),
                                  _UrgencyFilterChip(
                                    label: 'Medium',
                                    color: const Color(0xFFFB8C00),
                                    isSelected: selectedUrgency == 'Medium',
                                    onTap: () => state.setSelectedIssueUrgency('Medium'),
                                  ),
                                  const SizedBox(width: 8),
                                  _UrgencyFilterChip(
                                    label: 'Low',
                                    color: const Color(0xFF43A047),
                                    isSelected: selectedUrgency == 'Low',
                                    onTap: () => state.setSelectedIssueUrgency('Low'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  title: const Text('Civic Issues',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                  collapseMode: CollapseMode.pin,
                ),
              ),

              // ── Issue Cards ──────────────────────────────────────────────────
              if (issues.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            'No issues found with "$selectedUrgency" urgency',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () => state.setSelectedIssueUrgency('All'),
                            child: const Text('Show All Issues'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _IssueCard(issue: issues[i]),
                      ),
                      childCount: issues.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => ReportIssueDialog.show(context),
            backgroundColor: const Color(0xFFE53935),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            label: const Text('Report Issue',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        );
      },
    );
  }
}

// ── Urgency Filter Chip ───────────────────────────────────────────────────────
class _UrgencyFilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _UrgencyFilterChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            if (label != 'All') ...[
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFC62828) : Colors.white,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Issue Card ────────────────────────────────────────────────────────────────
class _IssueCard extends StatelessWidget {
  final CivicIssue issue;
  const _IssueCard({required this.issue});

  void _showDiscussionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(issue.title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF1B2D1F))),
            Text('${issue.location} • ${issue.category}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Divider(height: 24),
            const Text('Citizen Discussion & Updates',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _CommentTile(
                    author: 'Ward Inspector',
                    role: 'Municipal Authority',
                    text: 'Inspection scheduled for tomorrow morning. Road repair unit alerted.',
                    timeAgo: '2h ago',
                    isAuthority: true,
                  ),
                  const SizedBox(height: 10),
                  _CommentTile(
                    author: 'Ravi Kumar',
                    role: 'Resident',
                    text: 'This has been causing heavy traffic jams during rush hour. Thank you for reporting!',
                    timeAgo: '4h ago',
                    isAuthority: false,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add citizen comment or update...',
                      hintStyle: const TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFC62828)),
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comment posted to issue thread!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final isSupported = user?.supportedIssueIds.contains(issue.id) ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Urgency accent bar
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: issue.urgencyColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Urgency badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: issue.urgencyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${issue.urgency} Urgency',
                        style: TextStyle(
                          fontSize: 10,
                          color: issue.urgencyColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        issue.category,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    // Discussion action
                    IconButton(
                      icon: const Icon(Icons.forum_outlined, size: 18, color: Colors.grey),
                      tooltip: 'Discussion',
                      onPressed: () => _showDiscussionModal(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  issue.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B2D1F)),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(issue.location,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  issue.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Support count
                    Icon(Icons.thumb_up_outlined,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      '${issue.supportCount} supporters',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const Spacer(),
                    // Support button
                    GestureDetector(
                      onTap: () {
                        AppState.instance.toggleSupportIssue(issue.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isSupported
                                ? 'Withdrew support for issue'
                                : 'You supported this issue! Civic authorities notified.'),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSupported
                              ? const Color(0xFFE53935)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFE53935),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSupported
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              size: 13,
                              color: isSupported
                                  ? Colors.white
                                  : const Color(0xFFE53935),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isSupported ? 'Supported' : 'Support',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSupported
                                    ? Colors.white
                                    : const Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  final String author;
  final String role;
  final String text;
  final String timeAgo;
  final bool isAuthority;

  const _CommentTile({
    required this.author,
    required this.role,
    required this.text,
    required this.timeAgo,
    required this.isAuthority,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAuthority ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAuthority ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(author, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isAuthority ? Colors.blue : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  role,
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Text(timeAgo, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          Text(text, style: const TextStyle(fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
