import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../models/event_model.dart';
import '../../../utils/date_utils.dart';

class UpcomingServiceCardWidget extends StatelessWidget {
  final EventModel event;

  const UpcomingServiceCardWidget({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
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
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.event,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Service',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.white.withAlpha(230),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      event.title,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.calendar_today,
                text: AppDateUtils.getRelativeDateString(event.eventDate),
              ),
              SizedBox(width: 3.w),
              if (event.startTime != null)
                _buildInfoChip(
                  icon: Icons.access_time,
                  text: event.startTime!,
                ),
            ],
          ),
          if (event.location != null) ...[
            SizedBox(height: 2.h),
            _buildInfoChip(
              icon: Icons.location_on,
              text: event.location!,
            ),
          ],
          if (event.description != null) ...[
            SizedBox(height: 2.h),
            Text(
              event.description!,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: Colors.white.withAlpha(230),
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (event.registrationRequired)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade600,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    'Registration Required',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                const SizedBox(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(color: Colors.white.withAlpha(77)),
                ),
                child: Text(
                  event.displayType,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.white,
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

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(1.5.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 4.w,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
