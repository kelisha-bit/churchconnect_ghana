import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({super.key});

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Skeleton
                    Container(
                      width: double.infinity,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: _animation.value),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.0)),
                      ),
                    ),

                    // Content Skeleton
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Skeleton
                          Container(
                            width: 70.w,
                            height: 2.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),

                          SizedBox(height: 1.h),

                          // Subtitle Skeleton
                          Container(
                            width: 50.w,
                            height: 1.5.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme
                                  .surfaceContainerHighest
                                  .withValues(alpha: _animation.value),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),

                          SizedBox(height: 2.h),

                          // Details Skeleton
                          Row(
                            children: [
                              Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: _animation.value),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 40.w,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: _animation.value),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 1.h),

                          Row(
                            children: [
                              Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: _animation.value),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 35.w,
                                height: 1.5.h,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: _animation.value),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 2.h),

                          // Buttons Skeleton
                          Row(
                            children: List.generate(
                                3,
                                (buttonIndex) => Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: buttonIndex < 2 ? 2.w : 0),
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          color: AppTheme.lightTheme.colorScheme
                                              .surfaceContainerHighest
                                              .withValues(
                                                  alpha: _animation.value),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
