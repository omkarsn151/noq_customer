import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:noq/features/slot/bloc/slot_state.dart';
import 'package:noq/features/slot/data/slot_model.dart';
import 'package:noq/features/slot/presentation/widgets/slot_content.dart';

/// Placeholder slot picker shaped like the loaded one while slots load.
class SlotsLoadingWidget extends StatelessWidget {
  final bool isReschedule;

  const SlotsLoadingWidget({super.key, this.isReschedule = false});

  static final SlotLoaded _placeholder = _buildPlaceholder();

  static SlotLoaded _buildPlaceholder() {
    const blockMinutes = 30;
    final dayStart = DateTime(2000, 1, 1, 9);

    return SlotLoaded(
      selectedDate: '',
      model: SlotModel(
        business: const SlotBusiness(
          id: '',
          name: '',
          operations: SlotOperations(
            blockMinutes: blockMinutes,
            bufferMinutes: 0,
            bookingLimitPerSlot: 0,
            bookingWindowDays: 0,
            cancellationCutoffHours: 0,
            lateCancellationFeePercent: '0',
            autoApproveEnabled: false,
          ),
        ),
        window: SlotWindow(
          timezone: '',
          selectedDate: '',
          dates: [
            for (var i = 1; i <= 7; i++)
              SlotDate(
                date: '2000-01-0$i',
                weekday: 'Mon',
                isToday: false,
                isClosed: false,
              ),
          ],
        ),
        times: [
          for (var i = 0; i < 12; i++)
            SlotTime(
              start: dayStart.add(Duration(minutes: i * blockMinutes)),
              end: dayStart.add(Duration(minutes: (i + 1) * blockMinutes)),
              status: 'available',
            ),
        ],
        staffMembers: const [],
        summary: const SlotSummary(
          currencyCode: 'INR',
          totalPayable: '000.00',
          servicesCount: 1,
          totalDurationMinutes: blockMinutes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: SlotContent(state: _placeholder, isReschedule: isReschedule),
    );
  }
}
