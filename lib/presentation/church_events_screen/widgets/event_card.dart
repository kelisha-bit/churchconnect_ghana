import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EventCard extends StatefulWidget {
  final Map<String, dynamic> event;
  final Function(String eventId, String rsvpStatus) onRsvpChanged;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onRsvpChanged,
    required this.onTap,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  String? _currentRsvpStatus;

  @override
  void initState() {
    super.initState();
    _currentRsvpStatus = widget.event['userRsvpStatus'] as String?;
  }

  void _handleRsvpTap(String status) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentRsvpStatus = _currentRsvpStatus == status ? null : status;
    });
    widget.onRsvpChanged(
        widget.event['id'].toString(), _currentRsvpStatus ?? 'none');
  }

  @override
  Widget build(BuildContext context) {
    final eventDate = DateTime.parse(widget.event['date'] as String);
    final isLiveNow = widget.event['isLive'] as bool? ?? false;
    final isPastEvent = eventDate.isBefore(DateTime.now());
    final attendanceCount = widget.event['attendanceCount'] as int? ?? 0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image with Live Indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.0)),
                  child: CustomImageWidget(
                    imageUrl: widget.event['imageUrl'] as String,
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isLiveNow)
                  Positioned(
                    top: 2.h,
                    left: 3.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'LIVE NOW',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Event Details
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    widget.event['title'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Date and Time
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          DateFormat('EEEE, dd/MM/yyyy • HH:mm')
                              .format(eventDate),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  // Location
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          widget.event['location'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  // Attendance Count
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'people',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '$attendanceCount ${isPastEvent ? 'attended' : 'going'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // RSVP Buttons or Live Join Button
                  if (isLiveNow)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          // Handle join live event
                        },
                        icon: CustomIconWidget(
                          iconName: 'play_circle_filled',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        label: Text('Join Live'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    )
                  else if (!isPastEvent)
                    Row(
                      children: [
                        Expanded(
                          child: _buildRsvpButton(
                              'Going', 'check_circle', Colors.green),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child:
                              _buildRsvpButton('Maybe', 'help', Colors.orange),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: _buildRsvpButton(
                              'Can\'t Go', 'cancel', Colors.red),
                        ),
                      ],
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'photo_library',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'View Photos & Summary',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRsvpButton(String status, String iconName, Color color) {
    final isSelected = _currentRsvpStatus == status;

    return OutlinedButton.icon(
      onPressed: () => _handleRsvpTap(status),
      icon: CustomIconWidget(
        iconName: iconName,
        color: isSelected ? Colors.white : color,
        size: 16,
      ),
      label: Text(
        status,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: isSelected ? Colors.white : color,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.transparent,
        foregroundColor: isSelected ? Colors.white : color,
        side: BorderSide(color: color, width: 1.0),
        padding: EdgeInsets.symmetric(vertical: 0.8.h, horizontal: 1.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
