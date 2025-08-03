import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalendarView extends StatefulWidget {
  final List<Map<String, dynamic>> events;
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  const CalendarView({
    super.key,
    required this.events,
    required this.onDateSelected,
    required this.selectedDate,
  });

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      child: Column(
        children: [
          // Calendar Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'chevron_left',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_currentMonth),
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Days of Week Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          SizedBox(height: 1.h),

          // Calendar Grid
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentMonth = DateTime(
                      _currentMonth.year, _currentMonth.month + (index - 0));
                });
              },
              itemBuilder: (context, pageIndex) {
                final monthToShow = DateTime(
                    _currentMonth.year, _currentMonth.month + pageIndex);
                return _buildCalendarGrid(monthToShow);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstDayWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final eventsOnDay = _getEventsForDate(date);
      final isSelected = _isSameDay(date, widget.selectedDate);
      final isToday = _isSameDay(date, DateTime.now());

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onDateSelected(date);
          },
          child: Container(
            margin: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : isToday
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border: isToday && !isSelected
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 1.0,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : isToday
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected || isToday
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                SizedBox(height: 0.2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildEventDots(eventsOnDay.length, isSelected),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GridView.count(
        crossAxisCount: 7,
        children: dayWidgets,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  List<Widget> _buildEventDots(int eventCount, bool isSelected) {
    if (eventCount == 0) return [SizedBox(height: 4)];

    final dotsToShow = eventCount > 3 ? 3 : eventCount;
    final dots = <Widget>[];

    for (int i = 0; i < dotsToShow; i++) {
      dots.add(
        Container(
          width: 4,
          height: 4,
          margin: EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    if (eventCount > 3) {
      dots.add(
        Text(
          '+',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.onPrimary
                : AppTheme.lightTheme.colorScheme.primary,
            fontSize: 8.sp,
          ),
        ),
      );
    }

    return dots;
  }

  List<Map<String, dynamic>> _getEventsForDate(DateTime date) {
    return widget.events.where((event) {
      final eventDate = DateTime.parse(event['date'] as String);
      return _isSameDay(eventDate, date);
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
