import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../models/sermon_model.dart';

class RecentSermonCardWidget extends StatelessWidget {
  final SermonModel sermon;

  const RecentSermonCardWidget({
    Key? key,
    required this.sermon,
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
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.purple.shade600,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Sermon',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      sermon.title,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: Colors.grey.shade900,
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
          if (sermon.preacher != null) ...[
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.grey.shade600,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'By ${sermon.preacher}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
          ],
          if (sermon.scriptureReference != null) ...[
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: Colors.grey.shade600,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    sermon.scriptureReference!,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
          ],
          if (sermon.date != null) ...[
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey.shade600,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  sermon.formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (sermon.duration != null) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.access_time,
                    color: Colors.grey.shade600,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    sermon.duration!,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 2.h),
          ],
          if (sermon.description != null) ...[
            Text(
              sermon.description!,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              if (sermon.hasAudio)
                _buildMediaButton(
                  icon: Icons.headphones,
                  label: 'Audio',
                  color: Colors.blue,
                  onTap: () {
                    // Handle audio playback
                  },
                ),
              if (sermon.hasAudio && sermon.hasVideo) SizedBox(width: 3.w),
              if (sermon.hasVideo)
                _buildMediaButton(
                  icon: Icons.play_circle_fill,
                  label: 'Video',
                  color: Colors.red,
                  onTap: () {
                    // Handle video playback
                  },
                ),
              if ((sermon.hasAudio || sermon.hasVideo) && sermon.hasNotes)
                SizedBox(width: 3.w),
              if (sermon.hasNotes)
                _buildMediaButton(
                  icon: Icons.note,
                  label: 'Notes',
                  color: Colors.green,
                  onTap: () {
                    // Handle notes download
                  },
                ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Text(
                  sermon.displayCategory,
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: Colors.purple.shade700,
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

  Widget _buildMediaButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(color: color.withAlpha(77)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
