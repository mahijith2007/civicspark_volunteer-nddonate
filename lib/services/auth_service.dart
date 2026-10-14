import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/models.dart';
import 'firebase_config.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  AuthService._internal() {
    _initAuthListener();
  }

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  final StreamController<AppUser?> _userStreamController =
      StreamController<AppUser?>.broadcast();
  Stream<AppUser?> get authStateChanges => _userStreamController.stream;

  void _initAuthListener() {
    if (FirebaseConfig.isInitialized) {
      fb.FirebaseAuth.instance.authStateChanges().listen((fb.User? user) {
        if (user != null) {
          _currentUser = AppUser(
            uid: user.uid,
            displayName: user.displayName ?? (user.isAnonymous ? 'Guest Contributor' : 'Civic Hero'),
            email: user.email ?? (user.isAnonymous ? 'guest@civicspark.org' : 'user@civicspark.org'),
            isAnonymous: user.isAnonymous,
            avatarUrl: user.photoURL ?? '',
          );
        } else {
          _currentUser = null;
        }
        _userStreamController.add(_currentUser);
        notifyListeners();
      });
    } else {
      // Default to guest user for seamless out-of-the-box experience
      _currentUser = const AppUser(
        uid: 'demo_user_01',
        displayName: 'Aarav Sharma',
        email: 'aarav.sharma@civicspark.org',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        donationsTotal: 2500,
        joinedCampaignsCount: 3,
        reportedIssuesCount: 2,
      );
      _userStreamController.add(_currentUser);
    }
  }

  /// Sign In with Email and Password
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (FirebaseConfig.isInitialized) {
      final credential = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      final appUser = AppUser(
        uid: user?.uid ?? 'uid_${DateTime.now().millisecondsSinceEpoch}',
        displayName: user?.displayName ?? email.split('@').first,
        email: user?.email ?? email,
        avatarUrl: user?.photoURL ?? '',
      );
      _currentUser = appUser;
      _userStreamController.add(_currentUser);
      notifyListeners();
      return appUser;
    } else {
      // Mock Authentication
      await Future.delayed(const Duration(milliseconds: 500));
      final appUser = AppUser(
        uid: 'mock_uid_${email.hashCode.abs()}',
        displayName: email.split('@').first.capitalize(),
        email: email,
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        donationsTotal: 1500,
        joinedCampaignsCount: 2,
        reportedIssuesCount: 1,
      );
      _currentUser = appUser;
      _userStreamController.add(_currentUser);
      notifyListeners();
      return appUser;
    }
  }

  /// Register new user with Email, Password and Display Name
  Future<AppUser> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    if (FirebaseConfig.isInitialized) {
      final credential = await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      await user?.updateDisplayName(name);

      final appUser = AppUser(
        uid: user?.uid ?? 'uid_${DateTime.now().millisecondsSinceEpoch}',
        displayName: name,
        email: email,
        avatarUrl: '',
      );
      _currentUser = appUser;
      _userStreamController.add(_currentUser);
      notifyListeners();
      return appUser;
    } else {
      // Mock Registration
      await Future.delayed(const Duration(milliseconds: 500));
      final appUser = AppUser(
        uid: 'mock_uid_${email.hashCode.abs()}',
        displayName: name,
        email: email,
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        donationsTotal: 0,
        joinedCampaignsCount: 0,
        reportedIssuesCount: 0,
      );
      _currentUser = appUser;
      _userStreamController.add(_currentUser);
      notifyListeners();
      return appUser;
    }
  }

  /// Guest / Anonymous Sign In
  Future<AppUser> signInAnonymously() async {
    if (FirebaseConfig.isInitialized) {
      final credential = await fb.FirebaseAuth.instance.signInAnonymously();
      final user = credential.user;
      final appUser = AppUser(
        uid: user?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}',
        displayName: 'Guest Contributor',
        email: 'guest@civicspark.org',
        isAnonymous: true,
      );
      _currentUser = appUser;
      _userStreamController.add(_currentUser);
      notifyListeners();
      return appUser;
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
      const appUser = AppUser(
        uid: 'guest_local_01',
        displayName: 'Guest Contributor',
        email: 'guest@civicspark.org',
        isAnonymous: true,
      );
      _currentUser = appUser;
      _userStreamController.add(_currentUser);
      notifyListeners();
      return appUser;
    }
  }

  /// Quick Demo Profiles
  void signInWithDemoProfile({
    required String name,
    required String email,
    required String avatar,
    int donations = 5000,
    int volunteers = 4,
    int issues = 3,
  }) {
    _currentUser = AppUser(
      uid: 'demo_${name.replaceAll(' ', '_').toLowerCase()}',
      displayName: name,
      email: email,
      avatarUrl: avatar,
      donationsTotal: donations,
      joinedCampaignsCount: volunteers,
      reportedIssuesCount: issues,
    );
    _userStreamController.add(_currentUser);
    notifyListeners();
  }

  /// Record user contribution
  void recordDonation(int amount) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      donationsTotal: _currentUser!.donationsTotal + amount,
    );
    notifyListeners();
  }

  void recordVolunteered() {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      joinedCampaignsCount: _currentUser!.joinedCampaignsCount + 1,
    );
    notifyListeners();
  }

  void recordReportedIssue() {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      reportedIssuesCount: _currentUser!.reportedIssuesCount + 1,
    );
    notifyListeners();
  }

  void toggleIssueSupport(String issueId) {
    if (_currentUser == null) return;
    final currentSupported = Set<String>.from(_currentUser!.supportedIssueIds);
    if (currentSupported.contains(issueId)) {
      currentSupported.remove(issueId);
    } else {
      currentSupported.add(issueId);
    }
    _currentUser = _currentUser!.copyWith(supportedIssueIds: currentSupported);
    notifyListeners();
  }

  void toggleBookmarkCampaign(String campaignId) {
    if (_currentUser == null) return;
    final bookmarks = List<String>.from(_currentUser!.bookmarkedCampaignIds);
    if (bookmarks.contains(campaignId)) {
      bookmarks.remove(campaignId);
    } else {
      bookmarks.add(campaignId);
    }
    _currentUser = _currentUser!.copyWith(bookmarkedCampaignIds: bookmarks);
    notifyListeners();
  }

  /// Sign Out
  Future<void> signOut() async {
    if (FirebaseConfig.isInitialized) {
      await fb.FirebaseAuth.instance.signOut();
    }
    _currentUser = null;
    _userStreamController.add(null);
    notifyListeners();
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
