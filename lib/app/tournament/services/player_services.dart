import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/player_model.dart';

class PlayerServices {
  static final supabase = Supabase.instance.client;

  // static Future<Player> fetchPlayer(String kfupmId, WidgetRef ref) async {
  //   final kfupmMember = await AuthServices.fetchUser(kfupmId);
  //   final
  // }
}
