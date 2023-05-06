import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/services/team_services.dart';

import '../../../core/models/team_model.dart';

final fetchTeamsProvider = FutureProvider<List<Team>>((ref) async {
  return await TeamServices.fetchTeams();
});
