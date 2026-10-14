import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/campaigns_screen.dart';
import 'screens/organizations_screen.dart';
import 'screens/issues_screen.dart';

import 'package:flutter/services.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static void switchTab(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainShellState>()?._onTabSelected(index);
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<int> _history = [0];

  final List<Widget> _screens = const [
    HomeScreen(),
    CampaignsScreen(),
    OrganizationsScreen(),
    IssuesScreen(),
  ];

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      if (index == 0) {
        _history
          ..clear()
          ..add(0);
      } else {
        _history.add(index);
      }
      _currentIndex = index;
    });
  }

  void _handleBack() {
    if (_currentIndex != 0) {
      setState(() {
        if (_history.length > 1) {
          _history.removeLast();
          _currentIndex = _history.last;
        } else {
          _currentIndex = 0;
          _history
            ..clear()
            ..add(0);
        }
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _handleBack,
        const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true): _handleBack,
      },
      child: Focus(
        autofocus: true,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBack();
          },
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: _BottomNav(
              currentIndex: _currentIndex,
              onTap: _onTabSelected,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Custom Bottom Nav ─────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.campaign_outlined, activeIcon: Icons.campaign, label: 'Campaigns'),
    (icon: Icons.business_outlined, activeIcon: Icons.business, label: 'Orgs'),
    (icon: Icons.report_problem_outlined, activeIcon: Icons.report_problem, label: 'Issues'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isActive = currentIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF1A6B3C).withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            color: isActive
                                ? const Color(0xFF1A6B3C)
                                : Colors.grey.shade500,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive
                                ? const Color(0xFF1A6B3C)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
