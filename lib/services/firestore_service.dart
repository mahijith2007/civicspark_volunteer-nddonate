import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'firebase_config.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._internal();
  FirestoreService._internal();

  FirebaseFirestore? get _firestore =>
      FirebaseConfig.isInitialized ? FirebaseFirestore.instance : null;

  // ── Campaigns ──────────────────────────────────────────────────────────────
  Stream<List<Campaign>> campaignsStream() {
    if (!FirebaseConfig.isInitialized || _firestore == null) {
      return const Stream.empty();
    }
    return _firestore!.collection('campaigns').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Campaign.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> updateCampaignDonation(String campaignId, int addedAmount) async {
    if (!FirebaseConfig.isInitialized || _firestore == null) return;
    try {
      final docRef = _firestore!.collection('campaigns').doc(campaignId);
      await _firestore!.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (snap.exists) {
          final current = (snap.data()?['raisedAmount'] as num?)?.toInt() ?? 0;
          tx.update(docRef, {'raisedAmount': current + addedAmount});
        }
      });
    } catch (e) {
      debugPrint('[FirestoreService] updateCampaignDonation error: $e');
    }
  }

  Future<void> updateCampaignVolunteer(String campaignId) async {
    if (!FirebaseConfig.isInitialized || _firestore == null) return;
    try {
      final docRef = _firestore!.collection('campaigns').doc(campaignId);
      await docRef.update({
        'volunteersJoined': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('[FirestoreService] updateCampaignVolunteer error: $e');
    }
  }

  // ── Civic Issues ───────────────────────────────────────────────────────────
  Stream<List<CivicIssue>> issuesStream() {
    if (!FirebaseConfig.isInitialized || _firestore == null) {
      return const Stream.empty();
    }
    return _firestore!
        .collection('issues')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CivicIssue.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> reportIssue(CivicIssue issue) async {
    if (!FirebaseConfig.isInitialized || _firestore == null) return;
    try {
      await _firestore!.collection('issues').doc(issue.id).set(issue.toMap());
    } catch (e) {
      debugPrint('[FirestoreService] reportIssue error: $e');
    }
  }

  Future<void> supportIssue(String issueId, bool increment) async {
    if (!FirebaseConfig.isInitialized || _firestore == null) return;
    try {
      await _firestore!.collection('issues').doc(issueId).update({
        'supportCount': FieldValue.increment(increment ? 1 : -1),
      });
    } catch (e) {
      debugPrint('[FirestoreService] supportIssue error: $e');
    }
  }

  // ── Organizations ──────────────────────────────────────────────────────────
  Stream<List<Organization>> organizationsStream() {
    if (!FirebaseConfig.isInitialized || _firestore == null) {
      return const Stream.empty();
    }
    return _firestore!.collection('organizations').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Organization.fromMap(doc.data(), doc.id)).toList();
    });
  }
}
