import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

/// Data Source remoto de transacciones
abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions(String userId);
  Future<List<TransactionModel>> getTransactionsByType(
    String userId,
    String type,
  );
  Future<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<TransactionModel> getTransactionById(String id);
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<Map<String, double>> getMonthlyBalance(String userId, int year, int month);
}

/// Implementación del Data Source remoto con Supabase
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final SupabaseClient supabaseClient;

  TransactionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TransactionModel>> getTransactions(String userId) async {
    try {
      final response = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: false)
          .limit(100);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener transacciones: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByType(
    String userId,
    String type,
  ) async {
    try {
      final response = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .eq('type', type)
          .order('date', ascending: false)
          .limit(100);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener transacciones por tipo: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startDateStr = startDate.toIso8601String().split('T')[0];
      final endDateStr = endDate.toIso8601String().split('T')[0];

      final response = await supabaseClient
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .gte('date', startDateStr)
          .lte('date', endDateStr)
          .order('date', ascending: false);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener transacciones por rango de fechas: $e');
    }
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final response = await supabaseClient
          .from('transactions')
          .select()
          .eq('id', id)
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener transacción: $e');
    }
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await supabaseClient
          .from('transactions')
          .insert(transaction.toInsertJson())
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear transacción: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final response = await supabaseClient
          .from('transactions')
          .update(transaction.toUpdateJson())
          .eq('id', transaction.id)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar transacción: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await supabaseClient.from('transactions').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar transacción: $e');
    }
  }

  @override
  Future<Map<String, double>> getMonthlyBalance(
    String userId,
    int year,
    int month,
  ) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final transactions = await getTransactionsByDateRange(
        userId,
        startDate,
        endDate,
      );

      double totalIncome = 0;
      double totalExpense = 0;

      for (final transaction in transactions) {
        if (transaction.type == 'income') {
          totalIncome += transaction.amount;
        } else {
          totalExpense += transaction.amount;
        }
      }

      return {
        'income': totalIncome,
        'expense': totalExpense,
        'balance': totalIncome - totalExpense,
      };
    } catch (e) {
      throw Exception('Error al obtener balance mensual: $e');
    }
  }
}
