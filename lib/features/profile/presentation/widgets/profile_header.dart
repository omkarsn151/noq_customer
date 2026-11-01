import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/profile/bloc/profile_bloc.dart';
import 'package:noq/features/profile/bloc/profile_event.dart';
import 'package:noq/features/profile/bloc/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state is ProfileLoaded ? state.profile : null;
        final name = profile?.fullName;
        final photoUrl = profile?.photoUrl;

        // Everything shown comes from the API; nothing is filled in while it
        // loads, and a failure shows the server's message with a retry.
        final String? subtitle = switch (state) {
          ProfileLoaded(:final profile) => profile.phone,
          ProfileFailure(:final message) => message,
          _ => null,
        };

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 8.w,
                backgroundColor: AppColors.primary,
                foregroundImage: (photoUrl == null || photoUrl.isEmpty)
                    ? null
                    : NetworkImage(photoUrl),
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 22.sp,
                  color: AppColors.background,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: GestureDetector(
                  onTap: state is ProfileFailure
                      ? () => context.read<ProfileBloc>().add(
                          const ProfileRequested(),
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (name != null && name.isNotEmpty)
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      if (state is ProfileFailure)
                        Text(
                          'Tap to retry',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.edit_outlined,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
