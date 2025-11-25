part of 'transaction_bloc.dart';

/// Estados de transacciones
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class TransactionInitial extends TransactionState {}

/// Cargando
class TransactionLoading extends TransactionState {}

/// Estado que contiene datos cargados (transacciones y/o balance)
class TransactionDataLoaded extends TransactionState {
  final List<Transaction>? transactions;
  final Map<String, double>? balance;

  const TransactionDataLoaded({
    this.transactions,
    this.balance,
  });

  /// Copia el estado con nuevos valores
  TransactionDataLoaded copyWith({
    List<Transaction>? transactions,
    Map<String, double>? balance,
  }) {
    return TransactionDataLoaded(
      transactions: transactions ?? this.transactions,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [transactions, balance];
}

/// Transacciones cargadas (mantiene compatibilidad)
class TransactionsLoaded extends TransactionDataLoaded {
  const TransactionsLoaded({required List<Transaction> transactions})
      : super(transactions: transactions);
}

/// Balance mensual cargado (mantiene compatibilidad)
class MonthlyBalanceLoaded extends TransactionDataLoaded {
  const MonthlyBalanceLoaded({required Map<String, double> balance})
      : super(balance: balance);
}

/// Operación exitosa
class TransactionOperationSuccess extends TransactionState {
  final String message;

  const TransactionOperationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error
class TransactionError extends TransactionState {
  final String message;

  const TransactionError({required this.message});

  @override
  List<Object?> get props => [message];
}
