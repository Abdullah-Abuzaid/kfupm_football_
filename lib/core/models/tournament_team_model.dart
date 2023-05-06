import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kfupm_football/core/models/match_model.dart';

import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/models/tournament_player_model.dart';

import 'player_model.dart';

class TournamentTeam {
  Team team;
  List<TournamentPlayer> players;

  TournamentTeam({
    required this.team,
    required this.players,
  });

  TournamentTeam copyWith({
    Tournament? tournament,
    Team? team,
    List<TournamentPlayer>? players,
    List<TournamentMatch>? matches,
  }) {
    return TournamentTeam(
      team: team ?? this.team,
      players: players ?? this.players,
    );
  }

  // Map<String, dynamic> toMap() {
  //   final result = <String, dynamic>{};

  //   result.addAll({'tournament': tournament.toMap()});
  //   result.addAll({'team': team.toMap()});
  //   result.addAll({'players': players.map((x) => x.toMap()).toList()});
  //   result.addAll({'matches': matches.map((x) => x.toMap()).toList()});

  //   return result;
  // }

  factory TournamentTeam.fromMap(Map<String, dynamic> map) {
    return TournamentTeam(
      team: Team.fromMap(map['team']),
      players: List<TournamentPlayer>.from(map['players']?.map((x) => Player.fromMap(x))),
    );
  }

  factory TournamentTeam.fromJson(String source) => TournamentTeam.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TournamentTeam(team: $team, players: $players ';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TournamentTeam && other.team == team && listEquals(other.players, players);
  }

  @override
  int get hashCode {
    return team.hashCode ^ players.hashCode;
  }
}
