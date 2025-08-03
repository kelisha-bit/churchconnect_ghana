import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EventSearchBar extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback? onClearSearch;

  const EventSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    this.onClearSearch,
  });

  @override
  State<EventSearchBar> createState() => _EventSearchBarState();
}

class _EventSearchBarState extends State<EventSearchBar> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search events by name or description...',
          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.5),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
              size: 20,
            ),
          ),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _searchController.clear();
                    widget.onSearchChanged('');
                    if (widget.onClearSearch != null) {
                      widget.onClearSearch!();
                    }
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        ),
        style: AppTheme.lightTheme.textTheme.bodyMedium,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          _focusNode.unfocus();
        },
      ),
    );
  }
}
