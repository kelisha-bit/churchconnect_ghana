import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar implementing Sacred Minimalism design
/// with contextual navigation for church management application
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final ValueChanged<int> onTap;

  /// Bottom bar variant for different contexts
  final CustomBottomBarVariant variant;

  /// Whether to show labels
  final bool showLabels;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom selected item color
  final Color? selectedItemColor;

  /// Custom unselected item color
  final Color? unselectedItemColor;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.variant = CustomBottomBarVariant.primary,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  /// Factory constructor for main navigation with core church features
  factory CustomBottomBar.main({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.main,
    );
  }

  /// Factory constructor for admin navigation with management features
  factory CustomBottomBar.admin({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.admin,
    );
  }

  /// Factory constructor for minimal navigation with essential features only
  factory CustomBottomBar.minimal({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      variant: CustomBottomBarVariant.minimal,
      showLabels: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = _getNavigationItems();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: _getBottomBarHeight(),
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavigationItem(
                context,
                item,
                index,
                isSelected,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Build individual navigation item with spiritual design principles
  Widget _buildNavigationItem(
    BuildContext context,
    _NavigationItem item,
    int index,
    bool isSelected,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveSelectedColor = selectedItemColor ?? colorScheme.primary;
    final effectiveUnselectedColor =
        unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6);

    final color =
        isSelected ? effectiveSelectedColor : effectiveUnselectedColor;

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap(index);
          _navigateToRoute(context, item.route);
        },
        borderRadius: BorderRadius.circular(12.0),
        splashColor: effectiveSelectedColor.withValues(alpha: 0.1),
        highlightColor: effectiveSelectedColor.withValues(alpha: 0.05),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: showLabels ? 8.0 : 12.0,
            horizontal: 4.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gentle animation
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isSelected ? 6.0 : 4.0),
                decoration: isSelected
                    ? BoxDecoration(
                        color: effectiveSelectedColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      )
                    : null,
                child: Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  color: color,
                  size: 24.0,
                ),
              ),

              // Label with fade animation
              if (showLabels) ...[
                SizedBox(height: 4.0),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: color,
                    letterSpacing: 0.4,
                  ),
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Get navigation items based on variant
  List<_NavigationItem> _getNavigationItems() {
    switch (variant) {
      case CustomBottomBarVariant.main:
        return [
          _NavigationItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            route: '/home-dashboard-screen',
          ),
          _NavigationItem(
            icon: Icons.event_outlined,
            selectedIcon: Icons.event,
            label: 'Events',
            route: '/church-events-screen',
          ),
          _NavigationItem(
            icon: Icons.volunteer_activism_outlined,
            selectedIcon: Icons.volunteer_activism,
            label: 'Give',
            route: '/give-and-tithe-screen',
          ),
          _NavigationItem(
            icon: Icons.favorite_outline,
            selectedIcon: Icons.favorite,
            label: 'Prayer',
            route: '/prayer-requests-screen',
          ),
          _NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people,
            label: 'Members',
            route: '/member-directory-screen',
          ),
        ];

      case CustomBottomBarVariant.admin:
        return [
          _NavigationItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/home-dashboard-screen',
          ),
          _NavigationItem(
            icon: Icons.event_note_outlined,
            selectedIcon: Icons.event_note,
            label: 'Events',
            route: '/church-events-screen',
          ),
          _NavigationItem(
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet,
            label: 'Finance',
            route: '/give-and-tithe-screen',
          ),
          _NavigationItem(
            icon: Icons.group_outlined,
            selectedIcon: Icons.group,
            label: 'Members',
            route: '/member-directory-screen',
          ),
        ];

      case CustomBottomBarVariant.minimal:
        return [
          _NavigationItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            route: '/home-dashboard-screen',
          ),
          _NavigationItem(
            icon: Icons.event_outlined,
            selectedIcon: Icons.event,
            label: 'Events',
            route: '/church-events-screen',
          ),
          _NavigationItem(
            icon: Icons.favorite_outline,
            selectedIcon: Icons.favorite,
            label: 'Prayer',
            route: '/prayer-requests-screen',
          ),
        ];

      case CustomBottomBarVariant.primary:
      default:
        return [
          _NavigationItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            route: '/home-dashboard-screen',
          ),
          _NavigationItem(
            icon: Icons.event_outlined,
            selectedIcon: Icons.event,
            label: 'Events',
            route: '/church-events-screen',
          ),
          _NavigationItem(
            icon: Icons.volunteer_activism_outlined,
            selectedIcon: Icons.volunteer_activism,
            label: 'Give',
            route: '/give-and-tithe-screen',
          ),
          _NavigationItem(
            icon: Icons.people_outline,
            selectedIcon: Icons.people,
            label: 'Members',
            route: '/member-directory-screen',
          ),
        ];
    }
  }

  /// Get bottom bar height based on variant and label visibility
  double _getBottomBarHeight() {
    if (!showLabels) return 64.0;

    switch (variant) {
      case CustomBottomBarVariant.minimal:
        return 64.0;
      case CustomBottomBarVariant.main:
      case CustomBottomBarVariant.admin:
      case CustomBottomBarVariant.primary:
      default:
        return 80.0;
    }
  }

  /// Navigate to the specified route
  void _navigateToRoute(BuildContext context, String route) {
    // Only navigate if not already on the route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}

/// Enum defining different bottom bar variants
enum CustomBottomBarVariant {
  /// Primary bottom bar with essential features
  primary,

  /// Main bottom bar with full church features
  main,

  /// Admin bottom bar with management features
  admin,

  /// Minimal bottom bar with core features only
  minimal,
}

/// Internal class representing a navigation item
class _NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
