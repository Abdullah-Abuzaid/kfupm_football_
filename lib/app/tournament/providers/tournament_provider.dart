import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/tournament/services/tournament_services.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_substitution.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';

import '../../../core/models/player_model.dart';

final fetchTournaments = FutureProvider<List<Tournament>>((ref) async {
  return await TournamentServices.fetchTournaments(ref);
});

final fetchReferee = FutureProvider<List<KFUPMMemeber>>((ref) async {
  return await AuthServices.fetchReferees();
});
// final fetchTournamentTeams = FutureProvider.family<List<TournamentTeam>, String> ( (ref, tournamentId)   async{

// })

final fetchMatchSubstitutions = FutureProvider.family<List<MatchSubstitution>, String>((ref, matchID) async {
  return await TournamentServices.fetchMatchSubstitutions(matchID);
});
