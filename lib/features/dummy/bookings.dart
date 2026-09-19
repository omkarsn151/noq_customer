import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/utils/app_assets.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/features/dummy/service_slot.dart';

enum _BookingStatus { pending, confirmed, completed, cancelled }

class _Booking {
  final String name;
  final String category;
  final String date;
  final String time;
  final _BookingStatus status;

  const _Booking({
    required this.name,
    required this.category,
    required this.date,
    required this.time,
    required this.status,
  });
}

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  int _selectedTab = 0;

  static const List<_Booking> _upcoming = [
    _Booking(
      name: 'Dentistry Dental',
      category: 'Teeth Alignment',
      date: 'Today',
      time: '4:00 Pm',
      status: _BookingStatus.confirmed,
    ),
    _Booking(
      name: 'Dr Diana Psychologist',
      category: 'General Session',
      date: 'Tomorrow',
      time: '6:00 Pm',
      status: _BookingStatus.pending,
    ),
  ];

  static const List<_Booking> _past = [
    _Booking(
      name: 'Sachin Sports & Turf',
      category: 'Cricket',
      date: 'Jun 09',
      time: '7:00 Pm',
      status: _BookingStatus.completed,
    ),
    _Booking(
      name: 'Cal Fitness',
      category: 'Yoga & Meditation',
      date: 'Jun 19',
      time: '7:00 Pm',
      status: _BookingStatus.completed,
    ),
    _Booking(
      name: 'Radiance & Elegance Studio',
      category: 'Haircuts, Make Up, Massage',
      date: 'May 28',
      time: '5:00 Pm',
      status: _BookingStatus.completed,
    ),
    _Booking(
      name: 'Urban Cuts Barbershop',
      category: 'Fades, Beard Trim, Kids Cuts',
      date: 'May 12',
      time: '3:00 Pm',
      status: _BookingStatus.completed,
    ),
  ];

  static const List<_Booking> _cancelled = [
    _Booking(
      name: 'Glow Beauty Lounge',
      category: 'Skincare, Nails, Waxing',
      date: 'Jun 02',
      time: '2:00 Pm',
      status: _BookingStatus.cancelled,
    ),
  ];

  List<_Booking> get _currentBookings {
    switch (_selectedTab) {
      case 1:
        return _past;
      case 2:
        return _cancelled;
      default:
        return _upcoming;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'Bookings', showLeading: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TabPill(
                  label: 'Upcoming',
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                SizedBox(width: 2.w),
                _TabPill(
                  label: 'Past',
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                SizedBox(width: 2.w),
                _TabPill(
                  label: 'Cancelled',
                  isSelected: _selectedTab == 2,
                  onTap: () => setState(() => _selectedTab = 2),
                ),
              ],
            ),
            SizedBox(height: 2.5.h),
            Expanded(
              child: ListView.separated(
                itemCount: _currentBookings.length,
                separatorBuilder: (_, __) => SizedBox(height: 2.h),
                itemBuilder: (context, index) =>
                    _BookingCard(booking: _currentBookings[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.pink,
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final _Booking booking;

  const _BookingCard({required this.booking});

  bool get _showMenu =>
      booking.status == _BookingStatus.pending ||
      booking.status == _BookingStatus.confirmed;

  void _onReschedule(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const ServiceSlot(isReschedule: true)),
    );
  }

  void _onCancel(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.sp),
                child: Image.asset(
                  AppAssets.businessThumbnail,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      booking.category,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showMenu)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textSecondary,
                  ),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.sp),
                  ),
                  color: Colors.white,
                  onSelected: (value) {
                    if (value == 'reschedule') {
                      _onReschedule(context);
                    } else if (value == 'cancel') {
                      _onCancel(context);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'reschedule',
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Reschedule Booking',
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(height: 1),
                    PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined,
                            size: 16.sp,
                            color: AppColors.error,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Cancel Booking',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Divider(height: 1, color: AppColors.borderLight),
          SizedBox(height: 1.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 1.5.w),
                  Text(
                    '${booking.date}, ${booking.time}',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              _StatusLabel(status: booking.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final _BookingStatus status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    late final IconData icon;
    late final Color color;
    late final String label;

    switch (status) {
      case _BookingStatus.pending:
        icon = Icons.access_time_rounded;
        color = AppColors.primary;
        label = 'Pending';
        break;
      case _BookingStatus.confirmed:
        icon = Icons.check_circle_rounded;
        color = AppColors.success;
        label = 'Confirmed';
        break;
      case _BookingStatus.completed:
        icon = Icons.check_circle_rounded;
        color = AppColors.blue;
        label = 'Completed';
        break;
      case _BookingStatus.cancelled:
        icon = Icons.cancel_rounded;
        color = AppColors.error;
        label = 'Cancelled';
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: color),
        SizedBox(width: 1.w),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
