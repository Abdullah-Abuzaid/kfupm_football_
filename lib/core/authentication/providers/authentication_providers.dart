import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/core/authentication/models/authentication_model.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authUser = ChangeNotifierProvider<Authentication>((ref) {
  return Authentication(session: Supabase.instance.client.auth.currentSession);
});

final fetchUsers = FutureProvider<List<KFUPMMemeber>>((ref) async {
  return await AuthServices.fetchAllUsers();
});
