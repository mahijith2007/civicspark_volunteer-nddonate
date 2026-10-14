import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/mock_data.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  AppState._internal() {
    _initData();
  }

  final AuthService auth = AuthService.instance;
  final FirestoreService firestore = FirestoreService.instance;

  List<Campaign> _campaigns = [];
  List<Organization> _organizations = [];
  List<CivicIssue> _issues = [];
  List<NotificationItem> _notifications = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _selectedOrgType = 'All';
  String _selectedIssueUrgency = 'All';

  // Getters
  List<Campaign> get allCampaigns => _campaigns;
  List<Organization> get allOrganizations => _organizations;
  List<CivicIssue> get allIssues => _issues;
  List<NotificationItem> get notifications => _notifications;
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedOrgType => _selectedOrgType;
  String get selectedIssueUrgency => _selectedIssueUrgency;

  void _initData() {
    _campaigns = List.from(MockData.campaigns);
    _organizations = List.from(MockData.organizations);
    _issues = List.from(MockData.issues);

    _notifications = [
      NotificationItem(
        id: 'n1',
        title: 'New Campaign in your area',
        message: 'City Greenery Drive just launched! 50 volunteers needed.',
        timeAgo: '10m ago',
        icon: Icons.eco,
        color: const Color(0xFF1A6B3C),
      ),
      NotificationItem(
        id: 'n2',
        title: 'Issue Status Updated',
        message: 'Water logging at Market Road has been assigned to Public Works.',
        timeAgo: '1h ago',
        icon: Icons.check_circle_outline,
        color: const Color(0xFF1565C0),
      ),
      NotificationItem(
        id: 'n3',
        title: 'Thank you for your impact!',
        message: 'You have helped 3 civic campaigns reach their milestones.',
        timeAgo: '1d ago',
        icon: Icons.favorite,
        color: const Color(0xFFE53935),
      ),
    ];
  }

  // ── Filtered Views ─────────────────────────────────────────────────────────

  List<Campaign> get filteredCampaigns {
    return _campaigns.where((c) {
      final matchesCategory = _selectedCategory == 'All' ||
          c.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.organizationName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<Organization> get filteredOrganizations {
    return _organizations.where((org) {
      final matchesType = _selectedOrgType == 'All' ||
          org.type.toLowerCase() == _selectedOrgType.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          org.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          org.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          org.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();
  }

  List<CivicIssue> get filteredIssues {
    return _issues.where((issue) {
      final matchesUrgency = _selectedIssueUrgency == 'All' ||
          issue.urgency.toLowerCase() == _selectedIssueUrgency.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          issue.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          issue.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          issue.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesUrgency && matchesSearch;
    }).toList();
  }

  // ── Search & Filter Actions ────────────────────────────────────────────────

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedOrgType(String type) {
    _selectedOrgType = type;
    notifyListeners();
  }

  void setSelectedIssueUrgency(String urgency) {
    _selectedIssueUrgency = urgency;
    notifyListeners();
  }

  // ── Business Actions ───────────────────────────────────────────────────────

  /// Donate to Campaign
  void donateToCampaign(String campaignId, int amount) {
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      final current = _campaigns[index];
      _campaigns[index] = current.copyWith(
        raisedAmount: current.raisedAmount + amount,
      );

      // Record in auth profile
      auth.recordDonation(amount);

      // Push notification
      _addNotification(
        title: 'Donation Successful! 🎉',
        message: 'You donated ₹$amount to "${current.title}".',
        icon: Icons.volunteer_activism,
        color: const Color(0xFF1A6B3C),
      );

      // Sync Firestore
      firestore.updateCampaignDonation(campaignId, amount);

      notifyListeners();
    }
  }

  /// Volunteer for Campaign
  void volunteerForCampaign(String campaignId) {
    final index = _campaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      final current = _campaigns[index];
      _campaigns[index] = current.copyWith(
        volunteersJoined: current.volunteersJoined + 1,
      );

      auth.recordVolunteered();

      _addNotification(
        title: 'Joined as Volunteer! 🤝',
        message: 'You are now registered for "${current.title}".',
        icon: Icons.group_add,
        color: const Color(0xFF1565C0),
      );

      firestore.updateCampaignVolunteer(campaignId);

      notifyListeners();
    }
  }

  /// Report Civic Issue
  void reportCivicIssue({
    required String title,
    required String description,
    required String location,
    required String category,
    required String urgency,
  }) {
    final newIssue = CivicIssue(
      id: 'issue_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      location: location,
      category: category,
      urgency: urgency,
      imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=500',
      supportCount: 1, // Author automatically supports
      createdAt: DateTime.now().toIso8601String(),
    );

    _issues.insert(0, newIssue);
    auth.recordReportedIssue();
    auth.toggleIssueSupport(newIssue.id);

    _addNotification(
      title: 'Issue Reported! 📢',
      message: '"$title" has been submitted for citizen review.',
      icon: Icons.report_problem,
      color: const Color(0xFFE53935),
    );

    firestore.reportIssue(newIssue);

    notifyListeners();
  }

  /// Upvote / Support Issue
  void toggleSupportIssue(String issueId) {
    final index = _issues.indexWhere((i) => i.id == issueId);
    if (index != -1) {
      final issue = _issues[index];
      final isSupported = auth.currentUser?.supportedIssueIds.contains(issueId) ?? false;
      final newCount = isSupported ? (issue.supportCount - 1).clamp(0, 999999) : issue.supportCount + 1;

      _issues[index] = issue.copyWith(supportCount: newCount);
      auth.toggleIssueSupport(issueId);

      firestore.supportIssue(issueId, !isSupported);

      notifyListeners();
    }
  }

  /// Bookmark Campaign
  void toggleBookmarkCampaign(String campaignId) {
    auth.toggleBookmarkCampaign(campaignId);
    notifyListeners();
  }

  // ── Notifications ──────────────────────────────────────────────────────────

  void _addNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    _notifications.insert(
      0,
      NotificationItem(
        id: 'n_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        timeAgo: 'Just now',
        icon: icon,
        color: color,
        isRead: false,
      ),
    );
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }
}
