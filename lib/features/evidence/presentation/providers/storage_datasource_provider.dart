import 'package:crv_reprosisa/core/storage/supabase_client.dart';
import 'package:crv_reprosisa/features/evidence/data/datasources/supabase_storage_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageDatasourceProvider = Provider((ref) {
  return SupabaseStorageDatasource(ref.read(supabaseClientProvider));
});
