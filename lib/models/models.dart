import 'package:flutter/material.dart';

// ── Campaign ─────────────────────────────────────────────────────────────────
class Campaign {
  final String id;
  final String title;
  final String description;
  final String organizationName;
  final String category;
  final String imageUrl;
  final int raisedAmount;
  final int goalAmount;
  final int volunteersNeeded;
  final int volunteersJoined;
  final bool isDonation;
  final String location;
  final String date;

  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.organizationName,
    required this.category,
    required this.imageUrl,
    required this.raisedAmount,
    required this.goalAmount,
    required this.volunteersNeeded,
    required this.volunteersJoined,
    required this.isDonation,
    required this.location,
    required this.date,
  });

  double get progressPercent =>
      isDonation
          ? (raisedAmount / (goalAmount == 0 ? 1 : goalAmount)).clamp(0.0, 1.0)
          : (volunteersJoined / (volunteersNeeded == 0 ? 1 : volunteersNeeded)).clamp(0.0, 1.0);

  Campaign copyWith({
    String? id,
    String? title,
    String? description,
    String? organizationName,
    String? category,
    String? imageUrl,
    int? raisedAmount,
    int? goalAmount,
    int? volunteersNeeded,
    int? volunteersJoined,
    bool? isDonation,
    String? location,
    String? date,
  }) {
    return Campaign(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organizationName: organizationName ?? this.organizationName,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      raisedAmount: raisedAmount ?? this.raisedAmount,
      goalAmount: goalAmount ?? this.goalAmount,
      volunteersNeeded: volunteersNeeded ?? this.volunteersNeeded,
      volunteersJoined: volunteersJoined ?? this.volunteersJoined,
      isDonation: isDonation ?? this.isDonation,
      location: location ?? this.location,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organizationName': organizationName,
      'category': category,
      'imageUrl': imageUrl,
      'raisedAmount': raisedAmount,
      'goalAmount': goalAmount,
      'volunteersNeeded': volunteersNeeded,
      'volunteersJoined': volunteersJoined,
      'isDonation': isDonation,
      'location': location,
      'date': date,
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map, [String? id]) {
    return Campaign(
      id: id ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      organizationName: map['organizationName'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      raisedAmount: (map['raisedAmount'] as num?)?.toInt() ?? 0,
      goalAmount: (map['goalAmount'] as num?)?.toInt() ?? 1000,
      volunteersNeeded: (map['volunteersNeeded'] as num?)?.toInt() ?? 10,
      volunteersJoined: (map['volunteersJoined'] as num?)?.toInt() ?? 0,
      isDonation: map['isDonation'] ?? true,
      location: map['location'] ?? '',
      date: map['date'] ?? '',
    );
  }
}

// ── Organization ─────────────────────────────────────────────────────────────
class Organization {
  final String id;
  final String name;
  final String type; // NGO | Orphanage | Community
  final String description;
  final String location;
  final String imageUrl;
  final int campaignsCount;
  final int volunteersCount;
  final bool isVerified;
  final String email;
  final String phone;

  const Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.campaignsCount,
    required this.volunteersCount,
    required this.isVerified,
    this.email = 'contact@organization.org',
    this.phone = '+91 98765 43210',
  });

  Organization copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? location,
    String? imageUrl,
    int? campaignsCount,
    int? volunteersCount,
    bool? isVerified,
    String? email,
    String? phone,
  }) {
    return Organization(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      campaignsCount: campaignsCount ?? this.campaignsCount,
      volunteersCount: volunteersCount ?? this.volunteersCount,
      isVerified: isVerified ?? this.isVerified,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'campaignsCount': campaignsCount,
      'volunteersCount': volunteersCount,
      'isVerified': isVerified,
      'email': email,
      'phone': phone,
    };
  }

  factory Organization.fromMap(Map<String, dynamic> map, [String? id]) {
    return Organization(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? 'NGO',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      campaignsCount: (map['campaignsCount'] as num?)?.toInt() ?? 0,
      volunteersCount: (map['volunteersCount'] as num?)?.toInt() ?? 0,
      isVerified: map['isVerified'] ?? false,
      email: map['email'] ?? 'contact@organization.org',
      phone: map['phone'] ?? '+91 98765 43210',
    );
  }
}

// ── Issue ────────────────────────────────────────────────────────────────────
class CivicIssue {
  final String id;
  final String title;
  final String description;
  final String location;
  final String category;
  final String urgency; // Low | Medium | High
  final String imageUrl;
  final int supportCount;
  final String createdAt;

  const CivicIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.urgency,
    required this.imageUrl,
    required this.supportCount,
    this.createdAt = '',
  });

  Color get urgencyColor {
    switch (urgency) {
      case 'High':
        return const Color(0xFFE53935);
      case 'Medium':
        return const Color(0xFFFB8C00);
      default:
        return const Color(0xFF43A047);
    }
  }

  CivicIssue copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? category,
    String? urgency,
    String? imageUrl,
    int? supportCount,
    String? createdAt,
  }) {
    return CivicIssue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      urgency: urgency ?? this.urgency,
      imageUrl: imageUrl ?? this.imageUrl,
      supportCount: supportCount ?? this.supportCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'urgency': urgency,
      'imageUrl': imageUrl,
      'supportCount': supportCount,
      'createdAt': createdAt,
    };
  }

  factory CivicIssue.fromMap(Map<String, dynamic> map, [String? id]) {
    return CivicIssue(
      id: id ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      category: map['category'] ?? '',
      urgency: map['urgency'] ?? 'Medium',
      imageUrl: map['imageUrl'] ?? '',
      supportCount: (map['supportCount'] as num?)?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
    );
  }
}

// ── App User (Authentication & Profile) ───────────────────────────────────────
class AppUser {
  final String uid;
  final String displayName;
  final String email;
  final String avatarUrl;
  final bool isAnonymous;
  final int donationsTotal;
  final int joinedCampaignsCount;
  final int reportedIssuesCount;
  final List<String> bookmarkedCampaignIds;
  final Set<String> supportedIssueIds;

  const AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    this.avatarUrl = '',
    this.isAnonymous = false,
    this.donationsTotal = 0,
    this.joinedCampaignsCount = 0,
    this.reportedIssuesCount = 0,
    this.bookmarkedCampaignIds = const [],
    this.supportedIssueIds = const {},
  });

  AppUser copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? avatarUrl,
    bool? isAnonymous,
    int? donationsTotal,
    int? joinedCampaignsCount,
    int? reportedIssuesCount,
    List<String>? bookmarkedCampaignIds,
    Set<String>? supportedIssueIds,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      donationsTotal: donationsTotal ?? this.donationsTotal,
      joinedCampaignsCount: joinedCampaignsCount ?? this.joinedCampaignsCount,
      reportedIssuesCount: reportedIssuesCount ?? this.reportedIssuesCount,
      bookmarkedCampaignIds: bookmarkedCampaignIds ?? this.bookmarkedCampaignIds,
      supportedIssueIds: supportedIssueIds ?? this.supportedIssueIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'isAnonymous': isAnonymous,
      'donationsTotal': donationsTotal,
      'joinedCampaignsCount': joinedCampaignsCount,
      'reportedIssuesCount': reportedIssuesCount,
      'bookmarkedCampaignIds': bookmarkedCampaignIds,
      'supportedIssueIds': supportedIssueIds.toList(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, [String? uid]) {
    return AppUser(
      uid: uid ?? map['uid'] ?? '',
      displayName: map['displayName'] ?? 'Civic Member',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      isAnonymous: map['isAnonymous'] ?? false,
      donationsTotal: (map['donationsTotal'] as num?)?.toInt() ?? 0,
      joinedCampaignsCount: (map['joinedCampaignsCount'] as num?)?.toInt() ?? 0,
      reportedIssuesCount: (map['reportedIssuesCount'] as num?)?.toInt() ?? 0,
      bookmarkedCampaignIds: List<String>.from(map['bookmarkedCampaignIds'] ?? []),
      supportedIssueIds: Set<String>.from(map['supportedIssueIds'] ?? []),
    );
  }
}

// ── Notification Item ────────────────────────────────────────────────────────
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.icon,
    required this.color,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      message: message,
      timeAgo: timeAgo,
      icon: icon,
      color: color,
      isRead: isRead ?? this.isRead,
    );
  }
}
