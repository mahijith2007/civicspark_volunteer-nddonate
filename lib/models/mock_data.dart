import 'models.dart';

class MockData {
  // ── Campaigns ───────────────────────────────────────────────────────────────
  static const List<Campaign> campaigns = [
    Campaign(
      id: 'c1',
      title: 'Feed 500 Children This Winter',
      description:
          'Join us in providing nutritious meals to over 500 underprivileged children this winter season. Every contribution counts — your time or money can change a life.',
      organizationName: 'Sunshine Foundation',
      category: 'Food & Nutrition',
      imageUrl: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
      raisedAmount: 34000,
      goalAmount: 50000,
      volunteersNeeded: 40,
      volunteersJoined: 27,
      isDonation: true,
      location: 'Mumbai, MH',
      date: 'Dec 20, 2026',
    ),
    Campaign(
      id: 'c2',
      title: 'Weekend Park Cleanup Drive',
      description:
          'Help restore the beauty of Aarey Colony by joining our weekly cleanup drive. Gloves and bags provided. All ages welcome!',
      organizationName: 'GreenCity NGO',
      category: 'Environment',
      imageUrl: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
      raisedAmount: 0,
      goalAmount: 0,
      volunteersNeeded: 60,
      volunteersJoined: 38,
      isDonation: false,
      location: 'Aarey Colony, Mumbai',
      date: 'Every Sunday',
    ),
    Campaign(
      id: 'c3',
      title: 'Books for Bright Futures',
      description:
          'Donate textbooks and stationery to children in government schools across rural Maharashtra who lack access to basic learning materials.',
      organizationName: 'EduReach India',
      category: 'Education',
      imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
      raisedAmount: 18500,
      goalAmount: 30000,
      volunteersNeeded: 20,
      volunteersJoined: 15,
      isDonation: true,
      location: 'Pune, MH',
      date: 'Jan 15, 2027',
    ),
    Campaign(
      id: 'c4',
      title: 'Teach & Inspire: Weekend Classes',
      description:
          'Volunteer as a teacher for underprivileged kids every Saturday. No formal degree required — just passion and patience.',
      organizationName: 'EduReach India',
      category: 'Education',
      imageUrl: 'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?w=800',
      raisedAmount: 0,
      goalAmount: 0,
      volunteersNeeded: 25,
      volunteersJoined: 22,
      isDonation: false,
      location: 'Dharavi, Mumbai',
      date: 'Every Saturday',
    ),
    Campaign(
      id: 'c5',
      title: 'Medical Camp for Elderly',
      description:
          'Free health check-ups, medicines, and consultation for elderly citizens in underprivileged communities.',
      organizationName: 'HealthFirst Trust',
      category: 'Healthcare',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
      raisedAmount: 62000,
      goalAmount: 80000,
      volunteersNeeded: 30,
      volunteersJoined: 18,
      isDonation: true,
      location: 'Thane, MH',
      date: 'Nov 30, 2026',
    ),
  ];

  // ── Organizations ───────────────────────────────────────────────────────────
  static const List<Organization> organizations = [
    Organization(
      id: 'o1',
      name: 'Sunshine Foundation',
      type: 'NGO',
      description:
          'Dedicated to eradicating child hunger in urban slums through community kitchens and nutrition programs.',
      location: 'Mumbai, Maharashtra',
      imageUrl: 'https://images.unsplash.com/photo-1509099836639-18ba1795216d?w=800',
      campaignsCount: 12,
      volunteersCount: 320,
      isVerified: true,
    ),
    Organization(
      id: 'o2',
      name: 'Little Stars Orphanage',
      type: 'Orphanage',
      description:
          'Home to 85 children, we provide shelter, education, and emotional support to orphaned and abandoned children.',
      location: 'Pune, Maharashtra',
      imageUrl: 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=800',
      campaignsCount: 5,
      volunteersCount: 90,
      isVerified: true,
    ),
    Organization(
      id: 'o3',
      name: 'GreenCity NGO',
      type: 'Community',
      description:
          'A citizen-led initiative focused on urban greenery, waste management, and environmental awareness campaigns.',
      location: 'Mumbai, Maharashtra',
      imageUrl: 'https://images.unsplash.com/photo-1542601906897-bb9ad1df4915?w=800',
      campaignsCount: 8,
      volunteersCount: 450,
      isVerified: true,
    ),
    Organization(
      id: 'o4',
      name: 'EduReach India',
      type: 'NGO',
      description:
          'Bridging the education gap by providing quality resources, trained volunteers, and digital learning tools.',
      location: 'Pune, Maharashtra',
      imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
      campaignsCount: 15,
      volunteersCount: 600,
      isVerified: false,
    ),
    Organization(
      id: 'o5',
      name: 'HealthFirst Trust',
      type: 'NGO',
      description:
          'Running free medical camps, mental health awareness sessions, and preventive care programs for the underserved.',
      location: 'Thane, Maharashtra',
      imageUrl: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
      campaignsCount: 9,
      volunteersCount: 210,
      isVerified: true,
    ),
  ];

  // ── Issues ──────────────────────────────────────────────────────────────────
  static const List<CivicIssue> issues = [
    CivicIssue(
      id: 'i1',
      title: 'Broken Street Lights on MG Road',
      description:
          'Multiple street lights on MG Road have been non-functional for 3 weeks, causing safety hazards for pedestrians and motorists at night.',
      location: 'MG Road, Pune',
      category: 'Infrastructure',
      urgency: 'High',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      supportCount: 124,
    ),
    CivicIssue(
      id: 'i2',
      title: 'Overflowing Garbage Bins – Dharavi',
      description:
          'Garbage collection in Sector 4 has been irregular for 2 weeks. Bins are overflowing and creating a health hazard.',
      location: 'Dharavi, Mumbai',
      category: 'Sanitation',
      urgency: 'High',
      imageUrl: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
      supportCount: 87,
    ),
    CivicIssue(
      id: 'i3',
      title: 'Pothole Menace on Linking Road',
      description:
          'Large potholes on Linking Road are causing accidents. Two minor accidents reported this week alone.',
      location: 'Linking Road, Mumbai',
      category: 'Roads',
      urgency: 'Medium',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      supportCount: 56,
    ),
    CivicIssue(
      id: 'i4',
      title: 'Illegal Construction Blocking Park',
      description:
          'An illegal structure is blocking public access to the community park in Koregaon Park, Pune.',
      location: 'Koregaon Park, Pune',
      category: 'Public Spaces',
      urgency: 'Low',
      imageUrl: 'https://images.unsplash.com/photo-1543513090-28f81e382f9f?w=800',
      supportCount: 33,
    ),
  ];
}
