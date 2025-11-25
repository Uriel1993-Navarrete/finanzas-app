import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_to_savings_plan.dart';
import '../../domain/usecases/complete_savings_plan.dart';
import '../../domain/usecases/create_savings_plan.dart';
import '../../domain/usecases/delete_savings_plan.dart';
import '../../domain/usecases/get_savings_plans.dart';
import '../../domain/usecases/update_savings_plan.dart';
import 'savings_plan_event.dart';
import 'savings_plan_state.dart';

/// Bloc para gestionar los planes de ahorro
class SavingsPlanBloc extends Bloc<SavingsPlanEvent, SavingsPlanState> {
  final GetSavingsPlans getSavingsPlans;
  final GetActiveSavingsPlans getActiveSavingsPlans;
  final CreateSavingsPlan createSavingsPlan;
  final UpdateSavingsPlan updateSavingsPlan;
  final DeleteSavingsPlan deleteSavingsPlan;
  final AddToSavingsPlan addToSavingsPlan;
  final CompleteSavingsPlan completeSavingsPlan;

  SavingsPlanBloc({
    required this.getSavingsPlans,
    required this.getActiveSavingsPlans,
    required this.createSavingsPlan,
    required this.updateSavingsPlan,
    required this.deleteSavingsPlan,
    required this.addToSavingsPlan,
    required this.completeSavingsPlan,
  }) : super(SavingsPlanInitial()) {
    on<LoadSavingsPlansRequested>(_onLoadSavingsPlansRequested);
    on<LoadActiveSavingsPlansRequested>(_onLoadActiveSavingsPlansRequested);
    on<CreateSavingsPlanRequested>(_onCreateSavingsPlanRequested);
    on<UpdateSavingsPlanRequested>(_onUpdateSavingsPlanRequested);
    on<DeleteSavingsPlanRequested>(_onDeleteSavingsPlanRequested);
    on<AddToSavingsPlanRequested>(_onAddToSavingsPlanRequested);
    on<CompleteSavingsPlanRequested>(_onCompleteSavingsPlanRequested);
  }

  Future<void> _onLoadSavingsPlansRequested(
    LoadSavingsPlansRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await getSavingsPlans(event.userId);

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (savingsPlans) => emit(SavingsPlansLoaded(savingsPlans: savingsPlans)),
    );
  }

  Future<void> _onLoadActiveSavingsPlansRequested(
    LoadActiveSavingsPlansRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await getActiveSavingsPlans(event.userId);

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (savingsPlans) => emit(SavingsPlansLoaded(savingsPlans: savingsPlans)),
    );
  }

  Future<void> _onCreateSavingsPlanRequested(
    CreateSavingsPlanRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await createSavingsPlan(event.savingsPlan);

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (savingsPlan) => emit(SavingsPlanOperationSuccess(
        message: 'Plan de ahorro creado exitosamente',
        savingsPlan: savingsPlan,
      )),
    );
  }

  Future<void> _onUpdateSavingsPlanRequested(
    UpdateSavingsPlanRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await updateSavingsPlan(event.savingsPlan);

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (savingsPlan) => emit(SavingsPlanOperationSuccess(
        message: 'Plan de ahorro actualizado exitosamente',
        savingsPlan: savingsPlan,
      )),
    );
  }

  Future<void> _onDeleteSavingsPlanRequested(
    DeleteSavingsPlanRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await deleteSavingsPlan(event.planId);

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (_) => emit(const SavingsPlanOperationSuccess(
        message: 'Plan de ahorro eliminado exitosamente',
      )),
    );
  }

  Future<void> _onAddToSavingsPlanRequested(
    AddToSavingsPlanRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await addToSavingsPlan(
      planId: event.planId,
      amount: event.amount,
      note: event.note,
    );

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (savingsPlan) => emit(SavingsPlanOperationSuccess(
        message: 'Dinero agregado al plan exitosamente',
        savingsPlan: savingsPlan,
      )),
    );
  }

  Future<void> _onCompleteSavingsPlanRequested(
    CompleteSavingsPlanRequested event,
    Emitter<SavingsPlanState> emit,
  ) async {
    emit(SavingsPlanLoading());

    final result = await completeSavingsPlan(event.planId);

    result.fold(
      (failure) => emit(SavingsPlanError(message: failure.message)),
      (savingsPlan) => emit(SavingsPlanOperationSuccess(
        message: 'Plan de ahorro completado',
        savingsPlan: savingsPlan,
      )),
    );
  }
}
