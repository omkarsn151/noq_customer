import 'package:flutter/material.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/features/dummy/payment.dart';
import 'package:sizer/sizer.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/common/app_button.dart';

class _DateOption {
  final String dayOfWeek;
  final String date;
  bool isSelected;

  _DateOption({
    required this.dayOfWeek,
    required this.date,
    this.isSelected = false,
  });
}

class _TimeSlot {
  final String time;
  bool isSelected;

  _TimeSlot({required this.time, this.isSelected = false});
}

class _Stylist {
  final String name;
  final String? imagePath;
  bool isSelected;

  _Stylist({required this.name, this.imagePath, this.isSelected = false});
}

class ServiceSlot extends StatefulWidget {
  final bool isReschedule;

  const ServiceSlot({super.key, this.isReschedule = false});

  @override
  State<ServiceSlot> createState() => _ServiceSlotState();
}

class _ServiceSlotState extends State<ServiceSlot> {
  late List<_DateOption> _dates;
  late List<_TimeSlot> _timeSlots;
  late List<_Stylist> _stylists;

  @override
  void initState() {
    super.initState();
    _dates = [
      _DateOption(dayOfWeek: 'Sun', date: '09'),
      _DateOption(dayOfWeek: 'Mon', date: '10', isSelected: true),
      _DateOption(dayOfWeek: 'Tue', date: '11'),
      _DateOption(dayOfWeek: 'Wed', date: '12'),
      _DateOption(dayOfWeek: 'Thu', date: '13'),
      _DateOption(dayOfWeek: 'Fri', date: '14'),
      _DateOption(dayOfWeek: 'Sat', date: '15'),
      _DateOption(dayOfWeek: 'Sun', date: '16'),
    ];

    _timeSlots = [
      _TimeSlot(time: '10:00 AM', isSelected: true),
      _TimeSlot(time: '10:30 AM'),
      _TimeSlot(time: '11:00 AM'),
      _TimeSlot(time: '11:30 AM'),
      _TimeSlot(time: '12:00 PM'),
      _TimeSlot(time: '12:30 PM'),
      _TimeSlot(time: '01:00 PM'),
      _TimeSlot(time: '01:30 PM'),
      _TimeSlot(time: '02:00 PM'),
      _TimeSlot(time: '02:30 PM'),
      _TimeSlot(time: '03:00 PM'),
      _TimeSlot(time: '03:30 PM'),
      _TimeSlot(time: '04:00 PM'),
      _TimeSlot(time: '04:30 PM'),
      _TimeSlot(time: '05:00 PM'),
    ];

    _stylists = [
      _Stylist(name: 'Anyone'),
      _Stylist(
        name: 'Mike',
        imagePath: 'assets/dummy/service_thumbnail.png',
        isSelected: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppAppBar(
        title: widget.isReschedule ? 'Reschedule Booking' : 'Service Slot',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select your date', style: textTheme.titleMedium),
              SizedBox(height: 1.5.h),
              SizedBox(
                height: 10.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _dates.length,
                  itemBuilder: (context, index) {
                    final date = _dates[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 1.5.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            for (var d in _dates) {
                              d.isSelected = false;
                            }
                            date.isSelected = true;
                          });
                        },
                        child: Container(
                          width: 12.w,
                          decoration: BoxDecoration(
                            color: date.isSelected
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              color: date.isSelected
                                  ? AppColors.primary
                                  : AppColors.borderLight,
                            ),
                            borderRadius: BorderRadius.circular(20.sp),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                date.dayOfWeek,
                                style: textTheme.bodySmall!.copyWith(
                                  color: date.isSelected
                                      ? AppColors.background
                                      : AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: date.isSelected
                                      ? AppColors.background
                                      : AppColors.borderLight.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                                child: Text(
                                  date.date,
                                  style: textTheme.bodySmall!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 3.h),
              Text('Select Availability Time', style: textTheme.titleMedium),
              SizedBox(height: 1.5.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 1.5.h,
                ),
                itemCount: _timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = _timeSlots[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        for (var s in _timeSlots) {
                          s.isSelected = false;
                        }
                        slot.isSelected = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: slot.isSelected
                            ? AppColors.primary
                            : Colors.white,
                        border: Border.all(
                          color: slot.isSelected
                              ? AppColors.primary
                              : AppColors.borderLight,
                        ),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: Center(
                        child: Text(
                          slot.time,
                          style: textTheme.bodySmall!.copyWith(
                            color: slot.isSelected
                                ? AppColors.background
                                : AppColors.primary,
                            fontWeight: FontWeight.w600    
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 3.h),
              Text('Select your staff', style: textTheme.titleMedium),
              SizedBox(height: 1.5.h),
              SizedBox(
                height: 14.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _stylists.length,
                  itemBuilder: (context, index) {
                    final stylist = _stylists[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            for (var s in _stylists) {
                              s.isSelected = false;
                            }
                            stylist.isSelected = true;
                          });
                        },
                        child: Container(
                          width: 28.w,
                          decoration: BoxDecoration(
                            color: AppColors.pink,
                            border: stylist.isSelected
                                ? Border.all(color: AppColors.primary)
                                : null,
                            borderRadius: BorderRadius.circular(14.sp),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (stylist.imagePath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    stylist.imagePath!,
                                    width: 15.w,
                                    height: 15.w,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: 24.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              SizedBox(height: 1.h),
                              Text(
                                stylist.name,
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 3.h),
              Divider(height: 1, color: AppColors.borderLight),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹450',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.4.h),
                      Text(
                        '3 Services - 90 Min',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 45.w,
                    height: 5.h,
                    child: AppButton(
                      label: widget.isReschedule
                          ? 'Reschedule'
                          : 'Proceed to Checkout',
                      onPressed: () {
                        if (widget.isReschedule) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Payment()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        textStyle: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
  }
}
