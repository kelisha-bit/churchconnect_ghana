import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Sacred Minimalism design principles
/// for church management application with welcoming reverence
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button)
  final Widget? leading;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (uses theme if not specified)
  final Color? backgroundColor;

  /// Custom foreground color (uses theme if not specified)
  final Color? foregroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether to show a subtle bottom border instead of shadow
  final bool showBorder;

  /// App bar variant for different contexts
  final CustomAppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.showBorder = false,
    this.variant = CustomAppBarVariant.primary,
  });

  /// Factory constructor for home screen app bar with spiritual greeting
  factory CustomAppBar.home({
    Key? key,
    String title = "Grace Fellowship",
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      variant: CustomAppBarVariant.home,
      actions: actions ??
          [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  // Navigate to notifications
                },
                tooltip: 'Notifications',
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, '/member-directory-screen');
                },
                tooltip: 'Profile',
              ),
            ),
          ],
    );
  }

  /// Factory constructor for secondary screens with contextual actions
  factory CustomAppBar.secondary({
    Key? key,
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      variant: CustomAppBarVariant.secondary,
      showBackButton: showBackButton,
      actions: actions,
    );
  }

  /// Factory constructor for minimal app bar with border instead of shadow
  factory CustomAppBar.minimal({
    Key? key,
    required String title,
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    return CustomAppBar(
      key: key,
      title: title,
      variant: CustomAppBarVariant.minimal,
      showBackButton: showBackButton,
      actions: actions,
      elevation: 0.0,
      showBorder: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant and theme
    Color effectiveBackgroundColor;
    Color effectiveForegroundColor;

    switch (variant) {
      case CustomAppBarVariant.home:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case CustomAppBarVariant.secondary:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case CustomAppBarVariant.minimal:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case CustomAppBarVariant.primary:
      default:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
    }

    return Container(
      decoration: showBorder
          ? BoxDecoration(
              color: effectiveBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.12),
                  width: 1.0,
                ),
              ),
            )
          : null,
      child: AppBar(
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: _getTitleFontSize(),
            fontWeight: FontWeight.w600,
            color: effectiveForegroundColor,
            letterSpacing: 0.15,
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor:
            showBorder ? Colors.transparent : effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
        elevation: elevation,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        leading: _buildLeading(context, effectiveForegroundColor),
        actions: _buildActions(context),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
          statusBarBrightness: theme.brightness,
        ),
      ),
    );
  }

  /// Build the leading widget with proper navigation handling
  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    final shouldShowBack = showBackButton ?? Navigator.of(context).canPop();
    if (!shouldShowBack) return null;

    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: foregroundColor,
        size: 20,
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      tooltip: 'Back',
      splashRadius: 24,
    );
  }

  /// Build action widgets with proper spacing and interaction
  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: action,
        );
      }
      return action;
    }).toList();
  }

  /// Get title font size based on variant
  double _getTitleFontSize() {
    switch (variant) {
      case CustomAppBarVariant.home:
        return 22.0;
      case CustomAppBarVariant.secondary:
        return 20.0;
      case CustomAppBarVariant.minimal:
        return 18.0;
      case CustomAppBarVariant.primary:
      default:
        return 20.0;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

/// Enum defining different app bar variants for various contexts
enum CustomAppBarVariant {
  /// Primary app bar for main screens
  primary,

  /// Home app bar with spiritual branding
  home,

  /// Secondary app bar for detail screens
  secondary,

  /// Minimal app bar with border instead of shadow
  minimal,
}
