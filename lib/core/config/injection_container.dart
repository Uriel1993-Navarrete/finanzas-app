import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// Categories
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/check_category_name_exists.dart';
import '../../features/categories/domain/usecases/create_category.dart';
import '../../features/categories/domain/usecases/delete_category.dart';
import '../../features/categories/domain/usecases/get_categories.dart';
import '../../features/categories/domain/usecases/get_categories_by_type.dart';
import '../../features/categories/domain/usecases/get_subcategories.dart';
import '../../features/categories/domain/usecases/initialize_default_categories.dart';
import '../../features/categories/domain/usecases/search_categories.dart';
import '../../features/categories/domain/usecases/update_category.dart';
import '../../features/categories/domain/usecases/validate_category_deletion.dart';
import '../../features/categories/presentation/bloc/category_bloc.dart';
import '../../features/categories/presentation/bloc/category_management_bloc.dart';

// Transactions
import '../../features/transactions/data/datasources/transaction_remote_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/create_transaction.dart';
import '../../features/transactions/domain/usecases/delete_transaction.dart';
import '../../features/transactions/domain/usecases/get_monthly_balance.dart';
import '../../features/transactions/domain/usecases/get_transactions.dart';
import '../../features/transactions/domain/usecases/get_transactions_by_type.dart';
import '../../features/transactions/domain/usecases/update_transaction.dart';
import '../../features/transactions/presentation/bloc/transaction_bloc.dart';

// Savings
import '../../features/savings/data/datasources/savings_plan_remote_datasource.dart';
import '../../features/savings/data/repositories/savings_plan_repository_impl.dart';
import '../../features/savings/domain/repositories/savings_plan_repository.dart';
import '../../features/savings/domain/usecases/add_to_savings_plan.dart';
import '../../features/savings/domain/usecases/complete_savings_plan.dart';
import '../../features/savings/domain/usecases/create_savings_plan.dart';
import '../../features/savings/domain/usecases/delete_savings_plan.dart';
import '../../features/savings/domain/usecases/get_savings_plans.dart';
import '../../features/savings/domain/usecases/update_savings_plan.dart';
import '../../features/savings/presentation/bloc/savings_plan_bloc.dart';

/// Service Locator para inyección de dependencias
final sl = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación
Future<void> initializeDependencies() async {
  // ============================
  // External
  // ============================
  sl.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );

  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      scopes: ['email', 'profile'],
    ),
  );

  // ============================
  // Data Sources
  // ============================
  // Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: sl(),
      googleSignIn: sl(),
    ),
  );

  // Transactions (moved before Categories because Categories depends on it)
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(
      supabaseClient: sl(),
    ),
  );

  // Categories
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(
      supabaseClient: sl(),
      transactionDataSource: sl(),
    ),
  );

  // Savings
  sl.registerLazySingleton<SavingsPlanRemoteDataSource>(
    () => SavingsPlanRemoteDataSourceImpl(
      supabaseClient: sl(),
    ),
  );

  // ============================
  // Repositories
  // ============================
  // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Categories
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Transactions
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Savings
  sl.registerLazySingleton<SavingsPlanRepository>(
    () => SavingsPlanRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // ============================
  // Use Cases
  // ============================
  // Auth
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Categories
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetCategoriesByType(sl()));
  sl.registerLazySingleton(() => GetSubcategories(sl()));
  sl.registerLazySingleton(() => CreateCategory(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => InitializeDefaultCategories(sl()));
  sl.registerLazySingleton(() => CheckCategoryNameExists(sl()));
  sl.registerLazySingleton(() => SearchCategories(sl()));
  sl.registerLazySingleton(
    () => ValidateCategoryDeletion(
      categoryRepository: sl(),
      transactionRepository: sl(),
    ),
  );

  // Transactions
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => GetTransactionsByType(sl()));
  sl.registerLazySingleton(() => CreateTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetMonthlyBalance(sl()));

  // Savings
  sl.registerLazySingleton(() => GetSavingsPlans(sl()));
  sl.registerLazySingleton(() => GetActiveSavingsPlans(sl()));
  sl.registerLazySingleton(() => CreateSavingsPlan(sl()));
  sl.registerLazySingleton(() => UpdateSavingsPlan(sl()));
  sl.registerLazySingleton(() => DeleteSavingsPlan(sl()));
  sl.registerLazySingleton(() => AddToSavingsPlan(sl()));
  sl.registerLazySingleton(() => CompleteSavingsPlan(sl()));

  // ============================
  // Bloc / Cubit
  // ============================
  // Auth
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUser: sl(),
      signInWithEmail: sl(),
      signInWithGoogle: sl(),
      signUpWithEmail: sl(),
      signOut: sl(),
      initializeDefaultCategories: sl(),
    ),
  );

  // Categories
  sl.registerFactory(
    () => CategoryBloc(
      getCategories: sl(),
      getCategoriesByType: sl(),
      createCategory: sl(),
      updateCategory: sl(),
      deleteCategory: sl(),
    ),
  );

  // Category Management (nuevo BLoC para gestión avanzada)
  sl.registerFactory(
    () => CategoryManagementBloc(
      repository: sl(),
      checkCategoryNameExists: sl(),
      getSubcategories: sl(),
      searchCategories: sl(),
      validateCategoryDeletion: sl(),
    ),
  );

  // Transactions
  sl.registerFactory(
    () => TransactionBloc(
      getTransactions: sl(),
      getTransactionsByType: sl(),
      createTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      getMonthlyBalance: sl(),
    ),
  );

  // Savings
  sl.registerFactory(
    () => SavingsPlanBloc(
      getSavingsPlans: sl(),
      getActiveSavingsPlans: sl(),
      createSavingsPlan: sl(),
      updateSavingsPlan: sl(),
      deleteSavingsPlan: sl(),
      addToSavingsPlan: sl(),
      completeSavingsPlan: sl(),
    ),
  );
}
