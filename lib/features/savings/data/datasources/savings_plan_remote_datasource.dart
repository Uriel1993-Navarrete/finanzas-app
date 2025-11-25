import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/savings_plan_model.dart';

/// Fuente de datos remota para planes de ahorro (Supabase)
abstract class SavingsPlanRemoteDataSource {
  Future<List<SavingsPlanModel>> getSavingsPlans(String userId);
  Future<List<SavingsPlanModel>> getActiveSavingsPlans(String userId);
  Future<SavingsPlanModel> getSavingsPlanById(String id);
  Future<SavingsPlanModel> createSavingsPlan(SavingsPlanModel savingsPlan);
  Future<SavingsPlanModel> updateSavingsPlan(SavingsPlanModel savingsPlan);
  Future<void> deleteSavingsPlan(String id);
  Future<SavingsPlanModel> addToSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  });
  Future<SavingsPlanModel> withdrawFromSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  });
  Future<SavingsPlanModel> completeSavingsPlan(String planId);
  Future<SavingsPlanModel> cancelSavingsPlan(String planId);
}

class SavingsPlanRemoteDataSourceImpl implements SavingsPlanRemoteDataSource {
  final SupabaseClient supabaseClient;

  SavingsPlanRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<SavingsPlanModel>> getSavingsPlans(String userId) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => SavingsPlanModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Error al obtener planes de ahorro: $e');
    }
  }

  @override
  Future<List<SavingsPlanModel>> getActiveSavingsPlans(String userId) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .select()
          .eq('user_id', userId)
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => SavingsPlanModel.fromJson(json))
          .toList();
    } catch (e) {
      throw ServerException(
          message: 'Error al obtener planes de ahorro activos: $e');
    }
  }

  @override
  Future<SavingsPlanModel> getSavingsPlanById(String id) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .select()
          .eq('id', id)
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al obtener plan de ahorro: $e');
    }
  }

  @override
  Future<SavingsPlanModel> createSavingsPlan(
      SavingsPlanModel savingsPlan) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .insert({
            'user_id': savingsPlan.userId,
            'name': savingsPlan.name,
            'description': savingsPlan.description,
            'target_amount': savingsPlan.targetAmount,
            'current_amount': savingsPlan.currentAmount,
            'start_date': savingsPlan.startDate.toIso8601String().split('T')[0],
            'target_date': savingsPlan.targetDate
                ?.toIso8601String()
                .split('T')[0],
            'status': savingsPlan.status,
            'icon': savingsPlan.icon,
            'color': savingsPlan.color,
          })
          .select()
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al crear plan de ahorro: $e');
    }
  }

  @override
  Future<SavingsPlanModel> updateSavingsPlan(
      SavingsPlanModel savingsPlan) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .update({
            'name': savingsPlan.name,
            'description': savingsPlan.description,
            'target_amount': savingsPlan.targetAmount,
            'current_amount': savingsPlan.currentAmount,
            'start_date': savingsPlan.startDate.toIso8601String().split('T')[0],
            'target_date': savingsPlan.targetDate
                ?.toIso8601String()
                .split('T')[0],
            'status': savingsPlan.status,
            'icon': savingsPlan.icon,
            'color': savingsPlan.color,
          })
          .eq('id', savingsPlan.id)
          .select()
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar plan de ahorro: $e');
    }
  }

  @override
  Future<void> deleteSavingsPlan(String id) async {
    try {
      await supabaseClient.from('savings_plans').delete().eq('id', id);
    } catch (e) {
      throw ServerException(message: 'Error al eliminar plan de ahorro: $e');
    }
  }

  @override
  Future<SavingsPlanModel> addToSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  }) async {
    try {
      // Primero obtenemos el plan actual
      final currentPlan = await getSavingsPlanById(planId);

      // Calculamos el nuevo monto
      final newAmount = currentPlan.currentAmount + amount;

      // Determinamos si se completó la meta
      String newStatus = currentPlan.status;
      if (newAmount >= currentPlan.targetAmount && currentPlan.status == 'active') {
        newStatus = 'completed';
      }

      // Actualizamos el plan
      final response = await supabaseClient
          .from('savings_plans')
          .update({
            'current_amount': newAmount,
            'status': newStatus,
          })
          .eq('id', planId)
          .select()
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al agregar dinero al plan: $e');
    }
  }

  @override
  Future<SavingsPlanModel> withdrawFromSavingsPlan({
    required String planId,
    required double amount,
    String? note,
  }) async {
    try {
      // Primero obtenemos el plan actual
      final currentPlan = await getSavingsPlanById(planId);

      // Validamos que haya suficiente dinero
      if (currentPlan.currentAmount < amount) {
        throw ServerException(
          message: 'No hay suficiente dinero en el plan para retirar',
        );
      }

      // Calculamos el nuevo monto
      final newAmount = currentPlan.currentAmount - amount;

      // Actualizamos el plan
      final response = await supabaseClient
          .from('savings_plans')
          .update({'current_amount': newAmount})
          .eq('id', planId)
          .select()
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al retirar dinero del plan: $e');
    }
  }

  @override
  Future<SavingsPlanModel> completeSavingsPlan(String planId) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .update({'status': 'completed'})
          .eq('id', planId)
          .select()
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al completar plan de ahorro: $e');
    }
  }

  @override
  Future<SavingsPlanModel> cancelSavingsPlan(String planId) async {
    try {
      final response = await supabaseClient
          .from('savings_plans')
          .update({'status': 'cancelled'})
          .eq('id', planId)
          .select()
          .single();

      return SavingsPlanModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al cancelar plan de ahorro: $e');
    }
  }
}
