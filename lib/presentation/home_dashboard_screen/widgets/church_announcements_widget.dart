import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../models/event_model.dart';
import '../../../utils/date_utils.dart';

class ChurchAnnouncementsWidget extends StatelessWidget {
  final List<EventModel> events;

  const ChurchAnnouncementsWidget({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.campaign,
                  color: Colors.orange.shade600,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Church Announcements',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (events.isEmpty)
            _buildEmptyState()
          else
            ..._buildAnnouncementsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_note,
            color: Colors.grey.shade400,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No upcoming announcements',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Check back later for updates',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnnouncementsList() {
    return events.map((event) => _buildAnnouncementItem(event)).toList();
  }

  Widget _buildAnnouncementItem(EventModel event) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 3.w,
                height: 3.w,
                decoration: BoxDecoration(
                  color: _getEventColor(event.eventType),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey.shade600,
                          size: 3.5.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          AppDateUtils.getRelativeDateString(event.eventDate),
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (event.startTime != null) ...[
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey.shade600,
                            size: 3.5.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            event.startTime!,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (event.location != null) ...[
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey.shade600,
                            size: 3.5.w,
                          ),
                          SizedBox(width: 1.w),
                          Expanded(
                            child: Text(
                              event.location!,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.description != null) ...[
                      SizedBox(height: 1.h),
                      Text(
                        event.description!,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getEventColor(event.eventType).withAlpha(26),
                  borderRadius: BorderRadius.circular(1.5.w),
                ),
                child: Text(
                  event.displayType,
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    color: _getEventColor(event.eventType),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (event.registrationRequired)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(1.5.w),
                  ),
                  child: Text(
                    'Registration Required',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'service':
        return Colors.blue;
      case 'bible_study':
        return Colors.green;
      case 'prayer':
        return Colors.purple;
      case 'fellowship':
        return Colors.orange;
      case 'conference':
        return Colors.red;
      case 'workshop':
        return Colors.teal;
      case 'outreach':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
