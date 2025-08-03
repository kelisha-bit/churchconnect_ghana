import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search members...',
    this.onChanged,
    this.onFilterTap,
    this.showFilter = true,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            _controller.clear();
                            widget.onChanged?.call('');
                            _focusNode.unfocus();
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              size: 5.w,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 3.h,
                  ),
                ),
              ),
            ),
          ),
          if (widget.showFilter) ...[
            SizedBox(width: 3.w),
            InkWell(
              onTap: widget.onFilterTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'tune',
                    color: colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
