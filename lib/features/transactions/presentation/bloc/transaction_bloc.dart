import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/create_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_monthly_balance.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/get_transactions_by_type.dart';
import '../../domain/usecases/update_transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

/// Bloc de transacciones
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final GetTransactionsByType getTransactionsByType;
  final CreateTransaction createTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;
  final GetMonthlyBalance getMonthlyBalance;

  TransactionBloc({
    required this.getTransactions,
    required this.getTransactionsByType,
    required this.createTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.getMonthlyBalance,
  }) : super(TransactionInitial()) {
    on<LoadTransactionsRequested>(_onLoadTransactionsRequested);
    on<LoadTransactionsByTypeRequested>(_onLoadTransactionsByTypeRequested);
    on<CreateTransactionRequested>(_onCreateTransactionRequested);
    on<UpdateTransactionRequested>(_onUpdateTransactionRequested);
    on<DeleteTransactionRequested>(_onDeleteTransactionRequested);
    on<LoadMonthlyBalanceRequested>(_onLoadMonthlyBalanceRequested);
  }

  Future<void> _onLoadTransactionsRequested(
    LoadTransactionsRequested event,
    Emitter<TransactionState> emit,
  ) async {
    // No emitir loading si ya hay datos cargados
    if (state is! TransactionDataLoaded) {
      emit(TransactionLoading());
    }

    final result = await getTransactions(event.userId);
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) {
        // Mantener el balance si ya estaba cargado
        if (state is TransactionDataLoaded) {
          final currentState = state as TransactionDataLoaded;
          emit(currentState.copyWith(transactions: transactions));
        } else {
          emit(TransactionsLoaded(transactions: transactions));
        }
      },
    );
  }

  Future<void> _onLoadTransactionsByTypeRequested(
    LoadTransactionsByTypeRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await getTransactionsByType(
      userId: event.userId,
      type: event.type,
    );
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions: transactions)),
    );
  }

  Future<void> _onCreateTransactionRequested(
    CreateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await createTransaction(event.transaction);
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transaction) => emit(TransactionOperationSuccess(
        message: 'Transacción creada exitosamente',
      )),
    );
  }

  Future<void> _onUpdateTransactionRequested(
    UpdateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await updateTransaction(event.transaction);
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (transaction) => emit(TransactionOperationSuccess(
        message: 'Transacción actualizada exitosamente',
      )),
    );
  }

  Future<void> _onDeleteTransactionRequested(
    DeleteTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    final result = await deleteTransaction(event.transactionId);
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (_) => emit(TransactionOperationSuccess(
        message: 'Transacción eliminada exitosamente',
      )),
    );
  }

  Future<void> _onLoadMonthlyBalanceRequested(
    LoadMonthlyBalanceRequested event,
    Emitter<TransactionState> emit,
  ) async {
    final result = await getMonthlyBalance(
      userId: event.userId,
      year: event.year,
      month: event.month,
    );
    result.fold(
      (failure) => emit(TransactionError(message: failure.message)),
      (balance) {
        // Mantener las transacciones si ya estaban cargadas
        if (state is TransactionDataLoaded) {
          final currentState = state as TransactionDataLoaded;
          emit(currentState.copyWith(balance: balance));
        } else {
          emit(MonthlyBalanceLoaded(balance: balance));
        }
      },
    );
  }
}
