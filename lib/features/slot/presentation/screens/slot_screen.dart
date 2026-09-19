import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/common/app_appbar.dart';
import 'package:noq/core/common/app_button.dart';
import 'package:noq/core/utils/app_colors.dart';
import 'package:noq/core/utils/date_time_utils.dart';
import 'package:noq/features/dummy/payment.dart';
import 'package:noq/features/slot/bloc/slot_bloc.dart';
import 'package:noq/features/slot/bloc/slot_event.dart';
import 'package:noq/features/slot/bloc/slot_state.dart';
import 'package:noq/features/slot/data/slot_math.dart';
import 'package:noq/features/slot/data/slot_model.dart';
import 'package:noq/features/slot/repository/slot_repository.dart';
import 'package:sizer/sizer.dart';

class SlotScreen extends StatelessWidget {
  final String businessId;

  const SlotScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SlotBloc>(
      create: (_) => SlotBloc(SlotRepository())..add(SlotRequested(businessId)),
      child: const _SlotView(),
    );
  }
}

class _SlotView extends StatelessWidget {
  const _SlotView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlotBloc, SlotState>(
      builder: (context, state) {
        final businessName = state is SlotLoaded
            ? state.model.business.name
            : null;

        return Scaffold(
          appBar: AppAppBar(
            title: 'Service Slot',
            subtitle: (businessName?.isEmpty ?? true) ? null : businessName,
          ),
          body: switch (state) {
            SlotFailure() => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            SlotLoaded() => _SlotContent(state: state),
            _ => const Center(child: CircularProgressIndicator()),
          },
        );
      },
    );
  }
}

class _SlotContent extends StatelessWidget {
  final SlotLoaded state;

  const _SlotContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select your date', style: textTheme.titleMedium),
            SizedBox(height: 1.5.h),
            _DateStrip(state: state),
            SizedBox(height: 3.h),
            Text('Select Availability Time', style: textTheme.titleMedium),
            if (state.requiredSlots > 1) ...[
              SizedBox(height: 0.5.h),
              Text(
                'This visit needs ${state.requiredSlots} back-to-back slots',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            SizedBox(height: 1.5.h),
            _TimeSection(state: state),
            if (state.model.staffMembers.isNotEmpty) ...[
              SizedBox(height: 3.h),
              Text('Select your staff', style: textTheme.titleMedium),
              SizedBox(height: 1.5.h),
              _StaffStrip(state: state),
            ],
            SizedBox(height: 3.h),
            Divider(height: 1, color: AppColors.borderLight),
            SizedBox(height: 2.h),
            _SlotFooter(state: state),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }
}

class _DateStrip extends StatelessWidget {
  final SlotLoaded state;

  const _DateStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dates = state.model.window.dates;

    return SizedBox(
      height: 10.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.date == state.selectedDate;

          final Color background;
          final Color borderColor;
          final Color labelColor;
          if (isSelected) {
            background = AppColors.primary;
            borderColor = AppColors.primary;
            labelColor = AppColors.background;
          } else if (date.isClosed) {
            background = AppColors.borderLight.withValues(alpha: 0.3);
            borderColor = AppColors.borderLight;
            labelColor = AppColors.textSecondary;
          } else {
            background = AppColors.background;
            borderColor = AppColors.borderLight;
            labelColor = AppColors.textSecondary;
          }

          return Padding(
            padding: EdgeInsets.only(right: 1.5.w),
            child: GestureDetector(
              onTap: () => context.read<SlotBloc>().add(SlotDateSelected(date)),
              child: Container(
                width: 12.w,
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(20.sp),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      date.weekday,
                      style: textTheme.bodySmall!.copyWith(color: labelColor),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.background
                            : AppColors.borderLight.withValues(alpha: 0.5),
                      ),
                      child: Text(date.dayNumber, style: textTheme.bodySmall!),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeSection extends StatelessWidget {
  final SlotLoaded state;

  const _TimeSection({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isDayClosed) {
      return const _TimeMessage(message: 'Business is closed on this day');
    }

    if (state.isTimesLoading) {
      return SizedBox(
        height: 20.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.timesError != null) {
      return _TimeMessage(
        message: state.timesError!,
        onRetry: () {
          final date = state.model.window.dates.firstWhere(
            (d) => d.date == state.selectedDate,
            orElse: () => SlotDate(
              date: state.selectedDate,
              weekday: '',
              isToday: false,
              isClosed: false,
            ),
          );
          context.read<SlotBloc>().add(SlotDateSelected(date));
        },
      );
    }

    if (state.model.times.isEmpty) {
      return const _TimeMessage(message: 'No slots available for this day');
    }

    return _TimeGrid(state: state);
  }
}

class _TimeMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _TimeMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 10.h,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _TimeGrid extends StatelessWidget {
  final SlotLoaded state;

  const _TimeGrid({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final times = state.model.times;
    final requiredSlots = state.requiredSlots;
    final blockMinutes = state.blockMinutes;
    final selectedIndexes = state.selectedIndexes;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 1.5.h,
      ),
      itemCount: times.length,
      itemBuilder: (context, index) {
        final slot = times[index];
        final isSelected = selectedIndexes.contains(index);
        // A chip is tappable only if a full run can start here, or it is
        // already in the selected run (tap to clear the whole run).
        final canStart = canStartRunAt(
          times,
          index,
          requiredSlots,
          blockMinutes,
        );
        final isTappable = canStart || isSelected;

        final Color background;
        final Color borderColor;
        final Color labelColor;
        if (isSelected) {
          background = AppColors.primary;
          borderColor = AppColors.primary;
          labelColor = AppColors.background;
        } else if (!isTappable) {
          // `full`, `past`, end-of-day and pre-lunch-gap chips all land here
          // once the cart needs a run.
          background = AppColors.borderLight.withValues(alpha: 0.3);
          borderColor = AppColors.borderLight;
          labelColor = AppColors.textSecondary;
        } else {
          background = AppColors.background;
          borderColor = AppColors.borderLight;
          labelColor = AppColors.primary;
        }

        return GestureDetector(
          onTap: isTappable
              ? () => context.read<SlotBloc>().add(
                  isSelected
                      ? const SlotSelectionCleared()
                      : SlotRunSelected(slot.start),
                )
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Center(
              child: Text(
                DateTimeUtils.formatSlotTime(slot.start),
                style: textTheme.bodySmall!.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StaffStrip extends StatelessWidget {
  final SlotLoaded state;

  const _StaffStrip({required this.state});

  @override
  Widget build(BuildContext context) {
    final members = state.model.staffMembers;

    return SizedBox(
      height: 14.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        // Index 0 is the synthetic "Anyone" option; the API only returns
        // the concrete members.
        itemCount: members.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _StaffCard(
              name: 'Anyone',
              photoUrl: '',
              isSelected: state.selectedStaffId == null,
              onTap: () =>
                  context.read<SlotBloc>().add(const SlotStaffSelected(null)),
            );
          }

          final member = members[index - 1];
          return _StaffCard(
            name: member.name,
            photoUrl: member.photoUrl,
            isSelected: state.selectedStaffId == member.id,
            onTap: () =>
                context.read<SlotBloc>().add(SlotStaffSelected(member.id)),
          );
        },
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final String name;
  final String photoUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _StaffCard({
    required this.name,
    required this.photoUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(right: 2.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28.w,
          decoration: BoxDecoration(
            color: AppColors.pink,
            border: isSelected ? Border.all(color: AppColors.primary) : null,
            borderRadius: BorderRadius.circular(14.sp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (photoUrl.isEmpty)
                _StaffPlaceholder()
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    photoUrl,
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _StaffPlaceholder(),
                  ),
                ),
              SizedBox(height: 1.h),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15.w,
      height: 15.w,
      child: Icon(
        Icons.person_outline_rounded,
        size: 24.sp,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _SlotFooter extends StatelessWidget {
  final SlotLoaded state;

  const _SlotFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final summary = state.model.summary;
    final symbol = summary.currencyCode == 'INR'
        ? '₹'
        : '${summary.currencyCode} ';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$symbol${summary.totalPayable}',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 0.4.h),
            Text(
              '${summary.servicesCount} Services - ${summary.totalDurationMinutes} Min',
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
            label: 'Proceed to Checkout',
            onPressed: state.selectedStarts.length == state.requiredSlots
                ? () {
                    // TODO(booking API): POST state.selectedStarts as UTC
                    // ISO-8601, in order; the first is the start of the visit.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Payment()),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              textStyle: textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
