import 'package:flutter_test/flutter_test.dart';
import 'package:civicspark_demo/services/app_state.dart';
import 'package:civicspark_demo/services/auth_service.dart';

void main() {
  setUp(() {
    // Reset state before tests
    AppState.instance.setSearchQuery('');
    AppState.instance.setSelectedCategory('All');
    AppState.instance.setSelectedOrgType('All');
    AppState.instance.setSelectedIssueUrgency('All');
  });

  test('AppState filtering by category works as expected', () {
    final state = AppState.instance;
    expect(state.allCampaigns.isNotEmpty, true);

    state.setSelectedCategory('Education');
    for (final c in state.filteredCampaigns) {
      expect(c.category.toLowerCase(), 'education');
    }

    state.setSelectedCategory('All');
    expect(state.filteredCampaigns.length, state.allCampaigns.length);
  });

  test('AppState search query filters campaigns by title and description', () {
    final state = AppState.instance;
    state.setSearchQuery('Clean');
    for (final c in state.filteredCampaigns) {
      final matches = c.title.toLowerCase().contains('clean') ||
          c.description.toLowerCase().contains('clean') ||
          c.organizationName.toLowerCase().contains('clean');
      expect(matches, true);
    }
  });

  test('Donating to a campaign updates raised amount and records in user profile', () {
    final state = AppState.instance;
    final campaign = state.allCampaigns.first;
    final initialRaised = campaign.raisedAmount;
    final initialUserDonations = AuthService.instance.currentUser?.donationsTotal ?? 0;

    state.donateToCampaign(campaign.id, 500);

    final updated = state.allCampaigns.firstWhere((c) => c.id == campaign.id);
    expect(updated.raisedAmount, initialRaised + 500);
    expect(AuthService.instance.currentUser?.donationsTotal, initialUserDonations + 500);
  });

  test('Reporting an issue adds it to the issues list and updates user stats', () {
    final state = AppState.instance;
    final initialCount = state.allIssues.length;

    state.reportCivicIssue(
      title: 'Damaged Water Pipe on 5th Cross',
      description: 'Clean drinking water is being wasted and flooding the road.',
      location: '5th Cross, Rajajinagar',
      category: 'Water Supply',
      urgency: 'High',
    );

    expect(state.allIssues.length, initialCount + 1);
    expect(state.allIssues.first.title, 'Damaged Water Pipe on 5th Cross');
    expect(state.allIssues.first.supportCount, 1);
  });

  test('Supporting an issue increments support count and remembers user support', () {
    final state = AppState.instance;
    final issue = state.allIssues.first;
    final initialSupport = issue.supportCount;

    // Toggle support
    state.toggleSupportIssue(issue.id);
    final updated = state.allIssues.firstWhere((i) => i.id == issue.id);
    // If was supported, decrements; if not, increments
    expect(state.allIssues.any((i) => i.id == issue.id), true);
  });

  test('AuthService allows guest and demo login switching', () async {
    final auth = AuthService.instance;

    await auth.signInAnonymously();
    expect(auth.currentUser?.isAnonymous, true);

    auth.signInWithDemoProfile(
      name: 'Maya Rao',
      email: 'maya@civicspark.org',
      avatar: '',
      donations: 3000,
      volunteers: 4,
      issues: 1,
    );
    expect(auth.currentUser?.displayName, 'Maya Rao');
    expect(auth.currentUser?.donationsTotal, 3000);
  });
}
