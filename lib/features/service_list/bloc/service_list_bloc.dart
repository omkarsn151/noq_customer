import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noq/core/api/api_exception.dart';
import 'package:noq/features/service_list/bloc/service_list_event.dart';
import 'package:noq/features/service_list/bloc/service_list_state.dart';
import 'package:noq/features/service_list/repository/service_list_repository.dart';

class ServiceListBloc extends Bloc<ServiceListEvent, ServiceListState> {
  final ServiceListRepository _repository;

  ServiceListBloc(this._repository) : super(const ServiceListState()) {
    on<ServiceListRequested>(_onRequested);
    on<ServiceListSectionOpened>(_onSectionOpened);
    on<ServiceListCartChanged>(_onCartChanged);
  }

  Future<void> _onRequested(
    ServiceListRequested event,
    Emitter<ServiceListState> emit,
  ) async {
    // Start from a clean state so another shop's sections never flash up.
    emit(
      ServiceListState(
        status: ServiceListStatus.loading,
        businessId: event.businessId,
      ),
    );

    try {
      final sections = await _repository.getSections(event.businessId);
      emit(
        state.copyWith(status: ServiceListStatus.success, sections: sections),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: _isBusinessNotFound(e)
              ? ServiceListStatus.notFound
              : ServiceListStatus.failure,
          message: _messageOf(e),
        ),
      );
    }
  }

  Future<void> _onSectionOpened(
    ServiceListSectionOpened event,
    Emitter<ServiceListState> emit,
  ) async {
    final id = event.subCategoryId;
    final cached = state.sectionServices[id];
    if (state.status != ServiceListStatus.success ||
        cached?.status == SectionServicesStatus.loading ||
        cached?.status == SectionServicesStatus.success) {
      return;
    }

    final businessId = state.businessId;
    emit(
      state.copyWith(
        sectionServices: {
          ...state.sectionServices,
          id: const SectionServices(status: SectionServicesStatus.loading),
        },
      ),
    );

    try {
      final section = await _repository.getSectionServices(
        businessId: businessId,
        subCategoryId: id,
      );
      // The screen moved on to another shop meanwhile — drop the result.
      if (state.businessId != businessId) return;
      emit(
        state.copyWith(
          sectionServices: {
            ...state.sectionServices,
            id: SectionServices(
              status: SectionServicesStatus.success,
              items: section.items,
            ),
          },
        ),
      );
    } catch (e) {
      if (state.businessId != businessId) return;
      if (_isBusinessNotFound(e)) {
        emit(
          state.copyWith(
            status: ServiceListStatus.notFound,
            message: _messageOf(e),
          ),
        );
      } else if (e is ApiException &&
          e.code == 'CUSTOMER_SUB_CATEGORY_NOT_FOUND') {
        // The section emptied or moved; reload the list instead of retrying.
        add(ServiceListRequested(businessId: businessId));
      } else {
        emit(
          state.copyWith(
            sectionServices: {
              ...state.sectionServices,
              id: SectionServices(
                status: SectionServicesStatus.failure,
                message: _messageOf(e),
              ),
            },
          ),
        );
      }
    }
  }

  /// Re-fetches every loaded section in the background. Sections keep their
  /// current items (no spinner) and keep them if a re-fetch fails.
  Future<void> _onCartChanged(
    ServiceListCartChanged event,
    Emitter<ServiceListState> emit,
  ) async {
    if (state.status != ServiceListStatus.success) return;

    final businessId = state.businessId;
    final loadedIds = [
      for (final entry in state.sectionServices.entries)
        if (entry.value.status == SectionServicesStatus.success) entry.key,
    ];

    await Future.wait(
      loadedIds.map((id) async {
        try {
          final section = await _repository.getSectionServices(
            businessId: businessId,
            subCategoryId: id,
          );
          if (state.businessId != businessId) return;
          emit(
            state.copyWith(
              sectionServices: {
                ...state.sectionServices,
                id: SectionServices(
                  status: SectionServicesStatus.success,
                  items: section.items,
                ),
              },
            ),
          );
        } catch (_) {
          // Keep the old rows; a pull-to-refresh will retry.
        }
      }),
    );
  }

  bool _isBusinessNotFound(Object error) =>
      error is ApiException && error.code == 'CUSTOMER_BUSINESS_NOT_FOUND';

  String _messageOf(Object error) =>
      error is ApiException ? error.message : error.toString();
}
