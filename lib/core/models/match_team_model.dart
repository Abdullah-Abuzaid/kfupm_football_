// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:kfupm_football/core/models/match_player_model.dart';

import 'shot_model.dart';
import 'team_model.dart';

class MatchTeam {
  Team? team;
  List<MatchPlayer>? players;
  List<Shot>? shots;
  MatchTeam({
    this.shots,
    this.team,
    this.players,
  });

  int getGoals() {
    if (players == null || players!.isEmpty) return 0;
    return (players?.map((e) => e.getGoals()).reduce((value, element) => value + element)) ?? 0;
  }
}
