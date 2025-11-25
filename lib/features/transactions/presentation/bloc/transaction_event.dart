part of 'transaction_bloc.dart';

/// Eventos de transacciones
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Cargar todas las transacciones
class LoadTransactionsRequested extends TransactionEvent {
  final String userId;

  const LoadTransactionsRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Cargar transacciones por tipo
class LoadTransactionsByTypeRequested extends TransactionEvent {
  final String userId;
  final String type;

  const LoadTransactionsByTypeRequested({
    required this.userId,
    required this.type,
  });

  @override
  List<Object?> get props => [userId, type];
}

/// Crear transacción
class CreateTransactionRequested extends TransactionEvent {
  final Transaction transaction;

  const CreateTransactionRequested({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Actualizar transacción
class UpdateTransactionRequested extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransactionRequested({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

/// Eliminar transacción
class DeleteTransactionRequested extends TransactionEvent {
  final String transactionId;

  const DeleteTransactionRequested({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

/// Cargar balance mensual
class LoadMonthlyBalanceRequested extends TransactionEvent {
  final String userId;
  final int year;
  final int month;

  const LoadMonthlyBalanceRequested({
    required this.userId,
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [userId, year, month];
}
