import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/profile/presentation/widgets/profile_header.dart';
import 'package:noq/features/profile/presentation/widgets/profile_section_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: 2.h);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              const ProfileHeader(),
              SizedBox(height: 2.5.h),
              ProfileSectionCard(
                title: 'Activities',
                items: [
                  ProfileMenuItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Bookings',
                    onTap: () => context.go('/bookings'),
                  ),
                  const ProfileMenuItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Favorites',
                  ),
                ],
              ),
              gap,
              const ProfileSectionCard(
                title: 'Account',
                items: [
                  ProfileMenuItem(
                    icon: Icons.credit_card_rounded,
                    label: 'My Payments',
                  ),
                ],
              ),
              gap,
              const ProfileSectionCard(
                title: 'Preferences',
                items: [
                  ProfileMenuItem(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                  ),
                ],
              ),
              gap,
              const ProfileSectionCard(
                title: 'Support',
                items: [
                  ProfileMenuItem(
                    icon: Icons.headphones_rounded,
                    label: 'Contact Us',
                  ),
                  ProfileMenuItem(
                    icon: Icons.star_outline_rounded,
                    label: 'Rate App',
                  ),
                ],
              ),
              gap,
              ProfileSectionCard(
                title: 'About',
                items: [
                  const ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    label: 'FAQs',
                  ),
                  ProfileMenuItem(
                    icon: Icons.article_outlined,
                    label: 'Terms & conditions',
                    onTap: () => context.push('/tnc'),
                  ),
                ],
              ),
              gap,
              const ProfileSectionCard(
                title: 'Application',
                items: [
                  ProfileMenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    color: AppColors.error,
                    showChevron: false,
                  ),
                ],
              ),
              gap,
            ],
          ),
        ),
      ),
    );
  }
}
