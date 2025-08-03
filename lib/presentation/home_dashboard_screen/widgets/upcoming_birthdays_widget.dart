import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/member_model.dart';
import '../../../utils/date_utils.dart';

class UpcomingBirthdaysWidget extends StatelessWidget {
  final List<MemberModel> members;

  const UpcomingBirthdaysWidget({
    Key? key,
    required this.members,
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
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.cake,
                  color: Colors.pink.shade600,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Upcoming Birthdays',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          if (members.isEmpty) _buildEmptyState() else ..._buildBirthdaysList(),
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
            Icons.cake_outlined,
            color: Colors.grey.shade400,
            size: 8.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No birthdays this month',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Check back next month',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBirthdaysList() {
    return members.map((member) => _buildBirthdayItem(member)).toList();
  }

  Widget _buildBirthdayItem(MemberModel member) {
    final upcomingBirthday = member.dateOfBirth != null
        ? AppDateUtils.getUpcomingBirthday(member.dateOfBirth!)
        : null;

    final daysUntil = upcomingBirthday != null
        ? AppDateUtils.daysUntil(upcomingBirthday)
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(color: Colors.pink.shade100),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.pink.shade200, width: 2),
            ),
            child: ClipOval(
              child: member.profileImageUrl != null &&
                      member.profileImageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: member.profileImageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                          size: 6.w,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                          size: 6.w,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.person,
                        color: Colors.grey.shade400,
                        size: 6.w,
                      ),
                    ),
            ),
          ),

          SizedBox(width: 3.w),

          // Member Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullName,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  member.displayMinistry,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (member.dateOfBirth != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    'Age: ${AppDateUtils.calculateAge(member.dateOfBirth!)}',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Birthday Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (daysUntil != null) ...[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getBirthdayColor(daysUntil),
                    borderRadius: BorderRadius.circular(1.5.w),
                  ),
                  child: Text(
                    _getBirthdayText(daysUntil),
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
              ],
              if (member.dateOfBirth != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.pink.shade600,
                      size: 3.5.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '${member.dateOfBirth!.day}/${member.dateOfBirth!.month}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: Colors.pink.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBirthdayColor(int daysUntil) {
    if (daysUntil == 0) {
      return Colors.pink.shade600; // Today
    } else if (daysUntil <= 7) {
      return Colors.orange.shade600; // This week
    } else {
      return Colors.blue.shade600; // This month
    }
  }

  String _getBirthdayText(int daysUntil) {
    if (daysUntil == 0) {
      return 'TODAY!';
    } else if (daysUntil == 1) {
      return 'Tomorrow';
    } else if (daysUntil <= 7) {
      return 'In $daysUntil days';
    } else {
      return 'In $daysUntil days';
    }
  }
}
